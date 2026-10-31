# Chapter 03: 50-Point Mock Exam – Question 1 (Split-Plot)
*Complete Realistic Exam Problem, Manual Calculations, Excel Walkthrough, and R Terminal Script*

---

## The Exam Question Prompt (50 Points)

### Background Scenario:
A biotechnology team at a biopharmaceutical company is optimizing the upstream production of a therapeutic monoclonal antibody (mAb) using Chinese Hamster Ovary (CHO) cell culture in batch bioreactors.

The experiment evaluates two key factors on **Antibody Titer (g/L)**:
1. **Operating Temperature (Factor A):** A Hard-to-Change (HTC) factor evaluated at 2 levels:
   - Level 1: Mild Hypothermia ($32^\circ\text{C}$)
   - Level 2: Standard Physiological Temperature ($37^\circ\text{C}$)
2. **Feed Supplement Formulation (Factor B):** An Easy-to-Change (ETC) factor evaluated at 4 levels:
   - Feed 1: Basal Control Feed
   - Feed 2: Amino Acid Enriched
   - Feed 3: Lipid-Supplemented
   - Feed 4: Trace Metal Fortified

### Experimental Execution:
Due to equipment limitations and the multi-day stabilization time of 50-Liter bioreactors, it was impossible to run 24 independent bioreactor runs in completely randomized order.  
Instead:
- The engineers ran **6 bioreactor batches** in total (3 batches set at $32^\circ\text{C}$ and 3 batches set at $37^\circ\text{C}$).
- From each bioreactor batch, culture broth was sampled into **4 separate mini-bioreactor vessels**, and each vessel randomly received one of the 4 feed formulations.
- The resulting antibody titer ($\text{g/L}$) was measured after 14 days of culture ($N = 2 \times 3 \times 4 = 24$ total observations).

---

### The Raw Experimental Data

| Whole Plot (Bioreactor) | Temperature ($^\circ\text{C}$) | Feed 1 (Basal) | Feed 2 (Amino) | Feed 3 (Lipid) | Feed 4 (Trace) | Bioreactor Mean ($\bar{y}_{i\cdot k}$) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Bioreactor 1** | $32^\circ\text{C}$ (1) | 5.00 | 6.62 | 9.45 | 6.02 | **6.7725** |
| **Bioreactor 2** | $32^\circ\text{C}$ (1) | 3.95 | 6.00 | 6.86 | 4.26 | **5.2675** |
| **Bioreactor 3** | $32^\circ\text{C}$ (1) | 4.76 | 6.34 | 9.13 | 5.93 | **6.5400** |
| **Bioreactor 4** | $37^\circ\text{C}$ (2) | 4.84 | 6.24 | 7.31 | 6.13 | **6.1300** |
| **Bioreactor 5** | $37^\circ\text{C}$ (2) | 3.07 | 3.71 | 6.85 | 3.53 | **4.2900** |
| **Bioreactor 6** | $37^\circ\text{C}$ (2) | 2.53 | 4.32 | 5.34 | 3.44 | **3.9075** |
| **Feed Mean ($\bar{y}_{\cdot j \cdot}$)** | — | **4.025** | **5.538** | **7.490** | **4.885** | **Grand Mean = 5.485** |

---

### Questions to Answer:
1. **(10 Points)** Identify the experimental design. Explicitly define the **Whole-Plot Unit**, the **Subplot Unit**, and explain why analyzing this experiment as a standard Completely Randomized Design (CRD) would lead to a severe statistical error.
2. **(15 Points)** Construct the complete Split-Plot ANOVA Table. Show all degrees of freedom, Sums of Squares, Mean Squares, F-ratios, and state which error term tests each factor.
3. **(10 Points)** Detail the exact step-by-step procedure to compute this ANOVA table in **Microsoft Excel** using the Data Analysis ToolPak and cell formulas.
4. **(10 Points)** Provide the exact, minimal **Base R Terminal script** required to import, structure, and analyze this data using `aov()` with `Error()`, and display the expected R output.
5. **(5 Points)** State your statistical conclusions at $\alpha = 0.05$ and give actionable recommendations to the bioprocess engineering team.

---

## Comprehensive Model Solution

### Part 1: Design Identification & Experimental Units (10 Points)

