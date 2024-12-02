package aoc

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

// SHARED //////////////////////////////////////////////////////////////////////

parse_line :: proc(line: string) -> []int {
    result := make([dynamic]int, 0, context.temp_allocator)

    strs := strings.split(line, " ", context.temp_allocator)
    for str in strs {
        append(&result, strconv.atoi(str))
    }

    return result[:]
}

is_safe :: proc(levels: []int) -> bool {
    increasing, decreasing, unsafe: bool

    for idx in 0 ..< len(levels) - 1 {
        level := levels[idx]
        next_level := levels[idx + 1]

        diff := next_level - level
        if diff > 0 do increasing = true
        if diff < 0 do decreasing = true

        if abs(diff) < 1 do unsafe = true
        if abs(diff) > 3 do unsafe = true
    }

    if increasing && decreasing do unsafe = true

    return !unsafe
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1 :: proc(input: string) -> int {
    nr_of_safe_reports := 0

    it := input
    for line in strings.split_lines_iterator(&it) {
        report := parse_line(line)
        if is_safe(report) do nr_of_safe_reports += 1
    }

    return nr_of_safe_reports
}

// PART 2 //////////////////////////////////////////////////////////////////////

is_safe_damp :: proc(levels: []int) -> bool {
    safe := false

    for idx in 0 ..< len(levels) {
        plucked_level := slice.clone_to_dynamic(levels, context.temp_allocator)
        ordered_remove(&plucked_level, idx)
        if is_safe(plucked_level[:]) do safe = true
    }

    return safe
}

part_2 :: proc(input: string) -> int {
    nr_of_safe_reports := 0
    unsafe_reports := make([dynamic][]int, 0, context.temp_allocator)

    it := input
    for line in strings.split_lines_iterator(&it) {
        report := parse_line(line)
        if is_safe(report) {
            nr_of_safe_reports += 1
        } else {
            append(&unsafe_reports, report)
        }
    }

    for unsafe_report in unsafe_reports {
        if is_safe_damp(unsafe_report) do nr_of_safe_reports += 1
    }

    return nr_of_safe_reports
}

////////////////////////////////////////////////////////////////////////////////

@(test)
test :: proc(t: ^testing.T) {
    sample :: #load("../inputs/02.sample", string)

    testing.expect_value(t, part_1(sample), 2)
    testing.expect_value(t, part_2(sample), 4)
}

main :: proc() {
    input :: #load("../inputs/02.input", string)

    fmt.printfln("Part 1: %d", part_1(input))
    fmt.printfln("Part 2: %d", part_2(input))
}
