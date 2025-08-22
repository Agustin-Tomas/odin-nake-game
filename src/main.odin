package src
// Program entry point
// Main proc is an orquester


import rl "vendor:raylib"
import time "core:time"

Screen :: enum{
    Intro,
    Main_Menu,
    Config_Menu,
    Gameplay,
    Pause,
    Game_Over,
}


Context :: struct{
    gs: ^Game_State,
    last_tick_gs: ^Game_State,
    new_tick_gs: ^Game_State,
    st_changelog: [dynamic]^Changelog,
    nd_changelog: [dynamic]^Changelog,
    dt: f64,
    screen: Screen,
    bindings: map[PlayerCommand]rl.KeyboardKey,
    atlas: rl.Texture,
}


_actual_game_state : ^Game_State
ctx : Context


main:: proc() {
    ctx.screen = .Gameplay

    switch ctx.screen{
    case .Intro:
        return
    case .Main_Menu:
        return
    case .Config_Menu:
        return
    case .Gameplay:
        init_game_loop()
    case .Pause:
        return
    case .Game_Over:
        return
    }
}

init_game_loop :: proc() {
    _first_game_state := init_game_state()
    _second_game_state := init_game_state()
    _third_game_state := init_game_state()
    ctx.gs = _first_game_state
    ctx.last_tick_gs = _second_game_state
    ctx.new_tick_gs = _third_game_state

    init_window()
    set_bindings()
    load_textures()

    TPS : i64 : 60
    GAME_TICK_DURATION : i64 : i64( 1000000000 / TPS)
    start := time.tick_now()
    end : time.Tick
    game_loop : for !rl.WindowShouldClose() {
        defer end = time.tick_now()

        read_game_input()
        if time.duration_nanoseconds(time.tick_diff(start, end)) >= GAME_TICK_DURATION {
            defer start = time.tick_now()
            update_state()
        }
        render_scene()


        if ctx.gs.game_lost {
            rl.WaitTime(1)
            break game_loop }

    }
}

