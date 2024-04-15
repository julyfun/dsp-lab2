#set page(paper: "us-letter")
#set heading(numbering: "1.a.1.")
#set figure(numbering: "1")

#let student-number = "No. 521260910018"

// 这是注释
#figure(image("pic/sjtu.png", width: 50%), numbering: none) \ \ \

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
      [Student ID:], [#student-number],
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

_Source Code_: #link("https://github.com/julyfun/dsp-lab2")

#outline(indent: 1.5em)

= (Lab1) Signal operations <1>

#show figure: it => {
  let cap = if it.caption != none { it.caption + " - " + student-number } else { student-number }
  align(center, box[#it.body, #cap])
}

// #show figure: it => {

// }

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

#figure(image("pic/1.jpg", width: 50%))

It can be seen that the images of the three gate functions do not overlap.

In practice, we use python's `matplotlib` to draw function images. For
scalability, we use the `gate_func()`, `func_transform()` and
`add_func()` to generate, transform and add functions.
See @py1 for the code.

= Aliasing phenomenon in sampling process

Let the frequencies corresponding to the two peaks in the image be $f_(a 1) = 14, f_(a 2) = 3$ and
the function values be $X_1 = 2, X_2 = 1$. The sampling frequency is $f_s = 100"Hz"$.
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

To sample the function from $0s$ to $5s$ is equivalent to 

In this form, the sine wave with amplitude $1$ and the following sum of two
impulse function form a Fourier Transform pair, and we take modulo in this formula:

$
  ||cal(F)[sin(2 pi f_0 t)]|| = 1 / 2 (delta(f - f_0) + delta(f + f_0)) \
$

Due to linearity of Fourier Transform, we have:

$
  ||cal(F)[x(t)]|| &= ||cal(F)[A_1 sin(2 pi f_1 t) + A_2 sin(2 pi f_2 t)]|| \
  &= A_1 / 2 (delta(f - f_1) + delta(f + f_1)) + A_2 / 2 (delta(f - f_2) + delta(f + f_2)) \
$

Sampling the function from $0s$ to $5s$ is equivalent to multiplying a gate function with height $1$ and width $5$, that is,
the Fourier tranform of the two functions is convolved in the frequency domain. Suppose this gate function is $g$, and we have:

$
  ||cal(F)[g(t)]|| = |5 sinc(5 f)|
$

Where $5$ is the width of the gate function. From the above conclusion, we can infer that the image of _CTFT_ is the convolution of the two:

$
  ||cal(F)[x(t)]|| &= lr(||cal(F)[g(t)] * cal(F)[A_1 sin(2 pi f_1 t) + A_2 sin(2 pi f_2 t)]||) \
  &= norm(5 sinc(5f) * (A_1 / 2 (delta(f - f_1) + delta(f + f_1)) + A_2 / 2 (delta(f - f_2) + delta(f + f_2)))) \ 
  &= norm(5 / 2 lr((A_1 sinc(5(f - f_1)) + A_1 sinc(5(f + f_1)) + A_2 sinc(5(f - f_2)) + A_2 sinc(5(f + f_2)))))
$

Therefore, the peak values $X_1, X_2$ is $5 / 2$ times the amplitudes $A_1$ and $A_2$:

$
  A_1 = 2 / 5 X_1 = 4 / 5 \
  A_2 = 2 / 5 X_2 = 2 / 5
$

#align(center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: center,
    [Parameters], [$i = 1$], [$i = 2$],
    $f_i$, [$814"Hz"$], [$803"Hz"$],
    $A_i$, [$4 / 5$], [$2 / 5$]
  )
)
= (Lab2) Continuous-Time Fourier Transform properties

== Creation of Continuous-Time Fourier Transform (_CTFT_) function <3.a>

The definition of _CTFT_ is:

$ X_omega = integral_(-oo)^(+oo) x(t) dot e^(-j omega t) dif t $

To integrate arbitrary functions in code, we use discrete sampling summation for approximate integration. The code is in Appendix 3.a. In this code, the `CTFT(x, t, w)` function take `x` and `t` as lists of sampled data in time domain, which should be calculated outside the function.
For each element in `w`, which represents a frequency, the function calculates _CTFT_ at this frequency, and finally return a list of complex numbers.
The code is in @py3.a.

In order to improve the approximation accuracy, we can increase the number of samples (i.e. `SAMPLE_N` parameter).

== Comparison of $g$ and shifted $g$ <3.b>

We can get $g_2 = g(t - D / 2)$ by applying time shifting on $g$. To get $g_2$ in the code, we use a function called `func_tranform` to get the shifted function of $g$. The figure showing both functions is:

#figure(image("pic/image.png", width: 80%), caption: [$g "and" g_2$ in the same plot]) 

== Plot of _CTFT_ of $g$ and $g_2$ <3.c>

Using the function `CTFT()` function realized in _1.a_, we can calculate the _CTFT_ of $g_2$ and $g$ respectively. 

By observing the images of Modulus, phase, real part and imaginary part of the two functions, *we can verify the followling properties of time shifting under _CTFT_:*

+ The Modulus remains unchanged.
+ THe phase changes linearly with $omega$, and the distribution of real and imaginary parts changes.

#figure(image("pic/2-1-1.png", width: 80%), caption: [Modulus of $g$ and $g_2$])
#figure(image("pic/2-1-2.png", width: 80%), caption: [Phase of $g$ and $g_2$])
#figure(image("pic/2-1-3.png", width: 80%), caption: [Real part of $g$ and $g_2$])
#figure(image("pic/2-1-4.png", width: 80%), caption: [Imaginary part of $g$ and $g_2$])

== Modulation <3.d>

In the code, we can generate $y(t) = g(t) times cos(4 pi t)$ from $g(t)$. The figure below shows the comparison of $g(t)$ and $y(t)$ over $t = [-15, 15]$:

#figure(image("pic/2-1-5.png", width: 80%), caption: [$y$ and $g$ in the same plot])

== Modulation properties of Fourier Tranform <3.e>

To get the Modulus and phase of $y(t)$ and $g(t)$, we can calculte their _CTFT_ like in @3.c.

The modulation property of _CTFT_ gives:

$ G_T_1(t) cos(omega_0 t) <==>^(F.T.) 1 / 2 X[j(omega - omega_0)] +  1/ 2 X[j(omega + omega_0)] $ 

This property can be verified from the figures below, as the Modulus and phase of $g$ is shifted to $omega_0 = 4 pi$ and $-omega_0 = -4pi$ in the frequency domain.
Note the peak value of Modulus of $y$ is half this value of $g$.

#figure(image("pic/2-1-6.png", width: 80%), caption: [Modulus of $y$ and $g$])

#figure(image("pic/2-1-7.png", width: 80%), caption: [Phase of $y$ and $g$])

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

#figure(image("pic/2-2-b-1.png", width: 80%), caption: [Modulus of $G_(w, 1)$ and $G_(w, 2)$ in $f$])
#figure(image("pic/2-2-b-2.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $f$])
#figure(image("pic/2-2-b-3.png", width: 80%), caption: [Modulus of $G_(w, 1)$ and $G_(w, 2)$ in $f / f_s$])
#figure(image("pic/2-2-b-4.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $f / f_s$])
#figure(image("pic/2-2-b-5.png", width: 80%), caption: [Modulus of $G_(w, 1)$ and $G_(w, 2)$ in $w / f_s$])
#figure(image("pic/2-2-b-6.png", width: 80%), caption: [Phase of $G_(w, 1)$ and $G_(w, 2)$ in $w / f_s$])

