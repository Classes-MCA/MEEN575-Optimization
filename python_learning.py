import numpy as np
from scipy.optimize import minimize
from scipy.optimize import Bounds
from structure import structure

def runoptimization(params, stressmax):

    objhist = []

    def objcon(x):
        nonlocal objhist
        mass, stress = structure(x,params)
        f = mass
        g = stressmax - stress
        objhist.append(mass)
        return f, g

    # ----- don't change ----- #

    xlast = []
    flast = []
    glast = []

    def obj(x):
        nonlocal xlast, flast, glast
        if not np.array_equal(x,xlast):
            flast, glast = objcon(x)
            xlast = x
        return flast

    def con(x):
        nonlocal xlast, flast, glast
        if not np.array_equal(x,xlast):
            flast, glast = objcon(x)
            xlast = x
        return glast

    # ----- can change ----- #

    x0 = [3.0, 3.0]
    lb = [0.0, 0.0]
    ub = [10.0, 10.0]
    bounds = Bounds(lb, ub, keep_feasible = True)
    constraints = {'type': 'ineq', 'fun': con}
    options = {'disp': True}

    res = minimize(obj, x0, constraints = constraints, options = options, bounds = bounds)
    print("x = ", res.x)
    print("f = ", res.fun)
    print(res.success)

    return res.x, res.fun, objhist

if __name__ == "__main__":
    params = [100.0, 3.0]
    stressmax = [1.0, 5.0]

    xstar, fstar, objhist = runoptimization(params, stressmax)

    import matplotlib.pyplot as plt
    plt.figure()
    plt.semilogy(objhist)
    plt.show()