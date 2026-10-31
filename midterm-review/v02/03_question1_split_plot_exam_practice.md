# Chapter 03: 50-Point Mock Exam – Question 1 (Split-Plot)
*Complete Practice Problem with Detailed Statistical Solutions in Excel and Base R*

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
2. **(15 Points)** Construct the complete Split-Plot ANOVA Table. Show degrees of freedom ($df$), Sum of Squares ($SS$), Mean Squares ($MS$), $F$-statistics, and state which error term tests each factor.
3. **(10 Points)** Provide the exact step-by-step instructions for executing this analysis in **Microsoft Excel** using the Data Analysis ToolPak and formula calculations.
4. **(10 Points)** Provide the exact **Base R Terminal script** to import, structure, and analyze this data using `aov()` with `Error()`, and display the expected output.
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

### Part 2: Complete Split-Plot ANOVA Table (15 Points)

#### 1. Degrees of Freedom ($df$):
- Temperature levels: $a = 2$
- Feed levels: $b = 4$
- Bioreactors per temperature: $r = 3$
- Total observations: $N = a \times b \times r = 24$

$$\text{DF}_{Temp} = a - 1 = 2 - 1 = \mathbf{1}$$
$$\text{DF}_{WP\ Error} = a(r - 1) = 2(3 - 1) = \mathbf{4}$$
$$\text{DF}_{Feed} = b - 1 = 4 - 1 = \mathbf{3}$$
$$\text{DF}_{Temp \times Feed} = (a - 1)(b - 1) = (1)(3) = \mathbf{3}$$
$$\text{DF}_{SP\ Error} = a(r - 1)(b - 1) = 2(2)(3) = \mathbf{12}$$
$$\text{DF}_{Total} = N - 1 = 24 - 1 = \mathbf{23}$$

#### 2. Sums of Squares ($SS$):
- $SS_{Total} = \sum y^2 - \frac{(\sum y)^2}{24} = 793.8566 - 721.8774 = \mathbf{71.98}$
- **Whole-Plot SS (from Bioreactor Means, scaled by $b=4$):**
  - $SS_{Temp} = 4 \times 3.014 = \mathbf{12.06}$
  - $SS_{WP\ Error} = 4 \times 4.137 = \mathbf{16.55}$
- **Subplot SS:**
  - $SS_{Feed} = 6 \sum (\bar{y}_{\cdot j \cdot} - \bar{y}_{\dots})^2 = \mathbf{39.09}$
  - $SS_{Temp \times Feed} = \mathbf{0.88}$
- **Subplot Error SS (by subtraction):**
  $$SS_{SP\ Error} = 71.98 - 12.06 - 16.55 - 39.09 - 0.88 = \mathbf{3.40}$$

#### 3. Mean Squares & $F$-Ratios:
- **Temperature:**
  $$MS_{Temp} = \frac{12.06}{1} = 12.056, \quad MS_{WP\ Error} = \frac{16.55}{4} = 4.137$$
  $$F_{Temp} = \frac{MS_{Temp}}{MS_{WP\ Error}} = \frac{12.056}{4.137} = \mathbf{2.91}, \quad p = \mathbf{0.163}$$
- **Feed Formulation:**
  $$MS_{Feed} = \frac{39.09}{3} = 13.029, \quad MS_{SP\ Error} = \frac{3.40}{12} = 0.284$$
  $$F_{Feed} = \frac{MS_{Feed}}{MS_{SP\ Error}} = \frac{13.029}{0.284} = \mathbf{45.94}, \quad p = \mathbf{7.47 \times 10^{-7}}$$
- **Interaction ($Temp \times Feed$):**
  $$MS_{Temp \times Feed} = \frac{0.88}{3} = 0.295$$
  $$F_{Temp \times Feed} = \frac{MS_{Temp \times Feed}}{MS_{SP\ Error}} = \frac{0.295}{0.284} = \mathbf{1.04}, \quad p = \mathbf{0.410}$$

#### Master Split-Plot ANOVA Table

