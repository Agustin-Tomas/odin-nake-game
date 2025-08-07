package src

Direction :: enum{
    North,
    South,
    East,
    West,
}

// Parameters
WIDTH : u64 : 19
HEIGHT : u64 : 19
TILE_SIZE :: WIDTH * HEIGHT
SNAKE_SIZE :: WIDTH * HEIGHT

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
}


GameState :: struct {
    snake: Snake,

    food_buffer : [WIDTH * HEIGHT]bool,
    snake_buffer : [WIDTH * HEIGHT]bool,
    uccupied_buffer : [WIDTH * HEIGHT]bool,

    //Slice of pointers to food_buffer
    food_lotery_buffer : [WIDTH * HEIGHT]^bool,
    food_lotery_len : u64,
}


init_game_state:: proc() -> ^GameState {
    gs := new(GameState)

    // Initialize snake - Testing
    head_x : u64 = 4
    head_y : u64 = 16

    gs.snake.x[0] = head_x - 2
    gs.snake.x[1] = head_x - 1
    gs.snake.x[2] = head_x

    gs.snake.y[0] = head_y - 2
    gs.snake.y[1] = head_y - 1
    gs.snake.y[2] = head_y

    gs.snake.length= 3


    gs.food_buffer[15 + 4 * WIDTH] = true


    for i in 0..<gs.snake.length {
        x := gs.snake.x[i]
        y := gs.snake.y[i]
        gs.snake_buffer[x + y * WIDTH] = true
    }

    gs.uccupied_buffer = (gs.snake_buffer | gs.food_buffer)

    return gs
}
