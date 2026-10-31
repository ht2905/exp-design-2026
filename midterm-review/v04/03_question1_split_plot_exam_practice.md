# Chapter 03: 50-Point Mock Exam – Question 1 (Split-Plot)
*Complete Practice Problem with Detailed Solutions in Base R (CSV-Based), Excel ToolPak, and LibreOffice Calc*

---

## The Exam Question Prompt (50 Points)

### Scenario:
A biotechnology laboratory is investigating the upstream production of a monoclonal antibody (mAb) using mammalian cell culture in batch bioreactors.

The experiment evaluates two factors on **Antibody Titer (g/L)**:
1. **Bioreactor Operating Temperature (Factor A):** A Hard-to-Change (HTC) factor evaluated at 2 levels:
   - Level 1: $32^\circ\text{C}$ (Mild hypothermia)
   - Level 2: $37^\circ\text{C}$ (Standard physiological)
2. **Nutrient Feed Formulation (Factor B):** An Easy-to-Change (ETC) factor evaluated at 4 levels:
   - Feed 1: Basal Control
   - Feed 2: Amino Acid Supplemented
   - Feed 3: Lipid Supplemented
   - Feed 4: Trace Metal Fortified

### Execution:
Due to the multi-day stabilization required for 50-Liter bioreactors, running 24 completely randomized bioreactor batches was impossible. Instead:
- The engineers ran **6 bioreactor batches in total** (3 batches set at $32^\circ\text{C}$, 3 batches set at $37^\circ\text{C}$).
- From each bioreactor batch, culture broth was divided into **4 separate culture vessels**, and each vessel received one of the 4 feed formulations randomly.
- Antibody titer ($\text{g/L}$) was measured after 14 days ($N = 2 \times 3 \times 4 = 24$ total observations).

---

### The Raw Experimental Data

| Whole Plot (Bioreactor) | Temperature ($A$) | Feed 1 (Basal) | Feed 2 (Amino) | Feed 3 (Lipid) | Feed 4 (Trace) | Bioreactor Mean ($\bar{y}_{i\cdot k}$) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Bioreactor 1** | $32^\circ\text{C}$ (1) | 5.00 | 6.62 | 9.45 | 6.02 | **6.7725** |
| **Bioreactor 2** | $32^\circ\text{C}$ (1) | 3.95 | 6.00 | 6.86 | 4.26 | **5.2675** |
| **Bioreactor 3** | $32^\circ\text{C}$ (1) | 4.76 | 6.34 | 9.13 | 5.93 | **6.5400** |
| **Bioreactor 4** | $37^\circ\text{C}$ (2) | 4.84 | 6.24 | 7.31 | 6.13 | **6.1300** |
| **Bioreactor 5** | $37^\circ\text{C}$ (2) | 3.07 | 3.71 | 6.85 | 3.53 | **4.2900** |
| **Bioreactor 6** | $37^\circ\text{C}$ (2) | 2.53 | 4.32 | 5.34 | 3.44 | **3.9075** |
| **Feed Mean ($\bar{y}_{\cdot j \cdot}$)** | — | **4.025** | **5.538** | **7.490** | **4.885** | **Grand Mean = 5.485** |

---

### Sub-Questions (50 Points Total):
1. **(10 Points)** Identify the design structure. State explicitly the **Whole-Plot Experimental Unit** and the **Subplot Experimental Unit**. Explain why analyzing this data using standard Two-Way ANOVA would lead to a severe Type I Error.
2. **(10 Points)** Structure the experimental data into a **Tidy CSV format** in LibreOffice Calc ready for R import.
3. **(15 Points)** Provide the complete **Base R Terminal solution** using `read.csv()`, factor conversions, `aov()` with `Error()`, and display the expected ANOVA table.
4. **(10 Points)** Detail the alternative spreadsheet execution via **Excel ToolPak** and **LibreOffice Calc**.
5. **(5 Points)** State your statistical conclusions at $\alpha = 0.05$ and give concrete recommendations to the bioprocess engineering team.

---

## Detailed Model Solution

### Part 1: Design Identification & Experimental Units (10 Points)

1. **Design Name:** A **$2 \times 4$ Factorial Treatment Structure in a Split-Plot Design Structure**.
2. **Experimental Units:**
   - **Whole-Plot Unit:** The **individual 50-L Bioreactor batch** (6 units total). Receives the Hard-to-Change factor: Temperature.
   - **Subplot Unit:** The **mini-bioreactor culture vessel** sampled from each bioreactor batch (24 units total). Receives the Easy-to-Change factor: Feed formulation.
