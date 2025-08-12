package renderer

import rl "vendor:raylib"

import game "../game"

init_renderer :: proc(gs: ^game.GameState) -> rl.Texture2D {
    atlas := (rl.LoadTexture("./assets/snake_game_atlas.png"))
    return atlas
}

draw_snake :: proc(gs: ^game.GameState, atlas: ^rl.Texture2D) {
    tile_len : f32 = 6
    source := rl.Rectangle{3 * tile_len, 0, tile_len, tile_len}

    tint := rl.WHITE
    if gs^.game_lost {
        tint = rl.RED
    }

    x : f32
    y : f32

    scale : f32 = 2

    //offset : f32 = 24 * scale
    offset : f32 = 0

    for i in 0..<gs^.snake.length{
        x = f32(gs^.snake.x[game.clock_add(gs^.snake.tail_index, i, game.TILE_SIZE)]) * tile_len
        y = (f32(game.HEIGHT - 1) - f32(gs^.snake.y[game.clock_add(gs^.snake.tail_index, i, game.TILE_SIZE)])) * tile_len

        dest := rl.Rectangle{x * scale + offset, y * scale + offset, tile_len * scale, tile_len * scale}

        //rl.DrawTextureV(snake_body, {f32(0 + 46*x), f32(0 + 46*(game.WIDTH-y))}, rl.WHITE)
        rl.DrawTexturePro(atlas^, source, dest, rl.Vector2{0, 0}, 0, tint)
    }
}

draw_food :: proc(gs: ^game.GameState, atlas: ^rl.Texture2D) {
    tile_len : f32 = 6
    source := rl.Rectangle{7 * tile_len, 0, tile_len, tile_len}

    scale : f32 = 2
    //offset : f32 = 24 * scale
    offset : f32 = 0

    x : f32
    y : f32
    contains_food : bool
    for x_i in 0..<game.WIDTH {
        for y_i in 0..<game.HEIGHT{
            contains_food = gs^.food_buffer[x_i + y_i * game.WIDTH]
            if contains_food {
                x = f32(x_i) * tile_len
                y = f32(game.HEIGHT - 1 - y_i)  * tile_len
                dest := rl.Rectangle{x * scale + offset, y * scale + offset, tile_len * scale, tile_len * scale}
                rl.DrawTexturePro(atlas^, source, dest, rl.Vector2{0, 0}, 0, rl.WHITE)
            }
        }
    }
}

draw_tiles :: proc(gs: ^game.GameState, atlas: ^rl.Texture2D) {
    tile_len : f32 = f32(6)
    //source := rl.Rectangle{0 * tile_len, 0, tile_len, tile_len}

    scale : f32 = f32(2)
    //offset : f32 = f32(24) * scale
    offset : f32 = 0

    x : f32
    y : f32

    color_a := rl.ColorFromNormalized({66/255.0, 42/255.0, 20/255.0, 1})
    color_b := rl.ColorFromNormalized({77/255.0, 54/255.0, 42/255.0, 1})

    if gs^.game_lost {
        color_a = rl.ColorFromNormalized({80/255.0, 80/255.0, 80/255.0, 1})
        color_b = rl.ColorFromNormalized({110/255.0, 110/255.0, 110/255.0, 1})
    }

    for x_i in 0..<game.WIDTH {
        for y_i in 0..<game.HEIGHT {
            x = f32(x_i) * tile_len
            y = f32(game.HEIGHT - 1 - y_i)  * tile_len
            if int(x_i + y_i) % 2 == 0 {
                rl.DrawRectangleV({ x * scale + offset, y * scale + offset }, { tile_len * scale, tile_len * scale }, color_a)
            } else {
                rl.DrawRectangleV({ x * scale + offset, y * scale + offset }, { tile_len * scale, tile_len * scale }, color_b)
            }
        }
    }
}
