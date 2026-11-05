# Chapter 05: Handwritten A4 Cheat Sheet Master Layout
*High-Density, Mobile-Responsive Reference Guide for Physical Transcription*

---

> [!IMPORTANT]
> **Instructions for the Student:**  
> Your professor allows you to bring **one handwritten A4 paper** (front and back) into the exam room.  
> Divide your physical sheet into two sides:
> - **SIDE 1:** Biostats Foundations & Split-Plot Design (ToolPak Steps + Your R via CSV Script)
> - **SIDE 2:** Response Surface Methodology (RSM, CCD, BBD, R via CSV Script, & Eigenanalysis)
> 
> The sections below are formatted in responsive Markdown cards with concise code lines (< 45 characters) so you can comfortably read them on your phone while copying them onto your physical A4 paper.

---

# SIDE 1: BIOSTATS FOUNDATIONS & SPLIT-PLOT DESIGN

### 1. Biostats Core Formulas (In Plain English)
- **Sum of Squares:** $SS = \sum (y_i - \bar{y})^2$ (Total squared distance from mean).
- **Degrees of Freedom ($df$):** Independent pieces of information.
  - $df_{Factor} = k - 1$ (Comparisons among $k$ groups).
  - $df_{Error}$: Replication data for noise. **HIGH IS ALWAYS GOOD!** Higher $df_{Error}$ lowers $F_{crit}$ threshold and increases statistical power. Split-plot subplots have higher $df_{Error}$ ($12$ vs $4$).
- **Mean Square (Variance):** $MS = \frac{SS}{df}$.
- **$F$-Statistic:** $F = \frac{MS_{Treatment}}{MS_{Error}} = \frac{\text{Signal + Noise}}{\text{Noise}}$.
  - If $F \approx 1.0 \implies$ No treatment effect ($p \ge 0.05$).
  - If $F \gg 1.0 \implies$ Strong treatment effect ($p < 0.05$).
- **P-Value:** Probability that random luck alone produced a difference this big.

---

### 2. Split-Plot Architecture & Degrees of Freedom
*(Where $a$ = levels of $A$, $b$ = levels of $B$, $r$ = whole-plot replicates)*

| Source of Variation | Degrees of Freedom ($df$) | Example ($a=2, b=4, r=3$) | $F$-Test Formula |
| :--- | :---: | :---: | :--- |
| **Factor A (WP)** | $a - 1$ | $2 - 1 = \mathbf{1}$ | $F_A = \frac{MS_A}{MS_{WP}}$ |
| **WP Error (Residuals)** | $a(r - 1)$ | $2(3 - 1) = \mathbf{4}$ | *(Denominator for A)* |
| **Factor B (SP)** | $b - 1$ | $4 - 1 = \mathbf{3}$ | $F_B = \frac{MS_B}{MS_{SP}}$ |
| **Interaction ($A \times B$)** | $(a - 1)(b - 1)$ | $(1)(3) = \mathbf{3}$ | $F_{AB} = \frac{MS_{AB}}{MS_{SP}}$ |
| **Subplot Error** | $a(r - 1)(b - 1)$ | $2(2)(3) = \mathbf{12}$ | *(Denominator for B & AB)* |
| **Total** | $abr - 1$ | $24 - 1 = \mathbf{23}$ | — |

- **Two Error Terms:** $MS_{WP}$ tests Factor $A$; $MS_{SP}$ tests Factor $B$ and $A \times B$.
- **Fatal Trap:** Never test Factor $A$ against $MS_{SP}$! That causes massive False Positives (Type I Error).

---

### 3. Track 1: The Professor's Expected ToolPak Method
*(Write these steps down in case your professor grades on ToolPak steps)*
1. **Step 1 (Tank Means):** Run Single Factor ANOVA on the 6 tank averages.
   - **Scale up by $b$:** $SS_A = b \times SS_{Between}; \quad SS_{WP\ Error} = b \times SS_{Within}$
2. **Step 2 (Raw Data):** Run Two-Factor ANOVA with Replication ($r$ rows per sample).
   - Extract: $SS_{Total}$, $SS_B$ (Columns), $SS_{AB}$ (Interaction).
3. **Step 3 (Subtraction):**
   - $SS_{SP\ Error} = SS_{Total} - SS_A - SS_{WP\ Error} - SS_B - SS_{AB}$
   - $MS_{SP\ Error} = \frac{SS_{SP\ Error}}{DF_{SP\ Error}}$
   - P-values via `=F.DIST.RT(F_stat, df1, df2)`

---

### 4. Track 2: Your R Solution via CSV (Memorize for Exam!)

In LibreOffice, save `data.csv`:

| wp | temp | feed | titer |
| :---: | :---: | :---: | :---: |
| 1 | 32C | 1 | 5.00 |
| ... | ... | ... | ... |

