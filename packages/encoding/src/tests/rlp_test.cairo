use alexandria_encoding::rlp::{RLPError, RLPTrait64};


#[test]
#[available_gas(20000000)]
fn test_rlp_encode_empty_input_should_fail() {
    let input = array![];

    let res = RLPTrait64::encode_word_64(input.span());

    assert!(res.is_err(), "Should have failed");
    assert!(res.unwrap_err() == RLPError::EmptyInput, "err != EmptyInput");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_0() {
    let res = RLPTrait64::encode_word_64(array![0x0].span());
    assert!(*res.unwrap()[0] == 0x80, "Wrong RLP");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_lt_0x80() {
    let res = RLPTrait64::encode_word_64(array![0x75].span());
    assert!(*res.unwrap()[0] == 0x75, "Wrong RLP");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_lt_than_8_bytes() {
    let res = RLPTrait64::encode_word_64(array![0x6c6096f6e0111].span());
    assert!(res.unwrap() == array![0x8706c6096f6e0111].span(), "Wrong RLP");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_8_bytes() {
    let res = RLPTrait64::encode_word_64(array![0x6c6096f6e011111].span());
    assert!(res.unwrap() == array![0x88, 0x06c6096f6e011111].span(), "Wrong RLP");
}

#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_56_bytes() {
    let res = RLPTrait64::encode_word_64(
        array![
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e011111,
        ]
            .span(),
    );

    assert!(
        *res.unwrap()[0] == 0xB838, "Wrong RLP",
    ); //0XB7 + 1 (56  = 1 Byte) + 56 (len) = 0XB8 + 0X38 = 0XB838
    assert!(*res.unwrap()[1] == 0x6c6096f6e0111111, "Wrong RLP at index 1");
    assert!(*res.unwrap()[2] == 0x6c6096f6e0111111, "Wrong RLP at index 2");
    assert!(*res.unwrap()[3] == 0x6c6096f6e0111111, "Wrong RLP at index 3");
    assert!(*res.unwrap()[4] == 0x6c6096f6e0111111, "Wrong RLP at index 4");
    assert!(*res.unwrap()[5] == 0x6c6096f6e0111111, "Wrong RLP at index 5");
    assert!(*res.unwrap()[6] == 0x6c6096f6e0111111, "Wrong RLP at index 6");
    assert!(*res.unwrap()[7] == 0x6c6096f6e011111, "Wrong RLP at index 7");
}


#[test]
#[available_gas(20000000)]
fn test_rlp64_encode_string_gt_56_bytes() {
    let res = RLPTrait64::encode_word_64(
        array![
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x7b7b7b7b7b7b7b7b,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6e0111111,
            0x6c6096f6,
        ]
            .span(),
    );

    assert!(
        *res.unwrap()[0] == 0xB83C, "Wrong RLP",
    ); //0XB7 + 1 (56  = 1 Byte) + 56 (len) = 0XB8 + 0X38 = 0XB838
    assert!(*res.unwrap()[1] == 0x6c6096f6e0111111, "Wrong RLP at index 1");
    assert!(*res.unwrap()[2] == 0x6c6096f6e0111111, "Wrong RLP at index 2");
    assert!(*res.unwrap()[3] == 0x6c6096f6e0111111, "Wrong RLP at index 3");
    assert!(*res.unwrap()[4] == 0x7b7b7b7b7b7b7b7b, "Wrong RLP at index 4");
    assert!(*res.unwrap()[5] == 0x6c6096f6e0111111, "Wrong RLP at index 5");
    assert!(*res.unwrap()[6] == 0x6c6096f6e0111111, "Wrong RLP at index 6");
    assert!(*res.unwrap()[7] == 0x6c6096f6e0111111, "Wrong RLP at index 7");
    assert!(*res.unwrap()[8] == 0x6c6096f6, "Wrong RLP at index 8");
}

