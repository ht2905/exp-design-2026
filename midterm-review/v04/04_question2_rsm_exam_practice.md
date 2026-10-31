# Chapter 04: 50-Point Mock Exam – Question 2 (RSM, CCD, & BBD)
*Complete Practice Problem with CSV-Based R Terminal Commands, Output Interpretation, and Eigenanalysis*

---

## The Exam Question Prompt (50 Points)

### Scenario:
A biotechnology team is optimizing downstream enzymatic cell lysis to maximize the extraction of a recombinant therapeutic enzyme (**Protein Yield**, measured in **mg / g dry cell weight**).

Three quantitative factors were selected for optimization:
1. **Lysis Temperature ($X_1$, $^\circ\text{C}$):** Range $30^\circ\text{C}$ to $40^\circ\text{C}$ (Center = $35^\circ\text{C}$, Step = $5^\circ\text{C}$).
2. **Lysozyme Concentration ($X_2$, mg/mL):** Range $0.5\text{ mg/mL}$ to $1.5\text{ mg/mL}$ (Center = $1.0\text{ mg/mL}$, Step = $0.5\text{ mg/mL}$).
3. **Incubation Time ($X_3$, min):** Range $15\text{ min}$ to $45\text{ min}$ (Center = $30\text{ min}$, Step = $15\text{ min}$).

The biological team selected a **Box-Behnken Design (BBD)** with $k = 3$ factors and $n_0 = 3$ center point replicates ($N = 15$ runs total).

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

### Sub-Questions (50 Points Total):
1. **(10 Points)** Write down the mathematical factor coding equations for $x_1, x_2, x_3$. Explain two practical reasons why a **Box-Behnken Design (BBD)** was selected over a Central Composite Design (CCD) for this wet-lab experiment.
2. **(10 Points)** Structure the experimental data into a **Tidy CSV file** in LibreOffice Calc and explain how to import and code the data in R.
3. **(10 Points)** Provide the complete **R Terminal script** using `library(rsm)` to fit a full second-order response surface model (`SO`) directly from your imported CSV data.
4. **(10 Points)** Analyze the ANOVA output table from `rsm`:
   - Explain what the `FO`, `TWI`, and `PQ` partitions test.
   - Perform the **Lack of Fit test** at $\alpha = 0.05$. State hypotheses ($H_0, H_1$), test statistic, p-value, and your conclusion about model adequacy.
5. **(10 Points)** Perform the **Canonical / Eigenanalysis**:
   - State the stationary point in both coded and natural units. Is it inside or outside the experimental domain?
   - Examine the eigenvalues of matrix $\mathbf{B}$ to determine whether the stationary point is a local maximum, minimum, or saddle point, and state the predicted maximum yield $\hat{y}_{max}$.

---

## Detailed Model Solution

### Part 1: Coding Formulas & BBD Selection (10 Points)

#### 1. Coding Equations:
Using $x_i = \frac{X_i - X_{center}}{\Delta X / 2}$:
- **Temperature ($X_1$):** Midpoint = $35^\circ\text{C}$, Half-step = $\frac{40 - 30}{2} = 5^\circ\text{C}$
  $$x_1 = \frac{\text{Temperature} - 35}{5}$$
- **Lysozyme ($X_2$):** Midpoint = $1.0\text{ mg/mL}$, Half-step = $\frac{1.5 - 0.5}{2} = 0.5\text{ mg/mL}$
  $$x_2 = \frac{\text{Lysozyme} - 1.0}{0.5}$$
- **Time ($X_3$):** Midpoint = $30\text{ min}$, Half-step = $\frac{45 - 15}{2} = 15\text{ min}$
  $$x_3 = \frac{\text{Time} - 30}{15}$$

#### 2. Why BBD was Selected over CCD:
1. **Avoids Extreme Combinations:** In CCD, runs occur at extreme corners $(\pm 1, \pm 1, \pm 1)$ and axial points $(\pm 1.682)$. In cell lysis, running simultaneously at the highest temperature, highest lysozyme, and longest time would denature the target protein. BBD completely avoids extreme corners!
2. **Fewer Factor Levels & Operational Simplicity:** BBD requires **only 3 levels** per factor ($-1, 0, +1$), whereas rotatable CCD requires **5 levels** ($-\alpha, -1, 0, +1, +\alpha$). Preparing 3 stock concentrations in the lab is much simpler and less error-prone. BBD also requires only **15 runs** compared to 20 for CCD ($k=3$).

---

### Part 2: Tidy Data CSV Structure in LibreOffice Calc (10 Points)

In LibreOffice Calc, create your table and save it as `q2_bbd.csv`:

