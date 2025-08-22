import numpy as np

import dotprod

m = dotprod.dotprod()
a = np.array([1,2,4,6,3,6], dtype=np.int32)
b = np.array([0,0,0,0,0,1], dtype=np.int32)
x = m.main(a, b)

print(x)

