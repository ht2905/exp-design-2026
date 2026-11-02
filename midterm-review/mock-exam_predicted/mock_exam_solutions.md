# Model Solutions: Predicted Midterm Examination
**Course:** Experimental Design (BI313IU)  
**Instructor:** Dr. Nguyễn Tấn Khôi – School of Biotechnology, International University (VNU-HCMC)  
**Total Points:** 100 Points

---

## QUESTION 1 (50 Points) – Split-Plot Design

### Part a: Hypotheses and Experimental Design Identification (10 Points)
#### 1. Experimental Design:
This experiment is a **Split-Plot Design arranged in a Randomized Complete Block Design (RCBD)**:
- **Blocking factor ($b = 3$):** Season of the year (Spring, Summer, Fall).
- **Whole-Plot factor ($a = 4$ levels):** Pasture management treatment.
- **Subplot factor ($c = 2$ levels):** Mineral supplement regimen.
- **Total sample size ($N$):** $b \times a \times c = 3 \times 4 \times 2 = 24$ observations.

#### 2. Statistical Hypotheses:
1. **Whole-Plot Factor (Pasture Management):**
   - $H_0: \alpha_1 = \alpha_2 = \alpha_3 = \alpha_4 = 0$ (Pasture management has no effect on mean milk yield).
   - $H_1: \text{At least one } \alpha_i \neq 0$ (At least one pasture treatment significantly alters mean milk yield).
2. **Subplot Factor (Mineral Supplement):**
   - $H_0: \beta_1 = \beta_2 = 0$ (Mineral supplementation has no effect on mean milk yield).
   - $H_1: \text{At least one } \beta_j \neq 0$ (Mineral supplementation significantly alters mean milk yield).
3. **Interaction Effect ($\text{Pasture} \times \text{Mineral}$):**
   - $H_0: (\alpha\beta)_{ij} = 0 \quad \forall i, j$ (The effect of mineral supplementation is identical across all four pasture types).
   - $H_1: \text{At least one } (\alpha\beta)_{ij} \neq 0$ (The effect of mineral supplementation depends on the pasture type).

---

### Part b: Factor Types and Experimental Units (10 Points)
1. **Factor Classification:**
   - **Hard-to-Change (HTC) Factor:** **Pasture Management (Factor A, 4 levels)**. Setting up large grazing paddocks, seeding forage, and moving grazing herds requires significant land area, labor, and time. It cannot be re-randomized on an individual cow level.
   - **Easy-to-Change (ETC) Factor:** **Mineral Supplement (Factor B, 2 levels)**. Mineral supplements can be delivered easily at the feeding trough or via individual dosing to individual animals.
2. **Experimental Units Identification:**
   - **Whole-Plot Experimental Unit:** The **individual Pasture Paddock** (or the group of cows sharing the pasture plot within a season).
   - **Subplot Experimental Unit:** The **individual Cow** receiving a specific mineral supplement within that pasture paddock.

---

### Part c: Design Justification & Economic Rationale (10 Points)
1. **Why not a Completely Randomized Factorial Design (CRD)?**
   - In a completely randomized factorial design, every combination of Pasture $\times$ Mineral would have to be randomly and independently assigned to completely isolated experimental units.
   - This would require constructing 24 completely independent, isolated pasture paddocks across the farm. Fencing, managing, and maintaining 24 distinct pasture plots is physically impossible and cost-prohibitive.
2. **Practical and Statistical Trade-Off:**
   - **Economic / Efficiency Advantage:** By grouping cows into 4 large pasture paddocks per season (12 whole-plot paddocks total instead of 24 isolated units), land, fencing, and herd maintenance costs are dramatically reduced.
   - **Statistical Precision Trade-Off:** The split-plot structure deliberately sacrifices precision on the Whole-Plot factor (Pasture, tested with only $df = 6$ error degrees of freedom) in order to achieve **higher statistical precision and greater power** on the Subplot factor (Mineral) and the $\text{Pasture} \times \text{Mineral}$ interaction (tested with $df = 8$ subplot error degrees of freedom).

---

### Part d: Split-Plot ANOVA Table, Calculations, and Biological Interpretation (20 Points)

