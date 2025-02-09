use alexandria_math::fast_power::{fast_power};
use alexandria_math::{U64BitShift, U128BitShift};

#[generate_trait]
pub impl RLPImpl64 of RLPTrait64 {
    fn encode_word_64(input: u64) -> u64 {
        if input == 0 {
            return 0x80; // RLP encoding for empty input
        } else if input < 0x80 {
            return input.into(); // Single byte values are encoded as themselves
        }

        let byte_size: u64 = Self::get_byte_size(input).into(); // Get actual byte length
        if byte_size < 56 {
            let prefix = 0x80 + byte_size;
            let shifted_prefix = prefix.into() * U64BitShift::shl(256, 8 * (byte_size.into()-1));

            let result = (shifted_prefix + input.into());
            result
        } else {
            let len_of_length: u64 = Self::get_byte_size(byte_size)
                .into(); // Number of bytes in `byte_size`
            let prefix = 0xB7 + len_of_length; // Compute prefix
            
            //for a length of 500 (0x01F4) -> 0xB7+0x01FA 
            let shifted_prefix = (prefix.into() * U64BitShift::shl(256, 8 * (len_of_length - 1)))
                + byte_size*8;
            let result = (shifted_prefix * U64BitShift::shl(256, 8 * (byte_size-1))) + input;

            result
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