Type into R Terminal:
```r
dat <- read.csv("data.csv")
dat$wp   <- factor(dat$wp)    # Unique Tank ID (1:6)
dat$temp <- factor(dat$temp)  # Factor A
dat$feed <- factor(dat$feed)  # Factor B
fit <- aov(titer ~ temp * feed + Error(wp), data = dat)
summary(fit)
```

---

# SIDE 2: RESPONSE SURFACE METHODOLOGY (RSM, CCD, BBD)

### 1. Bench Coding & The Biological Second-Order Model
- **Bench Factor Coding (3-Point Dial):**
  $$\text{Coded } x_i = \frac{\text{Bench Setting} - \text{Center}}{\text{Step Size}}$$
  Where $\text{Center} = \frac{\text{High} + \text{Low}}{2}$ and $\text{Step Size} = \frac{\text{High} - \text{Low}}{2}$.
- **Bench Decoding (Physical Units):**
  $$\text{Optimal Bench Setting} = \text{Center} + (\text{R's Coded } x_i \times \text{Step Size})$$
- **The Biological Response Surface Concept:**
  $$\text{Yield} = \text{Baseline} + \text{Slopes (Direction)} - \text{Curvature (Peak Dome)} + \text{Interactions (Synergy)}$$
  - **Curvature:** Needed because enzymes denature and cells die if pushed too far, forming a natural biological hilltop!
  - **Interactions:** Biochemical synergy between reagents.

---

### 2. Design Selection: CCD vs. BBD

| Feature | Central Composite Design (CCD) | Box-Behnken Design (BBD) |
| :--- | :--- | :--- |
| **Geometry** | Cube + Star ($\pm \alpha$) + Center | Edge Midpoints + Center |
| **Extreme Corners** | **Yes** (tests $\pm 1, \pm 1, \pm 1$) | **NO extreme corners** (Safe for bio) |
| **Levels per Factor** | **5 levels** ($-\alpha, -1, 0, +1, +\alpha$) | **3 levels only** ($-1, 0, +1$) |
| **Total Runs ($k=3$)** | $2^k + 2k + n_0 = 8 + 6 + 6 = \mathbf{20}$ | $2k(k-1) + n_0 = 12 + 3 = \mathbf{15}$ |

---

### 3. Your R Script for Question 2 via CSV (Memorize for Exam!)

In LibreOffice, save `bbd.csv`:

| x1 | x2 | x3 | yield |
| :---: | :---: | :---: | :---: |
| -1 | -1 | 0 | 31.8 |
| ... | ... | ... | ... |

Type into R Terminal:
```r
library(rsm)
dat <- read.csv("bbd.csv")
fit <- rsm(yield ~ SO(x1, x2, x3), data = dat)
summary(fit)

# Predict at optimal coordinate:
predict(fit, data.frame(x1 = 0.115, x2 = 0.289, x3 = -0.207))
```

---

### 4. Output Interpretation & Canonical Analysis

#### A. ANOVA Breakdown
- **`FO`:** First-order directional slopes.
- **`TWI`:** Two-way biochemical interactions / synergy.
- **`PQ`:** Pure quadratic curvature (bending into a peak).
- **Lack of Fit Test:**
  Look at the `Lack of fit` row in R's ANOVA output.
  > [!IMPORTANT]
  > **Crucial Rule:** If **$p > 0.05 \implies$ Fail to reject $H_0$** (GOOD! Model accurately describes the biology; errors are within normal pipetting noise).

#### B. Biological Surface Shape Test (R's Eigenvalues `$values`)

| Signs of Eigenvalues ($\lambda_i$) | Biological Shape | Nature of Stationary Point | Wet-Lab Verdict |
| :--- | :--- | :--- | :--- |
| **All Negative ($\lambda_i < 0$)** | **Mountain Peak (Dome)** | **Local Maximum (Optimum)** | **Found the peak! Highest yield.** |
| **All Positive ($\lambda_i > 0$)** | **Bowl / Basin** | **Local Minimum** | Minimum found (lowest impurities). |
| **Mixed Signs ($+$ and $-$)** | **Horse Saddle** | **Saddle Point** | Inconclusive; no single peak. |

---

## 3 Fatal Exam Traps to Remember

1. **Split-Plot Factor Trap:** In R, always convert `wp`, `temp`, and `feed` using `factor()`. If you omit `factor()`, R treats them as continuous numbers and fits linear regression instead of ANOVA!
2. **Excel Sum of Squares Scaling Trap:** In Step 1 of ToolPak, you **must** multiply Between SS and Within SS by the subplot count $b = 4$.
3. **Lack-of-Fit P-Value Trap:** For factors, $p < 0.05$ indicates significance. For **Lack of Fit**, you **want $p > 0.05$** (proves the model adequately fits the surface).

