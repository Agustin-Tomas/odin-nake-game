package src


import rl "vendor:raylib"


init_window :: proc(){
    rl.SetTraceLogLevel(rl.TraceLogLevel.ERROR)
    rl.InitWindow(i32(144 * 2), i32(144 * 2), "Snake Game - Dr. Milk")
    //rl.SetTargetFPS(60)
}


Texture :: enum{
    snake_body,
    dead_snake_body,
    food,
}


load_textures :: proc() {
    atlas := (rl.LoadTexture("./assets/snake_game_atlas.png"))
    ctx.atlas = atlas
}


render_scene :: proc(){
    rl.BeginDrawing()

    draw_tiles()
    draw_food()
    draw_snake()

    rl.DrawFPS(0, 0)
    rl.EndDrawing()
}


draw_snake :: proc() {
    tile_len : f32 = 6
    source := rl.Rectangle{3 * tile_len, 0, tile_len, tile_len}

    tint := rl.WHITE
    if ctx.gs.game_lost {
        tint = rl.RED
    }

    x : f32
    y : f32

    scale : f32 = 2

    //offset : f32 = 24 * scale
    offset : f32 = 0

    for i in 0..<ctx.gs.snake.length{
        x = f32(ctx.gs.snake.x[clock_add(ctx.gs.snake.tail_index, i, TILE_SIZE)]) * tile_len
        y = (f32(HEIGHT - 1) - f32(ctx.gs.snake.y[clock_add(ctx.gs.snake.tail_index, i, TILE_SIZE)])) * tile_len

        dest := rl.Rectangle{x * scale + offset, y * scale + offset, tile_len * scale, tile_len * scale}

        //rl.DrawTextureV(snake_body, {f32(0 + 46*x), f32(0 + 46*(game.WIDTH-y))}, rl.WHITE)
        rl.DrawTexturePro(ctx.atlas, source, dest, rl.Vector2{0, 0}, 0, tint)
    }
}

draw_food :: proc() {
    tile_len : f32 = 6
    source := rl.Rectangle{7 * tile_len, 0, tile_len, tile_len}

    scale : f32 = 2
    //offset : f32 = 24 * scale
    offset : f32 = 0

    x : f32
    y : f32
    contains_food : bool
    for x_i in 0..<WIDTH {
        for y_i in 0..<HEIGHT{
            contains_food = ctx.gs.food_buffer[x_i + y_i * WIDTH]
            if contains_food {
                x = f32(x_i) * tile_len
                y = f32(HEIGHT - 1 - y_i)  * tile_len
                dest := rl.Rectangle{x * scale + offset, y * scale + offset, tile_len * scale, tile_len * scale}
                rl.DrawTexturePro(ctx.atlas, source, dest, rl.Vector2{0, 0}, 0, rl.WHITE)
            }
        }
    }
}

draw_tiles :: proc() {
    tile_len : f32 = f32(6)
    //source := rl.Rectangle{0 * tile_len, 0, tile_len, tile_len}

    scale : f32 = f32(2)
    //offset : f32 = f32(24) * scale
    offset : f32 = 0

    x : f32
    y : f32

    color_a := rl.ColorFromNormalized({66/255.0, 42/255.0, 20/255.0, 1})
    color_b := rl.ColorFromNormalized({77/255.0, 54/255.0, 42/255.0, 1})

    if ctx.gs.game_lost {
        color_a = rl.ColorFromNormalized({80/255.0, 80/255.0, 80/255.0, 1})
        color_b = rl.ColorFromNormalized({110/255.0, 110/255.0, 110/255.0, 1})
    }

    for x_i in 0..<WIDTH {
        for y_i in 0..<HEIGHT {
            x = f32(x_i) * tile_len
            y = f32(HEIGHT - 1 - y_i)  * tile_len
            if int(x_i + y_i) % 2 == 0 {
                rl.DrawRectangleV({ x * scale + offset, y * scale + offset }, { tile_len * scale, tile_len * scale }, color_a)
            } else {
                rl.DrawRectangleV({ x * scale + offset, y * scale + offset }, { tile_len * scale, tile_len * scale }, color_b)
            }
        }
    }
}

