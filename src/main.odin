package main

import "core:fmt"

WIDTH : u64 : 19
HEIGHT : u64 : 19
max_segments :: u64(WIDTH) * u64(HEIGHT)

Direction:: enum{
    North,
    South,
    East,
    West,
}

Segment:: struct {
    x: u64,
    y: u64,
}



clock_add:: proc(n: u64, add: u64, maximum: u64) -> u64 {
    result: u64
    if n > maximum do result = 0
    else if (n + add) > maximum do result = clock_add(0, ((n + add - u64(1)) - maximum), maximum)
    else do result = (n + add)

    return result
}

clock_subtract:: proc(n: u64, subtract: u64, maximum: u64) -> u64 {
    result: u64
    if n < 0 do result = maximum
    else if subtract > n do result = clock_subtract(0, (subtract - n), maximum)
    else do result = n - subtract

    return result
}

/*
// World topology
move_snake :: proc() {
    #partial switch p.facing {
        case Direction.North:
            if p.y == HEIGHT do p.y = 0
            else do p.y += 1
        case Direction.South:
            if p.y == 0 do p.y = HEIGHT
            else do p.y -= 1
        case Direction.East:
            if p.x == WIDTH do p.x = 0
            else do p.x += 1
        case Direction.West:
            if p.x == 0 do p.x = WIDTH
            else do p.x -= 1
}
}
*/



delete_tail:: proc(segments: ^[max_segments]Segment, length: ^u64, tail: ^u64) {
    // Undraw tail: at segments[tail^]
    tail^ += 1
    length^ -= 1
}


add_new_head:: proc(segments: ^[max_segments]Segment, tail_i: ^u64, direction: ^Direction, length: ^u64) {
    current_head_x := segments^[clock_add(tail_i^, (length^ - u64(1)), max_segments)].x
    current_head_y := segments^[clock_add(tail_i^, (length^ - u64(1)), max_segments)].y

    new_head_x : u64 = current_head_x
    new_head_y : u64 = current_head_y

    #partial switch direction^ {
        case Direction.North:
            new_head_y = clock_add(u64(current_head_y), u64(1), u64(HEIGHT))
        case Direction.South:
            new_head_y = clock_subtract(u64(current_head_y), u64(1), u64(HEIGHT))
        case Direction.East:
            new_head_x = clock_add(u64(current_head_x), u64(1), u64(WIDTH))
        case Direction.West:
            new_head_x = clock_subtract(u64(current_head_x), u64(1), u64(WIDTH))
    }
    new_head_index: u64 = clock_add(tail_i^, length^, max_segments)
    segments^[new_head_index] = Segment{new_head_x, new_head_y}
    length^ += 1

    //Draw head
}


update_frame:: proc(segments: ^[max_segments]Segment, length:^u64, tail: ^u64, direction: ^Direction) {
    delete_tail(segments, length, tail)
    add_new_head(segments, tail, direction, length)



// create_new_head
    // update segments state
    // update tiles state
        // add dead tail tile and remove new head tile
    // return state

}


main:: proc() {
    // Starting position
    start_x : u64 = 4
    start_y : u64 = 16
    // Initial snake length
    snake_len: u64 = 3
    // Initial tail index
    tail_index: u64 = 0

    // Snake body state
    posible_segments : [max_segments]Segment
    // Initialize snake - Testing
    posible_segments[0] = Segment{start_x - u64(2), start_y} // Tail
    posible_segments[1] = Segment{start_x - u64(1), start_y} // Mid
    posible_segments[2] = Segment{start_x, start_y} // Head

    // Tile state buffers
    // foo_buffer[x + y * WIDTH]
    food_buffer : [WIDTH * HEIGHT]bool
    snake_buffer : [WIDTH * HEIGHT]bool
    uccupied_tiles_buffer : [WIDTH * HEIGHT]bool

    //Slice of pointers to food_buffer
    food_lotery_buffer : [WIDTH * HEIGHT]^bool
    food_lotery_len : u64

    food_buffer[15 + 4 * WIDTH] = true

    snake_buffer[start_x - u64(2) + start_y * WIDTH] = true
    snake_buffer[start_x - u64(1) + start_y * WIDTH] = true
    snake_buffer[start_x + start_y * WIDTH] = true

    uccupied_tiles_buffer = (snake_buffer | food_buffer)

    // count empity
    empity_tiles_count: u64
    used_tiles_count: u64
    for x in 0..<WIDTH {
        for y in 0..<HEIGHT{
            switch uccupied_tiles_buffer[x + y * WIDTH]  {
            case true:
                used_tiles_count += 1
                fmt.println("x", x, "y", y)
            case false:
                empity_tiles_count += 1

                food_lotery_buffer[food_lotery_len] = &food_buffer[x + y * WIDTH]
                food_lotery_len += 1
            }
        }

    }

    fmt.println("len food":)

    fmt.println("Total", WIDTH * HEIGHT)
    fmt.println("Usadas", used_tiles_count)
    fmt.println("Libres", empity_tiles_count)

    max_frames: int = 30
    // Testing
    direction := Direction.East

    /*
    fmt.println("frame:", 0)
    fmt.println("tail", posible_segments[tail_index].x, posible_segments[tail_index].y)
        fmt.println("body", posible_segments[clock_add(tail_index, u64(1), max_segments)].x, posible_segments[clock_add(tail_index, u64(1), max_segments)].y)
        fmt.println("head", posible_segments[clock_add(tail_index, u64(2), max_segments)].x, posible_segments[clock_add(tail_index, u64(2), max_segments)].y, "\n")
    */

    for i in 0..<max_frames {
        // Testing
        if i == 10  {
            direction = Direction.North
            fmt.printfln("turn North")
        }
        else if i == 20 {
            direction = Direction.West
            fmt.printfln("turn West")

        }

        update_frame(&posible_segments, &snake_len, &tail_index, &direction)

        /*
        fmt.println("frame:", i+1)
        fmt.println("tail", posible_segments[tail_index].x, posible_segments[tail_index].y)
        fmt.println("body", posible_segments[clock_add(tail_index, u64(1), max_segments)].x, posible_segments[clock_add(tail_index, u64(1), max_segments)].y)
        fmt.println("head", posible_segments[clock_add(tail_index, u64(2), max_segments)].x, posible_segments[clock_add(tail_index, u64(2), max_segments)].y, "\n")
        */
    }
}