3. **Why Standard Two-Way ANOVA Fails (Type I Error):**
   - Standard Two-Way ANOVA assumes all 24 observations were independently assigned to 24 separate temperature setups.
   - In reality, Temperature was only replicated **3 times per level** (6 bioreactors total), giving only **4 degrees of freedom** for whole-plot error ($2 \times (3 - 1) = 4$).
   - Standard ANOVA pools the large bioreactor-to-bioreactor variation ($\sigma^2_{WP}$) with the small vessel-to-vessel variation ($\sigma^2_{SP}$) into a single pooled error term with 16 degrees of freedom ($MS_{Pooled} = 1.247$).
   - If Temperature ($MS = 12.056$) is tested against this pooled error, it produces:
     $$F_{CRD} = \frac{12.056}{1.247} = 9.67, \quad p = 0.0067 \quad (\text{Falsely Significant!})$$
   - In the correct Split-Plot analysis, Temperature is tested against the true Whole-Plot Error ($MS = 4.137$), yielding:
     $$F_{Split-Plot} = \frac{12.056}{4.137} = 2.91, \quad p = 0.163 \quad (\text{Not Significant!})$$
   - Treating this experiment as a standard CRD causes a **Type I Error (False Positive)**: you would incorrectly claim temperature has a significant effect when the difference is simply random bioreactor-to-bioreactor noise.

---

### Part 2: Tidy Data CSV Structure in LibreOffice Calc (10 Points)

In LibreOffice Calc, create a clean 4-column table and save it as `q1_split_plot.csv`:

```csv
wp,temp,feed,titer
1,32C,1,5.00
1,32C,2,6.62
1,32C,3,9.45
1,32C,4,6.02
2,32C,1,3.95
2,32C,2,6.00
2,32C,3,6.86
2,32C,4,4.26
3,32C,1,4.76
3,32C,2,6.34
3,32C,3,9.13
3,32C,4,5.93
4,37C,1,4.84
4,37C,2,6.24
4,37C,3,7.31
4,37C,4,6.13
5,37C,1,3.07
5,37C,2,3.71
5,37C,3,6.85
5,37C,4,3.53
6,37C,1,2.53
6,37C,2,4.32
6,37C,3,5.34
6,37C,4,3.44
```

> [!IMPORTANT]
> **Why this layout is Tidy:**
> 1. Column `wp` uniquely identifies the 6 whole-plot bioreactor batches (`1` through `6`).
> 2. Column `temp` has the whole-plot factor levels (`32C` and `37C`).
> 3. Column `feed` has the subplot factor levels (`1` through `4`).
> 4. Column `titer` contains the single numerical response for that specific vessel.

---

### Part 3: Base R Terminal Implementation from CSV (15 Points)

This is the exact code to type into R Terminal:

```r
# ==============================================================
# BASE R SPLIT-PLOT WORKFLOW (FROM CSV)
# ==============================================================

# 1. Read the CSV file exported from LibreOffice Calc
dat <- read.csv("q1_split_plot.csv")

# 2. Convert design columns into categorical factors
dat$wp   <- factor(dat$wp)    # Bioreactor Unit ID (1 to 6)
dat$temp <- factor(dat$temp)  # Factor A (HTC factor)
dat$feed <- factor(dat$feed)  # Factor B (ETC factor)

# 3. Fit Split-Plot Model
# Error(wp) tells R to partition whole-plot error from subplot error
fit <- aov(titer ~ temp * feed + Error(wp), data = dat)

# 4. Display the complete ANOVA summary
summary(fit)
```

#### Actual R Console Output:

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

#### Complete Split-Plot ANOVA Table:

