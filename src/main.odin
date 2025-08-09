package src
// Program entry point
// Main proc is an orquester


//import "core:fmt"
import rl "vendor:raylib"

import "renderer"
import "game"


main:: proc() {
    gs := game.init_game_state()
    defer free(gs)

    //renderer.init_renderer()

    // Mainloop
    rl.InitWindow(i32(46*game.WIDTH), i32(46*game.HEIGHT), "Snake Game - Dr. Milk")

    frame_counter: u64
    rl.SetTargetFPS(20)

    texture := renderer.init_renderer(gs)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        renderer.draw_snake(gs, texture)
        rl.EndDrawing()
        game.update_frame(gs)

        // testing: snake movement
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

        frame_counter += 1
    }
    rl.CloseWindow()

    //update_frame(gs)
    //show_snake(gs)
}
