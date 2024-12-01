package aoc

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

// SHARED //////////////////////////////////////////////////////////////////////

parse_line :: proc(line: string) -> (int, int) {
    str := strings.split(line, "   ", context.temp_allocator)
    return strconv.atoi(str[0]), strconv.atoi(str[1])
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1 :: proc(input: string) -> int {
    list_1: [dynamic]int = {}
    list_2: [dynamic]int = {}
    defer {delete(list_1);delete(list_2)}

    it := string(input)
    for line in strings.split_lines_iterator(&it) {
        r1, r2 := parse_line(line)

        append(&list_1, r1)
        append(&list_2, r2)
    }

    slice.sort(list_1[:])
    slice.sort(list_2[:])

    result: [dynamic]int = {}
    defer delete(result)
    for _, idx in list_1 {
        append(&result, abs(list_1[idx] - list_2[idx]))
    }

    return math.sum(result[:])
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2 :: proc(input: string) -> int {
    list_1: [dynamic]int = {}
    list_2: [dynamic]int = {}
    defer {delete(list_1);delete(list_2)}

    it := string(input)
    for line in strings.split_lines_iterator(&it) {
        r1, r2 := parse_line(line)

        append(&list_1, r1)
        append(&list_2, r2)
    }

    similarity_lookup := make(map[int]int)
    defer delete(similarity_lookup)
    for loc_id in list_2 {
        similarity := similarity_lookup[loc_id] or_else 0
        similarity_lookup[loc_id] = similarity + 1
    }

    result: [dynamic]int = {}
    defer delete(result)
    for loc_id in list_1 {
        similarity := similarity_lookup[loc_id] or_else 0
        append(&result, similarity * loc_id)
    }

    return math.sum(result[:])
}

////////////////////////////////////////////////////////////////////////////////

@(test)
test :: proc(t: ^testing.T) {
    sample :: #load("../inputs/01.sample", string)

    testing.expect_value(t, part_1(sample), 11)
    testing.expect_value(t, part_2(sample), 31)
}

main :: proc() {
    input :: #load("../inputs/01.input", string)

    fmt.printfln("Part 1: %d", part_1(input))
    fmt.printfln("Part 2: %d", part_2(input))
}
