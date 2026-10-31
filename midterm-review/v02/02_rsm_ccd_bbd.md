# Chapter 02: Response Surface Methodology (RSM), CCD & BBD
*Second-Order Modeling, Experimental Geometry, and R Terminal Analysis*

---

## 1. Why Response Surface Methodology?

Response Surface Methodology (RSM) is used when you want to **find the optimal operating settings** of continuous experimental factors ($X_1, X_2, \dots, X_k$) that maximize or minimize a quantitative response ($y$).

### First-Order vs. Second-Order Models

#### A. First-Order (Linear) Model
$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \dots + \beta_k x_k + \epsilon$$

- A first-order model represents a **flat, tilted plane**.
- A flat plane has a constant slope everywhere. It possesses **no maximum, no minimum, and no curvature**.
- It can only tell you the general uphill direction (used in the *Method of Steepest Ascent*).

#### B. Second-Order (Quadratic) Model
$$y = \beta_0 + \sum_{i=1}^k \beta_i x_i + \sum_{i=1}^k \beta_{ii} x_i^2 + \sum \sum_{i < j} \beta_{ij} x_i x_j + \epsilon$$

To locate an optimum (peak or valley), the mathematical surface must bend. This bending requires **second-order terms**:
- $\beta_i x_i$: First-order linear terms (directional slopes).
- $\beta_{ii} x_i^2$: **Pure quadratic terms (curvature)** along each factor axis.
- $\beta_{ij} x_i x_j$: **Two-way interaction terms (twist)** measuring how the effect of one factor changes depending on another.

---

## 2. Factor Coding & Decoding Mathematics

RSM requires that all physical variables ($X_i$) be converted into dimensionless **coded variables ($x_i$)**.

### The Coding Formula
$$x_i = \frac{X_i - X_{center}}{\Delta X / 2}$$

Where:
- $X_{center} = \frac{X_{high} + X_{low}}{2}$ (the midpoint, which corresponds to coded level $0$).
- $\Delta X = X_{high} - X_{low}$ (the step range between high and low levels).
- $\Delta X / 2$ is the half-step (distance corresponding to $+1$ coded unit).

### The Decoding Formula (Reverse Conversion)
$$X_i = X_{center} + x_i \times \left(\frac{\Delta X}{2}\right)$$

### Concrete Calculation Example:
Suppose Incubation Temperature ($X_1$) is tested between $30^\circ\text{C}$ and $40^\circ\text{C}$:
- Midpoint: $X_{center} = \frac{40 + 30}{2} = \mathbf{35^\circ\text{C}}$
- Half-step: $\frac{\Delta X}{2} = \frac{40 - 30}{2} = \mathbf{5^\circ\text{C}}$
- Coding equation:
  $$x_1 = \frac{X_1 - 35}{5}$$
- If R Terminal calculates the optimal coded coordinate as $x_{1,0} = +0.40$:
  $$X_{1,optimal} = 35 + (0.40 \times 5) = \mathbf{37.0^\circ\text{C}}$$

---

## 3. CCD vs. BBD: Experimental Designs for Curvature

To estimate quadratic curvature terms ($\beta_{ii} x_i^2$), each factor must be tested at **a minimum of 3 distinct levels**.

```
========================================================================================
                      CCD vs BBD GEOMETRY COMPARISON (k = 3 Factors)
========================================================================================
      CENTRAL COMPOSITE DESIGN (CCD)                   BOX-BEHNKEN DESIGN (BBD)
         (Factorial + Star + Center)                     (Edge Midpoints + Center)

                 •-------•                                    •---•---•
                /|      /|                                   /|  /   /|
               •-------• |                                  •---•---• |
               | |  •  | |  <-- Star points extend          | | • | | |  <-- Points lie ONLY
               | •-----|-•      outside the cube            •---•---• |      on midpoints of edges
               |/      |/       at distance ±α              |/  |   |/       (NO extreme corners!)
               •-------•                                    •---•---•
========================================================================================
```

---

### A. Central Composite Design (CCD)
A CCD is composed of three parts:
1. **Factorial Points ($2^k$ runs):** All corner combinations of $(\pm 1, \pm 1, \dots, \pm 1)$.
2. **Center Points ($n_0$ runs):** Replicated points at $(0, 0, \dots, 0)$ to estimate experimental pure error.
3. **Axial / Star Points ($2k$ runs):** Points lying on the coordinate axes at distance $\pm \alpha$:
   $$(\pm \alpha, 0, 0), \quad (0, \pm \alpha, 0), \quad (0, 0, \pm \alpha)$$

