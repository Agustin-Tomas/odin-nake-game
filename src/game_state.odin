package src
// Here I declare all of the game's state

Direction :: enum{
    North,
    South,
    East,
    West,
}

// Parameters
WIDTH : u64 : 24
HEIGHT : u64 : 24
TILE_SIZE :: WIDTH * HEIGHT
SNAKE_SIZE :: WIDTH * HEIGHT


Game_State :: struct {
    snake: Snake,

    food_buffer : [TILE_SIZE]bool,
    snake_buffer : [TILE_SIZE]bool,
    occupied_buffer : [TILE_SIZE]bool,

    //Slice of pointers to food_buffer
    food_is_present : bool,
    frames_since_eaten : u64,
    food_lotery_x : [TILE_SIZE]u64,
    food_lotery_y : [TILE_SIZE]u64,
    food_lotery_len : u64,

    game_lost : bool
}

//Changelog :: struct {
//    change
//}

Buffer :: struct {
    // Entire grid state
    // foo_buffer[x + y * WIDTH]
    tile : [TILE_SIZE]bool,
}

Snake :: struct {
    x : [TILE_SIZE]u64,
    y : [TILE_SIZE]u64,
    direction: Direction,
    length: u64,
    tail_index : u64,

    block_up : bool,
    block_right : bool,
    block_down : bool,
    block_left : bool,
}

init_game_state:: proc() -> ^Game_State {
    gs := new(Game_State)

    // Initialize snake - Testing
    head_x : u64 = 4
    head_y : u64 = 12


    gs.snake.x[0] = head_x-2
    gs.snake.x[1] = head_x-1
    gs.snake.x[2] = head_x


    gs.snake.y[0] = head_y
    gs.snake.y[1] = head_y
    gs.snake.y[2] = head_y

    gs.snake.tail_index = 0
    gs.snake.length = 3

    gs.snake.direction = Direction.East
    gs.snake.block_left = true


    //gs.food_buffer[0+ 0 * WIDTH] = true


    for i in 0..<gs.snake.length {
        x := gs.snake.x[i]
        y := gs.snake.y[i]
        gs.snake_buffer[x + y * WIDTH] = true
    }

    gs.occupied_buffer = (gs.snake_buffer | gs.food_buffer)

    return gs
}
