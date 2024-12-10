package aoc

import "core:fmt"
import "core:slice"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

VISITED_SIZE :: 60

in_bounds :: proc(v2, grid_size: [2]int) -> bool {
    return(
        !(v2.x >= grid_size.x || v2.y >= grid_size.y || v2.x < 0 || v2.y < 0) \
    )
}

neightbour_in_bounds :: proc(v2: [2]int, bounds: [2]int) -> [][2]int {
    neighbours := [dynamic][2]int {
        v2 + {1, 0},
        v2 - {1, 0},
        v2 + {0, 1},
        v2 - {0, 1},
    }

    result: [dynamic][2]int
    for point in neighbours {
        if in_bounds(point, bounds) do append(&result, point)
    }

    return result[:]
}

visited: [60][60]bool

// PART 1 //////////////////////////////////////////////////////////////////////

find_trailheads :: proc(
    start, bounds: [2]int,
    target, goal: int,
    heights: [VISITED_SIZE][VISITED_SIZE]int,
    is_part_1: bool,
) -> int {
    score := 0
    neighbours := neightbour_in_bounds(start, bounds)

    for n in neighbours {
        point := heights[n.x][n.y]
        if point != target do continue

        if is_part_1 {
            if visited[n.x][n.y] do continue
            visited[n.x][n.y] = true
        }

        if point == goal do score += 1
        else do score += find_trailheads(n, bounds, target + 1, goal, heights, is_part_1)
    }

    return score
}

part_1_day_10 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    lines := strings.split(input, "\n")
    w := len(lines[0])
    h := len(lines) - 1 // trailing newline
    bounds := [2]int{int(w), int(h)}

    heights: [VISITED_SIZE][VISITED_SIZE]int
    starting_points: [dynamic][2]int
    for x in 0 ..< w do for y in 0 ..< h {
        if lines[y][x] - '0' == 0 do append(&starting_points, [2]int{x, y})
        heights[x][y] = int(lines[y][x] - '0')
    }

    score := 0
    for start in starting_points {
        // Zero visited here!
        // This wouldn't be a problem if we didn't use recursion...
        for i in 0 ..< VISITED_SIZE do for j in 0 ..< VISITED_SIZE do visited[i][j] = false
        score += find_trailheads(start, bounds, 1, 9, heights, true)
    }

    return score
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2_day_10 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    lines := strings.split(input, "\n")
    w := len(lines[0])
    h := len(lines) - 1 // trailing newline
    bounds := [2]int{int(w), int(h)}

    heights: [VISITED_SIZE][VISITED_SIZE]int
    starting_points: [dynamic][2]int
    for x in 0 ..< w do for y in 0 ..< h {
        if lines[y][x] - '0' == 0 do append(&starting_points, [2]int{x, y})
        heights[x][y] = int(lines[y][x] - '0')
    }

    score := 0
    for start in starting_points {
        for i in 0 ..< VISITED_SIZE do for j in 0 ..< VISITED_SIZE do visited[i][j] = false
        score += find_trailheads(start, bounds, 1, 9, heights, false)
    }

    return score

}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/10.input", string)
    sample :: #load("../input/10.sample", string)

    p1 := part_1_day_10(sample)
    assert(p1 == 36, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_10(input))

    p2 := part_2_day_10(sample)
    assert(p2 == 81, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_10(input))
}
