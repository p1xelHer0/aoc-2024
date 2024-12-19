package aoc

import "core:container/queue"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

DIM :: 71

Pos :: [2]int

Mem_Space :: struct {
    x:    int,
    y:    int,
    dist: int,
}

parse_level :: proc(input: string, bytes_to_fall: int) -> [DIM][DIM]bool {
    mem_space: [DIM][DIM]bool

    for line, i in strings.split_lines(input) {
        if i > bytes_to_fall do break
        x, _, y := strings.partition(line, ",")
        mem_space[strconv.atoi(x)][strconv.atoi(y)] = true
    }

    return mem_space
}

// PART 1 //////////////////////////////////////////////////////////////////////

// TODO: Should be solvable
solve_1 :: proc(bytes: [DIM][DIM]bool, dim: int) -> (int, bool) {
    q: queue.Queue(Mem_Space)
    queue.init(&q)
    queue.push(&q, Mem_Space{0, 0, 0})
    seen: map[Pos]bool
    seen[{0, 0}] = true

    for queue.len(q) > 0 {
        m := queue.pop_back(&q)
        neighbours := [?]Pos {
            {m.x + 1, m.y},
            {m.x, m.y + 1},
            {m.x - 1, m.y},
            {m.x, m.y - 1},
        }

        for n in neighbours {
            if n.x < 0 || n.y < 0 || n.x > dim || n.y > dim do continue
            if bytes[n.x][n.y] do continue
            if seen[n] do continue

            if n.x == dim && n.y == dim do return m.dist + 1, true

            seen[{n.x, n.y}] = true
            queue.push(&q, Mem_Space{n.x, n.y, m.dist + 1})
        }
    }

    return 0, false
}

part_1_day_18 :: proc(input: string, dim: int, bytes_to_fall: int) -> int {
    context.allocator = context.temp_allocator
    input := strings.trim(input, "\n")
    mem_space := parse_level(input, bytes_to_fall)

    for y in 0 ..= dim {
        for x in 0 ..= dim {
            if mem_space[x][y] == true do fmt.print("#")
            else do fmt.print(".")
        }
        fmt.print("\n")
    }

    result, ok := solve_1(mem_space, dim)

    return result
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2_day_18 :: proc(input: string) -> int {
    return 0
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../../input/18.input", string)
    sample :: #load("../../input/18.sample", string)

    p1 := part_1_day_18(sample, 6, 12)
    assert(p1 == 24, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_18(input, 70, 1024))

    // p2 := part_2_day_18(sample)
    // assert(p2 == 81, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_18(input))
}
