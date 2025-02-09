use alexandria_encoding::rlp::{RLPTrait64};

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_long() {
    let res = RLPTrait64::encode_word_64(0x646f67);
    assert!(res == 0x83646f67, "Wrong RLP");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_long_lion() {
    let res = RLPTrait64::encode_word_64(0x6c6096f6e0111);
    assert!(res == 0x8706c6096f6e0111, "Wrong RLP");
}
