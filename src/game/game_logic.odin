package game
// Here's where I code how the game actually works

import "core:fmt"


clock_add:: proc(n: u64, add: u64, maximum: u64) -> u64 {
    // maximum not incluided
    return (n + add) % maximum
}


clock_sub:: proc(n: u64, sub: u64, maximum: u64) -> u64 {
    // maximum no included
    switch {
    case sub > n:
        return maximum - (sub - n)
    case:
        return n - sub
    }
}


delete_tail:: proc(gs: ^GameState) {
    // Undraw tail: at segments[tail^]
    gs^.snake.tail_index += 1
    gs^.snake.length -= 1
}


append_head:: proc(gs: ^GameState) {
    ONE : u64 : 1
    tail_index := gs^.snake.tail_index
    length := gs^.snake.length

    current_index := clock_add(tail_index, (length - ONE), SNAKE_SIZE)
    current_x := gs^.snake.x[current_index]
    current_y := gs^.snake.y[current_index]

    new_x : u64 = current_x
    new_y : u64 = current_y
    switch gs^.snake.direction {
        case .North:
            new_y = clock_add(current_y, ONE, HEIGHT)
        case .South:
            new_y = clock_sub(current_y, ONE, HEIGHT)
        case .East:
            new_x = clock_add(current_x, ONE, WIDTH)
        case .West:
            new_x = clock_sub(current_x, ONE, WIDTH)
    }
    new_index : u64 = clock_add(current_index, ONE, SNAKE_SIZE)

    gs^.snake.x[new_index] = new_x
    gs^.snake.y[new_index] = new_y
    gs^.snake.length += 1
}


update_frame:: proc(gs: ^GameState) {
    delete_tail(gs)
    append_head(gs)
}


show_snake :: proc(gs: ^GameState) {
    index := gs^.snake.tail_index
    for i in 0..<gs^.snake.length {
        fmt.println("-->", gs^.snake.x[index], gs^.snake.y[index])
        index += 1
    }
    fmt.println("")
}