package input

import rl "vendor:raylib"
import game "../game"

PlayerCommand :: enum {
    UP,
    RIGHT,
    DOWN,
    LEFT,
}

init_input :: proc(gs: ^game.GameState) -> map[PlayerCommand]rl.KeyboardKey {
    bindings := make( map[PlayerCommand]rl.KeyboardKey )
    bindings[.UP] = rl.KeyboardKey.UP
    bindings[.RIGHT] = rl.KeyboardKey.RIGHT
    bindings[.DOWN] = rl.KeyboardKey.DOWN
    bindings[.LEFT] = rl.KeyboardKey.LEFT
    return bindings
}

read_input :: proc(gs: ^game.GameState, bindings: map[PlayerCommand]rl.KeyboardKey) {
    up_key := bindings[.UP]
    right_key := bindings[.RIGHT]
    down_key := bindings[.DOWN]
    left_key := bindings[.LEFT]

    n_pressed := 0
    if rl.IsKeyPressed(up_key) && n_pressed == 0 && !gs^.snake.block_up {
        gs^.snake.direction = .North
        n_pressed =+ 1
        gs^.snake.block_up = false
        gs^.snake.block_right = false
        gs^.snake.block_down = true
        gs^.snake.block_left = false
    }
    else if rl.IsKeyPressed(right_key) && n_pressed == 0 && !gs^.snake.block_right {
        gs^.snake.direction = .East
        n_pressed =+ 1
        gs^.snake.block_up = false
        gs^.snake.block_right = false
        gs^.snake.block_down = false
        gs^.snake.block_left = true
    }
    else if rl.IsKeyPressed(down_key) && n_pressed == 0 && !gs^.snake.block_down {
        gs^.snake.direction = .South
        n_pressed =+ 1
        gs^.snake.block_up = true
        gs^.snake.block_right = false
        gs^.snake.block_down = false
        gs^.snake.block_left = false
    }
    else if rl.IsKeyPressed(left_key) && n_pressed == 0 && !gs^.snake.block_left {
        gs^.snake.direction = .West
        n_pressed =+ 1
        gs^.snake.block_up = false
        gs^.snake.block_right = true
        gs^.snake.block_down = false
        gs^.snake.block_left = false
    }
    n_pressed = 0
}
