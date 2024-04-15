import numpy as np
import matplotlib.pyplot as plt

SAMPLE_N = 5000


def CTFT(x, t, w):
    """
    x[i] and t[i] is the i-th sample of the signal and time,
    for each w[i], this function will calculate the CTFT of x(t) at w[i].

    ## Examples

    ```py
    def g(t):
        return np.where((t >= -4) & (t <= 4), 2, 0)

    t_values = np.linspace(-5, 9, SAMPLE_N)
    g_values = g(t_values)

    maxw = 10 * np.pi
    w_values = np.linspace(-maxw, maxw, SAMPLE_N)
    Gw = CTFT(g_values, t_values, w_values)
    ```
    """
    Xw = np.zeros_like(w, dtype=complex)
    dt = t[1] - t[0]
    for i, wi in enumerate(w):
        # Two iterators here, x and t
        Xw[i] = np.sum(x * np.exp(-1j * wi * t) * dt)
    return Xw
    ...


def DTFT(nT, xn, w):
    """
    nT[i] and xn[i] is the i-th sample of the time and signal,
    for each w[i], this function will calculate the DTFT of x(t) at w[i].

    ## Examples

    ```py
    def g(t):
        return np.where((t >= -4) & (t <= 4), 2, 0)
    sample_t = 0.1
    nt = np.arange(1000) * sample_t
    gn = g(nt)
    sample_w = 2 * np.pi / sample_t
    w_vec = np.linspace(-sample_w / 2, +
                        sample_w / 2, SAMPLE_N)  # nyquist interval
    dtft_vec = DTFT(nt, gn, w_vec)
    debug_draw(w_vec, np.abs(dtft_vec))
    ```
    """
    Xw = np.zeros(len(w), dtype=complex)
    for i, wi in enumerate(w):
        Xw[i] = np.sum(xn * np.exp(-1j * wi * nT))
    return Xw


def DFT(ys):
    """
    Calculate the Discrete Fourier Transform of the signal `ys`,
    which is an N-point sampling of the DTFT of the signal. 

    ## Examples

    ```py
    y = np.array([-1, 2, 3, 0, -2, 1, 4, -3, 0, -2])
    dft_w_vec, dft_vec = DFT(y)
    debug_draw(dft_w_vec, np.abs(dft_vec))
    ```
    """
    n = len(ys)
    ns = np.arange(n)

    def omega_k(k):
        return 2 * np.pi * k / n
    w_vec = np.array([omega_k(k) for k in range(n)])
    dft_vec = np.array([sum(ys * np.exp(-1j * w * ns)) for w in w_vec])
    return w_vec, dft_vec


def filter(bz, az, x, L):
    """
    `bz` and `az` is the coefficients of the difference equation.
    For the input signal x, this function will calculate first L terms of the output signal y.

    ## Examples

    ```py
    bz = [2, 3]
    az = [1, -0.5]
    L = 100
    xs = [1, 2, 3]
    xs, ys = filter(bz, az, xs, L)  # first several inputs
    debug_draw(np.arange(L), ys, label="Outputs")
    ```
    """
    def expand(arr, n):
        return np.pad(arr, (0, n - len(arr)), 'constant')
    xs = expand(x, L)
    ys = np.zeros_like(xs)

    def y_at(n):
        return 0 if n < 0 else ys[n]

    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - \
            sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys


def pzmap(bz, az):
    """
    Get the poles and zeros of the filter with the given difference equation coefficients.

    ## Examples

    ```py
    bz = [2, 3]
    az = [1, -0.5]
    debug_draw_poles_and_zeros(*pzmap(bz, az))
    ```
    """
    def expand(arr, n):
        return np.pad(arr, (0, n - len(arr)), 'constant')
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]


