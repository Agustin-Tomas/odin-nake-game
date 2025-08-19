package src


import rl "vendor:raylib"


PlayerCommand :: enum {
    UP,
    RIGHT,
    DOWN,
    LEFT,
}

set_bindings :: proc(){
    bindings := make(map[PlayerCommand]rl.KeyboardKey)
    bindings[.UP] = rl.KeyboardKey.UP
    bindings[.RIGHT] = rl.KeyboardKey.RIGHT
    bindings[.DOWN] = rl.KeyboardKey.DOWN
    bindings[.LEFT] = rl.KeyboardKey.LEFT

    ctx.bindings = bindings
}

read_game_input :: proc() {
    up_key := ctx.bindings[.UP]
    right_key := ctx.bindings[.RIGHT]
    down_key := ctx.bindings[.DOWN]
    left_key := ctx.bindings[.LEFT]

    n_pressed := 0
    if rl.IsKeyPressed(up_key) && n_pressed == 0 && !ctx.gs.snake.block_up {
        ctx.gs.snake.direction = .North
        n_pressed =+ 1
        ctx.gs.snake.block_up = false
        ctx.gs.snake.block_right = false
        ctx.gs.snake.block_down = true
        ctx.gs.snake.block_left = false
    }
    else if rl.IsKeyPressed(right_key) && n_pressed == 0 && !ctx.gs.snake.block_right {
        ctx.gs.snake.direction = .East
        n_pressed =+ 1
        ctx.gs.snake.block_up = false
        ctx.gs.snake.block_right = false
        ctx.gs.snake.block_down = false
        ctx.gs.snake.block_left = true
    }
    else if rl.IsKeyPressed(down_key) && n_pressed == 0 && !ctx.gs.snake.block_down {
        ctx.gs.snake.direction = .South
        n_pressed =+ 1
        ctx.gs.snake.block_up = true
        ctx.gs.snake.block_right = false
        ctx.gs.snake.block_down = false
        ctx.gs.snake.block_left = false
    }
    else if rl.IsKeyPressed(left_key) && n_pressed == 0 && !ctx.gs.snake.block_left {
        ctx.gs.snake.direction = .West
        n_pressed =+ 1
        ctx.gs.snake.block_up = false
        ctx.gs.snake.block_right = true
        ctx.gs.snake.block_down = false
        ctx.gs.snake.block_left = false
    }
    n_pressed = 0
}
