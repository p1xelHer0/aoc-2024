package aoc

import "core:fmt"
import "core:slice"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

DIM :: 50
BOX :: 'O'
WALL :: '#'
ROBOT :: '@'
FREE :: '.'

parse_map :: proc(input: string) -> ([DIM][DIM]u8, [2]int, [2]int) {
    trimmed := strings.trim(input, "\n")
    lines := strings.split_lines(trimmed)
    h := len(lines)
    w := len(lines[0])

    bounds := [2]int{int(w), int(h)}
    grid: [DIM][DIM]u8

    start_pos: [2]int
    for x in 0 ..< w do for y in 0 ..< h {
        if lines[y][x] == ROBOT do start_pos = [2]int{x, y}
        grid[x][y] = lines[y][x]
    }

    return grid, start_pos, bounds
}

u8_to_dir :: proc(r: rune) -> ([2]int, bool) {
    switch r {
    case '^':
        return [2]int{0, -1}, true
    case '>':
        return [2]int{1, 0}, true
    case 'v':
        return [2]int{0, 1}, true
    case '<':
        return [2]int{-1, 0}, true
    }

    return [2]int{0, 0}, false
}

parse_moves :: proc(input: string) -> [][2]int {
    trimmed := strings.trim(input, "\n")
    moves: [dynamic][2]int

    lines := strings.split_lines(trimmed)
    for line in lines do for rune in line {
        move, ok := u8_to_dir(rune)
        if ok do append(&moves, move)
    }

    return moves[:]
}

push_part_1 :: proc(pos, dir: [2]int, grid: ^[DIM][DIM]u8) -> bool {
    to := pos + dir
    unit_to_move := grid[pos.x][pos.y]
    unit_destination := grid[to.x][to.y]

    if unit_destination == WALL do return false

    pushed := true
    if unit_destination == BOX do pushed = push_part_1(to, dir, grid)
    if !pushed do return false

    grid[to.x][to.y] = unit_to_move
    grid[pos.x][pos.y] = FREE
    return true
}

print_grid :: proc(grid: [DIM][DIM]u8) {
    for y in 0 ..< 9 {
        for x in 0 ..< 9 {
            switch grid[x][y] {
            case '.':
                fmt.print(".")
            case '@':
                fmt.print("@")
            case 'O':
                fmt.print("O")
            case '#':
                fmt.print("#")
            case:
                fmt.print(" ")
            }
        }

        fmt.print("\n")
    }
}

find_robot :: proc(grid: [DIM][DIM]u8) -> ([2]int, bool) {
    robot: [2]int
    for x in 0 ..< DIM do for y in 0 ..< DIM {
        if grid[x][y] == ROBOT do return [2]int{x, y}, true
    }

    return robot, false
}

find_boxes :: proc(grid: [DIM][DIM]u8) -> [][2]int {
    boxes: [dynamic][2]int
    for x in 0 ..< DIM do for y in 0 ..< DIM {
        if grid[x][y] == BOX do append(&boxes, [2]int{x, y})
    }

    return boxes[:]
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1_day_15 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    input_parts := strings.split(input, "\n\n")
    grid, robot_pos, bounds := parse_map(input_parts[0])
    moves := parse_moves(input_parts[1])

    for move, idx in moves {
        push_part_1(robot_pos, move, &grid)

        new_pos, ok := find_robot(grid)
        if ok do robot_pos = new_pos
    }

    score := 0
    for box in find_boxes(grid) {
        score += box.y * 100 + box.x
    }

    return score
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2_day_15 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    return 0
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/15.input", string)
    sample :: #load("../input/15.sample", string)
    sample_smaller :: #load("../input/15.sample.smaller", string)

    p1_smaller := part_1_day_15(sample_smaller)
    assert(p1_smaller == 2028, fmt.tprintf("%v", p1_smaller))

    p1 := part_1_day_15(sample)
    assert(p1 == 10092, fmt.tprintf("%v", p1))

    p2 := part_2_day_15(sample)
    assert(p2 == 0, fmt.tprintf("%v", p2))

    fmt.printfln("Part 1: %d", part_1_day_15(input))

    fmt.printfln("Part 2: %d", part_2_day_15(input))
}
