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
    rl.InitWindow(1280, 720, "Snake Game - Dr. Milk")

    frame_counter: u64
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.EndDrawing()

        renderer.init_renderer(gs)

        // testing: snake movement
        switch frame_counter {
        case 0:
            gs^.snake.direction = .East
        case 10:
            gs^.snake.direction = .North
        case 20:
            gs^.snake.direction = .West
        }

        frame_counter += 1
    }
    rl.CloseWindow()

    //update_frame(gs)
    //show_snake(gs)
}
