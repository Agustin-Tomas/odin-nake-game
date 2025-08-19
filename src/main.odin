package src
// Program entry point
// Main proc is an orquester


import rl "vendor:raylib"


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
    last_gs: ^Game_State,
    mod_gs: ^Game_State,
    st_changelog: [dynamic]int,
    nd_changelog: int,
    dt: f64,
    screen: Screen,
    bindings: map[PlayerCommand]rl.KeyboardKey,
    atlas: rl.Texture,
}


_actual_game_state : ^Game_State
ctx : Context


main:: proc() {
    _actual_game_state = init_game_state()
    ctx.gs = _actual_game_state
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
    init_window()
    set_bindings()
    load_textures()

    game_loop : for !rl.WindowShouldClose() {
        read_game_input()
        update_state()
        render_scene()


        if ctx.gs.game_lost {
            rl.WaitTime(1)
            break game_loop }
    }
}