1. **Design Name:** A **$2 \times 4$ Full Factorial Treatment Structure within a Split-Plot Design Structure**.
2. **Experimental Units:**
   - **Whole-Plot Experimental Unit:** The **individual 50-L Bioreactor batch** (6 units total). It receives the Hard-to-Change factor: Temperature.
   - **Subplot Experimental Unit:** The **mini-bioreactor culture vessel** sampled from each batch (24 units total). It receives the Easy-to-Change factor: Feed formulation.
3. **Why Standard CRD ANOVA Fails (The Statistical Danger):**
   - A standard Two-Way ANOVA assumes all 24 observations were independently assigned to 24 separate temperature runs.
   - In reality, Temperature was only replicated **3 times per level** (6 bioreactors total), giving only **4 degrees of freedom** for whole-plot error ($2 \times (3 - 1) = 4$).
   - Standard CRD pools the large bioreactor-to-bioreactor variance ($\sigma^2_{WP}$) with the small vessel-to-vessel variance ($\sigma^2_{SP}$) into a pooled error with 16 DF ($MS_{Error} = 1.247$).
   - If Temperature ($MS = 12.056$) is tested against this pooled error, it produces:
     $$F_{CRD} = \frac{12.056}{1.247} = 9.67, \quad p = 0.0067 \quad (\text{Falsely Significant!})$$
   - In the correct Split-Plot analysis, Temperature is tested against the true Whole-Plot Error ($MS = 4.137$), yielding:
     $$F_{Split-Plot} = \frac{12.056}{4.137} = 2.91, \quad p = 0.163 \quad (\text{NOT Significant!})$$
   - Analyzing this as a CRD commits a **Type I Error (False Positive)**, falsely claiming temperature has a significant effect when the observed difference is simply bioreactor-to-bioreactor run noise.

---

### Part 2: Complete Split-Plot ANOVA Table (15 Points)

#### 1. Degrees of Freedom Arithmetic:
- Number of Temperature levels: $a = 2$
- Number of Feed levels: $b = 4$
- Number of Bioreactor replicates per temperature: $r = 3$
- Total observations: $N = a \times b \times r = 2 \times 4 \times 3 = 24$

$$\text{DF}_{Temp} = a - 1 = 2 - 1 = \mathbf{1}$$
$$\text{DF}_{WP\ Error} = a(r - 1) = 2(3 - 1) = \mathbf{4}$$
$$\text{DF}_{Feed} = b - 1 = 4 - 1 = \mathbf{3}$$
$$\text{DF}_{Temp \times Feed} = (a - 1)(b - 1) = (1)(3) = \mathbf{3}$$
$$\text{DF}_{SP\ Error} = a(r - 1)(b - 1) = 2(2)(3) = \mathbf{12}$$
$$\text{DF}_{Total} = N - 1 = 24 - 1 = \mathbf{23}$$

#### 2. Sums of Squares Calculations:
- **Total SS:**
  $$\sum y^2 = 793.8566, \quad \frac{(\sum y)^2}{24} = \frac{(131.64)^2}{24} = 721.8774$$
  $$SS_{Total} = 793.8566 - 721.8774 = \mathbf{71.98}$$

- **Whole-Plot Analysis on Bioreactor Means:**
  - $32^\circ\text{C}$ Means: $[6.7725, 5.2675, 6.5400] \implies \bar{y}_{1\cdot\cdot} = 6.1933$
  - $37^\circ\text{C}$ Means: $[6.1300, 4.2900, 3.9075] \implies \bar{y}_{2\cdot\cdot} = 4.7758$
  - $SS_{Temp (means)} = 3.014$
  - Scale by $b = 4$:
    $$SS_{Temp} = 4 \times 3.014 = \mathbf{12.06}$$
  - $SS_{WP\ Error (means)} = 4.137$
  - Scale by $b = 4$:
    $$SS_{WP\ Error} = 4 \times 4.137 = \mathbf{16.55}$$

- **Subplot Factors:**
  - Feed SS:
    $$SS_{Feed} = 6 \sum_{j=1}^4 (\bar{y}_{\cdot j \cdot} - \bar{y}_{\dots})^2 = \mathbf{39.09}$$
  - Interaction SS:
    $$SS_{Temp \times Feed} = \mathbf{0.88}$$