Explanation for these figures: The modulus figure is a modulus of a $sinc$ function. The envelope of the phase figure is linear because of the time shfiting property of Fourier transform: $ x(t - t_0) <==>^(F.T.) e^(-j omega t_0) X(j omega) $

The $omega$ in the exponential term results in a linear change in phase. 

At the same time, the function shows a jagged up and down step. This is because the $sinc$ function periodically appears postive and negative, causing the phase to be reversed.

== Deduciton of the theoretical _CTFT_ function of $g$ <4.c>
 
The theoretical _CTFT_ function of $g$ is:

$
X(w) &= integral_(-oo)^(+oo) g(t) e^(-j omega t) dif t \
&= integral_(-4)^(4) 2 e^(-j omega t) dif t \
&= 2 / (-j omega) (e^(-4 j omega) - e^(4 j omega)) \
&= 16sinc(4 omega)
$

We can plot them in the same figure:


#figure(image("pic/2-2-c-1.png", width: 80%), caption: [Modulus of $G_(w, 1)$ and _CTFT_ of $g$])
#figure(image("pic/2-2-c-2.png", width: 80%), caption: [Phase of $G_(w, 1)$ and _CTFT_ of $g$])
#figure(image("pic/2-2-c-3.png", width: 80%), caption: [Modulus of $G_(w, 2)$ and _CTFT_ of $g$])
#figure(image("pic/2-2-c-4.png", width: 80%), caption: [Phase of $G_(w, 2)$ and _CTFT_ of $g$])

For $G_(w, 1)$, the peak value at $omega = 0$ is ten times the _CTFT_ of $g$. That's
because the sampling frequency is $f_s = 10$. And for $G_(w, 2)$ it is five times,
as the sampling frequency is $f_s = 5$.

== Inverse _DTFT_ <4.d>

We can inverse _DTFT_ using the formula:

$ x[n T] = 1 / (w_s) integral_(-w_s / 2)^(+w_s / 2) X[e^(j omega)] e^(j omega n) dif omega $

We get:

#figure(image("pic/2-2-d-1.png", width: 80%), caption: [Figure of the discrete $g_1$ and the inverse of $G_(w, 1)$ ])
#figure(image("pic/2-2-d-2.png", width: 80%), caption: [Figure of the discrete $g_2$ and the inverse of $G_(w, 2)$ ])

This two images shows that the inverse _DTFT_ perfectly matches the discret sampling function.

== Adjusted Parseval's formula <4.e>

The former Parseval's formula is no longer validated for _DTFT_. If we calculate
the energy of the the original function and the _DTFT_ function (in one Nyquist interval to avoid infinite energy), we can get $31.99 "and" 3199.99$, the latter one is 100 times the former one. That is due to the sampling frequency
of the discrete function.

We can adjust this result by adding a factor of $(1 / f_s) ^ 2$ in the formula
of _DTFT_ function, which means the Parseval's formula would be:

$ integral_(-oo)^(+oo) |x(t)|^2 dif t = 1 / (2pi f_s ^ 2) integral_(-w_s / 2)^(+w_s / 2) |X(j omega)|^2 dif omega $. 

Under this formula, the energy in time domain and in frequency domain are both $31.99$, thus the Parseval's formula is validated.

= Windowing effects of DTFT

== _DTFT_ of $g$ with gate sampling function <5.a>

We can adopt $2 / N$ as factor to scale magnitudes of _DTFT_ function. The figure is:

#figure(image("pic/2-3-a-1.png", width: 80%), caption: [Figure and peak values when $L = 50$])
#figure(image("pic/2-3-a-2.png", width: 80%), caption: [Figure and peak values when $L = 200$])
#figure(image("pic/2-3-a-3.png", width: 80%), caption: [Figure and peak values when $L = 1000$])

The $f$ here is obtained through continuous trials, that is, manually adjusting
$f$, using the `dtft_single_point()` function in python to output the corresponding
_DTFT_ function value to see at which point the function value is the largest. The selected $f$ value is in the `draw_fs` list in the code.

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

#figure(image("pic/2-3-b-1.png", width: 80%), caption: [Figure and peak values when $L = 50$])
#figure(image("pic/2-3-b-2.png", width: 80%), caption: [Figure and peak values when $L = 200$])
#figure(image("pic/2-3-b-3.png", width: 80%), caption: [Figure and peak values when $L = 1000$])

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

#figure(image("pic/4-a.png", width: 80%), caption: [Figure of $y$])

== Modulus and phase of $y$'s _DTFT_ <6.b>

We can use the `DTFT()` function defined in the previous questions. The modulus and phase of _DTFT_ of $y$ in a Nyquist interval are:

#figure(image("pic/4-b-1.png", width: 80%), caption: [Modulus of _DTFT_ $y$])
#figure(image("pic/4-b-2.png", width: 80%), caption: [Phase of _DTFT_ of $y$])

The function is continuous in the frequency domain.

== N-point _DFT_ of $y$ <6.c>

The _DFT_ algorithm discretizes _DTFT_ samples in the frequency domain. The standard form is, for $k = 0, 1, ... N - 1, w_k = (2 pi k) / N$,

$
X(omega_k) = sum_(n = 0)^(N - 1) x(n) e^(-j omega_k n)
$

Using the new written `dft()` function, we can plot the two functions the same plot:

#figure(image("pic/4-c-1.png", width: 80%), caption: [Modulus of $y$'s _DFT_ (blue) and _DTFT_ (red)])
#figure(image("pic/4-c-2.png", width: 80%), caption: [Phase of $y$'s _DFT_ (blue) and _DTFT_ (red)])

At the sampling points of _DFT_, the function values of the two remain consistant.

== Inverse _DFT_ <6.d>

The formula of inverse _DTFT_ is:

$
x(n) = 1 / N sum_(k = 0)^(N - 1) X(k) e^(j (2pi k) / N n)
$

The following figure shows that the inverse _DTFT_ completely matches the original function:

#figure(image("pic/4-d-1.png", width: 80%), caption: [Original $y$ and its inverse _DTFT_])

== Zero-padding <6.e>

Using `numpy.pad()` function, we can apply zero-padding to $y[n]$.
To get the _FFT_ of $y$, we can use `numpy.fft.fft()` function. The modulus and phase of _FFT_ of $y$ are:

#figure(image("pic/4-e-1.png", width: 80%), caption: [Modulus of _FFT_ (N = 16) and _DTFT_ of $y$])
#figure(image("pic/4-e-2.png", width: 80%), caption: [Phase of _FFT_ (N = 16) and _DTFT_ of $y$]) 

It can be seen that the _FFT_ of $y$ is consistent with the _DTFT_ of $y$ on the sampling points.

== Computational time of _DFT_ and _FFT_ <6.f>

The time complexity of _DFT_ for a sequence of length $N$ is $O(N^2)$, while the time complexity of _FFT_ is $O(N log N)$. There is also a constant difference because `numpy.fft.fft()` is a built-in function and is implemented in C. On the contrary, the `dft()` function is implemented in Python and is slower.

#figure(image("pic/4-f-1.png", width: 80%), caption: [Computational time of _DFT_ and _FFT_])
#figure(image("pic/4-f-2.png", width: 80%), caption: [Computational time (log) of _DFT_ and _FFT_])

