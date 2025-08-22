let main (n: i32) (m: i32) (d: i32): i32 =
    let css = make.complex.numbers n m
    let escapes = mandelbrot css d
    in reduce (+) 0 (reshape (n*m) escapes)

let divergence (c: complex) (d: i32): i32 =
    loop ((z, i) = (c, 0)) = while i < d && dot(z) < 4.0 do (addComplex(c, mulComplex(z, z)), i + 1)
    in i

let mandelbrot(css: [n][m] complex) (d: i32): [n][m]i32 =
    map (\cs ->
        map (\c -> divergence c d)
            cs)
        css