```csv
x1,x2,x3,yield
-1,-1,0,31.8
1,-1,0,37.1
-1,1,0,39.3
1,1,0,39.4
-1,0,-1,39.0
1,0,-1,40.3
-1,0,1,35.3
1,0,1,39.8
0,-1,-1,35.2
0,1,-1,42.4
0,-1,1,34.9
0,1,1,38.7
0,0,0,45.3
0,0,0,45.0
0,0,0,45.3
```

*(Alternatively, you can enter natural columns `Temp`, `Enzyme`, `Time`, and calculate `x1`, `x2`, `x3` in LibreOffice using the formulas `=(A2-35)/5`, `=(B2-1)/0.5`, `=(C2-30)/15`).*

---

### Part 3: R Terminal Script from CSV (10 Points)

Write these commands into R Terminal:

```r
# ==============================================================
# R TERMINAL: RSM FROM CSV FILE
# ==============================================================
library(rsm)

# 1. Read the CSV file into R
dat <- read.csv("q2_bbd.csv")

# 2. Fit Full Second-Order Response Surface Model
# SO() expands automatically to: FO(x1,x2,x3) + TWI(x1,x2,x3) + PQ(x1,x2,x3)
rsm_fit <- rsm(yield ~ SO(x1, x2, x3), data = dat)

# 3. Display Comprehensive Summary
summary(rsm_fit)
```

---

### Part 4: ANOVA & Lack-of-Fit Analysis (10 Points)

#### R Terminal ANOVA Output:

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

#### Detailed Breakdown:
1. **`FO` (First-Order Terms, $p = 1.35 \times 10^{-6}$):** Highly significant. Demonstrates significant linear slopes across factors.
2. **`TWI` (Two-Way Interactions, $p = 0.000133$):** Highly significant. Confirms that factor effects are interdependent.
3. **`PQ` (Pure Quadratic, $p = 3.25 \times 10^{-7}$):** Extremely significant! Proves that significant **curvature** exists, justifying the second-order model.
4. **Lack of Fit Test:**
   - **Hypotheses:**
     - $H_0$: The second-order model adequately represents the true response surface.
     - $H_1$: The model exhibits significant lack of fit.
   - **Test Statistic:**
     $$F_{LOF} = \frac{MS_{Lack\ of\ fit}}{MS_{Pure\ error}} = \frac{0.0683}{0.0300} = \mathbf{2.28}$$
   - **P-Value:** $p = \mathbf{0.3196}$ with $df = (3, 2)$.
   - **Conclusion:** Because $p = 0.3196 > 0.05$, we **fail to reject $H_0$**. There is no significant lack of fit. The quadratic model is adequate and valid to describe the process.
   - **Model Fit:** $R^2 = 0.9988$ and $R^2_{adj} = 0.9968$, confirming that $99.88\%$ of response variation is captured by the model.

---

### Part 5: Canonical Analysis & Surface Characterization (10 Points)

#### R Terminal Console Output:

```
Stationary point of response surface:
        x1         x2         x3 
 0.1145743  0.2886621 -0.2067901 

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
   - Coded coordinates: $x_{1,0} = +0.115, \, x_{2,0} = +0.289, \, x_{3,0} = -0.207$.
   - Decoding to natural physical units ($X_i = X_{center} + x_i \times (\Delta X/2)$):
     - **Optimal Temperature:** $35 + (0.1146 \times 5) = \mathbf{35.57^\circ\text{C}}$
     - **Optimal Lysozyme:** $1.0 + (0.2887 \times 0.5) = \mathbf{1.144\text{ mg/mL}}$
     - **Optimal Incubation Time:** $30 + (-0.2068 \times 15) = \mathbf{26.90\text{ min}}$
   - **Domain Check:** In coded units, the distance from the center is $\sqrt{0.115^2 + 0.289^2 + (-0.207)^2} = 0.373 \ll 1.0$. The stationary point is located safely **inside the experimental design space**. No extrapolation is needed.

2. **Eigenanalysis (Surface Shape):**
   - The eigenvalues of matrix $\mathbf{B}$ are:
     $$\lambda_1 = -2.491, \quad \lambda_2 = -3.729, \quad \lambda_3 = -4.930$$
   - **Decision Rule:** **ALL THREE EIGENVALUES ARE NEGATIVE ($\lambda_i < 0$)**.
   - **Conclusion:** The surface is strictly concave downward in all directions. The stationary point is an **UNAMBIGUOUS TRUE LOCAL MAXIMUM (PEAK / OPTIMUM)**.

3. **Predicted Maximum Yield:**
   ```r
   predict(rsm_fit, data.frame(x1 = 0.1145743, x2 = 0.2886621, x3 = -0.2067901))
   # Returns: 45.7601
   ```
   $$\hat{y}_{max} = \mathbf{45.76\text{ mg / g dry cell weight}}$$
   Operating at these optimal conditions increases yield from $31.8\text{ mg/g}$ (unoptimized) to **$45.76\text{ mg/g}$**, a **$+43.9\%$ productivity improvement**.