For $N = 10000$, numpy's _FFT_ function still costs less than $0.001s$, while our _DFT_ has cost more than $10s$. The difference is even more significant when $N$ is larger.
  
= (Lab3) Functions for Filter

==

The code for `pzmap()` function is in the appendix. We can plot its poles and zeros as below:

#figure(image("pic2/1.a.png", width: 50%))

The pole is at $(0.5 + 0j)$, the zero is $(-1.5 + 0j)$. This filter system is *stable*, because the only pole is inside the unit circle.

==

`freqz()` function can be seen in the code below. We hereby draw the *modulus* and *phase* for the frequency response of the filter:

#figure(image("pic2/1.b.1.png", width: 80%))
#figure(image("pic2/1.b.2.png", width: 80%))

==

The I/O difference equation for $H(z) = Y(z) / X(z) = (sum_(i = 1)^(M) b_i z^(1 - i)) / (sum_(i = 1)^(N) a_i z^(1 - i))$ is:

$
  sum_(i = 1)^(M) y[n - i + 1] = sum_(i = 1)^(N) x[n - i + 1]
$

For the specific filter $H(z) = (2 + 3z^(-1)) / (1 - 0.5 z^(-1))$ in the question, the difference equation should be:

$
  y[n] = 0.5 y[n - 1] + 2 x[n] + 3 x[n - 1]
$

For $L = 100$ and $x = [1, 2, 3]$, the first $10$ of $y$ is $[2, 8, 16, 17, 8, 4, 2, 1, 0, 0]$ and we can draw the first $100$ y as below:

#figure(image("pic2/1.c.png", width: 80%))

#pagebreak()

==

To draw the impulse response, we can set the input $x = [1]$ in the sequence $"xn" = [0]$. The first six output is $[2, 4, 2, 1, 0, 0]$ and the following is all $0$, where the figure is as below:

#figure(image("pic2/1.d.png", width: 80%))

= Design an FIR filter with the Window method

==

We first designed a gate function of an ideal low-pass filter in the frequency domain:

$
  g(omega) &:= cases(1 "if" -omega_c <= omega <= omega_c, 0 "otherwise") \
$

Its figure:

#figure(image("pic2/2.a.1.png", width: 80%))

Then we apply the inverse _DTFT_ to the function and get $h[n]$. For $N = -30 ~ 30$, the figure is:

#figure(image("pic2/2.a.5.png", width: 80%))

Since $h[n]$ at this time is a non-causal sequence and is unrealizable, shift it in the time domain and obtain the new $h[n]$ as follows, here we draw the impulse response functions when $N = -30 ~ 30$ and $N = -100 ~ 100$ in the same plot:

#figure(image("pic2/2.a.2.png", width: 80%))

The real part and imaginary part of the frequency response of the filter are as follows:


#figure(image("pic2/2.a.3.png", width: 80%))
#figure(image("pic2/2.a.4.png", width: 80%))

==

We can design a high-pass filter by first creating an inversed gate function:

$
  g(omega) &:= cases(1 "if" |omega| > |omega_c|, 0 "otherwise") \
$

The figure is:

#figure(image("pic2/2.b.1.png", width: 80%))

Likewise in 2.a, we apply _IDTFT_ to this function and shift $h[n]$. We also apply Kaiser window (using `np.kaiser` with $beta = 10$) to make the window smoother. Here is the figure of their impulse responses:

#figure(image("pic2/2.b.2.png", width: 80%))

The FRFs:

#figure(image("pic2/2.b.3.png", width: 80%))
#figure(image("pic2/2.b.4.png", width: 80%))

It can be seen that the overshoot of Kaiser window method is smaller than that of the rectangular window method.

==

As the two frequencies are $f_1 = 7, f_2 = 24$, we can choose $f_c = 15$ as the cut-off frequency, therefore, the cut-off angular frequency is $omega_c = 2 pi f_c / f_s$, where $f_s = 200$.

Now we can apply all the steps in 2.b to get a high-pass filter. To refuce the overshoot, we applied the Kaiser window method to the _IDTFT_ result. The FRF of this filter is like:


#figure(image("pic2/2.c.1.png", width: 80%))
#figure(image("pic2/2.c.2.png", width: 80%))

==

Using the `filter()` function developed in 1.c.
and `np.convolve()`, we can get $y_1$ and $y_2$ easily. Plotting them in the same figure:

#figure(image("pic2/2.d.1.png", width: 80%))

By both the two methods, there's only one frequency of signal remaining. It can be verified that this frequency is $24$ by turning the abscissa into a $t$-based one.

==

Using `np.fft.fft()` we can get the _DFT_ of $x, y_1$ and $y_2$. The right half of the _DFT_ is the same as the left half, so we can only draw the left half. The figure is as below:

#figure(image("pic2/2.e.1.png", width: 80%))
#figure(image("pic2/2.e.2.png", width: 80%))

It can be verified from the plot that the signal of frequency $7$ is filtered out.

Let the sampling number be $n = 600$, we can get the remaining amplitude by $A = 2 / n sup{||y_1||}$. The result of the code is $3.79$, which is close to $4$.

= Design an IIR filter with bilinear transform and realize filtering

==

Let the input signal in the complex field be $underline(U_i)$, output signal $underline(U_o)$, the current intensity $underline(i)$ we have the equation in the circuit:

$
  underline(U_o) = underline(U_i) (C integral underline(i) dif t) / (C integral underline(i) dif t + underline(i) R + L (dif underline(i)) / (dif t))
$

Apply the Laplace transform to the equation, we can get the transfer function of the circuit:

$
  H(s) = underline(U_o) / underline(U_i) = 1 / (R + L s + 1 / (C s))
$

==

Apply the bilinear method, where $T = 1 / f_s$:

$
  H(z) &= H(s) |_(s = 2 / T (z - 1) / (z + 1)) \
       &= 1 / (1 + R C 2 / T (z - 1) / (z + 1) + L C 4 / (T ^ 2) (z - 1) ^ 2 / ((z + 1) ^ 2)) \
       &= (z ^ 2 + 2 z + 1) / (z ^ 2 (1 + (2 R C) / T + L C) + z (2 - 2 L C) + 1 - (2 R C) / T + L C 4 / (T ^ 2)) \
       &= (z ^ 2 + 2 z + 1) / (z ^ 2 (1 + 2 R C f_s + L C) + z (2 - 2 L C) + 1 - 2 R C f_s + 4 L C f_s ^ 2)
$

Let $a_1 = 1 + 2 R C f_s + L C$, we can We can divide both the numerator and denominator by $a_1$ to get the coefficients of the difference equation.

==

Set the $f_s = 23966.14"Hz"$ (to be obtained later), The FRF of the analog filter and the digital filter are:

#figure(image("pic2/t3.c.4.png", width: 80%))
#figure(image("pic2/t3.c.5.png", width: 80%))

At $f_"input" = 1000"Hz"$, we can plot the difference between the output of the analog filter and the digital filter for different sampling frequencies between $10000$ and $50000$ in $"dB"$:

#figure(image("pic2/t3.c.1.png", width: 80%))

As we can see in the figure, the minimum $f_s$ that makes the difference less than $0.1"dB"$ is around $23966.14"Hz"$.

Their magnitudes and in $"dB"$ and phases in radians are:

#figure(image("pic2/t3.c.2.png", width: 80%))
#figure(image("pic2/t3.c.3.png", width: 80%))

