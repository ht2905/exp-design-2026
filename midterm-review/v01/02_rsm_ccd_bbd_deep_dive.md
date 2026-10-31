# Chapter 02: Response Surface Methodology (RSM), CCD & BBD
*From Geometric Foundations to Mathematical Modeling in R Terminal*

---

## 1. What is Response Surface Methodology (RSM)?

Response Surface Methodology (RSM) is a collection of mathematical and statistical techniques used to **explore**, **model**, and **optimize** a process where a response of interest ($y$) is influenced by several quantitative input variables ($x_1, x_2, \dots, x_k$).

### The 3 Stages of Response Surface Optimization

In biotechnology and chemical engineering, you rarely jump straight into final optimization:

```
========================================================================================
                      THE 3 PHASES OF EXPERIMENTAL OPTIMIZATION
========================================================================================
Stage 1: SCREENING (Fractional Factorial / Plackett-Burman)
  Goal: Identify the 2 to 4 vital factors out of 10+ initial candidates.
  Model: First-order screening model (Linear terms only: y = β0 + β1*x1 + β2*x2 + ...).
  
Stage 2: EXPLORATION (Method of Steepest Ascent)
  Goal: Rapidly move the experimental region toward the vicinity of the optimum.
  Action: Take successive steps proportional to the regression coefficients (β1, β2, ...).
  Stop: When response stops increasing (curvature is encountered).

Stage 3: OPTIMIZATION (Central Composite Design or Box-Behnken Design)
  Goal: Pinpoint the precise coordinates of the maximum/minimum and characterize curvature.
  Model: Full Second-Order Polynomial (Linear + Interaction + Quadratic terms).
========================================================================================
```

### Why First-Order Models Cannot Find an Optimum
A first-order model is an equation of a flat, tilted plane:
$$y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \dots + \beta_k x_k$$
A flat plane has **no peak**, **no valley**, and **no curvature**. It slopes indefinitely! It can only tell you which direction is uphill.

To model a peak (maximum) or a basin (minimum), your mathematical surface **must bend**. In calculus, bending requires second derivatives. In statistics, this means you must fit a **second-order (quadratic) model**:

$$y = \beta_0 + \sum_{i=1}^k \beta_i x_i + \sum_{i=1}^k \beta_{ii} x_i^2 + \sum \sum_{i < j} \beta_{ij} x_i x_j + \epsilon$$

Where:
- $\beta_0$: Intercept (predicted response at design center).
- $\beta_i$: Linear main effects (first-order slope).
- $\beta_{ii}$: **Pure quadratic effects** (measures curvature along axis $i$).
- $\beta_{ij}$: **Two-way interaction effects** (measures twist/rotation of the surface).

---

## 2. Why Factor Coding is Mandatory

Before running any RSM experiment, all physical variables ($X_i$) **must be transformed into dimensionless coded variables ($x_i$)**.

### The Coding Formula
$$x_i = \frac{X_i - X_{center}}{\Delta X / 2} = \frac{X_i - \text{Midpoint}}{\text{Half-Step}}$$

Where:
- $X_{center} = \frac{X_{high} + X_{low}}{2}$ is the center point (coded as $0$).
- $\Delta X = X_{high} - X_{low}$ is the range between high and low levels.
- $\Delta X / 2$ is the unit distance (distance corresponding to $+1$ coded unit).

### Example from your coursework (`example-01.R`):
Suppose Temperature varies from $35^\circ\text{C}$ (low, $-1$) to $45^\circ\text{C}$ (high, $+1$):
- Center: $X_{center} = \frac{45 + 35}{2} = 40^\circ\text{C}$.
- Half-step: $\Delta X / 2 = \frac{45 - 35}{2} = 5^\circ\text{C}$.
- Coding equation:
  $$x_1 = \frac{\text{Temperature} - 40}{5}$$

