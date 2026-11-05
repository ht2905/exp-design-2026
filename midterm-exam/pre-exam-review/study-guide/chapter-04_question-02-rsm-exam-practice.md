# Chapter 04: 50-Point Mock Exam – Question 2 (RSM, CCD, & BBD)
*The Biologist's Model Solution: Maximizing Protein Yield in R Terminal Without Heavy Math*

---

## The Exam Question Prompt (50 Points)

### Scenario:
A biotechnology team is optimizing downstream enzymatic cell lysis to maximize the extraction of a recombinant therapeutic enzyme (**Protein Yield**, measured in **mg / g dry cell weight**).

Three quantitative factors were selected for optimization:
1. **Lysis Temperature ($X_1$, $^\circ\text{C}$):** Range $30^\circ\text{C}$ to $40^\circ\text{C}$ (Center = $35^\circ\text{C}$, Step = $5^\circ\text{C}$).
2. **Lysozyme Concentration ($X_2$, mg/mL):** Range $0.5\text{ mg/mL}$ to $1.5\text{ mg/mL}$ (Center = $1.0\text{ mg/mL}$, Step = $0.5\text{ mg/mL}$).
3. **Incubation Time ($X_3$, min):** Range $15\text{ min}$ to $45\text{ min}$ (Center = $30\text{ min}$, Step = $15\text{ min}$).

The team selected a **Box-Behnken Design (BBD)** with $k = 3$ factors and $n_0 = 3$ center point replicates ($N = 15$ runs total).

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
1. **(10 Points)** Write down the factor coding equations for $x_1, x_2, x_3$. Explain two practical reasons why a **Box-Behnken Design (BBD)** was selected over a Central Composite Design (CCD) for this wet-lab experiment.
2. **(10 Points)** Structure the experimental data into a **Tidy CSV file** in LibreOffice Calc ready for R import.
3. **(10 Points)** Provide the complete **R Terminal script** using `library(rsm)` to fit a full second-order response surface model (`SO`) directly from your imported CSV data.
4. **(10 Points)** Analyze the ANOVA output table from `rsm`:
   - Explain what the `FO`, `TWI`, and `PQ` partitions test in biological terms.
   - Perform the **Lack of Fit test** at $\alpha = 0.05$. State hypotheses ($H_0, H_1$), test statistic, p-value, and your conclusion about model adequacy.
5. **(10 Points)** Perform the **Canonical / Surface Characterization**:
   - State the stationary point in both coded and natural units. Is it inside or outside the experimental domain?
   - Examine the eigenvalues to determine whether the stationary point is a local maximum, minimum, or saddle point, and state the predicted maximum yield $\hat{y}_{max}$.

---

## Detailed Model Solution

### Part 1: Coding Formulas & BBD Selection (10 Points)

#### 1. Intuitive Bench Factor Coding:
Coding simply standardizes our laboratory settings: **Center = 0**, **Step Size = 1 coded unit**.

$$\text{Coded Value } (x_i) = \frac{\text{Natural Value} - \text{Center}}{\text{Step Size}}$$

- **Temperature ($x_1$):** Center = $35^\circ\text{C}$, Step = $5^\circ\text{C}$  
  $$x_1 = \frac{\text{Temp} - 35}{5}$$
- **Lysozyme ($x_2$):** Center = $1.0\text{ mg/mL}$, Step = $0.5\text{ mg/mL}$  
  $$x_2 = \frac{\text{Lysozyme} - 1.0}{0.5}$$
- **Incubation Time ($x_3$):** Center = $30\text{ min}$, Step = $15\text{ min}$  
  $$x_3 = \frac{\text{Time} - 30}{15}$$

#### 2. Why BBD was Selected over CCD (Wet-Lab Reasons):
1. **Protects Fragile Biologicals from Harsh Extremes:**  
   In a CCD, you are forced to run extreme corners like $(+1, +1, +1)$—maximum heat ($40^\circ\text{C}$), maximum enzyme ($1.5\text{ mg/mL}$), and maximum time ($45\text{ min}$) all simultaneously—plus axial extensions out to $1.68$. In downstream protein recovery, these harsh conditions **denature enzymes and aggregate proteins**. BBD completely skips extreme corners, protecting biological samples.
2. **Pipetting & Lab Prep Simplicity:**  
   BBD only requires **3 stock dilutions** per factor ($-1, 0, +1$). CCD requires **5 distinct dilutions** ($-\alpha, -1, 0, +1, +\alpha$), which is much more tedious and prone to pipetting mistakes. BBD also requires only **15 runs** compared to 20 for CCD ($k=3$).

---

### Part 2: Tidy Data Structure in LibreOffice Calc (10 Points)

In LibreOffice Calc, create 4 columns and export as `bbd.csv`:

| x1 | x2 | x3 | yield |
| :---: | :---: | :---: | :---: |
| -1 | -1 | 0 | 31.8 |
| +1 | -1 | 0 | 37.1 |
| -1 | +1 | 0 | 39.3 |
| +1 | +1 | 0 | 39.4 |
| -1 | 0 | -1 | 39.0 |
| +1 | 0 | -1 | 40.3 |
| -1 | 0 | +1 | 35.3 |
| +1 | 0 | +1 | 39.8 |
| 0 | -1 | -1 | 35.2 |
| 0 | +1 | -1 | 42.4 |
| 0 | -1 | +1 | 34.9 |
| 0 | +1 | +1 | 38.7 |
| 0 | 0 | 0 | 45.3 |
| 0 | 0 | 0 | 45.0 |
| 0 | 0 | 0 | 45.3 |

---

### Part 3: 4-Line R Terminal Script (10 Points)