This is a low-pass filter with its cut-off frequency $f_c = 51.33"Hz"$ (obtained by the code, where the gain is $-3"dB"$).

==

The input ($x$, blue curve) and the output ($y$, orange curve) of the filter are as follows:

#figure(image("pic2/t3.d.1.png", width: 80%))

Here we also plotted the signals with frequencies $f_1 = 5$ and $f_2 = 50$. It can be seen that these two frequencies are preserved and the component with the highest frequency $f_3 = 500$ in the blue curve are filtered out in the output signal.

The spectra shows that the frequency of $500"Hz"$ is filtered out:

#figure(image("pic2/t3.d.2.png", width: 80%))

= Pole/Zero Designs

==

Idea: we want to design a filter with the zeros of $H(z)$ right at $f_c = 24$, so that the frequency of $24"Hz"$ is filterer out. Theres should also be a pole at around $f_c = 24$, so that the frequencies away from $24$ is not affected.

As the coefficients of the difference equation are real, the roots of the numerator polynomial (named bz) and denominator polynomial (az) must be conjugate complex numbers.

Let the digital cut-off angular frequency be $omega_c = 2 pi f_c / f_s$. The roots of bz should be $e^(j w_c)$ and $e^(-j w_c)$, and the roots of az should be $R e^(j w_c)$ and $R e^(-j w_c)$, where $R$ is a parameter to be determined. So we have:

$
  H(z) &= ((z - e^(j w_c)) (z - e^(-j w_c))) / ((z - R e^(j w_c)) (z - R e^(-j w_c))) \
       &= (z ^ 2 - 2 cos(w_c) z + 1) / (z ^ 2 - 2 R cos(w_c) z + R ^ 2) \
$

Here $R$ will decide the bandwidth of the filter. Let's plot the bandwidth of $-3"dB"$ of different $R$ from $0.97$ to $1$. How do we get the bandwidth of an $R$? We can simply calculate the frequency responses into a list in python, and find the first and the last frequency that the response is less than $-3"dB"$. The bandwidth is the difference between these two frequencies. Now the bandwidth-$R$ curve is like:

#figure(image("pic2/t4.a.1.png", width: 80%))

Find the first $R$ in the list that makes the the band-width less than $1.00$, we can get the $R = 0.98383$. Good!

$
  H(z) &= (z ^ 2 - 2 cos(w_c) z + 1) / (z ^ 2 - 2 R cos(w_c) z + R ^ 2) \
       &tilde.eq (z ^ 2 - 1.46 z + 1) / (z ^ 2 - 1.43 z + 0.968)
$

The difference equation:

$
  y[n] - 1.43 y[n - 1] + 0.968 y[n - 2] = x[n] - 1.46 x[n - 1] + x[n - 2]
$

Now we can get the right az and bz, plot the pole-zero map and the frequency response of the filter:

#figure(image("pic2/t4.a.2.png", width: 50%))
#figure(image("pic2/t4.a.3.png", width: 80%))
#figure(image("pic2/t4.a.4.png", width: 80%))
#figure(image("pic2/t4.a.5.png", width: 80%))

In this figure, we can clearly see that the notch of $-3"dB"$ is between $23.5"Hz"$ and $24.5"Hz"$.

==

We just plot it here:

#figure(image("pic2/t4.b.1.png", width: 80%))

The high frequency component is filtered out. The frequency spectra is in the last figure in 4.a.

==

To design a comb filter, we make $H(z)$ something like:

#figure(image("pic2/t4.c.5.png", width: 50%))

$
  H(z) &= (z ^ 2 - 2 R_"zero" cos(w_c) z + R_"zero"^2) / (z ^ 2 - 2 R_"pole" cos(w_c) z + R_"pole" ^ 2) \
$

Unlike for a notch filter, we can't simply put the poles on the unit circle to amplify the higher frequency, because this will make the system unstable. So after deciding $f_"peak" = 24$ and $omega_"peak" = 2 pi f_"peak" / f_s$, we still have 2 DoF: the radii of the poles $R_"pole"$ and of zeros $R_"zero"$. Getting a good tuples of radii is complicated, so here we use the theoretical method.

To make the bandwidth of $1"Hz"$, we use the approximation method to analyze the conditions that two radii need to meet.

#figure(image("pic2/t4.c.6.png", width: 50%))

We consider a tiny part of the unit circle close to the pole. $A B$ is a very small part of the unit circle, so it is approximately a line. At $omega = omega_"peak"$, the magnification is $y / x$ according to the property of a comb filter. To normalize the gain function, we will multiply `bz` by $x / y$. We can deduce that the proper $Delta omega$ that makes that bandwidth $1"Hz"$ is: $ Delta omega_c = 2 pi times 1 / 2 times 1 / f_s tilde.eq 0.0157 $

Let's now find that condition that $x$ and $y$ should meet, with all the variable positive real numbers, so that when $Delta omega = Delta omega_c$, the attenuation is $1 / sqrt(2)$:

$
  q / p x / y = 1 / sqrt(2)
$

Here $q / p$ stands for the ratio of the distances from $F$ to the zero point and to pole point, $x / y$ stands for the normalization coefficient.

Square both sides:

$
  q^2 / p^2 x^2 / y^2 = 1 / 2
$

Using the Pythagorean theorem:

$
  ((y^2 + Delta omega^2) x^2) / ((x^2 + Delta omega^2) y^2) = 1 / 2
$

Shift the terms:

$
  x^2 = (Delta omega^2 y^2) / (2 Delta omega^2 + y^2)
$

As $x, y, Delta omega > 0$:

$
  x = (Delta omega y) / sqrt(2 Delta omega^2 + y^2)
$

There's now only $1$ DoF: the radius of the zero point $y$ (or the pole point, as they are limited by the equation above). It should be close to $1$ in order that frequencies away from $f_"peak"$ are not affected (so that after normalization, they are elimited).

On the other hand, the magnification is $y / x$. Likewise, we deduce that: $ y / x = sqrt(2 + y ^ 2 / w^2) $

The figure of magnification(dB)-$y$:

#figure(image("pic2/t4.c.7.png", width: 80%))
Larger the $y$ is, larger will the magnification be. We can set $y = 0.15$ for magnification $y / x tilde.eq 9.65 = 19.7"dB"$. We then have $x tilde.eq 0.0155, R_"zero" = 0.85, R_"pole" tilde.eq 0.9845$, and the transfer function:

$
  H(z) &tilde.eq 1 / 9.65 times (z ^ 2 - 1.70 z + 0.722) / (z ^ 2 - 1.97 z + 0.969) \
       &tilde.eq (0.104 z ^ 2 - 0.130 z + 0.0748) / (z ^ 2 - 1.97 z + 0.969)
$

The difference equation:

$
  y[n] - 1.97 y[n - 1] + 0.969 y[n - 2] = 0.104 x[n] - 0.130 x[n - 1] + 0.0748 x[n - 2]
$

Plotting the poles and zeros:

#figure(image("pic2/t4.c.1.png", width: 50%))

FRFs:

#figure(image("pic2/t4.c.2.png", width: 80%))
#figure(image("pic2/t4.c.3.png", width: 80%))

==

Time sequences:

#figure(image("pic2/t4.d.1.png", width: 80%))

The frequency spectra:

#figure(image("pic2/t4.c.4.png", width: 80%))