### Why Coding is Essential (4 Core Reasons):
1. **Dimensionless Uniformity:** Temperature ($^\circ\text{C}$), Stirring Speed ($\text{rpm}$), and Glucose ($\text{g/L}$) have wildly different units and numerical magnitudes. Coding forces them all onto a standardized scale around $[-1, +1]$.
2. **Direct Comparison of Effect Size:** In coded units, the magnitude of $\beta_i$ directly reflects factor importance. In un-coded units, a factor measured in grams will have a coefficient 1000 times smaller than the same factor measured in kilograms!
3. **Orthogonality & Numerics:** Coding makes the columns of design matrix $X$ orthogonal ($\sum x_i x_j = 0$), preventing multicollinearity and matrix inversion instability.
4. **Scale-Invariant Steepest Ascent:** The path of steepest ascent calculated in raw physical units is completely different from the path in coded units! The coded path gives every factor an equal, objective geometric share.

---

## 3. CCD vs BBD: Geometry, Comparison & Selection

To fit a second-order model, each factor must be tested at **a minimum of 3 distinct levels** (to estimate the curvature term $\beta_{ii} x_i^2$). The two premier designs are **Central Composite Design (CCD)** and **Box-Behnken Design (BBD)**.

```
========================================================================================
                      CCD vs BBD GEOMETRY COMPARISON (k = 3 Factors)
========================================================================================
      CENTRAL COMPOSITE DESIGN (CCD)                   BOX-BEHNKEN DESIGN (BBD)
              (Cube + Star + Center)                     (Edge Midpoints + Center)

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
Created by Box and Wilson (1951), a CCD consists of three distinct parts:
1. **Factorial / Cube Points ($2^k$ runs):** All combinations of $(\pm 1, \pm 1, \dots, \pm 1)$.
2. **Center Points ($n_0$ runs):** Multiple runs at $(0, 0, \dots, 0)$ to estimate pure experimental error and calculate the curvature test.
3. **Axial / Star Points ($2k$ runs):** Points lying on the coordinate axes at distance $\pm \alpha$:
   $$(\pm \alpha, 0, 0), \quad (0, \pm \alpha, 0), \quad (0, 0, \pm \alpha)$$

$$\text{Total Runs } N = 2^k + 2k + n_0$$

#### The Choice of Axial Distance $\alpha$:
- **Rotatable CCD:** $\alpha = (2^k)^{1/4}$.
  - For $k = 2$: $\alpha = (4)^{0.25} = 1.414$
  - For $k = 3$: $\alpha = (8)^{0.25} = 1.682$
  - For $k = 4$: $\alpha = (16)^{0.25} = 2.000$
  - *Statistical meaning of Rotatability:* The prediction variance $\text{Var}(\hat{y})$ depends solely on the distance from the center, not on the angular direction!
- **Face-Centered CCD (CCF):** $\alpha = 1.0$.
  - Star points are located directly on the center of each face of the cube.
  - Used when operating beyond $[-1, +1]$ is impossible (e.g., pH cannot go below 0 or above 14).
- **Spherical CCD:** $\alpha = \sqrt{k}$. All points lie on a sphere of radius $\sqrt{k}$.

---

### B. Box-Behnken Design (BBD)
Created by Box and Behnken (1960), a BBD is formed by combining $2^2$ factorials with balanced incomplete blocks:
- The design points are placed at the **midpoints of the edges** of the experimental hypercube, plus center points.
- **Total Runs formula ($k \ge 3$):**
  $$N = 2k(k - 1) + n_0$$
  - For $k = 3$ with $n_0 = 3$: $N = 2(3)(2) + 3 = \mathbf{15\ runs}$.
  - For $k = 4$ with $n_0 = 3$: $N = 2(4)(3) + 3 = \mathbf{27\ runs}$.

---

### C. Head-to-Head Comparison: Why Wet-Lab Scientists Prefer BBD

| Feature | Central Composite Design (CCD) | Box-Behnken Design (BBD) |
| :--- | :--- | :--- |
| **Number of Factor Levels** | **5 levels** ($-\alpha, -1, 0, +1, +\alpha$) | **Only 3 levels** ($-1, 0, +1$) |
| **Extreme Corner Combinations** | **Yes** (tests $(\pm 1, \pm 1, \pm 1)$) | **NO extreme corners!** |
| **Run Efficiency ($k=3$)** | 20 runs ($8 + 6 + 6$) | **15 runs** ($12 + 3$) |
| **Feasibility for Wet Labs** | Harder: preparing 5 different stock concentrations is tedious. | **Much easier:** preparing only 3 stock concentrations. |
| **Safety / Viability** | High risk of cell death or precipitation at simultaneous high levels $(+1, +1, +1)$. | **Safe:** never operates all factors at simultaneous extremes. |
| **Sequential Building** | **Excellent:** Can start with factorial runs, then add axial points later. | Must run all points together. |

> [!TIP]
> **Wet-Lab Bio-Justification (Great for Exam Answers):**  
> *"We choose a Box-Behnken Design because in biological systems, operating simultaneously at high temperature, high agitation, and low pH ($+1, +1, -1$) causes cell lysis and protein denaturation. BBD completely avoids extreme corners while requiring only 3 concentrations and fewer experimental runs."*

---

## 4. R Terminal Master Guide: Using `library(rsm)`

In your exam, you will use R Terminal with the `rsm` package (authored by Russell Lenth). Here is the complete workflow.

### Step 1: Generate the Design Matrix

```r
library(rsm)