| Source of Variation | DF | Sum of Squares (SS) | Mean Square (MS) | F-Ratio | p-value | Significance ($\alpha=0.05$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Temperature (Factor A)** | **1** | **12.06** | **12.056** | **2.91** | **0.163** | Not Significant |
| **WP Error (Bioreactors)** | **4** | **16.55** | **4.137** | — | — | *(Denominator for Factor A)* |
| **Feed Formulation (Factor B)** | **3** | **39.09** | **13.029** | **45.94** | **$< 0.001$** | **Highly Significant (***)** |
| **Temperature $\times$ Feed** | **3** | **0.88** | **0.295** | **1.04** | **0.410** | Not Significant |
| **Subplot Error** | **12** | **3.40** | **0.284** | — | — | *(Denominator for B & AB)* |
| **Total** | **23** | **71.98** | — | — | — | — |

---

### Part 4: Alternative Spreadsheet Solutions (10 Points)

#### Method 1: The Expected Excel ToolPak Way
1. **Bioreactor Means:** Compute `=AVERAGE(C2:F2)` for the 6 bioreactors.
   - Column J ($32^\circ\text{C}$): `6.7725`, `5.2675`, `6.5400`
   - Column K ($37^\circ\text{C}$): `6.1300`, `4.2900`, `3.9075`
2. **Single Factor ANOVA on Means:** Run **Data > Data Analysis > Anova: Single Factor** on `J1:K4`.
   - Scale by $b = 4$:
     $$SS_{Temp} = 4 \times 3.014 = \mathbf{12.056}, \quad SS_{WP\ Error} = 4 \times 4.137 = \mathbf{16.550}$$
3. **Two-Factor ANOVA on Raw Data:** Run **Data > Data Analysis > Anova: Two-Factor With Replication** (Rows per sample = 3).
   - Read: $SS_{Total} = 71.98$, $SS_{Columns} = 39.09$, $SS_{Interaction} = 0.88$.
4. **Subplot Error by Subtraction:**
   $$SS_{SP\ Error} = 71.98 - 12.056 - 16.550 - 39.09 - 0.88 = \mathbf{3.40}$$
   $$DF_{SP\ Error} = 23 - 1 - 4 - 3 - 3 = \mathbf{12}, \quad MS_{SP\ Error} = \frac{3.40}{12} = \mathbf{0.284}$$
5. **Formulas for P-values:**
   - Temp: `=F.DIST.RT(2.91, 1, 4)` $\rightarrow \mathbf{0.163}$
   - Feed: `=F.DIST.RT(45.94, 3, 12)` $\rightarrow \mathbf{7.47 \times 10^{-7}}$
   - Interaction: `=F.DIST.RT(1.04, 3, 12)` $\rightarrow \mathbf{0.410}$

#### Method 2: The LibreOffice Calc Way (Linux / CachyOS)
1. **Single Factor ANOVA on Means:**
   - Put $32^\circ\text{C}$ means in column A and $37^\circ\text{C}$ means in column B.
   - Go to **Data > Statistics > Analysis of Variance (ANOVA)** $\rightarrow$ **Single Factor**.
   - Multiply Between SS and Within SS by $b = 4$ to obtain $SS_{Temp} = 12.056$ and $SS_{WP} = 16.550$.
2. **Two-Factor ANOVA on Raw Data:**
   - In a grid of 6 rows and 4 columns, go to **Data > Statistics > Analysis of Variance (ANOVA)** $\rightarrow$ **Two Factor** (Rows per sample: 3).
   - Read $SS_{Total} = 71.98$, $SS_{Columns} = 39.09$, and $SS_{Interaction} = 0.88$.
3. **Subtraction & P-Values:**
   - Calculate $SS_{SP} = 3.40$ and $MS_{SP} = 0.284$.
   - Calculate p-values using the exact same formula: `=F.DIST.RT(F_stat, df1, df2)`.

---

### Part 5: Statistical Conclusions & Recommendations (5 Points)

1. **Temperature ($p = 0.163 > 0.05$):** Fail to reject $H_0$. Temperature is not statistically significant. The difference between $32^\circ\text{C}$ and $37^\circ\text{C}$ is within normal bioreactor-to-bioreactor run noise.
2. **Feed Formulation ($p = 7.47 \times 10^{-7} < 0.001$):** Reject $H_0$. Feed has an overwhelming, highly significant impact on antibody yield. Feed 3 (Lipid-supplemented) produced the highest mean titer ($7.49\text{ g/L}$ vs $4.03\text{ g/L}$ for basal control).
3. **Interaction ($p = 0.410 > 0.05$):** Fail to reject $H_0$. Interaction is not significant; Feed 3 performs best at both temperatures.
4. **Engineering Recommendation:** Standardize on **Feed 3 (Lipid Supplement)**, yielding an approximate **$86\%$ titer increase**. Because temperature has no significant effect, operate at the standard $37^\circ\text{C}$ condition for faster cell growth.