The higher frequency of $24$ is preserved. 
  

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
names = ['Modulus', 'Phase', 'Real', 'Imaginary']
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

prop_desc = ['Modulus', 'Phase']
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
    Modulus, phase
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
prop_desc = ['Modulus', 'Phase']

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

== Lab3 Problem 7

=== Code for 7.a

```python
# [1.a]
import numpy as np
import matplotlib.pyplot as plt

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def pzmap(bz, az):
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]

class HFunc:
    def __init__(self, bz, az):
        self.bz: np.array = bz
        self.az: np.array = az

def plot_complex_numbers(bz, az):
    # Create a new figure with custom size
    fig = plt.figure(figsize=(6, 6))
    
    # Extract real and imaginary parts for both lists
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    
    # Create scatter plots for both lists
    plt.scatter(real_parts1, imaginary_parts1, marker='o', color='blue', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2, marker='x', color='red', label='Poles')
    
    # Draw the unit circle
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    
    # Set axis limits
    plt.xlim(-3, 3)
    plt.ylim(-3, 3)
    
    # Force the x and y axis to be the same scale (each 1x1 grid should look like a square)
    plt.gca().set_aspect('equal', adjustable='box')
    
    # Add labels and title
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.title('Complex Numbers in the Complex Plane')
    
    # Add legend
    plt.legend()
    
    # Show the plot
    plt.grid(True)
    plt.show()

# Example usage
bz = [2, 3]
az = [1, -0.5]
plot_complex_numbers(*pzmap(bz, az))

```

=== Code for 7.b

