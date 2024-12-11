package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

// PART 1 //////////////////////////////////////////////////////////////////////

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

Block :: struct {
    pos: int,
    len: int,
}

part_2_day_9 :: proc(input: string) -> int {
    disk := parse_disk(input)
    files: map[int]Block
    blanks: [dynamic]Block

    file_id := 0
    pos := 0
    for ptr := 0; ptr < len(input) - 1; ptr += 1 {
        x := int(input[ptr] - '0')
        block := Block {
            pos = pos,
            len = x,
        }

        if ptr % 2 == 0 {
            files[file_id] = block
            file_id += 1
        } else {
            append(&blanks, block)
        }

        pos += x
    }

    for file_id > 0 {
        file_id -= 1
        file := files[file_id]

        for blank, b_idx in blanks {
            // the blank is rhs of the file, skip it
            if blank.pos >= file.pos {
                break
            }

            // the file can fit in the blank
            if file.len <= blank.len {
                // move the file to the blanks position
                files[file_id] = Block {
                    pos = blank.pos,
                    len = file.len,
                }

                // move the blank according to the file
                // this can result in blanks with len 0 but we just ignore those
                blanks[b_idx] = {
                    pos = blank.pos + file.len,
                    len = blank.len - file.len,
                }

                break
            }
        }
    }

    result := 0
    for file_id, file in files {
        for x in file.pos ..< file.pos + file.len {
            result += file_id * x
        }
    }

    return result
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/09.input", string)
    sample :: #load("../input/09.sample", string)

    p1 := part_1_day_9(sample)
    assert(p1 == 1928, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_9(input))

    p2 := part_2_day_9(sample)
    assert(p2 == 2858, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_9(input))
}