$$\text{Total Runs: } N = 2^k + 2k + n_0$$

#### Choice of Axial Distance $\alpha$:
- **Rotatable CCD:** $\alpha = (2^k)^{1/4}$.
  - For $k = 2$: $\alpha = 1.414$
  - For $k = 3$: $\alpha = 1.682$
  - *Meaning:* The prediction variance is equal at all points that are equidistant from the design center.
- **Face-Centered CCD (CCF):** $\alpha = 1.0$.
  - Axial points sit on the faces of the cube. Useful when physical constraints prevent testing beyond $[-1, +1]$ (e.g., pH cannot exceed 14).

---

### B. Box-Behnken Design (BBD)
A BBD places experimental points at the **midpoints of the edges** of the factor space, plus center points.

$$\text{Total Runs: } N = 2k(k - 1) + n_0$$
- For $k = 3$ factors with $n_0 = 3$ center points:
  $$N = 2(3)(2) + 3 = \mathbf{15\ runs}$$

---

### C. Direct Comparison: Why Wet Labs Prefer BBD

| Feature | Central Composite Design (CCD) | Box-Behnken Design (BBD) |
| :--- | :--- | :--- |
| **Levels per Factor** | **5 levels** ($-\alpha, -1, 0, +1, +\alpha$) | **3 levels only** ($-1, 0, +1$) |
| **Extreme Corner Runs** | **Yes** (tests $(\pm 1, \pm 1, \pm 1)$) | **NO extreme corners!** |
| **Run Count ($k=3$)** | 20 runs ($8 + 6 + 6$) | **15 runs** ($12 + 3$) |
| **Wet-Lab Feasibility** | Preparing 5 different reagent concentrations is labor-intensive. | Preparing only 3 concentrations is straightforward. |
| **Cell/Protein Safety** | High risk of cell death or protein aggregation at extreme corners. | Safe: avoids simultaneous extreme conditions. |

---

## 4. R Terminal Guide: Using `library(rsm)`

In your exam, you will generate and analyze RSM designs using R Terminal and the `rsm` package.

### Step-by-Step Code Template

```r
library(rsm)

# 1. Generate Box-Behnken Design (k = 3, n0 = 3) with coding
expt_des <- bbd(
  k = 3,
  n0 = 3,
  block = FALSE,
  randomize = FALSE,
  coding = list(
    x1 ~ (Temp - 35) / 5,
    x2 ~ (Enzyme - 1.0) / 0.5,
    x3 ~ (Time - 30) / 15
  )
)

# 2. Enter the response vector (15 runs)
y_yield <- c(
  31.8, 37.1, 39.3, 39.4, 39.0,
  40.3, 35.3, 39.8, 35.2, 42.4,
  34.9, 38.7, 45.3, 45.0, 45.3
)

# 3. Add response to design object
expt_des$yield <- y_yield

# 4. Fit Full Second-Order Response Surface Model
# SO() expands automatically to: FO(x1,x2,x3) + TWI(x1,x2,x3) + PQ(x1,x2,x3)
fit <- rsm(yield ~ SO(x1, x2, x3), data = expt_des)

# 5. Display Comprehensive Summary
summary(fit)
```

---

## 5. Deconstructing the `summary(rsm)` Console Output

The `summary(fit)` command produces four distinct analytical sections. Here is how to interpret each:

### Section 1: Parameter Estimates & Individual $t$-Tests

```
             Estimate Std. Error  t value  Pr(>|t|)    
(Intercept) 45.200000   0.132916 340.0644 4.173e-12 ***
x1           1.400000   0.081394  17.2003 1.216e-05 ***
x2           2.600000   0.081394  31.9433 5.647e-07 ***
x3          -1.025000   0.081394 -12.5930 5.607e-05 ***
x1:x2       -1.300000   0.115109 -11.2937 9.513e-05 ***
x1:x3        0.800000   0.115109   6.9500 0.0009475 ***
x2:x3       -0.850000   0.115109  -7.3843 0.0007161 ***
x1^2        -3.750000   0.119809 -31.2999 6.250e-07 ***
x2^2        -4.550000   0.119809 -37.9772 2.385e-07 ***
x3^2        -2.850000   0.119809 -23.7879 2.445e-06 ***
```

