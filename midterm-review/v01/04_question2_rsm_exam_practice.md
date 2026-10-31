# Chapter 04: 50-Point Mock Exam – Question 2 (RSM, CCD, & BBD)
*Complete Realistic Exam Problem, Step-by-Step R Terminal Commands, Annotated Output, and Eigenanalysis*

---

## The Exam Question Prompt (50 Points)

### Background Scenario:
A biotechnology laboratory is optimizing the downstream enzymatic lysis of *Escherichia coli* cells to maximize the extraction yield of a recombinant therapeutic enzyme (**Protein Yield**, measured in **mg / g dry cell weight**).

Prior screening experiments identified three critical quantitative factors:
1. **Lysis Temperature ($X_1$, $^\circ\text{C}$):** Operating range $30^\circ\text{C}$ to $40^\circ\text{C}$ (Center = $35^\circ\text{C}$).
2. **Lysozyme Concentration ($X_2$, mg/mL):** Operating range $0.5\text{ mg/mL}$ to $1.5\text{ mg/mL}$ (Center = $1.0\text{ mg/mL}$).
3. **Incubation Time ($X_3$, min):** Operating range $15\text{ min}$ to $45\text{ min}$ (Center = $30\text{ min}$).

The biological team chose a **Box-Behnken Design (BBD)** with $k = 3$ factors and $n_0 = 3$ center point replicates ($N = 15$ runs total).

---

### The Raw Experimental Data

| Run Order | Std Order | Temperature ($X_1$, $^\circ\text{C}$) | Lysozyme ($X_2$, mg/mL) | Time ($X_3$, min) | Coded $x_1$ | Coded $x_2$ | Coded $x_3$ | Protein Yield ($y$, mg/g) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **1** | 1 | 30 | 0.5 | 30 | -1 | -1 | 0 | **31.8** |
| **2** | 2 | 40 | 0.5 | 30 | +1 | -1 | 0 | **37.1** |
| **3** | 3 | 30 | 1.5 | 30 | -1 | +1 | 0 | **39.3** |
| **4** | 4 | 40 | 1.5 | 30 | +1 | +1 | 0 | **39.4** |
| **5** | 5 | 30 | 1.0 | 15 | -1 | 0 | -1 | **39.0** |
| **6** | 6 | 40 | 1.0 | 15 | +1 | 0 | -1 | **40.3** |
| **7** | 7 | 30 | 1.0 | 45 | -1 | 0 | +1 | **35.3** |
| **8** | 8 | 40 | 1.0 | 45 | +1 | 0 | +1 | **39.8** |
| **9** | 9 | 35 | 0.5 | 15 | 0 | -1 | -1 | **35.2** |
| **10** | 10 | 35 | 1.5 | 15 | 0 | +1 | -1 | **42.4** |
| **11** | 11 | 35 | 0.5 | 45 | 0 | -1 | +1 | **34.9** |
| **12** | 12 | 35 | 1.5 | 45 | 0 | +1 | +1 | **38.7** |
| **13** | 13 | 35 | 1.0 | 30 | 0 | 0 | 0 | **45.3** |
| **14** | 14 | 35 | 1.0 | 30 | 0 | 0 | 0 | **45.0** |
| **15** | 15 | 35 | 1.0 | 30 | 0 | 0 | 0 | **45.3** |

---

### Questions to Answer:
1. **(10 Points)** Write down the mathematical factor coding transformations for $x_1, x_2, x_3$. Explain two crucial biological and statistical reasons why a **Box-Behnken Design (BBD)** was preferred over a Central Composite Design (CCD) for this wet-lab experiment.
2. **(10 Points)** Provide the complete **R Terminal script** using `library(rsm)` to generate this design, attach the yield response, and fit a full second-order response surface model (`SO`).
3. **(10 Points)** Analyze the ANOVA output table from `rsm`:
   - Explain the significance of the `FO`, `TWI`, and `PQ` partitions.
   - Perform the **Lack of Fit test** at $\alpha = 0.05$. State the null and alternative hypotheses, the test statistic, the p-value, and your conclusion about model adequacy.
4. **(10 Points)** Perform the **Canonical / Eigenanalysis**:
   - State the stationary point in both coded and natural physical units. Is it inside or outside the experimental domain?
   - Examine the eigenvalues of the second-order coefficient matrix $\mathbf{B}$. Characterize the nature of the stationary point (Local Maximum, Local Minimum, Saddle Point, or Ridge).