- **Subplot Error SS (by subtraction):**
  $$SS_{SP\ Error} = SS_{Total} - SS_{Temp} - SS_{WP\ Error} - SS_{Feed} - SS_{Temp \times Feed}$$
  $$SS_{SP\ Error} = 71.98 - 12.06 - 16.55 - 39.09 - 0.88 = \mathbf{3.40}$$

#### 3. Mean Squares & F-Ratios:
$$MS_{Temp} = \frac{12.06}{1} = 12.06, \quad MS_{WP\ Error} = \frac{16.55}{4} = 4.137$$
$$F_{Temp} = \frac{MS_{Temp}}{MS_{WP\ Error}} = \frac{12.06}{4.137} = \mathbf{2.91}, \quad p = 0.163$$

$$MS_{Feed} = \frac{39.09}{3} = 13.03, \quad MS_{SP\ Error} = \frac{3.40}{12} = 0.284$$
$$F_{Feed} = \frac{MS_{Feed}}{MS_{SP\ Error}} = \frac{13.03}{0.284} = \mathbf{45.94}, \quad p = 7.47 \times 10^{-7} \quad (***)$$

$$MS_{Temp \times Feed} = \frac{0.88}{3} = 0.295$$
$$F_{Temp \times Feed} = \frac{MS_{Temp \times Feed}}{MS_{SP\ Error}} = \frac{0.295}{0.284} = \mathbf{1.04}, \quad p = 0.410$$

#### Master Split-Plot ANOVA Table

