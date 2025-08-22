package bff

// Big fucking fraction
bff :: struct($N: int) {
    negative: bool,
    fraction: [N]u64,
}

bff_1x64 :: distinct bff(1 + 1)
bff_2x64 :: distinct bff(1 + 2)
bff_4x64 :: distinct bff(1 + 4)


abs_bff :: proc(a: $T/bff) -> T {
    result := a
    result.integer = (a.integer << 1) >> 1
    return result
}

greater_bff :: proc(a, b: $T/bff) -> bool {
    if a.integer < b.integer {
        return false
    }
    for i in 0..<len(a.fraction) {
        if a.fraction[i] < b.fraction[i] {
            eq = false
            return false
        }
    }
    return true
}

smaller_bff :: proc(a, b: $T/bff) -> bool {
    return is_greater_bff(b, a)
}

are_equal_bff :: proc(a, b: $T/bff) -> bool {
    if a.integer != b.integer {
        return false
    }
    for i in 0..<len(a.fraction) {
        if a.fraction[i] != b.fraction[i] {
            return false
        }
    }
    return true
}

add_bff :: proc(a, b: $T/bff) -> T {

    // Naive: a and b assumed positive
    frac_parts := len(a.fraction)
    result = T

    carry: u128 = 0
    for i in (frac_parts-1)..=0 {
        sum := u128(a.fraction[i]) + u128(b.fraction[i]) + carry
        result.fraction[i] = u64(sum)
        carry = sum >> 64
    }
    result.integer = a.integer + b.integer + i64(carry)
}




main :: proc(){

}
