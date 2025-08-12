package game

// Here's where I code how the game actually works

//import "core:fmt"
import "core:math/rand"


clock_add :: proc(n: u64, add: u64, maximum: u64) -> u64 {
    // maximum not incluided
    return (n + add) % maximum
}


clock_sub :: proc(n: u64, sub: u64, maximum: u64) -> u64 {
    // maximum no included
    switch {
    case sub > n:
        return maximum - (sub - n)
    case:
        return n - sub
    }
}

// Main logic function
update_state :: proc(gs: ^GameState) {
    delete_tail(gs)
    append_head(gs)
    update_snake_buffer(gs)
    chek_self_collision(gs)
    check_collision(gs)
    spawn_food(gs)
}

delete_tail :: proc(gs: ^GameState) {
    // Update occupied buffer
    tail_index := gs^.snake.tail_index
    length := gs^.snake.length

    x := gs^.snake.x[tail_index]
    y := gs^.snake.y[tail_index]
    gs^.snake_buffer[x + y * WIDTH] = false

    head_index := clock_add(tail_index, (length - 1), SNAKE_SIZE)
    x = gs.snake.x[head_index]
    y = gs.snake.y[head_index]
    gs^.occupied_buffer[x + y * WIDTH] = true

    // Update snake body
    gs^.snake.tail_index = clock_add(gs^.snake.tail_index, 1, SNAKE_SIZE)
    gs^.snake.length -= 1
}

append_head :: proc(gs: ^GameState) {
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

update_snake_buffer :: proc(gs: ^GameState) {
    //iterate snake bodyparts, get XY
    // turn snake buffer tile FALSE when not snake
    // turn snake buffer tile TRUE otherwise
}

spawn_food :: proc(gs: ^GameState) {
    // Lists empity tiles
    // Chooses random empity tile
    // Creates Food
    // Updates empity buffer

    if gs^.food_is_present {
        return
    } else
    if !(gs^.frames_since_eaten >= 8) {
        gs^.frames_since_eaten += 1
        return
    }
    gs^.frames_since_eaten = 0

    gs^.food_lotery_len = 1
    for tile_x in 0..<WIDTH{
        for tile_y in 0..<HEIGHT{
            if !(gs^.occupied_buffer[tile_x + tile_y*WIDTH]) {
                gs^.food_lotery_x[gs^.food_lotery_len] = tile_x
                gs^.food_lotery_y[gs^.food_lotery_len] = tile_y

                gs^.food_lotery_len += 1
            }
        }
    }

    random_i : u64 = u64( rand.int_max( int(gs^.food_lotery_len) ) ) - 1

    new_food_x := gs^.food_lotery_x[random_i]
    new_food_y := gs^.food_lotery_y[random_i]
    gs^.food_buffer[new_food_x + new_food_y * WIDTH] = true
    gs^.food_is_present = true

    gs^.occupied_buffer[new_food_x + new_food_y * WIDTH] = true


    //Trun is_food_present ON
}

check_collision :: proc(gs: ^GameState) {
    ONE : u64 : 1
    old_tail_index := gs^.snake.tail_index
    length := gs^.snake.length
    current_index := clock_add(old_tail_index, (length - ONE), SNAKE_SIZE)
    head_x := gs^.snake.x[current_index]
    head_y := gs^.snake.y[current_index]

    // Snakes eats
    if gs^.food_buffer[head_x + head_y * WIDTH] {
        new_tail_i := clock_sub(old_tail_index, ONE, SNAKE_SIZE)
        gs^.snake.tail_index = new_tail_i
        gs^.snake.x[new_tail_i] = gs^.snake.x[old_tail_index]
        gs^.snake.y[new_tail_i] = gs^.snake.y[old_tail_index]

        gs^.food_buffer[head_x + head_y * WIDTH] = false
        gs^.food_is_present = false
        gs^.snake.length += 1
    }
}

chek_self_collision :: proc(gs: ^GameState) {
    ONE : u64 : 1
    tail_index := gs^.snake.tail_index
    length := gs^.snake.length

    current_index := clock_add(tail_index, (length - ONE), SNAKE_SIZE)
    head_x := gs^.snake.x[current_index]
    head_y := gs^.snake.y[current_index]

    for i in 0..<(length - ONE) {
        same_x : bool = gs^.snake.x[clock_add(tail_index, i, SNAKE_SIZE)] == head_x
        same_y : bool = gs^.snake.y[clock_add(tail_index, i, SNAKE_SIZE)] == head_y
        if same_x && same_y {
            gs^.game_lost = true
        }

    }
}



// This was for testing snake movement logic
/*
print_snake :: proc(gs: ^GameState) {
    index := gs^.snake.tail_index
    for i in 0..<gs^.snake.length {
        fmt.println("-->", gs^.snake.x[index], gs^.snake.y[index])
        index += 1
    }
    fmt.println("")
}
*/