- **`t value`:** Calculated as $t = \frac{\text{Estimate}}{\text{Std. Error}}$. Measures how many standard errors the effect is away from zero.
- **`Pr(>|t|)` (p-value):** If $p < 0.05$, the parameter is statistically significant.
- **Pure Quadratic signs ($x_1^2, x_2^2, x_3^2$):**
  - Negative values ($-3.75, -4.55, -2.85$) indicate **downward curvature** (the surface curves like a dome/hilltop).

---

### Section 2: ANOVA Table & The Lack-of-Fit Test

```
Analysis of Variance Table

Response: yield
                Df  Sum Sq Mean Sq  F value    Pr(>F)
FO(x1, x2, x3)   3  78.165  26.055 491.6038 1.350e-06 ***
TWI(x1, x2, x3)  3  12.210   4.070  76.7925  0.000133 ***
PQ(x1, x2, x3)   3 138.397  46.132 870.4235 3.251e-07 ***
Residuals        5   0.265   0.053                   
Lack of fit      3   0.205   0.068   2.2778  0.319604
Pure error       2   0.060   0.030                   
```

- **`FO` (First-Order):** Tests linear slopes as a group.
- **`TWI` (Two-Way Interactions):** Tests cross-product interaction terms.
- **`PQ` (Pure Quadratic):** Tests curvature terms as a group ($F = 870.4, p < 0.001 \implies$ strong curvature!).
- **Lack of Fit Test:**
  - $SS_{Residual} = SS_{Lack\ of\ fit} + SS_{Pure\ error} \implies 0.265 = 0.205 + 0.060$
  - $df_{Residual} = df_{Lack\ of\ fit} + df_{Pure\ error} \implies 5 = 3 + 2$
  - Test Statistic:
    $$F_{LOF} = \frac{MS_{Lack\ of\ fit}}{MS_{Pure\ error}} = \frac{0.0683}{0.0300} = \mathbf{2.28}, \quad p = \mathbf{0.3196}$$
  - **Decision:** Since $p = 0.3196 > 0.05$, we **fail to reject $H_0$**. There is no significant lack of fit. The quadratic model adequately describes the real surface!

---

### Section 3: Stationary Point Coordinates

```
Stationary point of response surface:
        x1         x2         x3 
 0.1145743  0.2886621 -0.2067901 

Stationary point in original units:
     Temp    Enzyme      Time 
35.572871  1.144331 26.898149 
```

The stationary point $\mathbf{x}_0$ is the location where the slope of the response surface is zero:
$$\mathbf{x}_0 = -\frac{1}{2} \mathbf{B}^{-1} \mathbf{b}$$

- **Check boundaries:** Coded coordinates $(0.115, 0.289, -0.207)$ lie well within $[-1, +1]$. The optimum is inside the tested laboratory region!
- **Natural conditions:** Temperature = $35.6^\circ\text{C}$, Enzyme = $1.14\text{ mg/mL}$, Time = $26.9\text{ min}$.

---

### Section 4: Canonical / Eigenanalysis (Surface Characterization)

```
Eigenanalysis:
eigen() decomposition
$values
[1] -2.491366 -3.728953 -4.929681

$vectors
         [,1]       [,2]        [,3]
x1  0.4298890  0.7792236 -0.45607679
x2 -0.3107448 -0.3465835 -0.88505229
x3  0.8477223 -0.5221978 -0.09314722
```

The **eigenvalues ($\lambda_1, \lambda_2, \lambda_3$)** characterize the shape of the second-order surface:

| Signs of Eigenvalues ($\lambda_i$) | Shape of Surface | Nature of Stationary Point | Action |
| :--- | :--- | :--- | :--- |
| **All Negative ($\lambda_i < 0$)** | **Dome / Hilltop** | **Local Maximum (Optimum)** | **Found the peak!** Set process to these conditions. |
| **All Positive ($\lambda_i > 0$)** | **Bowl / Basin** | **Local Minimum** | Minimum found (e.g. minimizing impurities). |
| **Mixed Signs ($+$ and $-$)** | **Saddle / Mountain Pass** | **Saddle Point** | No unique maximum. Move along rising ridge. |
| **One or more $\lambda_i \approx 0$** | **Elongated Ridge** | **Ridge System** | Multiple combinations produce equivalent yield. |

In our output:
$$\lambda_1 = -2.491, \quad \lambda_2 = -3.729, \quad \lambda_3 = -4.930$$
Because **all eigenvalues are negative**, the stationary point is an **UNAMBIGUOUS TRUE LOCAL MAXIMUM**.