Open R Terminal in the same folder and type:

```r
library(rsm)

# 1. Read your LibreOffice CSV file
dat <- read.csv("bbd.csv")

# 2. Fit Full Second-Order Response Surface Model
# SO() expands automatically to: linear slopes + curvature + interactions!
rsm_fit <- rsm(yield ~ SO(x1, x2, x3), data = dat)

# 3. Display ANOVA, Lack-of-Fit, and Optimal Coordinates
summary(rsm_fit)
```

---

### Part 4: ANOVA & Lack-of-Fit Analysis (10 Points)

#### R Terminal ANOVA Output:

| Component / Partition | Df | Sum Sq | Mean Sq | F value | Pr(>F) | Biological Significance |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **FO(x1, x2, x3)** | 3 | 78.165 | 26.055 | 491.60 | $1.35 \times 10^{-6}$ | **Significant Slopes (***)** |
| **TWI(x1, x2, x3)** | 3 | 12.210 | 4.070 | 76.79 | $1.33 \times 10^{-4}$ | **Significant Synergy / Interactions (***)** |
| **PQ(x1, x2, x3)** | 3 | 138.397 | 46.132 | 870.42 | $3.25 \times 10^{-7}$ | **Extreme Curvature / Bending (***)** |
| **Residuals** | 5 | 0.265 | 0.053 | — | — | Total unexplained variation |
| ↳ **Lack of fit** | 3 | 0.205 | 0.068 | 2.28 | **0.3196** | **Not Significant ($p > 0.05$, Good Fit!)** |
| ↳ **Pure error** | 2 | 0.060 | 0.030 | — | — | Random variation between 3 center tubes |

#### Biological Meaning of Each Partition:
1. **`FO` (First-Order Slopes, $p < 0.001$):** Demonstrates that changing temperature, enzyme concentration, and time produces strong directional shifts in yield.
2. **`TWI` (Two-Way Interactions, $p < 0.001$):** Demonstrates biochemical synergy—the impact of enzyme concentration depends on operating temperature.
3. **`PQ` (Pure Quadratic Curvature, $p < 0.001$):** Massive statistical significance ($F = 870.42$). The biological response bends sharply. A simple linear model would fail completely; curvature terms are essential to locate the peak!
4. **Lack of Fit Test:**
   - **Hypotheses:**
     - $H_0$: The response surface model accurately reflects the biological process.
     - $H_1$: The model exhibits significant lack of fit.
   - **Result:** $F_{LOF} = 2.28, \quad p = \mathbf{0.3196}$.
   - **Conclusion:** Because $p = 0.3196 > 0.05$, we **fail to reject $H_0$**. There is no significant lack of fit. Model errors are no bigger than normal pipetting noise, confirming the model fits our cell lysis process cleanly!
   - **Model Accuracy:** $R^2 = 0.9988$, meaning **$99.88\%$** of yield variation is explained by our 3 operating factors.

---

### Part 5: Finding the Optimal Peak & Predicted Yield (10 Points)

#### 1. Optimal Stationary Point ($\mathbf{x}_0$):
R automatically reports the coordinates where the surface slopes become flat:

| Factor | Coded Coordinate ($x_i$) | Bench Decoding Formula | Optimal Bench Setting |
| :--- | :---: | :--- | :---: |
| **Temperature ($x_1$)** | $+0.1146$ | $35^\circ\text{C} + (0.1146 \times 5^\circ\text{C})$ | **$35.57^\circ\text{C}$** |
| **Lysozyme ($x_2$)** | $+0.2887$ | $1.0\text{ mg/mL} + (0.2887 \times 0.5\text{ mg/mL})$ | **$1.14\text{ mg/mL}$** |
| **Incubation Time ($x_3$)** | $-0.2068$ | $30\text{ min} + (-0.2068 \times 15\text{ min})$ | **$26.90\text{ min}$** |

- **Experimental Domain Check:** In coded units, our tested range is between $-1.0$ and $+1.0$. Because all three coordinates ($+0.115, +0.289, -0.207$) fall comfortably within $[-1.0, +1.0]$, the optimal condition is safely **inside our tested experimental space**. No dangerous extrapolation is required!

#### 2. Surface Shape Verification (Eigenvalues):
In R's `Eigenanalysis`, inspect the **signs** of `$values`:

| Eigenvalue | Output Value | Sign | Physical Meaning |
| :---: | :---: | :---: | :--- |
| **$\lambda_1$** | $-2.49$ | **Negative ($-$)** | Surface curves downwards |
| **$\lambda_2$** | $-3.73$ | **Negative ($-$)** | Surface curves downwards |
| **$\lambda_3$** | $-4.93$ | **Negative ($-$)** | Surface curves downwards |

- **The Biologist's Rule:** **ALL THREE EIGENVALUES ARE NEGATIVE ($\lambda_i < 0$)**.
- **Definitive Conclusion:** In every direction away from this point, protein yield decreases. This confirms beyond doubt that the stationary point is a **TRUE LOCAL MAXIMUM (BIOLOGICAL OPTIMAL PEAK)**!

#### 3. Predicted Maximum Protein Yield:
Run in R:
```r
predict(rsm_fit, data.frame(x1 = 0.1145743, x2 = 0.2886621, x3 = -0.2067901))
```

$$\hat{y}_{max} = \mathbf{45.76\text{ mg / g dry cell weight}}$$

**Bioprocess Impact:** Running at these optimal conditions increases protein yield from $31.8\text{ mg/g}$ (unoptimized) to **$45.76\text{ mg/g}$**, representing a **$+43.9\%$ productivity improvement** for downstream extraction!
