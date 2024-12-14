package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

Robot :: struct {
    pos: [2]int,
    vel: [2]int,
}

parse_robot :: proc(line: string) -> Robot {
    r1, _ := strings.split(line, "p=")
    r2, _ := strings.split(r1[1], " v=")

    p1, _ := strings.split(r2[0], ",")
    pos := [2]int{strconv.atoi(p1[0]), strconv.atoi(p1[1])}

    v1, _ := strings.split(r2[1], ",")
    vel := [2]int{strconv.atoi(v1[0]), strconv.atoi(v1[1])}

    return Robot{pos = pos, vel = vel}
}

simulate_step :: proc(robot: ^Robot, times: int, bounds: [2]int) -> [2]int {
    pos := robot.pos + robot.vel * times
    pos.x = pos.x % bounds.x
    pos.y = pos.y % bounds.y

    if pos.x < 0 do pos.x += bounds.x
    if pos.y < 0 do pos.y += bounds.y

    return pos
}

// PART 1 //////////////////////////////////////////////////////////////////////

find_quandrant :: proc(pos: [2]int, bounds: [2]int) -> (int, bool) {
    x_half := bounds.x / 2
    y_half := bounds.y / 2

    if pos.x < x_half && pos.y < y_half do return 1, true
    if pos.x > x_half && pos.y < y_half do return 2, true
    if pos.x < x_half && pos.y > y_half do return 3, true
    if pos.x > x_half && pos.y > y_half do return 4, true

    return 0, false
}

part_1_day_14 :: proc(input: string, bounds: [2]int) -> int {
    context.allocator = context.temp_allocator

    quadrants: map[int]int
    it := strings.trim(input, "\n")
    for line in strings.split_iterator(&it, "\n") {
        robot := parse_robot(line)
        pos := simulate_step(&robot, 100, bounds)
        quadrant, ok := find_quandrant(pos, bounds)
        if !ok do continue
        quadrants[quadrant] += 1
    }

    safety_factor := 1
    for _, nr_of_robots in quadrants {
        safety_factor *= nr_of_robots
    }

    return safety_factor
}

// PART 2 //////////////////////////////////////////////////////////////////////

// don't try searching where previous starts have already been
already_searched: [101][103]bool

find_consecutive :: proc(
    pos, dir: [2]int,
    limit: int,
    robot_pos: [101][103]bool,
) -> bool {
    score := 0

    next_pos := pos + dir
    for next_pos.x < 101 && next_pos.y < 103 {
        if already_searched[next_pos.x][next_pos.y] do break
        already_searched[next_pos.x][next_pos.y] = true

        if robot_pos[next_pos.x][next_pos.y] {
            score += 1
            next_pos += dir
        }
    }

    return score >= limit
}

part_2_day_14 :: proc(input: string, bounds: [2]int) -> int {
    context.allocator = context.temp_allocator
    robot_pos: [101][103]bool

    robots: [dynamic]Robot
    it := strings.trim(input, "\n")
    for line in strings.split_iterator(&it, "\n") {
        robot := parse_robot(line)
        append(&robots, robot)
    }

    steps := 0
    step: for steps < 10000 {
        steps += 1

        // reset the slices for each step simulation
        for x in 0 ..< 101 do for y in 0 ..< 103 {
            already_searched[x][y] = false
            robot_pos[x][y] = false
        }

        for &robot in robots {
            pos := simulate_step(&robot, steps, bounds)
            robot_pos[pos.x][pos.y] = true
        }

        // for all points try to find consecutive robot positions
        for y in 0 ..< 103 {
            for x in 0 ..< 101 {
                // I tried different directions here, it seems the tree has a
                // frame so both {1, 1}, {1, 0} and {0, 1} works
                if find_consecutive([2]int{x, y}, [2]int{1, 1}, 10, robot_pos) do break step
            }
        }
    }

    // look, a tree!
    for y in 0 ..< 103 {
        for x in 0 ..< 101 {
            if robot_pos[x][y] do fmt.print("#")
            else do fmt.print(".")
        }

        fmt.print("\n")
    }

    return steps
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/14.input", string)
    sample :: #load("../input/14.sample", string)

    p1 := part_1_day_14(sample, [2]int{11, 7})
    assert(p1 == 12, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_14(input, [2]int{101, 103}))

    fmt.printfln("Part 2: %d", part_2_day_14(input, [2]int{101, 103}))
}
