#set page(paper: "us-letter")
#set heading(numbering: "1.a.1.")
#set figure(numbering: "1")

// 这是注释
#figure(image("sjtu.png", width: 50%), numbering: none) \ \ \

#align(center, text(17pt)[
  *Laboratory Report of Digital Signal Processing* \ \
  #table(
      columns: 2,
      stroke: none,
      rows: (2.5em),
      // align: (x, y) =>
      //   if x == 0 { right } else { left },
      align: (right, left),
      [Name:], [Junjie Fang],
      [Student ID:], [521260910018],
      [Date:], [2024/3/4],
      [Score:], [],
    )
])

#pagebreak()

#set page(header: align(right)[
  DSP Lab2 Report - Junjie FANG
], numbering: "1")

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

#outline(indent: 1.5em)

= Signal operations <1>

Given the parameters $A = 3, B = 4, D = 8$, the three gate functions are defined
by:

$
  g_0(t) &:= cases(4 "if" 0 <= t <= 3, 0 "otherwise") \
  g_1(t) &:= cases(4 "if" -3 / 8 <= t <= -3 / 5 \
  0 "otherwise") \
  g_2(t) &:= cases(8 "if" 8 <= t <= 11 \
  0 "otherwise")
$

And we know:

$
  x(t) := sum_(i = 0)^2 g_i (t)
$

We plot the $x$ function in the figure below:

#figure(image("1.jpg", width: 50%))

It can be seen that the images of the three gate functions do not overlap.

In practice, we use python's `matplotlib` to draw function images. For
scalability, we use the `gate_func()`, `func_transform()` and
`add_func()` to generate, transform and add functions.
See @py1 for the code.

= Aliasing phenomenon in sampling process

Let the frequencies corresponding to the two peaks in the image be $f_(a 1), f_(a 2)$ and
the function values be $X_1, X_2$. The sampling frequency is $f_s = 100"Hz"$.
According to the sampling theorem, we have:

$
  f_(a 1) &= plus.minus f_1 - k_1 f_s\
  f_(a 2) &= plus.minus f_2 - k_2 f_s\
$

where:

$
  k_1, k_2 != 0 \
  800"Hz" <= f_1, f_2 <= 850"Hz"
$

Plug the data $f_(a 1) = 14, f_(a 2) = 3$ into the equation and we can determine
that the only solution is:

$
  k_1 = 8, f_1 = 814"Hz" \
  k_2 = 8, f_2 = 803"Hz"
$

Next, we can determine the amplitudes $A_1$ and $A_2$ by reviewing some of the
properties of _Contiunous-Time Fourier Transform (CTFT)_. The Fourier Transform 
used in this question is in the form:

$
  X(j f) &= integral_(-oo)^(+oo) x(t) e^(-j 2 pi f t) dif t \
  x(t) &= integral_(-oo)^(+oo) X(j f) e^(j 2 pi f t) dif f
$

In this form, the cosine wave with amplitude $1$ and the following sum of two
impulse function form a Fourier Transform pair:

$
  cos(2 pi f_0 t) & <==>^("F.T.") 1 / 2 (delta(f - f_0) + delta(f + f_0)) \
$

Due to the linearity of Fourier Transform, we know that the amplitudes should be
twice the height of peaks in the frequency domain. Therefore, we have:

$
  A_1 = 2 X_1 = 4 \
  A_2 = 2 X_2 = 2
$

#align(center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: center,
    [Parameters], [$i = 1$], [$i = 2$],
    $f_i$, [$814"Hz"$], [$803"Hz"$],
    $A_i$, [4], [2]
  )
)
= Continuous-Time Fourier Transform properties

== Creation of Continuous-Time Fourier Transform (_CTFT_) function <3.a>

The definition of _CTFT_ is:

$ X_omega = integral_(-oo)^(+oo) x(t) dot e^(-j omega t) dif t $

To integrate arbitrary functions in code, we use discrete sampling summation for approximate integration. The code is in Appendix 3.a. In this code, the `CTFT(x, t, w)` function take `x` and `t` as lists of sampled data in time domain, which should be calculated outside the function.
For each element in `w`, which represents a frequency, the function calculates _CTFT_ at this frequency, and finally return a list of complex numbers.
The code is in @py3.a.

In order to improve the approximation accuracy, we can increase the number of samples (i.e. `SAMPLE_N` parameter).

== Comparison of $g$ and shifted $g$ <3.b>

We can get $g_2 = g(t - D / 2)$ by applying time shifting on $g$. To get $g_2$ in the code, we use a function called `func_tranform` to get the shifted function of $g$. The figure showing both functions is:

#figure(image("image.png", width: 80%), caption: [$g "and" g_2$ in the same plot]) 

== Plot of _CTFT_ of $g$ and $g_2$ <3.c>

Using the function `CTFT()` function realized in _1.a_, we can calculate the _CTFT_ of $g_2$ and $g$ respectively. 

By observing the images of module, phase, real part and imaginary part of the two functions, *we can verify the followling properties of time shifting under _CTFT_:*

+ The module remains unchanged.
+ THe phase changes linearly with $omega$, and the distribution of real and imaginary parts changes.

#figure(image("2-1-1.png", width: 80%), caption: [Module of $g$ and $g_2$])
#figure(image("2-1-2.png", width: 80%), caption: [Phase of $g$ and $g_2$])
#figure(image("2-1-3.png", width: 80%), caption: [Real part of $g$ and $g_2$])
#figure(image("2-1-4.png", width: 80%), caption: [Imaginary part of $g$ and $g_2$])

