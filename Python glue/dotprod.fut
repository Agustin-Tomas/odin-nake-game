let main (things1: []i32) (things2: []i32): i32 =
reduce (+) 0 (map2 (*) things1 things2)