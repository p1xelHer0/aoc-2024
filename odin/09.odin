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

Block :: struct {
    value: int,
    start: int,
    len:   int,
}

part_2_day_9 :: proc(input: string) -> int {
    disk := parse_disk(input)
    blocks: [dynamic]Block

    print_disk(disk)
    for idx := 0; idx < len(disk); idx += 1 {
        value := disk[idx]

        block_len := 1
        if idx + block_len < len(disk) {
            block := disk[idx + block_len]
            for block == value {
                block_len += 1
                if idx + block_len >= len(disk) do break
                block = disk[idx + block_len]
            }
        }

        block := Block {
            start = idx,
            len   = block_len,
            value = value,
        }
        append(&blocks, block)
        idx += block_len - 1
    }

    fmt.printfln("blocks %v", blocks)

    find_block :: proc(blocks: []Block, value: int) -> []int {
        result: [dynamic]int
        for block, idx in blocks {
            if block.value == value do append(&result, idx)
        }
        return result[:]
    }

    o: for idx := len(blocks) - 1; idx >= 0; idx -= 1 {
        block := blocks[idx]
        if block.value == -1 do continue
        fmt.printfln("should we swap %v?", block)
        swap_indexes := find_block(blocks[:], -1)
        fmt.printfln("%v", swap_indexes)

        for s_idx in swap_indexes {
            bs := blocks[s_idx]
            if bs.start + bs.len > block.start {
                fmt.printfln(
                    "%v leftmost -1 block right of block %v",
                    bs,
                    block,
                )
                break o
            }

            fmt.printfln("can we swap %v and %v?", block, bs)
            if bs.len >= block.len {
                fmt.printfln("swapping %v with %v", block, bs)
                for i := 0; i < block.len; i += 1 {
                    disk[bs.start + i] = block.value
                    disk[block.start + i] = bs.value
                }

                blocks[s_idx], blocks[idx] = blocks[idx], blocks[s_idx]
                print_disk(disk)
                fmt.printfln("continuing to next block")
                continue o
            }
        }
    }

    print_disk(disk)

    return 0
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/09.input", string)
    sample :: #load("../input/09.sample", string)

    // p1 := part_1_day_9(sample)
    // assert(p1 == 1928, fmt.tprintf("%v", p1))

    // fmt.printfln("Part 1: %d", part_1_day_9(input))

    p2 := part_2_day_9(sample)
    assert(p2 == 2858, fmt.tprintf("%v", p2))

    fmt.printfln("Part 2: %d", part_2_day_9(input))
}
