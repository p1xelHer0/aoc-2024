package aoc

import "core:fmt"
import "core:strings"
import "core:testing"

// SHARED //////////////////////////////////////////////////////////////////////

next_dir :: proc(dir: int) -> int {
    return (dir + 1) % 4
}

next_pos :: proc(pos: [2]int, dir: int) -> (int, int) {
    // 0 = up, 1 = right, 2 = down, 3 = left
    dirs: [4][2]int = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}

    offset := dirs[dir]
    pos := pos + offset
    return pos.x, pos.y
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1_day_6 :: proc(input: string) -> int {
    ta := context.temp_allocator

    lines := strings.split(input, "\n", ta)
    w := len(lines[0])
    h := len(lines) - 1 // trailing newline

    // kinda cheating but yeah yeah
    // it's advent of code
    // not advent of nice code
    collisions: [130][130]bool
    guard_pos: [2]int
    guard_dir: int // 0 = up

    for x in 0 ..< w do for y in 0 ..< h {
        if lines[y][x] == '#' do collisions[x][y] = true
        if lines[y][x] == '^' do guard_pos = {x, y}
    }

    guard_hist: [130][130]bool
    guard_hist[guard_pos.x][guard_pos.y] = true
    nr_of_steps := 1
    for {
        // take a step forward
        x, y := next_pos(guard_pos, guard_dir)

        // did we step out of bounds?
        if x >= w || y >= h || x < 0 || y < 0 do break

        // did we collide?
        if collisions[x][y] {
            // we collided - turn instead and try again
            guard_dir = next_dir(guard_dir)
            continue
        } else {
            // we didn't - we successfully moved
            guard_pos = {x, y}
        }

        // if we haven't been here before we count it
        if !guard_hist[guard_pos.x][guard_pos.y] do nr_of_steps += 1

        // record the position and direction
        guard_hist[guard_pos.x][guard_pos.y] = true
    }

    return nr_of_steps
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2_day_6 :: proc(input: string) -> int {
    ta := context.temp_allocator

    // deja vu
    lines := strings.split(input, "\n", ta)
    w := len(lines[0])
    h := len(lines) - 1 // trailing newline

    // kinda cheating but yeah yeah
    // it's advent of code
    // not advent of nice code
    collisions: [130][130]bool
    guard_pos: [2]int
    guard_dir: int // 0 = up

    for x in 0 ..< w do for y in 0 ..< h {
        if lines[y][x] == '#' do collisions[x][y] = true
        if lines[y][x] == '^' do guard_pos = {x, y}
    }

    loops := 0
    // place obstacles on one position after another
    // record all moves including directions
    // moving to an old position in the same direction is a loop
    for x_collision in 0 ..< w do for y_collision in 0 ..< h {
        guard_pos := guard_pos
        if guard_pos == {x_collision, y_collision} do continue
        guard_dir := guard_dir

        collisions := collisions
        collisions[x_collision][y_collision] = true

        guard_hist: [4][130][130]bool
        guard_hist[guard_dir][guard_pos.x][guard_pos.y] = true

        for {
            // take a step forward
            x, y := next_pos(guard_pos, guard_dir)

            // did we step out of bounds?
            if x >= w || y >= h || x < 0 || y < 0 do break

            // did we collide?
            if collisions[x][y] {
                // we collided - turn instead and try again
                guard_dir = next_dir(guard_dir)
                continue
            } else {
                // we didn't - we successfully moved
                guard_pos = {x, y}
            }

            // have we been in this position (and direction) before? it's a loop!
            if guard_hist[guard_dir][guard_pos.x][guard_pos.y] {
                loops += 1
                break
            }

            // record the position and direction
            guard_hist[guard_dir][guard_pos.x][guard_pos.y] = true
        }
    }

    return loops
}

////////////////////////////////////////////////////////////////////////////////

@(test)
test_day_6 :: proc(t: ^testing.T) {
    sample :: #load("../input/06.sample", string)

    testing.expect_value(t, part_1_day_6(sample), 41)
    testing.expect_value(t, part_2_day_6(sample), 6)
}

main :: proc() {
    input :: #load("../input/06.input", string)
    sample :: #load("../input/06.sample", string)

    fmt.printfln("Part 1: %d", part_1_day_6(input))
    fmt.printfln("Part 2: %d", part_2_day_6(input))
}