# A. Generate a Box-Behnken Design (BBD) for 3 factors with 3 center points
expt_des <- bbd(
  k = 3,
  n0 = 3,
  block = FALSE,
  randomize = FALSE,
  coding = list(
    x1 ~ (Temperature - 35) / 5,
    x2 ~ (Detergent - 1.0) / 0.5,
    x3 ~ (Time - 20) / 10
  )
)

# B. (Alternative) Generate a Rotatable Central Composite Design (CCD)
# expt_ccd <- ccd(
#   k = 3,
#   n0 = c(4, 2), # 4 center points in cube, 2 in axial block
#   alpha = "rotatable",
#   randomize = FALSE,
#   coding = list(...)
# )
```

---

### Step 2: Attach Response Data & Fit Second-Order Model

```r
# Enter the response vector (15 runs for BBD k=3, n0=3)
response_yield <- c(
  12.4, 14.1, 15.6, 16.2, 12.8,
  13.5, 14.2, 11.0, 10.5, 11.8,
  23.1, 21.4, 24.0, 11.2,  9.8
)

# Attach response to design object
expt_des$yield <- response_yield

# Fit full Second-Order response surface model
# SO() specifies: First-order (FO) + Two-way interactions (TWI) + Pure quadratic (PQ)
rsm_model <- rsm(yield ~ SO(x1, x2, x3), data = expt_des)

# Print full statistical summary
summary(rsm_model)
```

---

## 5. Deconstructing the `summary(rsm)` Output (Line by Line)

When you type `summary(rsm_model)` in R Terminal, it outputs 4 distinct sections. You must know how to explain every single one to your professor:

### Section 1: Parameter Estimates & Significance

```
             Estimate Std. Error t value Pr(>|t|)  
