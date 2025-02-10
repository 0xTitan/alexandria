use alexandria_math::{U128BitShift, U64BitShift};

// Possible RLP errors
#[derive(Drop, Copy, PartialEq)]
pub enum RLPError {
    EmptyInput,
    InputTooShort,
    PayloadTooLong,
}

#[generate_trait]
pub impl RLPImpl64 of RLPTrait64 {
    fn encode_word_64(mut input: Span<u64>) -> Result<Span<u64>, RLPError> {
        if input.len() == 0 {
            return Result::Err(RLPError::EmptyInput);
        }
        //get last item to get last length
        let item = input.at(input.len() - 1);

        if *item == 0 {
            return Result::Ok(array![0x80].span()); // RLP encoding for empty input
        } else if *item < 0x80 {
            return Result::Ok(input); // Single byte values are encoded as themselves
        }

        let mut byte_size = if (input.len() < 2) {
            Self::get_byte_size(*item).into()
        } else {
            Self::get_byte_size(*item).into() + ((input.len().into() - 1) * 8)
        }; // Get actual byte length

        if byte_size < 56 {
            let prefix = 0x80 + byte_size;
            if byte_size >= 8 {
                let mut result = array![prefix];
                result.append_span(input);
                return Result::Ok(result.span());
            }
            let shifted_prefix = prefix.into() * U64BitShift::shl(256, 8 * (byte_size - 1));
            let result = (shifted_prefix + *item);
            Result::Ok(array![result].span())
        } else {
            let len_of_length: u64 = Self::get_byte_size(byte_size)
                .into(); // Number of bytes in `byte_size`
            let prefix = 0xB7 + len_of_length; // Compute prefix
            //for a length of 500 (0x01F4) -> 0xB7+0x01FA
            let shifted_prefix = (prefix.into() * U64BitShift::shl(256, 8 * (len_of_length - 1)))
                + byte_size;
            let mut result = array![shifted_prefix];
            result.append_span(input);
            Result::Ok(result.span())
        }
    }

    // Function to determine the number of bytes needed to represent `input`
    fn get_byte_size(mut value: u64) -> u8 {
        if value == 0 {
            return 1_u8;
        }

        let mut bytes = 0_u8;

        while value > 0 {
            bytes += 1;
            value = value / 256; // Simulate value >>= 8
        };

        bytes
    }
}