```python
# [1.b]
def h_value(bz, az, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = sum([az[i] * z ** (-i) for i in range(len(az))])
    return num / den
def freqz(bz, az, w):
    ... # w between -pi and pi?
    hs = np.array([h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, hs

SAMPLE_N = 5000

def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag

ws = np.linspace(-np.pi, np.pi, SAMPLE_N)
ws, hs = freqz(bz, az, ws)

hs_plots = get_mod_pha_real_imag(hs)
names = ['Modulus', 'Phase', 'Real', 'Imaginary']

for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ws, hs_plots[i], 'r-', label=f'Frequency response {names[i]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

=== Code for 7.c

```python
# [1.c]
def filter(bz, az, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys


L = 100
xs = [1, 2, 3]
xs, ys = filter(bz, az, xs, L)
print(*ys[:20], sep=", ")
ys_plots = get_mod_pha_real_imag(ys)

fig = plt.figure(figsize=(18, 6))
plt.plot(np.arange(L), ys_plots[0], 'r-', label=f'first {L} y')
plt.xlabel('w')
plt.legend()
fig.show()
```

=== Code for 7.d

```python
# [1.d]
impulse_xs = [1] # impulse response
xs, ys = filter(bz, az, impulse_xs, L)
ys_plots = get_mod_pha_real_imag(ys)

print(ys[:20])

for i in range(1):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(np.arange(L), ys_plots[i], 'r-', label=f'Impulse response {names[i]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

== Lab3 Problem 8

=== Code for 8.a

```python
# [2.a]
import numpy as np
import matplotlib.pyplot as plt

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def get_mod_pha_real_imag(c):
    return np.abs(c), np.angle(c), c.real, c.imag

def gen_g(d, h):
    def g(t):
        return np.where((t >= -d) & (t <= d), h, 0)
    return g

W_C = 0.3 * np.pi
low_pass_g = gen_g(W_C, 1)

SAMPLE_N = 5000
def discret_samples(f, d):
    t_values = np.linspace(-d, d, SAMPLE_N)
    return t_values, f(t_values)

def __draw(xs, ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(xs, ys)
    plt.xlabel('x')
    fig.show()
    
def __draw_ys(ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ys)
    plt.xlabel('x')
    fig.show()
    
__draw(*discret_samples(low_pass_g, np.pi))

def idtft_window(minn, maxn, dtft_func):
    ns = np.arange(minn, maxn + 1)
    hs = np.zeros_like(ns, dtype=complex)
    w_samples, f_samples = discret_samples(dtft_func, np.pi)
    dw = w_samples[1] - w_samples[0]
    for i in range(len(ns)):
        hs[i] = 1 / (2 * np.pi) * np.sum(f_samples * np.exp(1j * ns[i] * w_samples) * dw)
    return ns, hs # hs itself is causal

ns, hs = idtft_window(-30, 30, low_pass_g)
__draw(ns, hs)

def filter(bz, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))])
    return xs, ys

fig = plt.figure(figsize=(18, 6))
test_n = [30, 100]
colors = ['r-', 'b--']
for j in range(len(test_n)):
    n = test_n[j]
    ns, hs = idtft_window(-n, n, low_pass_g)
    bz = hs
    impulse_xs = np.array([1 + 0j])
    L = 200
    xs, ys = filter(bz, impulse_xs, L)
    plt.plot(np.arange(L), ys, colors[j],label=f'Impulse response of window length {n}'),
plt.xlabel('w')
plt.legend()
fig.show()

def cap_h_value(bz, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = 1
    return num / den

def frequency_response(bz):
    ws = np.linspace(-np.pi, np.pi, SAMPLE_N)
    cap_hs = np.array([cap_h_value(bz, np.exp(1j * omega)) for omega in ws])
    return ws, cap_hs
    

prop_desc = ['Modulus', 'Phase']
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    test_n = [30, 100]
    colors = ['r-', 'b--']
    for j in range(len(test_n)):
        n = test_n[j]
        ns, hs = idtft_window(-n, n, low_pass_g)
        bz = hs
        ws, cap_hs = frequency_response(bz)
        hs_plots = get_mod_pha_real_imag(cap_hs)
        plt.plot(ws, hs_plots[i], colors[j],label=f'FRF\'s {prop_desc[i]} of window length {n}'),
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

=== Code for 8.b

```python
# [2.b]
def gen_pit(d, h):
    def g(t):
        return np.where((t <= -d) | (t >= d), h, 0)
    return g

high_pass_g = gen_pit(W_C, 1)
__draw(*discret_samples(high_pass_g, np.pi))

WINDOW_N = 61
ns, hs = idtft_window(-30, 30, high_pass_g)
# print(hs)
kaiser_hs = np.kaiser(WINDOW_N, beta=10) * hs
window_names = ['Rectangular', 'Kaiser']

fig = plt.figure(figsize=(18, 6))
colors = ['r-', 'b--']
for i in range(2):
    bz = hs if i == 0 else kaiser_hs
    impulse_xs = np.array([1 + 0j])
    L = 200
    xs, ys = filter(bz, impulse_xs, L)
    plt.plot(np.arange(L), ys, colors[i], label=f'Impulse response of {window_names[i]} window'),
plt.xlabel('w')
plt.legend()
fig.show()

prop_desc = ['Modulus', 'Phase']
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    colors = ['r-', 'b--']
    for j in range(2):
        bz = hs if j == 0 else kaiser_hs
        ws, cap_hs = frequency_response(bz)
        hs_plots = get_mod_pha_real_imag(cap_hs)
        plt.plot(ws, hs_plots[i], colors[j], label=f'FRF\'s {prop_desc[i]} of {window_names[j]} window'),
    plt.xlabel('w')
    plt.legend()
    fig.show()

```

=== Code for 8.c

```python
# [2.c]
f_s = 200
f_c = 15
w_c = 2 * np.pi * f_c / f_s
# [pit]
high_pass_g = gen_pit(w_c, 1)
# [idtft]
ns, hs = idtft_window(-30, 30, high_pass_g)
kaiser_hs = np.kaiser(WINDOW_N, beta=10) * hs
# [draw frequency response]
prop_desc = ['Modulus', 'Phase']
for i in range(2):
    fig = plt.figure(figsize=(18, 6))
    bz = kaiser_hs
    ws, cap_hs = frequency_response(bz)
    hs_plots = get_mod_pha_real_imag(cap_hs)
    plt.plot(ws, hs_plots[i], 'r-', label=f'Designed FRF\'s {prop_desc[i]}'),
    plt.xlabel('w')
    plt.legend()
    fig.show()
```

=== Code for 8.d

```python
# [2.d]
a_1 = 8
a_2 = 4
f_1 = 7
f_2 = 24
T = 1 / f_s
ns = np.arange(-200, 400)
xs = a_1 * np.cos(2 * np.pi * f_1 * T * ns) + a_2 * np.cos(2 * np.pi * f_2 * T * ns)
xs, ys = filter(kaiser_hs, xs, len(xs))

blocks = [xs[i:i + 200] for i in range(0, len(xs), 200)]
blocks_ys = [np.convolve(hs, block)[:200] for block in blocks] # for a 200 block, length is 200 + len(hs) - 1, the last several is removed
pieced_ys = np.concatenate(blocks_ys)

fig = plt.figure(figsize=(18, 6))
plt.plot(ns, ys, 'r-', label=f'y1'),
plt.plot(ns, pieced_ys, 'b--', label=f'y2'),
plt.xlabel('n')
plt.legend()
fig.show()
```

=== Code for 8.e

```python
# [2.e]
FFT_N = 1024
pad_x = np.arange(FFT_N)
pad_w = np.array([2 * np.pi * k / FFT_N for k in range(FFT_N)])
pad_ys = expand(ys, FFT_N)
pad_xs = expand(xs, FFT_N)
pad_pieced_ys = expand(pieced_ys, FFT_N)

fft_ys = np.fft.fft(pad_ys)
fft_xs = np.fft.fft(pad_xs)
fft_pieced_ys = np.fft.fft(pad_pieced_ys)

for part in range(2):
    fig = plt.figure(figsize=(18, 6))
    fft_ys_plots = get_mod_pha_real_imag(fft_ys)
    fft_xs_plots = get_mod_pha_real_imag(fft_xs)
    fft_pieced_ys_plots = get_mod_pha_real_imag(fft_pieced_ys)

    half = FFT_N // 2
    plt.plot(pad_w[:half], fft_ys_plots[part][:half], 'b-', label=f'FFT {prop_desc[part]} of y1')
    plt.plot(pad_w[:half], fft_xs_plots[part][:half], 'r--', label=f'FFT {prop_desc[part]} of x')
    plt.plot(pad_w[:half], fft_pieced_ys_plots[part][:half], 'g--', label=f'FFT {prop_desc[part]} of pieced y2')
    plt.legend()
    plt.xlabel('w')
    fig.show()
    
print(f'The amplitude of the remaining of frequency 24 is {max(fft_ys_plots[0]) / 600 * 2}')
```

== Lab3 Problem 9

=== Code for 9.c

```python
# [3.c]
import numpy as np
import matplotlib.pyplot as plt

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def pzmap(bz, az):
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]

def plot_complex_numbers(bz, az):
    # Create a new figure with custom size
    fig = plt.figure(figsize=(6, 6))
    
    # Extract real and imaginary parts for both lists
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    
    # Create scatter plots for both lists
    plt.scatter(real_parts1, imaginary_parts1, marker='o', color='blue', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2, marker='x', color='red', label='Poles')
    
    # Draw the unit circle
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    
    # Set axis limits
    plt.xlim(-3, 3)
    plt.ylim(-3, 3)
    
    # Force the x and y axis to be the same scale (each 1x1 grid should look like a square)
    plt.gca().set_aspect('equal', adjustable='box')
    
    # Add labels and title
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.title('Complex Numbers in the Complex Plane')
    
    # Add legend
    plt.legend()
    
    # Show the plot
    plt.grid(True)
    plt.show()

# Example usage
# bz = [2, 3]
# az = [1, -0.5]

def cap_h_value(bz, az, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = sum([az[i] * z ** (-i) for i in range(len(az))])
    return num / den
def freqz(bz, az, w):
    ... # w between -pi and pi?
    hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, hs

SAMPLE_N = 5000

def get_mod_pha_real_imag(c):
    return [np.abs(c), np.angle(c), c.real, c.imag]

def filter(bz, az, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys

R = 3
L = 0.02
C = 0.001
def gen_bz_az(f_s):
    bz = np.array([1, 2, 1])
    a1 = 1 + 2 * R * C * f_s + 4 * L * C * f_s ** 2
    az = np.array([a1, 2 - 8 * L * C * f_s ** 2, 1 - 2 * R * C * f_s + 4 * L * C * f_s ** 2])
    return bz / a1, az / a1

def hw(w):
    return 1 / (1 + 1j * w * R * C - w ** 2 * L * C)

def hz_w(w, w_s, bz, az):
    real_w = w / w_s * np.pi * 2
    return cap_h_value(bz, az, np.exp(1j * real_w))

def frequency_response(bz, az):
    ws = np.linspace(-np.pi, np.pi, SAMPLE_N)
    cap_hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in ws])
    return ws, cap_hs

# def analog_frequency_response(hw_func, ws):
#     return ws, np.array([hw_func(w) for w in ws])

def db(x):
    return 20 * np.log10(np.abs(x))

TEST_F = 1000
TEST_W = 2 * np.pi * TEST_F
def __draw(xs, ys, xlabel='x', ylabel='y'):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(xs, ys, label=ylabel)
    plt.legend()
    plt.xlabel(xlabel)
    fig.show()

try_f_s = np.linspace(10000, 50000, 100000)
try_diff = []
for f_s in try_f_s:
    bz, az = gen_bz_az(f_s)
    diff = np.abs(hz_w(TEST_W, 2 * np.pi * f_s, bz, az)) / np.abs(hw(TEST_W))
    try_diff.append(diff)
try_diff = db(np.array(try_diff))
fig = plt.figure(figsize=(18, 6))
plt.plot(try_f_s, try_diff, label='Difference (dB)')
plt.legend()
plt.xlabel('fs')

min_index = min(i for i, x in enumerate(try_diff) if abs(x) < 0.1)
min_f_s_that_makes_diff_less_than_0_point_1_db = try_f_s[min_index]
print(min_f_s_that_makes_diff_less_than_0_point_1_db)

plt.plot(min_f_s_that_makes_diff_less_than_0_point_1_db, try_diff[min_index], 'ro')  # 'ro'表示红色圆点
plt.text(min_f_s_that_makes_diff_less_than_0_point_1_db, try_diff[min_index],
         f'({min_f_s_that_makes_diff_less_than_0_point_1_db:.2f}, {try_diff[min_index]:.2f})', ha='right', va='bottom')  # 标注坐标
# hhh
fig.show()

f_s = min_f_s_that_makes_diff_less_than_0_point_1_db
bz, az = gen_bz_az(f_s)

prop_desc = ['Magnitude', 'Phase', 'Real', 'Imaginary']
for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    ws, cap_hs = frequency_response(bz, az)
    analog_hs = np.array([hw(w * f_s) for w in ws])

    hs_plots = get_mod_pha_real_imag(cap_hs)
    analog_hs_plots = get_mod_pha_real_imag(analog_hs)
    plt.plot(ws, analog_hs_plots[prop], '-', label=f'Analog filter FRF {prop_desc[prop]}')
    plt.plot(ws, hs_plots[prop], '--', label=f'Digital filter {prop_desc[prop]}')

    plt.xlabel('w')
    plt.legend()
    fig.show()

```

```python
frequencies = np.linspace(1, f_s / 2, SAMPLE_N)
analog_output = np.array([hw(2 * np.pi * f) for f in frequencies])
digital_output = np.array([hz_w(2 * np.pi * f, 2 * np.pi * f_s, bz, az) for f in frequencies])
# Why tf the transform makes w_real in 0 and 2pi?
analog_plots = get_mod_pha_real_imag(analog_output)
digital_plots = get_mod_pha_real_imag(digital_output)
analog_plots[0] = db(analog_plots[0])
digital_plots[0] = db(digital_plots[0])

for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.semilogx(frequencies, analog_plots[prop], '-',  label=f'Analog {prop_desc[prop]}')
    plt.semilogx(frequencies, digital_plots[prop], '--', label=f'Digital {prop_desc[prop]}')
    plt.xlabel('f (Hz)')
    plt.ylabel('Gain (dB)' if prop == 0 else 'Phase (rad)')
    plt.legend()
    fig.show()
    
cut_off_frequency = frequencies[[i for i, x in enumerate(digital_plots[0]) if x < -3][0]]
print(cut_off_frequency)
```

=== Code for 9.d

```python
# [3.d]
# 模拟角频率转数字角频率
f1, f2, f3 = 5, 50, 500
def attenuate(f):
    return db(hz_w(2 * np.pi * f, 2 * np.pi * f_s, bz, az))

print(attenuate(f1), attenuate(f2), attenuate(f3))

def x(n):
    return np.cos(2 * np.pi * f1 * n / f_s) + np.cos(2 * np.pi * f2 * n / f_s) + np.cos(2 * np.pi * f3 * n / f_s)

def f1_x(n):
    return np.cos(2 * np.pi * f1 * n / f_s)

def f2_x(n):
    return np.cos(2 * np.pi * f2 * n / f_s)

# 原来 T = 1 / fs。在数字输入中，T = 1，故角频率放缓 fs 倍
ns = np.arange(10000)
xs = x(ns)
ys = filter(bz, az, xs, len(ns))[1]
f1_xs = f1_x(ns)
f2_xs = f2_x(ns)
fig = plt.figure(figsize=(18, 6))
plt.plot(ns, xs, label='x')
plt.plot(ns, ys, label='y')
plt.plot(ns, f1_xs, '--', label='f1_x')
plt.plot(ns, f2_xs, '--', label='f2_x')
plt.legend()
fig.show()

fig = plt.figure(figsize=(18, 6))

def dtft(ns, xs, ws=np.linspace(-np.pi, np.pi, SAMPLE_N)):
    cap_xs = np.zeros(len(ws), dtype=complex)
    for i in range(len(ws)):
        cap_xs[i] = np.sum(xs * np.exp(-1j * ws[i] * ns))
    return ws, cap_xs

_, input_dtft = dtft(ns, xs, np.linspace(0, 600 / f_s * 2 * np.pi, SAMPLE_N))
ws, output_dtft = dtft(ns, ys, np.linspace(0, 600 / f_s * 2 * np.pi, SAMPLE_N))
input_dtft = input_dtft / len(ns) * 2
output_dtft = output_dtft / len(ns) * 2
ws *= f_s / 2 / np.pi

plt.plot(ws, np.abs(input_dtft) , label='Input DTFT')
plt.plot(ws, np.abs(output_dtft), label='Output DTFT')
plt.legend()
fig.show()
```

== Lab3 Problem 10

=== Code for 10.a

```python
# [4.a]
import numpy as np
import matplotlib.pyplot as plt

def __draw_ys(ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ys)
    plt.xlabel('x')
    fig.show()

def __draw(xs, ys):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(xs, ys)
    plt.xlabel('x')
    fig.show()

def expand(arr, n):
    return np.pad(arr, (0, n - len(arr)), 'constant')

def pzmap(bz, az):
    m = len(bz)
    n = len(az)
    level = max(m, n)
    pad_bz = expand(bz, level)
    pad_az = expand(az, level)
    return [np.roots(pad_bz), np.roots(pad_az)]

def plot_complex_numbers(bz, az):
    # Create a new figure with custom size
    fig = plt.figure(figsize=(6, 6))
    
    # Extract real and imaginary parts for both lists
    real_parts1 = [z.real for z in bz]
    imaginary_parts1 = [z.imag for z in bz]
    real_parts2 = [z.real for z in az]
    imaginary_parts2 = [z.imag for z in az]
    
    # Create scatter plots for both lists
    plt.scatter(real_parts1, imaginary_parts1, marker='o', color='blue', label='Zeros')
    plt.scatter(real_parts2, imaginary_parts2, marker='x', color='red', label='Poles')
    
    # Draw the unit circle
    theta = np.linspace(0, 2 * np.pi, 100)
    x_circle = np.cos(theta)
    y_circle = np.sin(theta)
    plt.plot(x_circle, y_circle, color='green', label='Unit Circle')
    
    # Set axis limits
    # plt.xlim(k1, 3)
    # plt.ylim(-3, 3)
    
    # Force the x and y axis to be the same scale (each 1x1 grid should look like a square)
    plt.gca().set_aspect('equal', adjustable='box')
    
    # Add labels and title
    plt.xlabel('Real Part')
    plt.ylabel('Imaginary Part')
    plt.title('Complex Numbers in the Complex Plane')
    
    # Add legend
    plt.legend()
    
    # Show the plot
    plt.grid(True)
    plt.show()

# Example usage
# bz = [2, 3]
# az = [1, -0.5]

def cap_h_value(bz, az, z: complex):
    num = sum([bz[i] * z ** (-i) for i in range(len(bz))])
    den = sum([az[i] * z ** (-i) for i in range(len(az))])
    return num / den
def freqz(bz, az, w):
    ... # w between -pi and pi?
    hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in w])
    return w, hs

