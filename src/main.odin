package src
// Program entry point
// Main proc is an orquester


//import "core:fmt"
import rl "vendor:raylib"

import "renderer"
import "game"
import "input"


main:: proc() {
    gs := game.init_game_state()
    defer free(gs)

    //renderer.init_renderer()

    //rl.InitWindow(i32(46*game.WIDTH), i32(46*game.HEIGHT), "Snake Game - Dr. Milk")
    //main grid 144+1 * 144+1
    rl.SetTraceLogLevel(rl.TraceLogLevel.ERROR)
    rl.InitWindow(i32(144 * 2), i32(144 * 2), "Snake Game - Dr. Milk")
    rl.SetTargetFPS(13)

    bindings := input.init_input(gs)

    atlas := renderer.init_renderer(gs)


    // Mainloop
    main_loop : for !rl.WindowShouldClose() {
        //input.read_input()
        input.read_input(gs, bindings)

        game.update_state(gs)

        rl.BeginDrawing()
        if gs.game_lost{
            rl.ClearBackground(rl.ColorFromNormalized({80/255.0, 80/255.0, 80/255.0, 1}))
        } else {
            rl.ClearBackground(rl.ColorFromNormalized({21/255.0, 38/255.0, 15/255.0, 1}))
        }
        renderer.draw_tiles(gs, &atlas)
        renderer.draw_snake(gs, &atlas)
        renderer.draw_food(gs, &atlas)
        //rl.DrawFPS(0, 0)
        rl.EndDrawing()

        if gs^.game_lost {
            rl.WaitTime(1)
            break main_loop
        }


        // testing: snake movement
        /*
        switch frame_counter%35 {
        case 0:
            gs^.snake.direction = .East
        case 8:
            gs^.snake.direction = .North
        case 17:
            gs^.snake.direction = .West
        case 28:
            gs^.snake.direction = .North
        }
        */

    }
    rl.CloseWindow()

    //update_frame(gs)
    //show_snake(gs)
}
