use alexandria_math::fast_power::{fast_power};

#[generate_trait]
pub impl RLPImpl64 of RLPTrait64 {
    fn encode_word_64(input: u64) -> u64 {
        if input == 0 {
            return 0x80; // RLP encoding for empty input
        } else if input < 0x80 {
            return input; // Single byte values are encoded as themselves
        } else {
            let byte_len = Self::get_byte_size(input); // Get actual byte length
            if byte_len < 56 {
                return Self::add_rlp_prefix(input, byte_len.into()); // Short encoding
            } else {
                return Self::encode_long_form(
                    input, byte_len.into(),
                ); // Long encoding for >= 56 bytes
            }
        }
    }

    fn add_rlp_prefix(value: u64, length: u64) -> u64 {
        let prefix = 0x80 + length; // Calculate RLP prefix (e.g., 0x83 for length 3)
        let shifted_prefix: u64 = (prefix * fast_power(256, length.into())).into(); //byte shift

        (shifted_prefix + value)
    }

    fn encode_long_form(value: u64, length: u64) -> u64 {
        let len_of_length = Self::get_byte_size(length.into()); // Get byte size of length
        let prefix: u64 = 0xB7 + len_of_length.into(); // Compute long-form prefix

        // Shift
        let shifted_prefix = prefix * fast_power(256, len_of_length.into() + length);
        let shifted_length = length * fast_power(256, length);

        return shifted_prefix.into() + shifted_length.into() + value;
    }

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
