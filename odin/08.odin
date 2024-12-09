package aoc

import "core:fmt"
import "core:slice"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

parse_antennas :: proc(input: string) -> (map[u8][dynamic][2]int, [2]int) {
    lines, _ := slice.split_last(strings.split_lines(input))
    w := len(lines[0])
    h := len(lines)
    antennas_by_freq: map[u8][dynamic][2]int

    for x in 0 ..< w do for y in 0 ..< h {
        freq := lines[y][x]
        if freq != '.' {
            antenna := antennas_by_freq[freq] or_else {}
            append(&antenna, [2]int{x, y})
            antennas_by_freq[freq] = antenna
        }
    }

    return antennas_by_freq, {w, h}
}

bounds :: proc(v2, grid_size: [2]int) -> bool {
    return v2.x >= grid_size.x || v2.y >= grid_size.y || v2.x < 0 || v2.y < 0
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1_day_8 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    antennas_by_freq, grid_size := parse_antennas(input)
    antinodes: [dynamic][2]int

    for freq in antennas_by_freq {
        antennas := antennas_by_freq[freq] or_else {}
        for antenna_1 in antennas {
            for x in 0 ..< len(antennas) {
                antenna_2 := antennas[x]
                if (antenna_1 != antenna_2) {
                    antinode := (antenna_2 - antenna_1) + antenna_2

                    if bounds(antinode, grid_size) do continue

                    if !(slice.contains(antinodes[:], antinode)) do append(&antinodes, antinode)
                }
            }
        }
    }

    return len(antinodes)
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2_day_8 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    antennas_by_freq, grid_size := parse_antennas(input)
    antinodes: [dynamic][2]int

    for freq in antennas_by_freq {
        antennas := antennas_by_freq[freq] or_else {}
        for antenna_1 in antennas {
            for x in 0 ..< len(antennas) {
                // two antennas in the same frequency makes them both antinodes
                if !(slice.contains(antinodes[:], antenna_1)) do append(&antinodes, antenna_1)

                antenna_2 := antennas[x]
                if (antenna_1 != antenna_2) {
                    dir := antenna_2 - antenna_1
                    antinode := antenna_2 + dir

                    // keep stepping in the same direction until we are out of bounds
                    for !(bounds(antinode, grid_size)) {
                        if !(slice.contains(antinodes[:], antinode)) do append(&antinodes, antinode)

                        antinode += dir
                    }
                }
            }
        }
    }

    return len(antinodes)
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/08.input", string)
    sample :: #load("../input/08.sample", string)

    p1 := part_1_day_8(sample)
    assert(p1 == 14, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_8(input))

    p2 := part_2_day_8(sample)
    assert(p2 == 34, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_8(input))
}