| Source of Variation | DF | Sum of Squares (SS) | Mean Square (MS) | F-Ratio | p-value | Significance ($\alpha=0.05$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Temperature (Factor A)** | **1** | **12.06** | **12.056** | **2.91** | **0.163** | Not Significant |
| **WP Error (Bioreactors)** | **4** | **16.55** | **4.137** | — | — | *(Denominator for Factor A)* |
| **Feed Formulation (Factor B)** | **3** | **39.09** | **13.029** | **45.94** | **$< 0.001$** | **Highly Significant (***)** |
| **Temperature $\times$ Feed** | **3** | **0.88** | **0.295** | **1.04** | **0.410** | Not Significant |
| **Subplot Error** | **12** | **3.40** | **0.284** | — | — | *(Denominator for B & AB)* |
| **Total** | **23** | **71.98** | — | — | — | — |

---

### Part 3: Microsoft Excel Step-by-Step Guide (10 Points)

```
========================================================================================
                      EXCEL TWO-STEP TOOLPAK RECIPE
========================================================================================
STEP 1: Run "Anova: Single Factor" on Bioreactor Means
  1. Calculate the mean for each bioreactor (e.g. cells H2:H7: =AVERAGE(C2:F2)).
  2. Arrange means into two columns:
       Column J (Temp 1: 32°C): 6.7725, 5.2675, 6.5400
       Column K (Temp 2: 37°C): 6.1300, 4.2900, 3.9075
  3. Go to Data > Data Analysis > "Anova: Single Factor". Select input range J1:K4.
  4. ToolPak output gives:
       Between Groups SS = 3.014  ──► Multiply by 4: SS_Temp = 12.056
       Within Groups SS  = 4.137  ──► Multiply by 4: SS_WP_Error = 16.550

STEP 2: Run "Anova: Two-Factor With Replication" on Raw Data
  1. Arrange raw data with Rows = Temperature and Columns = Feeds (3 rows per temperature).
  2. Go to Data > Data Analysis > "Anova: Two-Factor With Replication". Set Rows per sample = 3.
  3. Extract from the ToolPak table:
       SS_Total = 71.98
       SS_Columns (Feed) = 39.09
       SS_Interaction = 0.88

STEP 3: Assemble Master Table & Formulas
  1. Calculate Subplot Error SS by formula:
       =SS_Total - SS_Temp - SS_WP_Error - SS_Feed - SS_Interaction
       =71.98 - 12.06 - 16.55 - 39.09 - 0.88  ──► 3.40
  2. Degrees of freedom:
       DF_SP_Error = 23 - 1 - 4 - 3 - 3 = 12
  3. Mean Squares:
       MS_SP_Error = 3.40 / 12 = 0.284
  4. F-Statistics & P-Values:
       F_Temp = 12.056 / 4.137 = 2.91  ──► =F.DIST.RT(2.91, 1, 4)  ──► 0.163
       F_Feed = 13.029 / 0.284 = 45.94 ──► =F.DIST.RT(45.94, 3, 12) ──► 7.47E-07
       F_Int  = 0.295 / 0.284  = 1.04  ──► =F.DIST.RT(1.04, 3, 12)  ──► 0.410
========================================================================================
```

---

### Part 4: Base R Terminal Implementation (10 Points)

Write these exact lines into R Terminal:

```r
# ==============================================================
# BASE R SPLIT-PLOT MONOCLONAL ANTIBODY SCRIPT
# ==============================================================

# 1. Define Factors
temp <- factor(rep(c(1, 2), each = 12))  # 1 = 32C, 2 = 37C
feed <- factor(rep(1:4, times = 6))      # 4 Feeds
wp   <- factor(rep(1:6, each = 4))       # 6 Unique Bioreactor IDs

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
# Error(wp) specifies the whole-plot error structure
fit <- aov(titer ~ temp * feed + Error(wp), data = dat)

# 5. Display ANOVA Summary
summary(fit)
```

#### Expected R Console Output:

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

### Part 5: Statistical Conclusions & Recommendations (5 Points)

1. **Temperature ($p = 0.163 > 0.05$):** Fail to reject $H_0$. Temperature is not statistically significant. The difference between $32^\circ\text{C}$ and $37^\circ\text{C}$ is within normal bioreactor-to-bioreactor run noise.
2. **Feed Formulation ($p = 7.47 \times 10^{-7} < 0.001$):** Reject $H_0$. Feed has an overwhelming, highly significant impact on antibody yield. Feed 3 (Lipid-supplemented) produced the highest mean titer ($7.49\text{ g/L}$ vs $4.03\text{ g/L}$ for basal control).
3. **Interaction ($p = 0.410 > 0.05$):** Fail to reject $H_0$. Interaction is not significant; Feed 3 performs best at both temperatures.
4. **Engineering Recommendation:** Standardize on **Feed 3 (Lipid Supplement)**, yielding an approximate **$86\%$ titer increase**. Because temperature has no significant effect, operate at the standard $37^\circ\text{C}$ condition for faster cell growth.