def freqz(bz, az, w):
    """
    get the frequency response of the filter with the given difference equation coefficients.

    ## Examples

    ```py
    bz = [2, 3]
    az = [1, -0.5]
    w_values = np.linspace(-np.pi, np.pi, SAMPLE_N)

    def get_mod_pha_real_imag(c):
        return [np.abs(c), np.angle(c), c.real, c.imag]
    w, cap_hs = freqz(bz, az, w_values)
    debug_draw(w, get_mod_pha_real_imag(cap_hs)[0], xlabel="Frequency",
               ylabel="Magnitude", title="Frequency Response")

    ```
    """
    def cap_h_value(bz, az, z: complex):
        num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
        den = sum([az[i] * z ** (-i) for i in range(len(az))])
        return num / den
    cap_hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, cap_hs  # values of H(w)


def IDTFT(minn, maxn, dtft_func):
    """
    Calculate the inverse DTFT of the given DTFT function (like a low-pass filter function),
    truncated to the range [minn, maxn].

    ## Examples

    ```py
    def low_pass_filter(w):
        return np.where(np.abs(w) <= 0.3 * np.pi, 1, 0)
    ns, hs = IDTFT(-30, 30, low_pass_filter)
    debug_draw(ns, np.abs(
        hs), title="IDTFT (difference equation coefficients) of low pass filter",
        xlabel="n", ylabel="h[n]")
    ```
    """
    ns = np.arange(minn, maxn + 1)
    hs = np.zeros_like(ns, dtype=complex)
    w_samples = np.linspace(-np.pi, np.pi, SAMPLE_N)
    f_samples = dtft_func(w_samples)
    dw = w_samples[1] - w_samples[0]
    for i in range(len(ns)):
        hs[i] = 1 / (2 * np.pi) * np.sum(f_samples *
                                         np.exp(1j * ns[i] * w_samples) * dw)
    return ns, hs  # hs itself is causal


def debug_draw(xs, ys, xlabel="x", ylabel="y", label=f"y(x)", color="-", figsize=(10, 6), title=""):
    """
    Show a debugging plot for the given data.
    color: '--', '-.', ':', '-', 'o', '*', '<', '|', '_', 'v', '1', '2', '3'... as you like
        its prefix can be 'r', 'b', 'g', 'y', 'k'.. to assign the color
    """
    plt.figure(figsize=figsize)
    plt.plot(xs, ys, color, label=label)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.legend()
    plt.title(title)
    plt.show()


def debug_draw_poles_and_zeros(bz, az, xlabel="Real Part", ylabel="Imaginary Part", figsize=(6, 6), title="Poles and Zeros"):
    """
    Easily plot the poles and zeros of the filter.
    """
    plt.figure(figsize=figsize)
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    plt.scatter(real_parts1, imaginary_parts1,
                marker='o', color='b', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2,
                marker='x', color='r', label='Poles')
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    plt.gca().set_aspect('equal', adjustable='box')
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title)
    plt.legend()
    plt.grid(True)
    plt.show()


def draw_some_other_thing():
    """
    This is an example to draw vertical and horizontal lines.
    """
    L = 10
    y = np.array([-1, 2, 3, 0, -2, 1, 4, -3, 0, -2])
    ns = np.arange(L)
    plt.figure(figsize=(18, 6))
    # [Draw vertical lines]
    plt.vlines(ns, ymin=0, ymax=y, colors='r', linestyles='solid', label='G1')
    # [Draw a horizontal line across the axis]
    plt.axhline(y=0, color='k')
    # [Draw a red point]
    x1, y1 = 3.3, 3.8
    plt.plot(x1, y1, 'ro')
    # plt.loglog() # plot in logarithmic form
    # plt.semilogx() # plot x in logarithmic form
    # plt.semilogy() # plot y in logarithmic form
    # [Text annotation]
    plt.text(x1, y1, f"({x1}, {y1})", ha='right', va='bottom')  # 标注坐标
    # Set the range for axis
    plt.xlim(0, 12)
    plt.ylim(-4, 5)
    plt.legend()
    plt.show()
