package aoc

import "core:fmt"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

split_uint :: proc(digits: string) -> (uint, uint) {
    half := len(digits) / 2

    lhf_str := digits[:half]
    rhs_str := digits[half:]

    lhs, _ := strconv.parse_uint(lhf_str)
    rhs, _ := strconv.parse_uint(rhs_str)

    return lhs, rhs
}

blink :: proc(stones: map[uint]uint) -> map[uint]uint {
    result: map[uint]uint

    for mark, amount in stones {
        if mark == 0 {
            result[1] += amount
        } else {
            digits := fmt.tprintf("%v", mark)
            if len(digits) % 2 == 0 {
                lhs, rhs := split_uint(digits)

                lhs_amount := stones[lhs] or_else 0
                rhs_amount := stones[rhs] or_else 0

                result[lhs] += amount
                result[rhs] += amount
            } else {
                next_mark := mark * 2024
                result[next_mark] += amount
            }
        }
    }

    return result
}

// PART 1 + 2 //////////////////////////////////////////////////////////////////

day_11 :: proc(input: string, blink_times: uint) -> uint {
    context.allocator = context.temp_allocator

    stones: map[uint]uint

    it := strings.trim(input, "\n")
    for i in strings.split_iterator(&it, " ") {
        mark, _ := strconv.parse_uint(i)
        amount := stones[mark] or_else 0
        stones[mark] = amount + 1
    }

    blink_times := blink_times
    for blink_times > 0 {
        defer blink_times -= 1
        stones = blink(stones)
    }

    result: uint = 0
    for _, amount in stones {
        result += amount
    }

    return result
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/11.input", string)
    sample :: #load("../input/11.sample", string)

    p1 := day_11(sample, blink_times = 25)
    assert(p1 == 55312, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", day_11(input, blink_times = 25))
    fmt.printfln("Part 2: %d", day_11(input, blink_times = 75))
}
