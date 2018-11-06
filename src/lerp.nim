
proc lerp*(a: float, b: float, c: float): float =
    result = (a * (1.0 - c)) + (b * c)