== Modulation <3.d>

In the code, we can generate $y(t) = g(t) times cos(4 pi t)$ from $g(t)$. The figure below shows the comparison of $g(t)$ and $y(t)$ over $t = [-15, 15]$:

#figure(image("2-1-5.png", width: 80%), caption: [$y$ and $g$ in the same plot])

== Modulation properties of Fourier Tranform <3.e>

To get the module and phase of $y(t)$ and $g(t)$, we can calculte their _CTFT_ like in @3.c.

The modulation property of _CTFT_ gives:

$ G_T_1(t) cos(omega_0 t) <==>^(F.T.) 1 / 2 X[j(omega - omega_0)] +  1/ 2 X[j(omega + omega_0)] $ 

This property can be verified from the figures below, as the module and phase of $g$ is shifted to $omega_0 = 4 pi$ and $-omega_0 = -4pi$ in the frequency domain.
Note the peak value of module of $y$ is half this value of $g$.

#figure(image("2-1-6.png", width: 80%), caption: [Module of $y$ and $g$])

#figure(image("2-1-7.png", width: 80%), caption: [Phase of $y$ and $g$])

== Verification of Parseval's formula <3.f>

In the code we can get the energy in both time and frequency domain, which are $99.95$ and $99.38$. There is a slight difference, and we can consider the two energies to be the same.
The difference comes from the error in the integral calculation and is very small (the error can be reduced by increasing the number of integral samples).

The reason behind that is Parseval's formula, which gives:

$ integral_(-oo)^(+oo) |x(t)|^2 dif t = 1 / (2pi) integral_(-oo)^(+oo) |X(j omega)|^2 dif omega $

This denotes that the energy in time domain is equal to the energy in frequency domain. The proof of this formula is as follows:

$
& integral_(-oo)^(+oo) x^2(t) dif t \
&= integral_(-oo)^(+oo) x(t) (1 / (2pi) integral_(-oo)^(+oo) X(j omega) e^(j omega t) dif omega) dif t \
&= 1 / (2pi) integral_(-oo)^(+oo) X(j omega) (integral_(-oo)^(+oo) x(t) e^(j omega t) dif t) dif omega \ 
&= 1 / (2pi) integral_(-oo)^(+oo) X(j omega) X(-j omega) dif t \
&= 1 / (2pi) integral_(-oo)^(+oo) |X(j omega)| ^ 2  dif t
$

= Discrete-Time Fourier Transform properties

== Creation of the Discrete-Time Fourier Transform (_DTFT_) function <4.a>

The code in appendix implements `DTFT(nT, xn, w)` function, using the following formula:

$ X(omega) = sum_(n = -oo)^(+oo) x(n T) e^(-j omega n T) $

To avoid infinite calculation, we can set a start time and end time for sampling
function, as long as it covers the whole signal.
The code is in @py4.a.

== Plots of _DTFT_ when $T = D / 80$ and $T = D / 40$ <4.b>

Using the function implemented in _3.a_, we rendered the images of $G_(w, 1)$ and $G_(w, 2)$ in a Nyquist interval,

#figure(image("2-2-b-1.png", width: 80%), caption: [Module of $G_(w, 1)$ and $G_(w, 2)$ in $f$])
#figure(image("2-2-b-2.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $f$])
#figure(image("2-2-b-3.png", width: 80%), caption: [Module of $G_(w, 1)$ and $G_(w, 2)$ in $f / f_s$])
#figure(image("2-2-b-4.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $f / f_s$])
#figure(image("2-2-b-5.png", width: 80%), caption: [Module of $G_(w, 1)$ and $G_(w, 2)$ in $w / f_s$])
#figure(image("2-2-b-6.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $w / f_s$])

== Deduciton of the theoretical _CTFT_ function of $g$ <4.c>
 
The theoretical _CTFT_ function of $g$ is:

$
X(w) &= integral_(-oo)^(+oo) g(t) e^(-j omega t) dif t \
&= integral_(-4)^(4) 2 e^(-j omega t) dif t \
&= 2 / (-j omega) (e^(-4 j omega) - e^(4 j omega)) \
&= 16sinc(4 omega)
$

We can plot them in the same figure:


#figure(image("2-2-c-1.png", width: 80%), caption: [Module of $G_(w, 1)$ and _CTFT_ of $g$])
#figure(image("2-2-c-2.png", width: 80%), caption: [Phase of $G_(w, 1)$ and _CTFT_ of $g$])
#figure(image("2-2-c-3.png", width: 80%), caption: [Module of $G_(w, 2)$ and _CTFT_ of $g$])
#figure(image("2-2-c-4.png", width: 80%), caption: [Phase of $G_(w, 2)$ and _CTFT_ of $g$])

For $G_(w, 1)$, the peak value at $omega = 0$ is ten times the _CTFT_ of $g$. That's
because the sampling frequency is $f_s = 10$. And for $G_(w, 2)$ it is five times,
as the sampling frequency is $f_s = 5$.

== Inverse _DTFT_ <4.d>

We can inverse _DTFT_ using the formula:

$ x[n T] = 1 / (w_s) integral_(-w_s / 2)^(+w_s / 2) X[e^(j omega)] e^(j omega n) dif omega $

We get:

#figure(image("2-2-d-1.png", width: 80%), caption: [Figure of the discrete $g_1$ and the inverse of $G_(w, 1)$ ])
#figure(image("2-2-d-2.png", width: 80%), caption: [Figure of the discrete $g_2$ and the inverse of $G_(w, 2)$ ])

This two images shows that the inverse _DTFT_ perfectly matches the discret sampling function.

== Adjusted Parseval's formula <4.e>

The former Parseval's formula is no longer validated for _DTFT_. If we calculate
the energy of the the original function and the _DTFT_ function (in one Nyquist interval to avoid infinite energy), we can get $31.99 "and" 3199.99$, the latter one is 100 times the former one. That is due to the sampling frequency
of the discrete function.

We can adjust this result by adding a factor of $(1 / f_s) ^ 2$ in the formula
of _DTFT_ function, which means the Parseval's formula would be:

$ integral_(-oo)^(+oo) |x(t)|^2 dif t = 1 / (2pi f_s ^ 2) integral_(-w_s / 2)^(+w_s / 2) |X(j omega)|^2 dif omega $. 

= Windowing effects of DTFT

== _DTFT_ of $g$ with gate sampling function <5.a>

We can adopt $2 / N$ as factor to scale magnitudes of _DTFT_ function. The figure is:

#figure(image("2-3-a-1.png", width: 80%), caption: [Figure and peak values when $L = 50$])
#figure(image("2-3-a-2.png", width: 80%), caption: [Figure and peak values when $L = 200$])
#figure(image("2-3-a-3.png", width: 80%), caption: [Figure and peak values when $L = 1000$])

Larger the $L$, the more accurate we can find the right amplitude and frequency.

#import "@preview/tablem:0.1.0": tablem

#figure(
tablem[
  | $L$ | factor | $A_1$ | $A_2$ | $f_1$ | $f_2$ |
  | ------ | ---------- | -------- | ------- | - | - |
  | 50 | $2 / 50$ | $1.46$ | $0.30$ | $16.05$ | $18.50$ |
  | 200 | $2 / 200$ | $1.40$ | $0.67$ | $15.93$ | $17.08$ |
  | 1000 | $2 / 1000$ | $1.40$ | $0.60$ | $16.00$ | $17.00$ |
]
)

== _DTFT_ of $g$ with Hamming function <5.b>

Using Hamming function, the factor should be $2 / (N a_0)$, becuase the area of Hamming function is $integral_0^T a_0 - (1 - a_0) cos((2 pi t) / T) = a_0T$, where
$a_0 = 0.53836$. The figure is:

#figure(image("2-3-b-1.png", width: 80%), caption: [Figure and peak values when $L = 50$])
#figure(image("2-3-b-2.png", width: 80%), caption: [Figure and peak values when $L = 200$])
#figure(image("2-3-b-3.png", width: 80%), caption: [Figure and peak values when $L = 1000$])

#figure(
tablem[
  | $L$ | factor | $A_1$ | $A_2$ | $f_1$ | $f_2$ |
  | ------ | ---------- | -------- | ------- | - | - |
  | 50 | $2 / (50 a_0)$ | $1.48$ | $0.53$ | $16.08$ | $18.50$ |
  | 200 | $2 / (200 a_0)$ | $1.39$ | $0.64$ | $15.97$ | $16.80$ |
  | 1000 | $2 / (1000 a_0)$ | $1.40$ | $0.60$ | $16.00$ | $17.00$ |
]
)

The sidelobes after applying Hamming function are much lower than the original ones, which means the frequency leakage is reduced. But the width of the main lobe is increased, leading to a reduction of frequency resolution.

= DFT and FFT

== Figure of the samples <6.a>

The figure of $y$ is:

#figure(image("4-a.png", width: 80%), caption: [Figure of $y$])

== Module and phase of $y$'s _DTFT_ <6.b>

We can use the `DTFT()` function defined in the previous questions. The modulus and phase of _DTFT_ of $y$ in a Nyquist interval are:

#figure(image("4-b-1.png", width: 80%), caption: [Module of _DTFT_ $y$])
#figure(image("4-b-2.png", width: 80%), caption: [Phase of _DTFT_ of $y$])

The function is continuous in the frequency domain.

== N-point _DFT_ of $y$ <6.c>

The _DFT_ algorithm discretizes _DTFT_ samples in the frequency domain. The standard form is, for $k = 0, 1, ... N - 1, w_k = (2 pi k) / N$,

$
X(omega_k) = sum_(n = 0)^(N - 1) x(n) e^(-j omega_k n)
$

Using the new written `dft()` function, we can plot the two functions the same plot:

#figure(image("4-c-1.png", width: 80%), caption: [Module of $y$'s _DFT_ (blue) and _DTFT_ (red)])
#figure(image("4-c-2.png", width: 80%), caption: [Phase of $y$'s _DFT_ (blue) and _DTFT_ (red)])

At the sampling points of _DFT_, the function values of the two remain consistant.

== Inverse _DFT_ <6.d>

The formula of inverse _DTFT_ is:

$
x(n) = 1 / N sum_(k = 0)^(N - 1) X(k) e^(j (2pi k) / N n)
$

The following figure shows that the inverse _DTFT_ completely matches the original function:

#figure(image("4-d-1.png", width: 80%), caption: [Original $y$ and its inverse _DTFT_])

== Zero-padding <6.e>

Using `numpy.pad()` function, we can apply zero-padding to $y[n]$.
To get the _FFT_ of $y$, we can use `numpy.fft.fft()` function. The modulus and phase of _FFT_ of $y$ are:

#figure(image("4-e-1.png", width: 80%), caption: [Module of _FFT_ (N = 16) and _DTFT_ of $y$])
#figure(image("4-e-2.png", width: 80%), caption: [Phase of _FFT_ (N = 16) and _DTFT_ of $y$]) 

It can be seen that the _FFT_ of $y$ is consistent with the _DTFT_ of $y$ on the sampling points.

== Computational time of _DFT_ and _FFT_ <6.f>

The time complexity of _DFT_ for a sequence of length $N$ is $O(N^2)$, while the time complexity of _FFT_ is $O(N log N)$. There is also a constant difference because `numpy.fft.fft()` is a built-in function and is implemented in C. On the contrary, the `dft()` function is implemented in Python and is slower.

#figure(image("4-f-1.png", width: 80%), caption: [Computational time of _DFT_ and _FFT_])
#figure(image("4-f-2.png", width: 80%), caption: [Computational time (log) of _DFT_ and _FFT_])

For $N = 10000$, numpy's _FFT_ function still costs less than $0.001s$, while our _DFT_ has cost more than $10s$. The difference is even more significant when $N$ is larger.

= Appendix Code (Python)

== Signal operations in @1 <py1>

#import "@preview/codelst:2.0.0": sourcecode
#show raw.where(block: true): it => {
  set text(size: 10pt)
  sourcecode(it)
}

```python
import numpy as np
import matplotlib.pyplot as plt

# Generate a gate function with the given parameter
def gate_func(A, B):
    def output_func(t):
        return np.where((t >= 0) & (t <= A), B, 0)
    return output_func

# Transform a function. Parameter shifting is given by param_func(), and the value is multiplied by `times`
def func_transform(func, param_func, times):
    def output_func(x):
        return func(param_func(x)) * times
    return output_func

# Returns with a function whose output is the sum of the outputs of f and g
def add_func(f, g):
    def output_func(x):
        return f(x) + g(x)
    return output_func 
    

A = 3
B = 4
D = 8

g0 = gate_func(A, B)
g1 = func_transform(g0, lambda t: 3 * t + D, 1)
g2 = func_transform(g0, lambda t: t - D, 2)

x_func = add_func(add_func(g0, g1), g2)

x_values = np.linspace(-5, 12, 1000)
y_values = x_func(x_values)
plt.plot(x_values, y_values, label=f'x(t)')
plt.xlabel('t')
plt.ylabel('x(t)')
plt.legend()
plt.show()
```

== Continuous-Time Fourier Transform properties

=== Code for @3.a and @3.b <py3.a>

```py
import numpy as np
import matplotlib.pyplot as plt

def gen_g(d, h):
    def g(t):
        return np.where((t >= -d / 2) & (t <= d / 2), h, 0)
    return g

D = 8
H = 5
SAMPLE_N = 5000

g = gen_g(D, H)

def CTFT(x, t, w):
    """
    x[i] and t[i] is the i-th sample of the signal and time,
    for each w[i], calculate the CTFT of x(t) at w[i]
    """
    Xw = np.zeros_like(w, dtype=complex)
    dt = t[1] - t[0]
    for i, wi in enumerate(w):
        # Two iterators here, x and t
        Xw[i] = np.sum(x * np.exp(-1j * wi * t) * dt)
    return Xw

def func_transform(ori_func, param_func, times):
    def output_func(t):
        return ori_func(param_func(t)) * times
    return output_func

g2 = func_transform(g, lambda t: t - D / 2, 1)

t_values = np.linspace(-5, 9, SAMPLE_N)
g_values = g(t_values)
g2_values = g2(t_values)
fig = plt.figure(figsize=(18, 6))
plt.plot(t_values, g_values, 'r-', label=f'g(t)')
plt.plot(t_values, g2_values, 'b--', label=f'g2(t)')
plt.xlabel('t')
plt.legend()
fig.show()
```

=== Code for @3.c <py3.c>

```py
maxw = 10 * np.pi
w_values = np.linspace(-maxw, maxw, SAMPLE_N)
Gw = CTFT(g_values, t_values, w_values)
Gw2 = CTFT(g2_values, t_values, w_values)
def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag
g_4plots = get_mod_pha_real_imag(Gw)
g2_4plots = get_mod_pha_real_imag(Gw2)
names = ['Modules', 'Phase', 'Real', 'Imaginary']
for i in range(4):
    print(f'Gw {names[i]}')
    fig = plt.figure(figsize=(18, 6))
    plt.plot(w_values, g_4plots[i], 'r-', label=f'Gw {names[i]}')
    plt.plot(w_values, g2_4plots[i], 'b--', label=f'Gw2 {names[i]}')
    plt.xlabel('w')
    plt.legend() # 图例...
    fig.show()
```

=== Code for @3.d <py3.d>

```py
def y_func(t):
    return g(t) * np.cos(4 * np.pi * t)

t_values = np.linspace(-15.233, 15.666, SAMPLE_N)
y_values = y_func(t_values)
g_values = g(t_values)
fig = plt.figure(figsize=(18, 6))
plt.plot(t_values, g_values, 'r-', label=f'g(t)')
plt.plot(t_values, y_values, 'b--', label=f'y(t)')
plt.xlabel('t')
plt.legend() # 图例...
fig.show()
```

=== Code for @3.e <py3.e>