(Intercept) 15.000000   1.850000  8.1081 0.00045 **
x1           0.125000   1.133893  0.1102 0.91653  
x2           0.500000   1.133893  0.4410 0.67758  
x3           2.875000   1.133893  2.5355 0.05221 .
x1:x2       -0.250000   1.603567 -0.1559 0.88219  
x1:x3       -1.000000   1.603567 -0.6236 0.56012  
x2:x3       -0.750000   1.603567 -0.4677 0.65968  
x1^2        -2.083333   1.669074 -1.2482 0.26712  
x2^2         1.666667   1.669074  0.9986 0.36387  
x3^2        -0.083333   1.669074 -0.0499 0.96207  
```

- **Intercept ($b_0$):** $15.00$ is the predicted yield at the center point $(0, 0, 0)$.
- **Linear terms ($b_1, b_2, b_3$):** First-order rate of change along each coordinate axis.
- **Interaction terms ($b_{12}, b_{13}, b_{23}$):** Twist/cross-product effects. Negative interaction means factors act antagonistically.
- **Pure Quadratic terms ($b_{11}, b_{22}, b_{33}$):** Curvature!
  - Negative coefficient (e.g., $b_{11} = -2.083$ for $x_1^2$) indicates **downward curvature (convex / mountain peak)**.
  - Positive coefficient (e.g., $b_{22} = +1.667$ for $x_2^2$) indicates **upward curvature (concave / valley trough)**.

---

### Section 2: ANOVA Decomposition & Lack-of-Fit Test

```
Analysis of Variance Table

Response: yield
                Df  Sum Sq Mean Sq F value Pr(>F)
FO(x1, x2, x3)   3  68.250  22.750  1.1017 0.4300
TWI(x1, x2, x3)  3   6.500   2.167  0.1049 0.9537
PQ(x1, x2, x3)   3  28.433   9.478  0.4589 0.7231
Residuals        5 103.250  20.650               
Lack of fit      3  36.875  12.292  0.3706 0.7864
Pure error       2  66.375  33.188               
```

- `FO`: Tests whether first-order (linear) effects as a group are significant.
- `TWI`: Tests whether two-way interactions are significant.
- `PQ`: Tests whether quadratic (curvature) terms are significant.

#### The Crucial Lack-of-Fit Test:
Notice how `Residuals` ($DF = 5$) is split into two components:
$$\text{Residual SS} = \text{Lack of Fit SS} + \text{Pure Error SS}$$
$$\text{Residual DF} = \text{Lack of Fit DF} + \text{Pure Error DF} \implies 5 = 3 + 2$$

- **Pure Error ($DF = 2$):** Calculated exclusively from the 3 center point replicates ($n_0 - 1 = 3 - 1 = 2$). This is pure, un-modeled biological experimental variability.
- **Lack of Fit ($DF = 3$):** Measures the discrepancy between the fitted second-order model and the true underlying surface.
- **Hypotheses:**
  - $H_0: \text{The model adequately fits the response surface (No Lack of Fit)}.$
  - $H_1: \text{The model does NOT adequately fit the surface (Significant Lack of Fit)}.$
- **Decision Rule:**
  $$F_{LOF} = \frac{MS_{Lack\ of\ fit}}{MS_{Pure\ error}} = \frac{12.292}{33.188} = 0.3706, \quad p = 0.7864$$
  Since $p = 0.7864 > 0.05$, we **fail to reject $H_0$**.
  > [!IMPORTANT]
  > **High p-value on Lack of Fit is GOOD!** It proves your second-order model is statistically sound and adequately describes the data.

---

### Section 3: Stationary Point Coordinates

```
Stationary point of response surface:
        x1         x2         x3 
-10.760241   8.671084  42.791566 

Stationary point in original units:
    Temperature    Detergent         Time 
       -13.8012     360.1325     671.8735 
