package main

import "core:fmt"

WIDTH : u8 : 19
HEIGHT : u8 : 19

Direction:: enum{
    North,
    South,
    East,
    West,
}

Mobile:: struct {
    x: u8,
    y: u8,
    facing: Direction,
}



update_frame:: proc(p: ^Mobile) {
    #partial switch p.facing {
        case Direction.North:
            if p.y == HEIGHT do p.y = 0
            else do p.y += 1
        case Direction.South:
            if p.y == 0 do p.y = 19
            else do p.y -= 1
        case Direction.East:
            if p.x == WIDTH do p.x = 0
            else do p.x += 1
        case Direction.West:
            if p.x == 0 do p.x = 19
            else do p.x -= 1

    }
}


main:: proc() {
    character : Mobile
    // Starting conditions
    character.x = u8(4)
    character.y = u8(4)
    character.facing = Direction.West

    max_frames: int = 30
    fmt.println(character.x, character.y)
    for i in 0..<max_frames {
        update_frame(&character)
        fmt.println(character.x, character.y)
    }
}