5. **(10 Points)** Calculate the predicted maximum protein yield $\hat{y}$ at the optimum operating conditions, and provide specific instructions for the wet-lab scientists.

---

## Comprehensive Model Solution

### Part 1: Coding Formulas & BBD Justification (10 Points)

#### 1. Factor Coding Transformations:
Using the general formula $x_i = \frac{X_i - X_{center}}{\Delta X / 2}$:
- **Temperature ($X_1$):** Center = $35^\circ\text{C}$, Half-step = $\frac{40 - 30}{2} = 5^\circ\text{C}$
  $$x_1 = \frac{\text{Temperature} - 35}{5}$$
- **Lysozyme Concentration ($X_2$):** Center = $1.0\text{ mg/mL}$, Half-step = $\frac{1.5 - 0.5}{2} = 0.5\text{ mg/mL}$
  $$x_2 = \frac{\text{Lysozyme} - 1.0}{0.5}$$
- **Incubation Time ($X_3$):** Center = $30\text{ min}$, Half-step = $\frac{45 - 15}{2} = 15\text{ min}$
  $$x_3 = \frac{\text{Time} - 30}{15}$$

#### 2. Why BBD was Preferred over CCD:
1. **Avoidance of Extreme Corner Combinations:** In a standard CCD, runs occur at extreme corners $(\pm 1, \pm 1, \pm 1)$ or extreme axial distances ($\pm 1.682$). In cell biology, running simultaneously at the highest temperature ($40^\circ\text{C}$), highest lysozyme ($1.5\text{ mg/mL}$), and longest time ($45\text{ min}$) or beyond would cause severe thermal and proteolytic denaturation of the target recombinant enzyme. BBD completely avoids extreme corners!
2. **Fewer Factor Levels & Operational Simplicity:** BBD requires **only 3 levels** per factor ($-1, 0, +1$). In contrast, a rotatable CCD requires **5 levels** ($-\alpha, -1, 0, +1, +\alpha$). Preparing 3 stock concentrations of lysozyme in the wet lab is vastly faster and less error-prone than formulating 5 distinct concentrations. Furthermore, BBD requires only **15 runs** compared to 20 runs for a CCD ($k=3$).

---

### Part 2: R Terminal Script (10 Points)

Type the following exact code into R Terminal:

```r
# ==============================================================
# R TERMINAL: BOX-BEHNKEN DESIGN & SECOND-ORDER MODEL FITTING
# ==============================================================
library(rsm)

# 1. Generate the Box-Behnken Design with coding formulas
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

# 2. Enter the observed response vector (15 values)
response_yield <- c(
  31.8, 37.1, 39.3, 39.4, 39.0,
  40.3, 35.3, 39.8, 35.2, 42.4,
  34.9, 38.7, 45.3, 45.0, 45.3
)

# 3. Add response column to design object
expt_des$yield <- response_yield

# 4. Fit Full Second-Order Response Surface Model
# SO() automatically expands to FO(x1,x2,x3) + TWI(x1,x2,x3) + PQ(x1,x2,x3)
rsm_fit <- rsm(yield ~ SO(x1, x2, x3), data = expt_des)

# 5. Display Comprehensive Summary Table
summary(rsm_fit)
```

---

### Part 3: ANOVA Table & Lack-of-Fit Analysis (10 Points)

#### R Terminal Output (ANOVA Section):

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

#### Detailed Deconstruction:
1. **First-Order Terms (`FO`, $p = 1.35 \times 10^{-6}$):** Highly significant. Indicates strong linear directional trends across the factors.
2. **Two-Way Interactions (`TWI`, $p = 0.000133$):** Highly significant. Demonstrates that the effect of lysozyme depends strongly on temperature and incubation time (the factors do not act independently).
3. **Pure Quadratic Terms (`PQ`, $p = 3.25 \times 10^{-7}$):** Extremely significant! This proves substantial **surface curvature**. A linear first-order model would fail completely; the quadratic terms are indispensable.
4. **Lack of Fit Test:**
   - **Hypotheses:**
     - $H_0: \text{The second-order model adequately represents the true response surface}.$
     - $H_1: \text{The model exhibits significant lack of fit}.$
   - **Test Statistic:**
     $$F_{LOF} = \frac{MS_{Lack\ of\ fit}}{MS_{Pure\ error}} = \frac{0.0683}{0.0300} = \mathbf{2.28}$$
   - **Degrees of Freedom:** $df_1 = 3, \, df_2 = 2$
   - **P-Value:** $p = \mathbf{0.3196}$
   - **Conclusion:** Because $p = 0.3196 > 0.05$, we **fail to reject $H_0$**. There is no statistically significant lack of fit. The quadratic model is fully adequate and accurately describes the experimental surface.
   - **Goodness-of-Fit:** $R^2 = 0.9988$ and $R^2_{adj} = 0.9968$, confirming that $99.88\%$ of the variation in protein yield is explained by this model.