```py
ctft_of_g = CTFT(g_values, t_values, w_values)
ctft_of_y = CTFT(y_values, t_values, w_values)
g_4plots = get_mod_pha_real_imag(ctft_of_g)
y_4plots = get_mod_pha_real_imag(ctft_of_y)

for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(w_values, g_4plots[prop], 'r-', label=f'g CTFT {names[prop]}')
    print(w_values.shape, g_4plots[prop].shape)
    plt.plot(w_values, y_4plots[prop], 'b--', label=f'y CTFT {names[prop]}')
    plt.xlabel('w')
    plt.legend() # 图例...
    fig.show()
```

=== Code for @3.f <py3.f>

```py
def calculate_energy(ys, xs):
    dx = xs[1] - xs[0]
    return sum(ys * ys.conjugate() * dx)

print(calculate_energy(y_values, t_values))
print(calculate_energy(ctft_of_y, w_values) / 2 / np.pi)
```

== Discrete-Time Fourier Transform properties

=== Code for @4.a and @4.b <py4.a>

```py
import numpy as np
import matplotlib.pyplot as plt

def gen_g(d, h):
    def g(t):
        return np.where((t >= -d / 2) & (t <= d / 2), h, 0)
    return g

D = 8
H = 2
NUM_W = 5000
CTFT_NUM_T = 5000
g = gen_g(D, H)

def DTFT(nT, xn, w):
    Xw = np.zeros(len(w), dtype=complex)
    for i, wi in enumerate(w):
        # Only at t = nT[i], there is xn[i] * delta
        Xw[i] = np.sum(xn * np.exp(-1j * wi * nT))
    return Xw

def discret_samples(f, s, t, time_interval):
    t_values = np.arange(s, t, time_interval)
    return t_values, f(t_values)

def dtft_of_func_nyquist(f, s, t, time_interval):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    sampling_angular_frequency = 2 * np.pi / time_interval
    w_vec = np.linspace(-sampling_angular_frequency / 2, +sampling_angular_frequency / 2, NUM_W)
    t_values, f_values = discret_samples(f, s, t, time_interval)
    return w_vec, DTFT(t_values, f_values, w_vec)

def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag

prop_desc = ['Modules', 'Phase']
x_axis_desc = ['f', 'f / fs', 'w / fs']

def compress_x_axis(opt, w_vec, omega_sampling):
    if opt == 0: # [w] -> [f]
        return w_vec / (2 * np.pi)
    f_sampling = omega_sampling / (2 * np.pi)
    if opt == 1: # [f / fs]
        return w_vec / (2 * np.pi) / f_sampling
    if opt == 2: # [w / fs]
        return w_vec / f_sampling

"""
f, f/f2, w/ws
    module, phase
        g1, g2
"""
SAMPLING_T1 = D / 80
SAMPLING_T2 = D / 40
w_vec_d1, dtft_d1 = dtft_of_func_nyquist(g, -D, D, SAMPLING_T1)
w_vec_d2, dtft_d2 = dtft_of_func_nyquist(g, -D, D, SAMPLING_T2)
plots_d1 = get_mod_pha_real_imag(dtft_d1)
plots_d2 = get_mod_pha_real_imag(dtft_d2)
for opt in range(3):
    for part in range(2):
        fig = plt.figure(figsize=(18, 6))
        x_vec1 = compress_x_axis(opt, w_vec_d1, 2 * np.pi / SAMPLING_T1)
        x_vec2 = compress_x_axis(opt, w_vec_d2, 2 * np.pi / SAMPLING_T2)
        plt.plot(x_vec1, plots_d1[part], 'r-', label=f'(D / 80) G1 {prop_desc[part]}')
        plt.plot(x_vec2, plots_d2[part], 'b--', label=f'(D / 40) G2 {prop_desc[part]}')
        plt.xlabel(x_axis_desc[opt])
        plt.legend()
        fig.show()

```

=== Code for @4.c <py4.c>

```py
def CTFT(x, t, w):
    """
    x[i] and t[i] is the i-th sample of the signal and time,
    for each w[i], calculate the CTFT of x(t) at w[i]
    """
    Xw = np.zeros_like(w, dtype=complex)
    dt = t[1] - t[0]
    for i, wi in enumerate(w):
        # Two iterators here, x and t
        Xw[i] = np.sum(x * np.exp(-1j * wi * t) * dt)
    return Xw

def ctft_of_func(f, s, t, w_max):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    w_vec = np.linspace(-w_max, w_max, NUM_W)
    t_values = np.linspace(s, t, CTFT_NUM_T)
    f_values = f(t_values) 
    return w_vec, CTFT(f_values, t_values, w_vec)

def dtft_of_func(f, s, t, time_interval, w_max):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    w_vec = np.linspace(-w_max, +w_max, NUM_W)
    t_values = np.arange(s, t, time_interval)
    f_values = f(t_values) 
    return w_vec, DTFT(t_values, f_values, w_vec)

w_s1 = 2 * np.pi / SAMPLING_T1
w_s2 = 2 * np.pi / SAMPLING_T2
g1_ctft_w_vec, g1_ctft = ctft_of_func(g, -D, D, 3 * w_s1)
g1_dtft_w_vec, g1_dtft = dtft_of_func(g, -D, D, SAMPLING_T1, 3 * w_s1)
g2_ctft_w_vec, g2_ctft = ctft_of_func(g, -D, D, 3 * w_s2)
g2_dtft_w_vec, g2_dtft = dtft_of_func(g, -D, D, SAMPLING_T2, 3 * w_s2)
g1_ctft_plots = get_mod_pha_real_imag(g1_ctft)
g1_dtft_plots = get_mod_pha_real_imag(g1_dtft)
g2_ctft_plots = get_mod_pha_real_imag(g2_ctft)
g2_dtft_plots = get_mod_pha_real_imag(g2_dtft)

# ct g vs dt g1
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    x_vec1 = compress_x_axis(1, g1_ctft_w_vec, w_s1)
    x_vec2 = compress_x_axis(1, g1_dtft_w_vec, w_s1)
    plt.plot(x_vec1, g1_ctft_plots[i], 'r-', label=f'G1 CTFT {prop_desc[i]}')
    plt.plot(x_vec2, g1_dtft_plots[i], 'b--', label=f'G1 DTFT {prop_desc[i]}')
    plt.xlabel('f / fs')
    plt.legend()
    fig.show()

# ct g vs dt g2
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    x_vec1 = compress_x_axis(1, g2_ctft_w_vec, w_s2)
    x_vec2 = compress_x_axis(1, g2_dtft_w_vec, w_s2)
    plt.plot(x_vec1, g2_ctft_plots[i], 'r-', label=f'G2 CTFT {prop_desc[i]}')
    plt.plot(x_vec2, g2_dtft_plots[i], 'b--', label=f'G2 DTFT {prop_desc[i]}')
    plt.xlabel('f / fs')
    plt.legend()
    fig.show()
```

