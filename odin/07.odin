package aoc

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

Equation :: struct {
    test_value: int,
    numbers:    []int,
}

// PART 1 //////////////////////////////////////////////////////////////////////

is_valid_part_1 :: proc(eq: Equation) -> bool {
    check :: proc(goal, acc: int, numbers: []int) -> bool {
        if slice.is_empty(numbers) do return goal == acc
        else {
            mult := check(goal, acc * numbers[0], numbers[1:])
            add := check(goal, acc + numbers[0], numbers[1:])
            return mult || add
        }
    }

    return check(eq.test_value, 0, eq.numbers)
}

part_1_day_7 :: proc(input: string) -> int {
    ta := context.temp_allocator
    dyn_equations: [dynamic]Equation

    split_input, _ := slice.split_last(strings.split_lines(input, ta))
    for line in split_input {
        split_input := strings.split(line, ":", ta)
        test_value := strconv.atoi(split_input[0])
        n := strings.split(strings.trim_space(split_input[1]), " ", ta)
        numbers, _ := slice.mapper(n, strconv.atoi, ta)
        append(
            &dyn_equations,
            Equation{test_value = test_value, numbers = numbers[:]},
        )
    }

    equations := dyn_equations[:]
    valid_equations, _ := slice.filter(equations, is_valid_part_1, ta)
    totals, _ := slice.mapper(
        valid_equations,
        proc(eq: Equation) -> int {return eq.test_value},
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

    check :: proc(goal, acc: int, numbers: []int) -> bool {
        if slice.is_empty(numbers) do return goal == acc
        else {
            mult := check(goal, acc * numbers[0], numbers[1:])
            add := check(goal, acc + numbers[0], numbers[1:])
            concat := check(goal, concat(acc, numbers[0]), numbers[1:])
            return mult || add || concat
        }
    }

    return check(eq.test_value, 0, eq.numbers)
}

part_2_day_7 :: proc(input: string) -> int {
    ta := context.temp_allocator
    dyn_equations: [dynamic]Equation

    split_input, _ := slice.split_last(strings.split_lines(input, ta))
    for line in split_input {
        split_input := strings.split(line, ":", ta)
        test_value := strconv.atoi(split_input[0])
        n := strings.split(strings.trim_space(split_input[1]), " ", ta)
        numbers, _ := slice.mapper(n, strconv.atoi, ta)
        append(
            &dyn_equations,
            Equation{test_value = test_value, numbers = numbers[:]},
        )
    }

    equations := dyn_equations[:]
    valid_equations, _ := slice.filter(equations, is_valid_part_2, ta)
    totals, _ := slice.mapper(
        valid_equations,
        proc(eq: Equation) -> int {return eq.test_value},
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
