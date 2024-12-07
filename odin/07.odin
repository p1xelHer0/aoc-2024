package aoc

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

Equation :: struct {
    test_value: uint,
    numbers:    []uint,
}

// PART 1 //////////////////////////////////////////////////////////////////////

is_valid_part_1 :: proc(eq: Equation) -> bool {
    check :: proc(goal, acc: uint, numbers: []uint) -> bool {
        if slice.is_empty(numbers) do return goal == acc
        else {
            mult := check(goal, acc * numbers[0], numbers[1:])
            add := check(goal, acc + numbers[0], numbers[1:])
            return mult || add
        }
    }

    return check(eq.test_value, 0, eq.numbers)
}

part_1_day_7 :: proc(input: string) -> uint {
    ta := context.temp_allocator
    dyn_equations: [dynamic]Equation

    split_input, _ := slice.split_last(strings.split_lines(input, ta))
    for line in split_input {
        split_input := strings.split(line, ":", ta)
        test_value, _ := strconv.parse_uint(split_input[0])
        n := strings.split(strings.trim_space(split_input[1]), " ", ta)
        to_uint :: proc(s: string) -> uint {
            result, _ := strconv.parse_uint(s)
            return result
        }
        numbers, _ := slice.mapper(n, to_uint, ta)
        append(
            &dyn_equations,
            Equation{test_value = test_value, numbers = numbers[:]},
        )
    }

    equations := dyn_equations[:]
    valid_equations, _ := slice.filter(equations, is_valid_part_1, ta)
    totals, _ := slice.mapper(
        valid_equations,
        proc(eq: Equation) -> uint {return eq.test_value},
        ta,
    )

    return math.sum(totals)
}

// PART 2 //////////////////////////////////////////////////////////////////////

is_valid_part_2 :: proc(eq: Equation) -> bool {
    // this code is probably not very good but it works :D
    // someone needs to teach me Odin
    concat :: proc(s1, s2: int) -> int {
        b1: [100]byte
        b2: [100]byte
        n1 := strconv.itoa(b1[:], s1)
        n2 := strconv.itoa(b2[:], s2)
        return strconv.atoi(strings.join({n1, n2}, ""))
    }

    // ok thx Laytan - this was ~15x faster in my case
    better_concat :: proc(a, b: uint) -> uint {
        d := a
        for c := b; c > 0; c /= 10 {
            d *= 10
        }
        return d + b
    }

    check :: proc(goal, acc: uint, numbers: []uint) -> bool {
        if slice.is_empty(numbers) do return goal == acc
        else {
            mult := check(goal, acc * numbers[0], numbers[1:])
            add := check(goal, acc + numbers[0], numbers[1:])
            concat := check(goal, better_concat(acc, numbers[0]), numbers[1:])
            return mult || add || concat
        }
    }

    return check(eq.test_value, 0, eq.numbers)
}

part_2_day_7 :: proc(input: string) -> uint {
    ta := context.temp_allocator
    dyn_equations: [dynamic]Equation

    split_input, _ := slice.split_last(strings.split_lines(input, ta))
    for line in split_input {
        split_input := strings.split(line, ":", ta)
        test_value, _ := strconv.parse_uint(split_input[0])
        n := strings.split(strings.trim_space(split_input[1]), " ", ta)
        to_uint :: proc(s: string) -> uint {
            result, _ := strconv.parse_uint(s)
            return result
        }
        numbers, _ := slice.mapper(n, to_uint, ta)
        append(
            &dyn_equations,
            Equation{test_value = test_value, numbers = numbers[:]},
        )
    }

    equations := dyn_equations[:]
    valid_equations, _ := slice.filter(equations, is_valid_part_2, ta)
    totals, _ := slice.mapper(
        valid_equations,
        proc(eq: Equation) -> uint {return eq.test_value},
        ta,
    )

    return math.sum(totals)
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/07.input", string)
    sample :: #load("../input/07.sample", string)

    p1 := part_1_day_7(sample)
    assert(p1 == 3749, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_7(input))

    p2 := part_2_day_7(sample)
    assert(p2 == 11387, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_7(input))
}
