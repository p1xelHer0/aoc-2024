package aoc

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

// SHARED //////////////////////////////////////////////////////////////////////

Dir :: enum {
    UP,
    DOWN,
    LEFT,
    RIGHT,
    UP_LEFT,
    UP_RIGHT,
    DOWN_LEFT,
    DOWN_RIGHT,
}

Dir_Vecs := [Dir][2]int {
    .UP         = {0, -1},
    .DOWN       = {0, 1},
    .LEFT       = {-1, 0},
    .RIGHT      = {1, 0},
    .UP_LEFT    = {-1, -1},
    .UP_RIGHT   = {1, -1},
    .DOWN_LEFT  = {-1, 1},
    .DOWN_RIGHT = {1, 1},
}
Dirs :: bit_set[Dir;u8]

// PART 1 //////////////////////////////////////////////////////////////////////

find_xmas :: proc(pos: [2]int, dir: Dir, grid: [][]rune) -> bool {
    result := make([dynamic]rune, 0, 4, context.temp_allocator)
    xmas := "XMAS"

    curr_pos := pos
    next := Dir_Vecs[dir]
    bounds: [2]int = {len(grid[0]) - 1, len(grid) - 1}
    for i := 0; i < len(xmas); i += 1 {
        if curr_pos.x <= bounds.x &&
           curr_pos.x >= 0 &&
           curr_pos.y <= bounds.y &&
           curr_pos.y >= 0 {
            rune := grid[curr_pos.y][curr_pos.x]
            append(&result, rune)
        }

        curr_pos += next
    }

    return utf8.runes_to_string(result[:], context.temp_allocator) == xmas
}

find_xmas_in_directions :: proc(start_pos: [2]int, grid: [][]rune) -> int {
    result := 0

    dirs: Dirs = {
        .UP,
        .DOWN,
        .LEFT,
        .RIGHT,
        .UP_LEFT,
        .UP_RIGHT,
        .DOWN_LEFT,
        .DOWN_RIGHT,
    }
    for dir in dirs {
        if find_xmas(start_pos, dir, grid) do result += 1
    }

    return result
}

part_1 :: proc(input: string) -> int {
    result := 0

    grid := make([dynamic][]rune, 0)
    defer delete(grid)
    lines := strings.split_lines(input, context.temp_allocator)
    for line in lines {
        append(&grid, utf8.string_to_runes(line, context.temp_allocator))
    }

    for line, y in grid {
        for rune, x in line {
            if rune == 'X' {
                result += find_xmas_in_directions({x, y}, grid[:len(grid) - 1])
            }
        }
    }

    return result
}

// PART 2 //////////////////////////////////////////////////////////////////////

find_x_mas :: proc(pos: [2]int, grid: [][]rune) -> bool {
    result := make([dynamic]rune, 0, 4, context.temp_allocator)

    bounds: [2]int = {len(grid[0]) - 1, len(grid) - 1}

    dirs: Dirs = {.UP_LEFT, .UP_RIGHT, .DOWN_LEFT, .DOWN_RIGHT}
    for dir in dirs {
        next_pos := pos + Dir_Vecs[dir]

        if next_pos.x <= bounds.x &&
           next_pos.x >= 0 &&
           next_pos.y <= bounds.y &&
           next_pos.y >= 0 {
            next_rune := grid[next_pos.y][next_pos.x]
            append(&result, next_rune)
        }
    }

    x_mas_text := utf8.runes_to_string(result[:], context.temp_allocator)
    valid_combinations: []string = {"MMSS", "MSMS", "SSMM", "SMSM"}

    return slice.contains(valid_combinations, x_mas_text)
}

part_2 :: proc(input: string) -> int {
    result := 0

    grid := make([dynamic][]rune, 0)
    defer delete(grid)
    lines := strings.split_lines(input, context.temp_allocator)
    for line in lines {
        append(&grid, utf8.string_to_runes(line, context.temp_allocator))
    }

    for line, y in grid {
        for rune, x in line {
            if rune == 'A' {
                if find_x_mas(
                    pos = {x, y},
                    grid = grid[:len(grid) - 1],
                ) {result += 1}

            }
        }
    }

    return result
}

////////////////////////////////////////////////////////////////////////////////

@(test)
test :: proc(t: ^testing.T) {
    sample :: #load("../input/04.sample", string)

    testing.expect_value(t, part_1(sample), 18)
    testing.expect_value(t, part_2(sample), 9)
}

main :: proc() {
    input :: #load("../input/04.input", string)

    fmt.printfln("Part 1: %d", part_1(input))
    fmt.printfln("Part 2: %d", part_2(input))
}