SAMPLE_N = 5000

def get_mod_pha_real_imag(c):
    return [np.abs(c), np.angle(c), c.real, c.imag]

def filter(bz, az, x, L):
    ...
    # y[n] = 
    xs = expand(x, L) # first several x
    ys = np.zeros_like(xs)
    def y_at(n):
        return 0 if n < 0 else ys[n]
    def x_at(n):
        return 0 if n < 0 else xs[n]
    for n in range(L):
        # calculate y[n]
        ys[n] = sum([bz[i] * x_at(n - i) for i in range(len(bz))]) - sum([az[i] * y_at(n - i) for i in range(1, len(az))])
    return xs, ys

def frequency_response(bz, az, sample_n=SAMPLE_N):
    ws = np.linspace(-np.pi, np.pi, sample_n)
    cap_hs = np.array([cap_h_value(bz, az, np.exp(1j * omega)) for omega in ws])
    return ws, cap_hs

# def analog_frequency_response(hw_func, ws):
#     return ws, np.array([hw_func(w) for w in ws])

def db(x):
    return 20 * np.log10(np.abs(x))

```

```python
f_s = 200
a_1 = 8
a_2 = 4
f_1 = 7
f_2 = 24
T = 1 / f_s
ns = np.arange(-200, 400)
xs = a_1 * np.cos(2 * np.pi * f_1 * T * ns) + a_2 * np.cos(2 * np.pi * f_2 * T * ns)

