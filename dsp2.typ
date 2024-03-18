#set page(paper: "us-letter")
#set heading(numbering: "1.a")
#set figure(numbering: "1")

// 这是注释
#figure(image("sjtu.png", width: 50%), numbering: none) \ \ \

#align(center, text(17pt)[
  #set block(spacing: 2em) 
  *Laboratory Report of Digital Signal Processing* \ \
  Name: Junjie Fang 123456 \ \
  Student ID: 521260910018 \ \
  Date: 2024/3/4 \ \
  Score: #h(4em)
])
 
#pagebreak()

#set page(header: align(right)[
  DSP Lab2 Report - Junjie FANG
], numbering: "1")
#set text(size: 11pt)

#outline(indent: auto)

= Continuous-Time Fourier Transform properties

== 

The definition of _CTFT_ is:

$ X_omega = integral_(-oo)^(+oo) x(t) dot e^(-j omega t) dif t $

To integrate arbitrary functions in code, we use discrete sampling summation for approximate integration. The code is in Appendix 3.a. In this code, the `CTFT(x, t, w)` function take `x` and `t` as lists of sampled data in time domain, which should be calculated outside the function.
For each element in `w`, which represents a frequency, the function calculates _CTFT_ at this frequency, and finally return a list of complex numbers.

In order to improve the approximation accuracy, we can increase the number of samples (i.e. `SAMPLE_N` parameter).

==

We can get $g_2 = g(t - D / 2)$ by applying time shifting on $g$. To get $g_2$ in the code, we use a function called `func_tranform` to get the shifted function of $g$. The figure showing both functions is:

#figure(image("image.png", width: 80%), caption: [$g "and" g_2$ in the same plot]) 

== <1.c>

Using the function `CTFT()` function realized in _1.a_, we can calculate the _CTFT_ of $g_2$ and $g$ respectively. 

By observing the images of module, phase, real part and imaginary part of the two functions, *we can verify the followling properties of time shifting under _CTFT_:*

+ The module remains unchanged.
+ THe phase changes linearly with $omega$, and the distribution of real and imaginary parts changes.

#figure(image("2-1-1.png", width: 80%), caption: [Module of $g$ and $g_2$])
#figure(image("2-1-2.png", width: 80%), caption: [Phase of $g$ and $g_2$])
#figure(image("2-1-3.png", width: 80%), caption: [Real part of $g$ and $g_2$])
#figure(image("2-1-4.png", width: 80%), caption: [Imaginary part of $g$ and $g_2$])

==

In the code, we can generate $y(t) = g(t) times cos(4 pi t)$ from $g(t)$. The figure below shows the comparison of $g(t)$ and $y(t)$ over $t = [-15, 15]$:

#figure(image("2-1-5.png", width: 80%), caption: [$y$ and $g$ in the same plot])

==

To get the module and phase of $y(t)$ and $g(t)$, we can calculte their _CTFT_ like in @1.c.

The modulation property of _CTFT_ gives:

$ G_T_1(t) cos(omega_0 t) <==>^(F.T.) 1 / 2 X[j(omega - omega_0)] +  1/ 2 X[j(omega + omega_0)] $ 

This property can be verified from the figures below, as the module and phase of $g$ is shifted to $omega_0 = 4 pi$ and $-omega_0 = -4pi$ in the frequency domain.
Note the peak value of module of $y$ is half this value of $g$.

#figure(image("2-1-6.png", width: 80%), caption: [Module of $y$ and $g$])

#figure(image("2-1-7.png", width: 80%), caption: [Phase of $y$ and $g$])


==

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

== 

The code in appendix implements `DTFT(nT, xn, w)` function, using the following formula:

$ X(omega) = sum_(n = -oo)^(+oo) x(n T) e^(-j omega n T) $

To avoid infinite calculation, we can set a start time and end time for sampling
function, as long as it covers the whole signal.

==

Using the function implemented in _3.a_, we rendered the images of $G_(w, 1)$ and $G_(w, 2)$ in a Nyquist interval,

#figure(image("2-2-b-1.png", width: 80%), caption: [Module of $G_(w, 1)$ and $G_(w, 2)$ in $f$])
#figure(image("2-2-b-2.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $f$])
#figure(image("2-2-b-3.png", width: 80%), caption: [Module of $G_(w, 1)$ and $G_(w, 2)$ in $f / f_s$])
#figure(image("2-2-b-4.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $f / f_s$])
#figure(image("2-2-b-5.png", width: 80%), caption: [Module of $G_(w, 1)$ and $G_(w, 2)$ in $w / f_s$])
#figure(image("2-2-b-6.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $w / f_s$])

==
 
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

==

We can inverse _DTFT_ using the formula:

$ x[n T] = 1 / (w_s) integral_(-w_s / 2)^(+w_s / 2) X[e^(j omega)] e^(j omega n) dif omega $

We get:

#figure(image("2-2-d-1.png", width: 80%), caption: [Figure of the discrete $g_1$ and the inverse of $G_(w, 1)$ ])
#figure(image("2-2-d-2.png", width: 80%), caption: [Figure of the discrete $g_2$ and the inverse of $G_(w, 2)$ ])

This two images shows that the inverse _DTFT_ perfectly matches the discret sampling function.

==

The former Parseval's formula is no longer validated for _DTFT_. If we calculate
the energy of the the original function and the _DTFT_ function (in one Nyquist interval to avoid infinite energy), we can get $31.99 "and" 3199.99$, the latter one is 100 times the former one. That is due to the sampling frequency
of the discrete function.

We can adjust this result by adding a factor of $(1 / f_s) ^ 2$ in the formula
of _DTFT_ function, which means the Parseval's formula would be:

$ integral_(-oo)^(+oo) |x(t)|^2 dif t = 1 / (2pi f_s ^ 2) integral_(-w_s / 2)^(+w_s / 2) |X(j omega)|^2 dif omega $. 

= Windowing effects of DTFT

== 

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

==

Using hamming function, the factor should be $(2 a_0) / N$, where
$a_0 = 0.53836$. The figure is:

#figure(image("2-3-b-1.png", width: 80%), caption: [Figure and peak values when $L = 50$])
#figure(image("2-3-b-2.png", width: 80%), caption: [Figure and peak values when $L = 200$])
#figure(image("2-3-b-3.png", width: 80%), caption: [Figure and peak values when $L = 1000$])

#figure(
tablem[
  | $L$ | factor | $A_1$ | $A_2$ | $f_1$ | $f_2$ |
  | ------ | ---------- | -------- | ------- | - | - |
  | 50 | $(2 a_0) / 50$ | $1.48$ | $0.53$ | $16.08$ | $18.50$ |
  | 200 | $(2 a_0) / 200$ | $1.39$ | $0.64$ | $15.97$ | $16.80$ |
  | 1000 | $(2 a_0) / 1000$ | $1.40$ | $0.60$ | $16.00$ | $17.00$ |
]
)

The sidelobes after applying hamming function are much lower than the original ones, which means the frequency leakage is reduced. But the width of the main lobe is increased, leading to a reduction of frequency resolution.