=== Code for @4.d <py4.d>

```py
def inverse_dtft(maxn, t_sample, dtft_w_vec, dtft_x_vec):
    # w_vec and x_vec should be in one Nyquist interval, from -ws / 2 to +ws / 2
    ns = np.arange(-maxn, maxn + 1)
    ts = ns * t_sample
    xs = np.zeros_like(ts, dtype=complex)
    dw = dtft_w_vec[1] - dtft_w_vec[0]
    w_sample = 2 * np.pi / t_sample
    for i in range(len(ts)):
        nT = ts[i]
        xs[i] = sum(dtft_x_vec * np.exp(1j * nT * dtft_w_vec) * dw) / w_sample 
    return ts, xs

g1_t, g1_values = discret_samples(g, -D, D, SAMPLING_T1)
g1_dtft_w_vec, g1_dtft = dtft_of_func(g, -D, D, SAMPLING_T1, w_s1/ 2)
g1_idtft_t, g1_idtft = inverse_dtft(80, SAMPLING_T1, g1_dtft_w_vec, g1_dtft)
g1_idtft_plots = get_mod_pha_real_imag(g1_idtft) # complex

fig = plt.figure(figsize=(18, 6))
plt.vlines(g1_t, ymin = 0, ymax=g1_values, colors='r', linestyles='dashed', label='G1')
plt.vlines(g1_idtft_t, ymin = 0, ymax=g1_idtft_plots[0], colors='b', linestyles='dotted', label='G1 IDTFT')
plt.legend()
fig.show()

g2_t, g2_values = discret_samples(g, -D, D, SAMPLING_T2)
g2_dtft_w_vec, g2_dtft = dtft_of_func(g, -D, D, SAMPLING_T2, w_s2 / 2)
g2_idtft_t, g2_idtft = inverse_dtft(40, SAMPLING_T2, g2_dtft_w_vec, g2_dtft)
g2_idtft_plots = get_mod_pha_real_imag(g2_idtft) # complex

fig = plt.figure(figsize=(18, 6))
plt.vlines(g2_t, ymin = 0, ymax=g2_values, colors='r', linestyles='dashed', label='G2')
plt.vlines(g2_idtft_t, ymin = 0, ymax=g2_idtft_plots[0], colors='b', linestyles='dotted', label='G2 IDTFT')
plt.legend()
fig.show()
```

=== Code for @4.e <py4.e>

```py
def calculate_energy(ys, xs):
    dx = xs[1] - xs[0]
    return sum(ys * ys.conjugate() * dx)

t_values, g_values = discret_samples(g, -D, D, SAMPLING_T1)
g_energy =  calculate_energy(g_values, t_values)
w_values, dtft_of_g = dtft_of_func(g, -D, D, SAMPLING_T1, w_s1 / 2)
g1_dtft_energy = calculate_energy(dtft_of_g, w_values) / 2 / np.pi
print(g_energy, g1_dtft_energy)
```

== Windowing eﬀects of DTFT

=== Code for @5.a <py5.a>

