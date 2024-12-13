package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

// SHARED //////////////////////////////////////////////////////////////////////

Game :: struct {
    a:     [2]int,
    b:     [2]int,
    prize: [2]int,
}

// hahahahah
parse_game :: proc(input: string) -> Game {
    lines, _ := strings.split_lines(input)

    a_button := lines[0]
    a1, _ := strings.split(a_button, "Button A: X+")
    a2, _ := strings.split(a1[1], ", Y+")
    a: [2]int = {strconv.atoi(a2[0]), strconv.atoi(a2[1])}

    b_button := lines[1]
    b1, _ := strings.split(b_button, "Button B: X+")
    b2, _ := strings.split(b1[1], ", Y+")
    b: [2]int = {strconv.atoi(b2[0]), strconv.atoi(b2[1])}

    p := lines[2]
    p1, _ := strings.split(p, "Prize: X=")
    p2, _ := strings.split(p1[1], ", Y=")
    prize: [2]int = {strconv.atoi(p2[0]), strconv.atoi(p2[1])}

    return Game{a = a, b = b, prize = prize}
}

// PART 1 //////////////////////////////////////////////////////////////////////

min_tokens :: proc(game: Game) -> int {
    min_tokens := 0

    for a_press in 1 ..= 100 do for b_press in 1 ..= 100 {
        x_score := game.a.x * a_press + game.b.x * b_press
        y_score := game.a.y * a_press + game.b.y * b_press
        if x_score == game.prize.x && y_score == game.prize.y {
            tokens := a_press * 3 + b_press
            if min_tokens == 0 do min_tokens = tokens
            min_tokens = min(min_tokens, tokens)
        }
    }

    return min_tokens
}

part_1_day_13 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    tokens := 0

    it := strings.trim(input, "\n")
    for g in strings.split_iterator(&it, "\n\n") {
        game := parse_game(g)
        tokens += min_tokens(game)
    }

    return tokens
}

// PART 2 //////////////////////////////////////////////////////////////////////

// https://en.wikipedia.org/wiki/Cramer%27s_rule
// no - I've never would've found this without help lol
cramers_min_tokens :: proc(game: Game) -> int {
    x_prize := game.prize.x + 10000000000000
    y_prize := game.prize.y + 10000000000000
    ax := game.a.x
    ay := game.a.y
    bx := game.b.x
    by := game.b.y

    determinant := ax * by - bx * ay
    if determinant == 0 do return 0

    x := x_prize * by - bx * y_prize
    if x % determinant != 0 do return 0

    y := ax * y_prize - x_prize * ay
    if y % determinant != 0 do return 0

    return (x * 3 + y) / determinant
}

part_2_day_13 :: proc(input: string) -> int {
    context.allocator = context.temp_allocator

    tokens := 0

    it := strings.trim(input, "\n")
    for g in strings.split_iterator(&it, "\n\n") {
        game := parse_game(g)
        tokens += cramers_min_tokens(game)
    }

    return tokens
}

////////////////////////////////////////////////////////////////////////////////

main :: proc() {
    input :: #load("../input/13.input", string)
    sample :: #load("../input/13.sample", string)

    p1 := part_1_day_13(sample)
    assert(p1 == 480, fmt.tprintf("%v", p1))

    fmt.printfln("Part 1: %d", part_1_day_13(input))

    fmt.printfln("Part 2: %d", part_2_day_13(input))
}
