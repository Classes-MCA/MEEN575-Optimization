import numpy as np
import time

def structure(x, params):
    mass = (1 - x[0])**2 + params[0] * (x[1] - x[0]**2)**2
    stress = np.zeros(2)
    stress[0] = x[0]**2 + x[1]**2
    stress[1] = x[0] + params[1]*x[1]
    # time.sleep(0.5)

    return mass, stress