```py
import numpy as np
import matplotlib.pyplot as plt

SAMPLING_T = 0.01
F_S = 100
F1 = 16
A1 = 1.4
DELTA_F = 1
F2 = F1 + DELTA_F
A2 = 0.6

NUM_W = 5000
W_S = 2 * np.pi * F_S

def func_x(t):
    # t = n * SAMPLING_T
    return A1 * np.sin(2 * np.pi * F1 * t) + A2 * np.sin(2 * np.pi * F2 * t)

def DTFT(nT, xn, w):
    Xw = np.zeros(len(w), dtype=complex)
    for i, wi in enumerate(w):
        # Only at t = nT[i], there is xn[i] * delta
        Xw[i] = np.sum(xn * np.exp(-1j * wi * nT))
    return Xw

def dtft_single_point(f, w, length):
    w_vec = np.array([w])
    ns = np.arange(length)
    ts = ns * SAMPLING_T
    fs = f(ts)
    return DTFT(ts, fs, w_vec)[0]

def dtft_of_func_half_nyquist(f, length):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    sampling_angular_frequency = W_S
    w_vec = np.linspace(0, +sampling_angular_frequency / 2, NUM_W)
    ns = np.arange(length)
    ts = ns * SAMPLING_T
    fs = f(ts)
    return w_vec, DTFT(ts, fs, w_vec)

def compress_x_axis(opt, w_vec, omega_sampling):
    if opt == 0: # [w] -> [f]
        return w_vec / (2 * np.pi)
    f_sampling = omega_sampling / (2 * np.pi)
    if opt == 1: # [f / fs]
        return w_vec / (2 * np.pi) / f_sampling
    if opt == 2: # [w / fs]
        return w_vec / f_sampling

ls = [50, 200, 1000]
draw_fs = [
    [16.05, 18.5],
    [15.93, 17.08],
    [16.00, 17],
]
for i, length in enumerate(ls):
    w_vec, dtft = dtft_of_func_half_nyquist(func_x, length)
    fs = compress_x_axis(0, w_vec, W_S)
    fig = plt.figure(figsize=(18, 6))
    print(f'--- N={length}')
    for j in range(2):
        f1 = draw_fs[i][j]
        w1 = f1 * 2 * np.pi
        y1 = np.abs(dtft_single_point(func_x, w1, length)) * 2 / length
        print(f'A{j + 1} = {y1:.2f}, f{j + 1} = {f1:.2f}')
        plt.plot(f1, y1, 'ro')  # 'ro'表示红色圆点
        plt.text(f1, y1, f'({f1:.2f}, {y1:.2f})', ha='right', va='bottom')  # 标注坐标
    plt.plot(fs, np.abs(dtft) * 2 / length, label=f'L={length}')
    plt.grid(True)
    plt.legend()
    fig.show()
```

=== Code for @5.b <py5.b>

```py
A0 = 0.53836
def hamming(n, N):
    return A0 - (1 - A0) * np.cos(2 * np.pi * n / (N - 1))

def dtft_of_func_half_nyquist_hamming(f, length):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    sampling_angular_frequency = W_S
    w_vec = np.linspace(0, +sampling_angular_frequency / 2, NUM_W)
    ns = np.arange(length)
    ts = ns * SAMPLING_T
    fs = f(ts)
    for i in range(length):
        fs[i] *= hamming(i, length)
    return w_vec, DTFT(ts, fs, w_vec)

def dtft_single_point_hamming(f, w, length):
    w_vec = np.array([w])
    ns = np.arange(length)
    ts = ns * SAMPLING_T
    fs = f(ts)
    for i in range(length):
        fs[i] *= hamming(i, length)
    return DTFT(ts, fs, w_vec)[0]

ls = [50, 200, 1000]
draw_fs = [
    [16.08, 18.5],
    [15.97, 16.8],
    [16.00, 17],
]
for i, length in enumerate(ls):
    w_vec, dtft = dtft_of_func_half_nyquist_hamming(func_x, length)
    fs = compress_x_axis(0, w_vec, W_S)
    fig = plt.figure(figsize=(18, 6))
    print(f'--- N={length}')
    for j in range(2):
        f1 = draw_fs[i][j]
        w1 = f1 * 2 * np.pi
        y1 = np.abs(dtft_single_point_hamming(func_x, w1, length)) * 2 / length / A0
        print(f'A{j + 1} = {y1:.2f}, f{j + 1} = {f1:.2f}')
        plt.plot(f1, y1, 'ro')  # 'ro'表示红色圆点
        plt.text(f1, y1, f'({f1:.2f}, {y1:.2f})', ha='right', va='bottom')  # 标注坐标
    plt.plot(fs, np.abs(dtft) * 2 / length / A0, label=f'L={length}')
    plt.grid(True)
    plt.legend()
    fig.show()

```

== DFT and FFT

=== Code for @6.a <py6.a>

```py
import numpy as np
import matplotlib.pyplot as plt
L = 10
y = np.array([-1, 2, 3, 0, -2, 1, 4, -3, 0, -2])
ns = np.arange(L)

fig = plt.figure(figsize=(18, 6))
plt.vlines(ns, ymin = 0, ymax=y, colors='r', linestyles='solid', label='G1')
plt.axhline(y=0, color='k')
plt.legend()
fig.show()
```

=== Code for @6.b <py6.b>

```py
NUM_W = 5000

def DTFT(nT, xn, w):
    Xw = np.zeros(len(w), dtype=complex)
    for i, wi in enumerate(w):
        # Only at t = nT[i], there is xn[i] * delta
        Xw[i] = np.sum(xn * np.exp(-1j * wi * nT))
    return Xw

def dtft_of_func_nyquist(x_values, y_values, time_interval):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    sampling_angular_frequency = 2 * np.pi / time_interval
    w_vec = np.linspace(-sampling_angular_frequency / 2, +sampling_angular_frequency / 2, NUM_W)
    return w_vec, DTFT(x_values, y_values, w_vec)

def dtft_of_func_positive_nyquist(x_values, y_values, time_interval):
    # The period (Nyquist interval) is ws (the sampling frequency)
    # s and t in the time domain
    sampling_angular_frequency = 2 * np.pi / time_interval
    w_vec = np.linspace(0, +sampling_angular_frequency, NUM_W)
    return w_vec, DTFT(x_values, y_values, w_vec)

def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag

w_vec, dtft = dtft_of_func_nyquist(ns, y, 1)
dtft_plots = get_mod_pha_real_imag(dtft)
prop_desc = ['Modules', 'Phase']

def plot_mod_phase(x_vec, y_vec, x_name, y_name):
    plots = get_mod_pha_real_imag(y_vec)
    for part in range(2):
        fig = plt.figure(figsize=(18, 6))
        plt.plot(x_vec, plots[part], 'r-', label=f'{y_name} {prop_desc[part]}')
        plt.legend()
        plt.xlabel(x_name)
        fig.show()
        
plot_mod_phase(w_vec, dtft, 'w', 'Y')
```

