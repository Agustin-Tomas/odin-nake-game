package ode

fun :: proc(x, y: f64) -> f64 {
    return x + y
}

f :: proc(x, y: f64) -> f64

rk4_step :: proc(diffeq: f, x0, y0, h: f64) -> f64 {
    resultado : f64
    HALF : f64 : 0.5
    SIXTH : f64 : 1.0 / 6.0
    TWO : f64 : 2

    k1 := diffeq(x0, y0)
    k2 := diffeq(x0 + HALF * h, y0 + HALF * k1 * h)
    k3 := diffeq(x0 + HALF * h, y0 + HALF * k2 * h)
    k4 := diffeq(x0 + HALF, y0 + k3 * h)
    resultado = y0 + h * SIXTH * (k1 + k2 * TWO + k3 * TWO + k4)

    return resultado
}

ode_solve_rk4_elapsed :: proc(diffeq: f, x0, y0, h, max_x: f64) -> ([dynamic]f64, [dynamic]f64) {
    next_x := x0
    next_y := y0
    x_serie := make([dynamic]f64)
    y_serie := make([dynamic]f64)
    append(&x_serie, next_x)
    append(&y_serie, next_y)
    for next_x + h <= max_x {
        next_x += h
        next_y = rk4_step(diffeq, next_x, next_y, h)
        append(&x_serie, next_x)
        append(&y_serie, next_y)
    }
    return x_serie, y_serie
}

