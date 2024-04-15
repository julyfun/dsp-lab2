import numpy as np
import matplotlib.pyplot as plt
from dsppy import *

TEST = "some"
if TEST == "CTFT":
    def g(t):
        return np.where((t >= -4) & (t <= 4), 2, 0)

    t_values = np.linspace(-5, 9, SAMPLE_N)
    g_values = g(t_values)

    maxw = 10 * np.pi
    w_values = np.linspace(-maxw, maxw, SAMPLE_N)
    Gw = CTFT(g_values, t_values, w_values)
    debug_draw(w_values, np.abs(Gw))

if TEST == "DTFT":
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

if TEST == "DFT":
    y = np.array([-1, 2, 3, 0, -2, 1, 4, -3, 0, -2])
    dft_w_vec, dft_vec = DFT(y)
    debug_draw(dft_w_vec, np.abs(dft_vec))

if TEST == "IDTFT":
    def low_pass_filter(w):
        return np.where(np.abs(w) <= 0.3 * np.pi, 1, 0)
    ns, hs = IDTFT(-30, 30, low_pass_filter)
    debug_draw(ns, np.abs(
        hs), title="IDTFT (difference equation coefficients) of low pass filter",
        xlabel="n", ylabel="h[n]")

if TEST == "filter":
    bz = [2, 3]
    az = [1, -0.5]
    L = 100
    xs = [1, 2, 3]
    xs, ys = filter(bz, az, xs, L)  # first several inputs
    debug_draw(np.arange(L), ys, label="Outputs")

if TEST == "freqz":
    bz = [2, 3]
    az = [1, -0.5]
    w_values = np.linspace(-np.pi, np.pi, SAMPLE_N)

    def get_mod_pha_real_imag(c):
        return [np.abs(c), np.angle(c), c.real, c.imag]
    w, cap_hs = freqz(bz, az, w_values)
    debug_draw(w, get_mod_pha_real_imag(cap_hs)[0], xlabel="Frequency",
               ylabel="Magnitude", title="Frequency Response")


if TEST == "pzmap":
    bz = [2, 3]
    az = [1, -0.5]
    debug_draw_poles_and_zeros(*pzmap(bz, az))

if TEST == "some":
    draw_some_other_thing()