```

#### What is the Stationary Point?
The stationary point $\mathbf{x}_0$ is the location where all partial derivatives of the response surface are simultaneously zero (the slope is completely flat):
$$\frac{\partial \hat{y}}{\partial x_1} = \frac{\partial \hat{y}}{\partial x_2} = \dots = \frac{\partial \hat{y}}{\partial x_k} = 0$$

In matrix notation:
$$\hat{y} = b_0 + \mathbf{x}^T \mathbf{b} + \mathbf{x}^T \mathbf{B} \mathbf{x}$$
$$\mathbf{x}_0 = -\frac{1}{2} \mathbf{B}^{-1} \mathbf{b}$$

Where $\mathbf{B}$ is the $k \times k$ symmetric matrix of second-order coefficients:
$$\mathbf{B} = \begin{bmatrix} b_{11} & \frac{1}{2}b_{12} & \frac{1}{2}b_{13} \\ \frac{1}{2}b_{12} & b_{22} & \frac{1}{2}b_{23} \\ \frac{1}{2}b_{13} & \frac{1}{2}b_{23} & b_{33} \end{bmatrix}, \quad \mathbf{b} = \begin{bmatrix} b_1 \\ b_2 \\ b_3 \end{bmatrix}$$

> [!WARNING]
> **Check whether the stationary point is INSIDE or OUTSIDE the experimental region!**  
> In coded units, your experimental region is $[-1, +1]$ (or $[-\alpha, +\alpha]$).  
> If the stationary point is $(-10.76, 8.67, 42.79)$, it is **far outside the experimental region**!  
> In physical units, a negative temperature ($-13.8^\circ\text{C}$) or $360\%$ detergent is biologically impossible.  
> **Exam Conclusion:** *"The stationary point lies far outside the experimental domain; therefore, the model cannot be extrapolated to this point, and we must perform ridge analysis or steepest ascent to guide further experimentation."*

---

### Section 4: Canonical / Eigenanalysis (Determining the Surface Shape)

```
Eigenanalysis:
eigen() decomposition
$values
[1]  1.74376853 -0.03112244 -2.21264609

$vectors
           [,1]       [,2]       [,3]
x1  0.005942178  0.2433358 0.96992390
x2 -0.979882267 -0.1920780 0.05419198
x3  0.199487926 -0.9507333 0.23729907
```

Canonical analysis rotates the coordinate axes to align with the principal axes of curvature ($w_1, w_2, \dots, w_k$). The **eigenvalues ($\lambda_1, \lambda_2, \dots, \lambda_k$)** of matrix $\mathbf{B}$ dictate the exact shape of your response surface:

| Signs of Eigenvalues ($\lambda_i$) | Nature of Stationary Point | Geometric Shape | Wet-Lab Interpretation |
| :--- | :--- | :--- | :--- |
| **All Negative** ($\lambda_i < 0$) | **Local Maximum** | **Peak (Hilltop)** | True optimum found! Operating at $\mathbf{x}_0$ gives highest yield. |
| **All Positive** ($\lambda_i > 0$) | **Local Minimum** | **Basin (Bowl)** | True minimum found! Useful for minimizing impurities/cost. |
| **Mixed Signs** ($+$ and $-$) | **Saddle Point** | **Mountain Pass (Col)** | In some directions the yield increases, in others it decreases. No unique maximum! |
| **One or more $\lambda_i \approx 0$** | **Ridge System** | **Stationary / Rising Ridge** | A wide plateau or ridge exists where many combinations give equivalent yield. |

In our output above:
$$\lambda_1 = +1.74, \quad \lambda_2 = -0.03, \quad \lambda_3 = -2.21$$
Because the eigenvalues have **mixed signs** (one positive, two negative), the stationary point is a **SADDLE POINT**.

---

## 6. Visualizing Response Surfaces in R

To visualize the fitted surface, `rsm` provides clean plotting functions:

```r
# Contour plots: slices through the 3D surface
# Slices are taken through the center (or stationary point)
contour(rsm_model, ~ x1 + x2 + x3, image = TRUE)

# 3D Perspective Wireframe Plot of x1 vs x2
persp(rsm_model, x2 ~ x1, zlab = "Yield", col = "lightcyan", contours = "bottom")
```

---

## 7. What to do if the Optimum is NOT Found? (Steepest Ascent)

If your stationary point is a saddle point or lies far outside the region, you use the **Method of Steepest Ascent** to find the next experimental zone:

```r
# Calculate path of steepest ascent
steepest(rsm_model, dist = seq(0, 3, by = 0.5))
```

R will output step-by-step physical values moving along the gradient vector:
- Follow these steps until the measured response begins to drop.
- Once the response drops, center a new BBD or CCD around that peak and re-optimize!