#### 1. Degrees of Freedom Arithmetic:
- Total $df = N - 1 = 24 - 1 = 23$
- Block $df = b - 1 = 3 - 1 = 2$
- Whole-Plot ($\text{Pasture}$) $df = a - 1 = 4 - 1 = 3$
- **Whole-Plot Error ($\text{Block} \times \text{Pasture}$) $df = (b - 1)(a - 1) = 2 \times 3 = 6$**
- Subplot ($\text{Mineral}$) $df = c - 1 = 2 - 1 = 1$
- Interaction ($\text{Pasture} \times \text{Mineral}$) $df = (a - 1)(c - 1) = 3 \times 1 = 3$
- **Subplot Error (Residuals) $df = a(b - 1)(c - 1) = 4 \times 2 \times 1 = 8$**

#### 2. Complete Split-Plot ANOVA Table (Generated via R / Excel):

| Source of Variation | Degrees of Freedom ($df$) | Sum of Squares ($SS$) | Mean Square ($MS$) | $F$-Ratio | $p$-Value | Significance ($\alpha = 0.05$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Block (Season)** | 2 | 230.25 | 115.125 | — | — | Nuisance Block |
| **Pasture (Whole-Plot)** | 3 | 69.83 | 23.278 | **11.25** | **0.00709** | **Significant ($p < 0.01$)** |
| **WP Error ($\text{Block} \times \text{WP}$)** | 6 | 12.42 | 2.069 | — | — | Denominator for WP |
| **Mineral (Subplot)** | 1 | 13.50 | 13.500 | **6.48** | **0.03440** | **Significant ($p < 0.05$)** |
| **$\text{Pasture} \times \text{Mineral}$** | 3 | 13.83 | 4.611 | **2.21** | **0.16410** | Not Significant ($p > 0.05$) |
| **Subplot Error (Residuals)** | 8 | 16.67 | 2.083 | — | — | Denominator for SP & Interaction |
| **Total** | 23 | 356.50 | — | — | — | — |

> **Table 4 Extras (Professor's Diagnostic Check):**  
> - $\text{WP Error } F = \frac{MS_{\text{WP Error}}}{MS_{\text{SP Error}}} = \frac{2.069}{2.083} = 0.99$ ($p = 0.48861$).  
> - Because $F \approx 1.0$ and $p > 0.25$, there is no significant whole-plot unit-to-unit variability beyond residual measurement error.

#### 3. Crucial Statistical Rule: Choice of Error Term:
- **Testing Whole-Plot (Pasture):**
  $$F_{\text{WP}} = \frac{MS_{\text{Pasture}}}{MS_{\text{WP Error}}} = \frac{23.278}{2.069} = 11.25$$
  - Under $H_0$, $F_{\text{WP}} \sim F(3, 6)$, yielding $p = 0.00709$.
  - **Grading Trap Warning:** If tested incorrectly against Subplot Residuals ($MS = 2.083$ on $df = 8$), the degrees of freedom would be artificially inflated, leading to pseudo-replication.
- **Testing Subplot (Mineral) & Interaction:**
  $$F_{\text{Mineral}} = \frac{MS_{\text{Mineral}}}{MS_{\text{SP Error}}} = \frac{13.500}{2.083} = 6.48 \quad (p = 0.03440)$$
  $$F_{\text{Interaction}} = \frac{MS_{\text{Pasture:Mineral}}}{MS_{\text{SP Error}}} = \frac{4.611}{2.083} = 2.21 \quad (p = 0.16410)$$

#### 4. Biological Conclusions at $\alpha = 0.05$:
1. **Pasture Management ($p = 0.00709 < 0.01$):** Reject $H_0$. Pasture management has a statistically significant effect on milk yield. Inspecting marginal treatment means:
   - Pasture 4 yields the highest mean milk production ($34.00\text{ kg}$), followed by Pasture 2 ($31.33\text{ kg}$), Pasture 3 ($30.00\text{ kg}$), and Pasture 1 ($29.67\text{ kg}$).
2. **Mineral Supplementation ($p = 0.03440 < 0.05$):** Reject $H_0$. Mineral supplement significantly increases milk yield. Cows receiving Fortified Mineral 2 produced an average of $32.00\text{ kg/cow/day}$ versus $30.50\text{ kg/cow/day}$ for Standard Mineral 1 (a significant gain of $+1.50\text{ kg/cow/day}$).
3. **$\text{Pasture} \times \text{Mineral}$ Interaction ($p = 0.16410 > 0.05$):** Fail to reject $H_0$. The interaction is not statistically significant. Mineral Supplement 2 provides consistent benefits regardless of which pasture system is utilized.
4. **Final Recommendation:** The farm should implement **Pasture Management 4** combined with **Mineral Supplement 2** to maximize milk yield.

---

## QUESTION 2 (50 Points) – Response Surface Methodology (RSM)

### Part a: Design Process, Objectives, and Factor Coding (15 Points)

#### 1. Purpose of Response Surface Methodology (RSM):
RSM is an empirical modeling approach combining mathematical and statistical techniques. It is applied after preliminary screening designs to:
1. Model complex, non-linear curvature in the response surface.
2. Estimate linear, interaction, and pure quadratic effects simultaneously.
3. Determine the coordinates of the **Stationary Point** $(\mathbf{x}_0)$ that optimize (maximize or minimize) the biological response.

#### 2. Factor Coding Equations:
For each quantitative factor $X_i$, the dimensionless coded variable $x_i \in [-1, +1]$ is computed as:
$$x_i = \frac{X_i - \text{Center}_i}{\text{Half-Step}_i}$$

Specifically:
1. **Temperature ($X_1$, $^\circ\text{C}$):** $\text{Center} = 35$, $\text{Step} = 5$
   $$x_1 = \frac{X_1 - 35}{5}$$
2. **Lysozyme Concentration ($X_2$, mg/mL):** $\text{Center} = 1.0$, $\text{Step} = 0.5$
   $$x_2 = \frac{X_2 - 1.0}{0.5}$$
3. **Incubation Time ($X_3$, min):** $\text{Center} = 30$, $\text{Step} = 15$
   $$x_3 = \frac{X_3 - 30}{15}$$

#### 3. Why BBD was Preferred Over CCD:
1. **Avoidance of Extreme Combinations (Protects Biological Samples):** In a Central Composite Design (CCD), experiments must be run at extreme axial star points ($\pm \alpha = \pm 1.682$ or $\pm 1.732$) and extreme factorial corners $(\pm 1, \pm 1, \pm 1)$. In a wet-lab protein extraction, extreme temperature combined with prolonged incubation time will cause severe enzyme thermal denaturation and sample degradation. BBD samples only the midpoints of edges, avoiding simultaneous extremes.
2. **Fewer Operating Levels (3 Levels vs 5 Levels):** BBD requires only **3 distinct physical levels** ($-1, 0, +1$) per factor, whereas CCD requires **5 distinct physical levels** ($-\alpha, -1, 0, +1, +\alpha$). Setting up 3 controlled water baths and reagent concentrations is far simpler and less prone to pipetting error.
3. **Run Efficiency:** For $k = 3$, BBD requires only 15 runs ($12 \text{ factorial edges} + 3 \text{ center replicates}$), providing an orthogonal, rotatable/nearly-rotatable design with minimal reagent consumption.

---

### Part b: Parameter Optimization, ANOVA, Diagnostics, and Canonical Analysis (25 Points)

#### 1. Second-Order Polynomial Regression Equation:
Fitting the full quadratic response surface model:
$$\hat{y} = \beta_0 + \sum_{i=1}^3 \beta_i x_i + \sum_{i=1}^3 \beta_{ii} x_i^2 + \sum_{i<j} \beta_{ij} x_i x_j$$

From the R regression output:
$$\begin{aligned}
\hat{y} = 45.200 &+ 1.400 x_1 + 2.600 x_2 - 1.025 x_3 \\
&- 1.300 x_1 x_2 + 0.800 x_1 x_3 - 0.850 x_2 x_3 \\
&- 3.750 x_1^2 - 4.550 x_2^2 - 2.850 x_3^2
\end{aligned}$$

- **Model Quality:** $R^2 = 0.99884$ (99.88% of variance explained), Adjusted $R^2 = 0.99676$, Residual Standard Error $s = 0.2302\text{ mg/g}$ on $df = 5$.

#### 2. ANOVA Decomposition Table:

| Source of Variation | Degrees of Freedom ($df$) | Sum of Squares ($SS$) | Mean Square ($MS$) | $F$-Value | $p$-Value | Interpretation |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **First-Order (FO)** | 3 | 78.165 | 26.055 | 491.60 | $1.35 \times 10^{-6}$ | Highly Significant ($p < 0.001$) |
| **Two-Way Interaction (TWI)** | 3 | 12.210 | 4.070 | 76.79 | $1.33 \times 10^{-4}$ | Highly Significant ($p < 0.001$) |
| **Pure Quadratic (PQ)** | 3 | 138.397 | 46.132 | 870.42 | $3.25 \times 10^{-7}$ | Pronounced Curvature ($p < 0.001$) |
| **Residuals (Error)** | 5 | 0.265 | 0.053 | — | — | — |
| *Lack of Fit* | *3* | *0.205* | *0.068* | **2.28** | **0.31960** | **Not Significant ($p > 0.05$)** |
| *Pure Error (Replicates)* | *2* | *0.060* | *0.030* | — | — | Experimental Noise |
| **Total** | 14 | 229.037 | — | — | — | — |

#### 3. Lack-of-Fit Diagnostic (Model Adequacy):
- **Hypotheses:**
  - $H_0: \text{The second-order polynomial model adequately fits the response surface}$.
  - $H_1: \text{The model exhibits significant lack of fit (higher-order terms or unmodeled interactions exist)}$.
- **Test Statistic & $p$-Value:**
  $$F_{\text{LOF}} = \frac{MS_{\text{Lack of Fit}}}{MS_{\text{Pure Error}}} = \frac{0.0683}{0.0300} = 2.2778 \quad (df = 3, 2), \quad p = 0.31960$$
- **Decision:** Because $p = 0.31960 > 0.05$, we **fail to reject $H_0$**. The lack of fit is statistically insignificant. The fitted second-order model is **fully adequate** for optimization and prediction.

#### 4. Stationary Point ($\mathbf{x}_0$) Calculation:
In matrix notation, the model is $\hat{y} = \beta_0 + \mathbf{x}^T \mathbf{b} + \mathbf{x}^T \mathbf{B} \mathbf{x}$. The stationary point is found by setting the first derivatives to zero:
$$\mathbf{x}_0 = -\frac{1}{2} \mathbf{B}^{-1} \mathbf{b}$$

From the R canonical solution:
- **Coded Coordinates:**
  $$x_1^* = +0.11457, \quad x_2^* = +0.28866, \quad x_3^* = -0.20679$$
- **Domain Distance Check:**
  $$\|\mathbf{x}_0\| = \sqrt{(0.11457)^2 + (0.28866)^2 + (-0.20679)^2} = \sqrt{0.1392} = 0.3731$$
  Since $\|\mathbf{x}_0\| = 0.3731 \le 1.0$, the stationary point lies **well inside the experimental boundary** of the Box-Behnken design. No extrapolation is required!

- **Conversion to Natural Physical Units:**
  $$X_i^* = \text{Center}_i + x_i^* \times \text{Step}_i$$
  - **Lysis Temperature ($X_1^*$):** $35 + (0.11457 \times 5) = \mathbf{35.57^\circ\text{C}}$
  - **Lysozyme Concentration ($X_2^*$):** $1.0 + (0.28866 \times 0.5) = \mathbf{1.144\text{ mg/mL}}$
  - **Incubation Time ($X_3^*$):** $30 + (-0.20679 \times 15) = \mathbf{26.90\text{ min}}$

#### 5. Canonical Analysis (Surface Characterization):
Eigenanalysis of the symmetric curvature matrix $\mathbf{B}$:
$$\lambda_1 = -2.4914, \quad \lambda_2 = -3.7290, \quad \lambda_3 = -4.9297$$
- **Surface Topology:** Since **all three eigenvalues are strictly negative ($\lambda_i < 0$)**, the response surface displays downward curvature along all canonical axes.
- **Conclusion:** The stationary point is a **UNIQUE LOCAL MAXIMUM** (a true global peak within the experimental space).

#### 6. Predicted Optimum Protein Yield:
Substituting $\mathbf{x}_0$ into the fitted model:
$$\hat{y}_{\text{opt}} = \mathbf{45.76\text{ mg / g dry cell weight}}$$

---

### Part c: The Critical Final Step in Optimization (10 Points)
The essential final step in Response Surface Methodology is the **Confirmatory Wet-Lab Validation Experiment**:
1. **Execution:** Conduct $n \ge 3$ independent wet-lab extraction runs at the calculated optimum physical conditions:
   - Temperature = $35.6^\circ\text{C}$
   - Lysozyme Concentration = $1.14\text{ mg/mL}$
   - Incubation Time = $26.9\text{ min}$
2. **Statistical Verification:** Compute the sample mean $\bar{y}_{\text{confirm}}$ and verify that it falls within the **95% Confidence / Prediction Interval** of the model prediction ($\hat{y}_{\text{opt}} = 45.76 \pm t_{0.025, 5} \times SE_{\text{pred}}$).
3. **Production Transfer:** Once empirical confirmation confirms lack of bias, lock these optimized process parameters into the downstream Standard Operating Procedure (SOP).