| Source of Variation | DF | Sum of Squares (SS) | Mean Square (MS) | F-Ratio | p-value | Significance ($\alpha=0.05$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Temperature (WP Factor)** | **1** | **12.06** | **12.056** | **2.91** | **0.163** | Not Significant |
| **WP Error (Bioreactors)** | **4** | **16.55** | **4.137** | — | — | *(Denominator for Temp)* |
| **Feed Formulation (SP Factor)** | **3** | **39.09** | **13.029** | **45.94** | **$< 0.001$** | **Highly Significant (***)** |
| **Temperature $\times$ Feed** | **3** | **0.88** | **0.295** | **1.04** | **0.410** | Not Significant |
| **Subplot Error** | **12** | **3.40** | **0.284** | — | — | *(Denominator for SP & Int)* |
| **Total** | **23** | **71.98** | — | — | — | — |

---

### Part 3: Microsoft Excel Step-by-Step Execution Guide (10 Points)

If you solve this in Microsoft Excel on the exam, use the following sequence:

```
========================================================================================
                      EXCEL TWO-STEP TOOLPAK METHOD RECIPE
========================================================================================
STEP 1: Calculate Bioreactor Means
  - In cells H2:H7, enter `=AVERAGE(C2:F2)` down to `=AVERAGE(C7:F7)`.
  - Format means into two columns:
      Column J (Temp 1: 32°C): 6.7725, 5.2675, 6.5400
      Column K (Temp 2: 37°C): 6.1300, 4.2900, 3.9075
  - Go to: Data > Data Analysis > "Anova: Single Factor"
  - Select input range J1:K4 (Columns, with labels).
  - Output provides:
      Between Groups SS = 3.014  -> Multiply by 4: SS_Temp = 12.056
      Within Groups SS  = 4.137  -> Multiply by 4: SS_WP_Error = 16.550

STEP 2: Run Two-Factor ANOVA on Raw Data
  - Arrange raw data as a 2-factor table (Rows = Temp, Columns = Feeds, 3 rows/sample).
  - Go to: Data > Data Analysis > "Anova: Two-Factor With Replication"
  - Rows per sample: 3.
  - From the output table, extract:
      SS_Total = 71.98
      SS_Columns (Feed) = 39.09
      SS_Interaction = 0.88

STEP 3: Assemble Master Table & Compute p-values by Formula
  - In cell B14: SS_SP_Error = `=SS_Total - SS_Temp - SS_WP_Error - SS_Feed - SS_Interaction`
                            = `=71.98 - 12.06 - 16.55 - 39.09 - 0.88`  (= 3.40)
  - In cell C14: DF_SP_Error = `=23 - 1 - 4 - 3 - 3` (= 12)
  - MS_SP_Error = `=3.40 / 12` (= 0.284)
  - F_Temp = `=12.056 / 4.137` (= 2.91)   -> p-value: `=F.DIST.RT(2.91, 1, 4)`  -> 0.163
  - F_Feed = `=13.029 / 0.284` (= 45.94)  -> p-value: `=F.DIST.RT(45.94, 3, 12)` -> 7.47E-07
  - F_Int  = `=0.295 / 0.284`  (= 1.04)   -> p-value: `=F.DIST.RT(1.04, 3, 12)`  -> 0.410
========================================================================================
```

---

### Part 4: Base R Terminal Implementation (10 Points)

Write these exact commands into R Terminal:

```r
# ==============================================================
# BASE R SCRIPT: SPLIT-PLOT MONOCLONAL ANTIBODY EXPERIMENT
# ==============================================================

# 1. Define Factors
temp <- factor(rep(c(1, 2), each = 12))  # 1 = 32C, 2 = 37C
feed <- factor(rep(1:4, times = 6))      # 4 Feeds
wp   <- factor(rep(1:6, each = 4))       # 6 Unique Bioreactors

# 2. Enter Response Data (Titer in g/L)
titer <- c(
  5.00, 6.62, 9.45, 6.02,   # Bioreactor 1 (Temp 1)
  3.95, 6.00, 6.86, 4.26,   # Bioreactor 2 (Temp 1)
  4.76, 6.34, 9.13, 5.93,   # Bioreactor 3 (Temp 1)
  4.84, 6.24, 7.31, 6.13,   # Bioreactor 4 (Temp 2)
  3.07, 3.71, 6.85, 3.53,   # Bioreactor 5 (Temp 2)
  2.53, 4.32, 5.34, 3.44    # Bioreactor 6 (Temp 2)
)

# 3. Create Dataframe
dat <- data.frame(wp, temp, feed, titer)

# 4. Fit Split-Plot Model
# Crucial syntax: Error(wp) specifies the whole-plot error structure
fit <- aov(titer ~ temp * feed + Error(wp), data = dat)

# 5. Display ANOVA Table
summary(fit)
```

#### Exact Output from R Terminal:

```
Error: wp
          Df Sum Sq Mean Sq F value Pr(>F)
temp       1  12.06  12.056   2.914  0.163
Residuals  4  16.55   4.137               

Error: Within
          Df Sum Sq Mean Sq F value   Pr(>F)    
feed       3  39.09  13.029   45.94 7.47e-07 ***
temp:feed  3   0.88   0.295    1.04     0.41    
Residuals 12   3.40   0.284                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

---

### Part 5: Biological Interpretation & Recommendations (5 Points)

1. **Temperature Effect ($p = 0.163 > 0.05$):**
   - We **fail to reject the null hypothesis** for Temperature. The difference in titer between $32^\circ\text{C}$ ($\bar{y} = 6.19\text{ g/L}$) and $37^\circ\text{C}$ ($\bar{y} = 4.78\text{ g/L}$) is not statistically significant after properly accounting for the large bioreactor-to-bioreactor run variability ($MS_{WP} = 4.137$).
2. **Feed Formulation Effect ($p = 7.47 \times 10^{-7} < 0.001$):**
   - We **reject the null hypothesis** for Feed Formulation. Feed supplement has an overwhelming, highly significant impact on antibody yield.
   - Examining group means:
     - **Feed 3 (Lipid-supplemented):** $\mathbf{7.49\text{ g/L}}$ (highest titer by far!)
     - Feed 2 (Amino acid): $5.54\text{ g/L}$
     - Feed 4 (Trace metal): $4.89\text{ g/L}$
     - Feed 1 (Basal control): $4.03\text{ g/L}$
3. **Temperature $\times$ Feed Interaction ($p = 0.410 > 0.05$):**
   - The interaction is **not significant**. Feed 3 performs superiorly regardless of whether the bioreactor is operated at $32^\circ\text{C}$ or $37^\circ\text{C}$.
4. **Actionable Bioprocess Recommendation:**
   - Immediately standardize downstream operations on **Feed 3 (Lipid Supplement)**, which provides an approximate **$86\%$ increase in antibody yield** over basal control.
   - Because Temperature did not demonstrate a statistically significant difference, the facility can operate at the more energy-efficient or faster-growing temperature ($37^\circ\text{C}$) without sacrificing titer.
