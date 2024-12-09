package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

parse_disk :: proc(input: string) -> []int {
    disk: [dynamic]int
    disk_id := 0

    for idx := 0; idx < len(input); idx += 2 {
        defer disk_id += 1

        block := input[idx] - '0'
        free_space := idx < len(input) - 2 ? input[idx + 1] - '0' : 0

        for _ in 0 ..< block {
            append(&disk, disk_id)
        }

        for _ in 0 ..< free_space {
            append(&disk, -1)
        }
    }

    return disk[:]
}

print_disk :: proc(disk: []int) {
    for n in disk {
        if n == -1 {
            fmt.print(".")
        } else {
            fmt.print(n)
        }
    }

    fmt.print("\n")
}

// PART 1 //////////////////////////////////////////////////////////////////////

part_1_day_9 :: proc(input: string) -> int {
    disk := parse_disk(input)

    #reverse for _, idx in disk {
        swap_idx, _ := slice.linear_search(disk[:], -1)
        disk[idx], disk[swap_idx] = disk[swap_idx], disk[idx]

        // all of the contents of the right block is -1
        if slice.all_of(disk[idx:], -1) {
            // and none of the contents of the left block is -1
            if slice.none_of(disk[:idx - 1], -1) {
                // we are compacted
                break
            }
        }
    }

    filesystem_checksum := 0
    for block, id in disk {
        if block == -1 do break
        filesystem_checksum += block * id
    }

    return filesystem_checksum
}

// PART 2 //////////////////////////////////////////////////////////////////////

part_2_day_9 :: proc(input: string) -> int {

    return 0
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/09.input", string)
    sample :: #load("../input/09.sample", string)

    p1 := part_1_day_9(sample)
    assert(p1 == 1928, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_9(input))

    p2 := part_2_day_9(sample)
    assert(p2 == 0, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_9(input))
}