---

### Part 4: Canonical Analysis & Surface Characterization (10 Points)

#### R Terminal Output (Stationary Point & Eigenanalysis Section):

```
Stationary point of response surface:
        x1         x2         x3 
 0.1145743  0.2886621 -0.2067901 

Stationary point in original units:
     Temp    Enzyme      Time 
35.572871  1.144331 26.898149 

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

#### Detailed Interpretation:
1. **Stationary Point Location:**
   - In coded units:
     $$x_{1,0} = +0.115, \quad x_{2,0} = +0.289, \quad x_{3,0} = -0.207$$
   - In natural physical units:
     - **Optimal Temperature:** $\mathbf{35.57^\circ\text{C}}$
     - **Optimal Lysozyme:** $\mathbf{1.144\text{ mg/mL}}$
     - **Optimal Incubation Time:** $\mathbf{26.90\text{ min}}$
   - **Domain Check:** In coded units, the radius from the center is $\sqrt{0.115^2 + 0.289^2 + (-0.207)^2} = 0.373 \ll 1.0$. The stationary point is located **safely inside the experimental design boundary**. Extrapolation is not required!

2. **Eigenanalysis (Surface Characterization):**
   - The eigenvalues of the second-order coefficient matrix $\mathbf{B}$ are:
     $$\lambda_1 = -2.491, \quad \lambda_2 = -3.729, \quad \lambda_3 = -4.930$$
   - **Sign Rule:** **ALL THREE EIGENVALUES ARE NEGATIVE ($\lambda_i < 0$)**.
   - **Definitive Conclusion:** The response surface is strictly concave downward in all directions. The stationary point is an **UNAMBIGUOUS TRUE LOCAL MAXIMUM (PEAK / OPTIMUM)**. There is no saddle point or valley.

---

### Part 5: Optimization & Wet-Lab Recommendations (10 Points)

#### 1. Calculating Predicted Maximum Yield:
The fitted second-order regression equation is:
$$\begin{aligned}
\hat{y} = & 45.20 + 1.40 x_1 + 2.60 x_2 - 1.025 x_3 \\
& - 3.75 x_1^2 - 4.55 x_2^2 - 2.85 x_3^2 \\
& - 1.30 x_1 x_2 + 0.80 x_1 x_3 - 0.85 x_2 x_3
\end{aligned}$$

Substituting the optimal coded coordinates $(x_1 = 0.1146, x_2 = 0.2887, x_3 = -0.2068)$:

```r
# In R Terminal:
predict(rsm_fit, data.frame(x1 = 0.1145743, x2 = 0.2886621, x3 = -0.2067901))
# Returns: 45.7601
```

The predicted maximum protein yield is:
$$\hat{y}_{max} = \mathbf{45.76\text{ mg / g dry cell weight}}$$

#### 2. Concrete Instructions for Wet-Lab Scientists:
1. **Standardize Process Operating Parameters:**
   - Set the lysis water bath / incubator to **$35.6^\circ\text{C}$**.
   - Prepare a lysozyme stock solution to achieve a final working concentration of **$1.14\text{ mg/mL}$**.
   - Incubate the suspension for exactly **$27.0\text{ minutes}$** under gentle agitation.
2. **Process Efficiency Gain:**
   - Under standard unoptimized conditions (e.g. low enzyme at $30^\circ\text{C}$, Run 1), yield was only $31.8\text{ mg/g}$.
   - Operating at the identified optimum increases protein yield to **$45.76\text{ mg/g}$**, representing a **$+43.9\%$ increase in productivity**.
   - Furthermore, the optimal incubation time ($27\text{ min}$) is shorter than the standard $30\text{ min}$ or $45\text{ min}$ runs, saving substantial processing time and reducing the risk of product degradation.