notch_f = 24
def ana_f_to_dig_w(f):
    return f / f_s * 2 * np.pi

def dig_w_to_ana_f(w):
    return w / (2 * np.pi) * f_s

notch_dig_w = ana_f_to_dig_w(notch_f)

rs = np.linspace(0.97, 1, 500)
band_fs = []
for r in rs:
    # get the band width of -3dB
    ...
    bz = [1, -2 * np.cos(notch_dig_w), 1]
    az = [1, -2 * r * np.cos(notch_dig_w), r ** 2]
    ws, hs = frequency_response(bz, az)
    hs = np.abs(hs)
    ws, hs = ws[len(ws) // 2:], hs[len(hs) // 2:]
    # first one lower than -3dB
    those_w_higher_than_minus_3_db = [w for w, h in zip(ws, hs) if db(h) < -3]
    if len(those_w_higher_than_minus_3_db) < 2:
        band_fs.append(0)
        continue
    l_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[0])
    r_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[-1])
    # print(l_f, r_f)
    band_f = r_f - l_f
    band_fs.append(band_f)

__draw(rs, band_fs)
min_r_making_band_with_1 = [r for r, band_f in zip(rs, band_fs) if band_f <= 1][0]
print(min_r_making_band_with_1)
```

```python
min_r = min_r_making_band_with_1
bz = [1, -2 * np.cos(notch_dig_w), 1]
az = [1, -2 * min_r * np.cos(notch_dig_w), min_r ** 2]
print(bz, az)
plot_complex_numbers(*pzmap(bz, az))
ws, hs = frequency_response(bz, az)
hs_plots = get_mod_pha_real_imag(hs)
ana_fs = dig_w_to_ana_f(ws)

prop_desc = ['Magnitude', 'Phase', 'Real', 'Imaginary']
for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ws, hs_plots[prop], '-', label=f'FTF {prop_desc[prop]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()

DISPLAY_N = len(ws) // 2
fig = plt.figure(figsize=(18, 6))
plt.plot(ana_fs[DISPLAY_N:], db(hs_plots[0][DISPLAY_N:]), '-', label=f'Gain')
plt.axhline(y=-3, color='r', linestyle='--')  # Draw horizontal line at y = 0.707
plt.text(0, -2, 'y = -3', color='r', fontsize=12, va='center')  # Add text annotation
plt.scatter([23.5, 24.5], [-3, -3], color='red')
# 添加文本标注
plt.text(23.5, -3, '(23.5, -3)', color='red', fontsize=10, va='bottom', ha='right')
plt.text(24.5, -3, '(24.5, -3)', color='red', fontsize=10, va='bottom', ha='left')
plt.xlabel('f')
plt.legend()
fig.show()

```

=== Code for 10.b

```python
# [4.b]
_, ys = filter(bz, az, xs, 600)
fig = plt.figure(figsize=(18, 6))
plt.plot(ns, xs, '-', label=f'x')
plt.plot(ns, ys, '-', label=f'y')
plt.xlabel('n')
plt.legend()
fig.show()

```

=== Code for 10.c

```python
# [4.c]
comb_f = 24
notch_dig_w = ana_f_to_dig_w(comb_f)

def coef_of_r(r):
    return np.array([1, -2 * r * np.cos(notch_dig_w), r ** 2])
del_w = ana_f_to_dig_w(0.5)
print(del_w)
good_y = 0.15 # zero 必须接近单位圆，使得远离此频率时，不受该点影响
zero_r = 1 - good_y
x_with_band_1 = (del_w * good_y) / (2 * del_w ** 2 + good_y ** 2) ** 0.5
pole_r = 1 - x_with_band_1
print(x_with_band_1, del_w)
max_gain = (1 - zero_r) / (1 - pole_r)
print(max_gain)
bz = coef_of_r(zero_r) / max_gain
az = coef_of_r(pole_r)
print(bz, az)
ws, hs = frequency_response(bz, az, 50000)
plot_complex_numbers(*pzmap(bz, az))

# for r in rs:
#     # get the band width of -3dB
#     ...
#     bz = coef_of_r(r)
#     az = coef_of_r(omg_r)
#     max_gain = (1 - r) / (1 - omg_r)
#     ws, hs = frequency_response(bz, az, 30000)
#     hs = np.abs(hs) / max_gain
#     ws, hs = ws[len(ws) // 2:], hs[len(hs) // 2:]

#     # first one lower than -3dB
#     if r == rs[0]:
#         __draw(ws, hs)
#     those_w_higher_than_minus_3_db = [w for w, h in zip(ws, hs) if db(h) > -3]
#     if len(those_w_higher_than_minus_3_db) < 2:
#         band_fs.append(0)
#         continue
#     l_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[0])
#     r_f = dig_w_to_ana_f(those_w_higher_than_minus_3_db[-1])
#     # print(l_f, r_f)
#     band_f = r_f - l_f
#     band_fs.append(band_f)

# __draw(rs, band_fs)
# min_zero_r_making_band_with_1 = [r for r, band_f in zip(rs, band_fs) if band_f >= 1][0]
# print(min_zero_r_making_band_with_1)
```

```python
m_ys = np.linspace(0, 1, 1000)
m_ms = [(2 / (1 - (1 / (2 * del_w ** 2 / y ** 2 + 1)))) ** 0.5 for y in m_ys]
__draw(m_ys, db(m_ms))
mm_ms = [(2 + y ** 2 / del_w ** 2) ** 0.5 for y in m_ys]
__draw(m_ys, db(mm_ms))
```

```python
hs_plots = get_mod_pha_real_imag(hs)
ana_fs = dig_w_to_ana_f(ws)

prop_desc = ['Magnitude', 'Phase', 'Real', 'Imaginary']
for prop in range(2):
    fig = plt.figure(figsize=(18, 6))
    plt.plot(ws, hs_plots[prop], '-', label=f'FTF {prop_desc[prop]}')
    plt.xlabel('w')
    plt.legend()
    fig.show()

ana_fs_idx_around_24 = np.where((ana_fs > 0))

fig = plt.figure(figsize=(18, 6))
plt.plot(ana_fs[ana_fs_idx_around_24], db(hs_plots[0][ana_fs_idx_around_24]), '-', label=f'Gain')
plt.axhline(y=-3, color='r', linestyle='--')  # Draw horizontal line at y = 0.707
plt.text(23, -2.8, 'y = -3', color='r', fontsize=12, va='center')  # Add text annotation
plt.scatter([23.5, 24.5], [-3, -3], color='red')
# 添加文本标注
plt.text(23.5, -3, '(23.5, -3)', color='red', fontsize=10, va='bottom', ha='right')
plt.text(24.5, -3, '(24.5, -3)', color='red', fontsize=10, va='bottom', ha='left')
plt.xlabel('f')
plt.legend()
fig.show()
```

=== Code for 10.d

```python
# [4.d]
_, ys = filter(bz, az, xs, 600)
fig = plt.figure(figsize=(18, 6))
plt.plot(ns, xs, '-', label=f'x')
plt.plot(ns, ys, '-', label=f'y')
plt.xlabel('n')
plt.legend()
fig.show()
```

