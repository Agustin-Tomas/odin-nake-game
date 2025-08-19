package src

// Here's where I code how the game actually works

//import "core:fmt"
import "core:math/rand"
import fmt "core:fmt"

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
update_state :: proc() {
    delete_tail()
    append_head()
    update_snake_buffer()
    chek_self_collision()
    check_collision()
    spawn_food()
}

delete_tail :: proc() {
    // Update occupied buffer
    tail_index := ctx.gs.snake.tail_index
    length := ctx.gs.snake.length

    x :=  ctx.gs.snake.x[tail_index]
    y := ctx.gs.snake.y[tail_index]
    ctx.gs.snake_buffer[x + y * WIDTH] = false

    head_index := clock_add(tail_index, (length - 1), SNAKE_SIZE)
    x = ctx.gs.snake.x[head_index]
    y = ctx.gs.snake.y[head_index]
    ctx.gs.occupied_buffer[x + y * WIDTH] = true

    // Update snake body
    ctx.gs.snake.tail_index = clock_add(ctx.gs.snake.tail_index, 1, SNAKE_SIZE)
    ctx.gs.snake.length -= 1
}

append_head :: proc() {
    ONE : u64 : 1
    tail_index := ctx.gs.snake.tail_index
    length := ctx.gs.snake.length

    current_index := clock_add(tail_index, (length - ONE), SNAKE_SIZE)
    current_x := ctx.gs.snake.x[current_index]
    current_y := ctx.gs.snake.y[current_index]

    new_x : u64 = current_x
    new_y : u64 = current_y
    switch ctx.gs.snake.direction {
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

    ctx.gs.snake.x[new_index] = new_x
    ctx.gs.snake.y[new_index] = new_y
    ctx.gs.snake.length += 1
}

update_snake_buffer :: proc() {
    //iterate snake bodyparts, get XY
    // turn snake buffer tile FALSE when not snake
    // turn snake buffer tile TRUE otherwise
}

spawn_food :: proc() {
    // Lists empity tiles
    // Chooses random empity tile
    // Creates Food
    // Updates empity buffer

    if ctx.gs.food_is_present {
        return
    } else
    if !(ctx.gs.frames_since_eaten >= 8) {
        ctx.gs.frames_since_eaten += 1
        return
    }
    ctx.gs.frames_since_eaten = 0

    ctx.gs.food_lotery_len = 1
    for tile_x in 0..<WIDTH{
        for tile_y in 0..<HEIGHT{
            if !(ctx.gs.occupied_buffer[tile_x + tile_y*WIDTH]) {
                ctx.gs.food_lotery_x[ctx.gs.food_lotery_len] = tile_x
                ctx.gs.food_lotery_y[ctx.gs.food_lotery_len] = tile_y

                ctx.gs.food_lotery_len += 1
            }
        }
    }

    random_i : u64 = 0
    if ctx.gs.food_lotery_len > 0 {
        random_i = u64( rand.int_max(int(ctx.gs.food_lotery_len)) )
        new_food_x := ctx.gs.food_lotery_x[random_i]
        new_food_y := ctx.gs.food_lotery_y[random_i]
        ctx.gs.food_buffer[new_food_x + new_food_y * WIDTH] = true
        ctx.gs.food_is_present = true

        ctx.gs.occupied_buffer[new_food_x + new_food_y * WIDTH] = true
 }


    // Turn is_food_present ON
}

check_collision :: proc() {
    ONE : u64 : 1
    old_tail_index := ctx.gs.snake.tail_index
    length := ctx.gs.snake.length
    current_index := clock_add(old_tail_index, (length - ONE), SNAKE_SIZE)
    head_x := ctx.gs.snake.x[current_index]
    head_y := ctx.gs.snake.y[current_index]

    // Snakes eats
    if ctx.gs.food_buffer[head_x + head_y * WIDTH] {
        new_tail_i := clock_sub(old_tail_index, ONE, SNAKE_SIZE)
        ctx.gs.snake.tail_index = new_tail_i
        ctx.gs.snake.x[new_tail_i] = ctx.gs.snake.x[old_tail_index]
        ctx.gs.snake.y[new_tail_i] = ctx.gs.snake.y[old_tail_index]

        ctx.gs.food_buffer[head_x + head_y * WIDTH] = false
        ctx.gs.food_is_present = false
        ctx.gs.snake.length += 1
    }
}

chek_self_collision :: proc() {
    ONE : u64 : 1
    tail_index := ctx.gs.snake.tail_index
    length := ctx.gs.snake.length

    current_index := clock_add(tail_index, (length - ONE), SNAKE_SIZE)
    head_x := ctx.gs.snake.x[current_index]
    head_y := ctx.gs.snake.y[current_index]

    for i in 0..<(length - ONE) {
        same_x : bool = ctx.gs.snake.x[clock_add(tail_index, i, SNAKE_SIZE)] == head_x
        same_y : bool = ctx.gs.snake.y[clock_add(tail_index, i, SNAKE_SIZE)] == head_y
        if same_x && same_y {
            ctx.gs.game_lost = true
        }

    }
}

