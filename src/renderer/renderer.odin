package renderer

import rl "vendor:raylib"

import game "../game"

init_renderer :: proc(gs: ^game.GameState) -> rl.Texture2D {
    snake_cell : rl.Texture2D = rl.LoadTexture("assets/snake.png")
    return snake_cell
}

draw_snake :: proc(gs: ^game.GameState, texture: rl.Texture2D) {
    for i in 0..<gs^.snake.length{
        x := gs^.snake.x[i + gs^.snake.tail_index]
        y := gs^.snake.y[i + gs^.snake.tail_index]
        rl.DrawTextureV(texture, {f32(0 + 46*x), f32(0 + 46*(game.WIDTH-y))}, rl.WHITE)
        //rl.DrawTexturePro(texture, rl.Rectangle{30.0, 30.0, 30.0, 30.0}, rl.Rectangle{30.0, 30.0, 30.0, 30.0}, {500, 500}, 0, rl.WHITE)
    }
}