package aoc

import "core:fmt"
import "core:log"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

// SHARED //////////////////////////////////////////////////////////////////////

both_parts :: proc(input: string) -> (int, int) {
    ta := context.temp_allocator
    split_input := strings.split(input, "\n\n", ta)

    page_ordering_rules := strings.split(split_input[0], "\n", ta)

    proceeds: map[int][dynamic]int
    defer delete(proceeds)
    for order in page_ordering_rules {
        key_str, _, val_str := strings.partition(order, "|")
        key := strconv.atoi(key_str)
        val := strconv.atoi(val_str)
        p := proceeds[key] or_else {}
        append(&p, val)
        proceeds[key] = p
    }

    // drop the last empty list from the trailing newline
    page_number_updates, _ := slice.split_last(
        strings.split(split_input[1], "\n", ta)[:],
    )
    ok_updates, bad_updates: [dynamic][]int
    for update in page_number_updates {
        is_ok := true
        numbers := slice.mapper(strings.split(update, ","), strconv.atoi, ta)

        #reverse for num, idx in numbers {
            num := numbers[idx]
            must_be_before := proceeds[num][:]
            nums_to_check := numbers[:idx]
            for num in nums_to_check {
                if slice.contains(must_be_before, num) do is_ok = false
            }
        }

        if is_ok {
            append(&ok_updates, numbers)
        } else {
            append(&bad_updates, numbers)
        }
    }

    part_1_result := 0
    for update in ok_updates {
        part_1_result += slice.first(update[len(update) / 2:])
    }

    part_2_result := 0
    for &update in bad_updates {
        update = proceeds_sort(update, proceeds)
        part_2_result += slice.first(update[len(update) / 2:])
    }

    return part_1_result, part_2_result
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1_day_5 :: proc(input: string) -> int {
    result, _ := both_parts(input)

    return result
}

// PART 2 //////////////////////////////////////////////////////////////////////

proceeds_sort :: proc(input: []int, lookup: map[int][dynamic]int) -> []int {
    result := input
    not_done := false

    for idx in 0 ..< len(result) - 1 {
        num := input[idx]
        next_num := input[idx + 1]
        should_preceed := lookup[next_num] or_else {}
        if slice.contains(should_preceed[:], num) {
            result[idx], result[idx + 1] = result[idx + 1], result[idx]
            not_done = true
        }
    }

    if not_done {
        proceeds_sort(result, lookup)
    }

    return result
}

part_2_day_5 :: proc(input: string) -> int {
    _, result := both_parts(input)
    return result
}

////////////////////////////////////////////////////////////////////////////////

@(test)
test_day_5 :: proc(t: ^testing.T) {
    sample :: #load("../input/05.sample", string)

    testing.expect_value(t, part_1_day_5(sample), 143)
    testing.expect_value(t, part_2_day_5(sample), 123)
}

main :: proc() {
    input :: #load("../input/05.input", string)

    fmt.printfln("Part 1: %d", part_1_day_5(input))
    fmt.printfln("Part 2: %d", part_2_day_5(input))
}
