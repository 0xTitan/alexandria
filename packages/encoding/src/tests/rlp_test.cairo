use alexandria_encoding::rlp::{RLPTrait64};

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_long() {
    let res = RLPTrait64::encode_word_64(6582119);

    assert!(res == 2204397415, "Wrong RLP fist byte");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_short() {
    let res = RLPTrait64::encode_word_64(54);
    assert!(res == 54, "Wrong RLP fist byte");
}