=== Code for @6.c <py6.c>

```py
def dft(ys):
    n = len(ys)
    ns = np.arange(n)
    def omega_k(k):
        return 2 * np.pi * k / n
    w_vec = np.array([omega_k(k) for k in range(n)])
    dft_vec = np.array([sum(ys * np.exp(-1j * w * ns)) for w in w_vec])
    return w_vec, dft_vec

dft_w_vec, dft_vec = dft(y)
dtft_w_vec, dtft_vec = dtft_of_func_positive_nyquist(ns, y, 1)

for part in range(2):
    fig = plt.figure(figsize=(18, 6))
    dft_plots = get_mod_pha_real_imag(dft_vec)
    dtft_plots = get_mod_pha_real_imag(dtft_vec)
    plt.plot(dft_w_vec, dft_plots[part], 'b-', label=f'DFT {prop_desc[part]}')
    plt.plot(dtft_w_vec, dtft_plots[part], 'r-', label=f'DTFT {prop_desc[part]}')
    plt.legend()
    plt.xlabel('w')
    fig.show()
```

=== Code for @6.d <py6.d>

```py
def inverse_dtft(maxn, t_sample, dtft_w_vec, dtft_x_vec):
    # w_vec and x_vec should be in one Nyquist interval, from -ws / 2 to +ws / 2
    ns = np.arange(-maxn, maxn + 1)
    ts = ns * t_sample
    xs = np.zeros_like(ts, dtype=complex)
    dw = dtft_w_vec[1] - dtft_w_vec[0]
    w_sample = 2 * np.pi / t_sample
    for i in range(len(ts)):
        nT = ts[i]
        xs[i] = sum(dtft_x_vec * np.exp(1j * nT * dtft_w_vec) * dw) / w_sample 
    return ts, xs

def inverse_dft(dft_vec):
    n = len(dft_vec)
    ns = np.arange(n)
    w_vec = np.array([2 * np.pi * k / n for k in range(n)])
    y_vec = np.array([sum(dft_vec * np.exp(1j * w * ns)) / n for w in w_vec])
    return ns, y_vec

# plot y and its inverse DFT in one figure
fig = plt.figure(figsize=(18, 6))
_, idft_y = inverse_dft(dft_vec)
plt.vlines(ns, ymin = 0, ymax=idft_y, colors='b', linestyles='dashed', label='Inverse DFT')
plt.vlines(ns, ymin = 0, ymax=y, colors='r', linestyles='dotted', label='Original y')
plt.legend()
plt.axhline(y=0, color='k')
fig.show()
```

=== Code for @6.e <py6.e>

```py
pad_x = np.arange(16)
pad_w = np.array([2 * np.pi * k / 16 for k in range(16)])
pad_y = np.pad(y, (0, 16 - len(y)), 'constant', constant_values=(0,))
fft = np.fft.fft(pad_y)

for part in range(2):
    fig = plt.figure(figsize=(18, 6))
    fft_plots = get_mod_pha_real_imag(fft)
    dtft_plots = get_mod_pha_real_imag(dtft_vec)
    plt.plot(pad_w, fft_plots[part], 'b-', label=f'FFT {prop_desc[part]}')
    plt.plot(dtft_w_vec, dtft_plots[part], 'r-', label=f'DTFT {prop_desc[part]}')
    plt.legend()
    plt.xlabel('w')
    fig.show()
```

=== Code for @6.f - Time statistics <py6.f>

```py
import numpy as np
import time
L_values = np.arange(1000, 10001, 1000)
log_l = np.log10(L_values)
dft_times = []
fft_times = []

for L in L_values:
    y_padded = np.pad(y, (0, L - len(y)), 'constant', constant_values=(0,))
    
    # Measure the time for DFT
    start_time = time.time()
    dft(y_padded)
    dft_time = time.time() - start_time
    dft_times.append(dft_time)
    
    # Measure the time for FFT
    start_time = time.time()
    np.fft.fft(y_padded)
    fft_time = time.time() - start_time
    fft_times.append(fft_time)

print(fft_times, dft_times)
```

=== Code for @6.f - Plot of time statistics

```py
# Plot the computational time curve
plt.figure(figsize=(18, 6))
plt.plot(L_values, dft_times, label='DFT')
plt.plot(L_values, fft_times, label='FFT')
plt.xlabel('L')
plt.ylabel('Computational Time (s)')
plt.title('Computational Time of DFT and FFT with respect to L')
plt.legend()
plt.show()

plt.figure(figsize=(18, 6))
plt.loglog(L_values, dft_times, label='DFT')
plt.loglog(L_values, fft_times, label='FFT')
plt.xlabel('L')
plt.ylabel('Computational Time (s)')
plt.title('Computational Time of DFT and FFT with respect to L (log plot)')
plt.legend()
plt.show()
```
