# Chapter 05: Handwritten A4 Cheat Sheet Master Layout
*High-Density, Mobile-Responsive Reference Guide for Physical Transcription*

---

> [!IMPORTANT]
> **Instructions for the Student:**  
> Your professor allows you to bring **one handwritten A4 paper** (front and back) into the exam room.  
> Divide your physical sheet into two sides:
> - **SIDE 1:** Biostats Foundations & Split-Plot Design (CSV-Based Base R Workflow + ToolPak Notes)
> - **SIDE 2:** Response Surface Methodology (CSV-Based `rsm` Workflow, Coding, Eigenanalysis)
> 
> The sections below are formatted in responsive Markdown cards with concise code lines (< 45 characters) so you can comfortably read them on your phone while copying them onto your physical A4 paper.

---

# SIDE 1: BIOSTATS FOUNDATIONS & SPLIT-PLOT DESIGN

### 1. Biostats Core Formulas
- **Sum of Squares:** $SS = \sum (y_i - \bar{y})^2$ (Total squared variation).
- **Mean Square (Variance):** $MS = \frac{SS}{df}$.
- **$t$-Statistic:** $t = \frac{\text{Estimate}}{SE}$ (Signal / Noise ratio).
- **$F$-Statistic:** $F = \frac{MS_{Treatment}}{MS_{Error}}$ (Ratio of two variances).
- **P-Value Decision:**
  - If $p < 0.05 \implies$ **Reject $H_0$** (Statistically significant).
  - If $p \ge 0.05 \implies$ **Fail to reject $H_0$** (Not significant).

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

### 3. Tidy CSV Format in LibreOffice (Split-Plot)
Create `data.csv` in LibreOffice with tidy columns:
```csv
wp,temp,feed,titer
1,32C,1,5.00
1,32C,2,6.62
...
```
*(Each row is one observation; `wp` is unique 1 to 6)*

---

### 4. Split-Plot: The Base R Script from CSV (Memorize for Exam!)

```r
# 1. Read CSV file
dat <- read.csv("data.csv")

# 2. MUST convert columns to factors!
dat$wp   <- factor(dat$wp)    # Unique WP ID (1:6)
dat$temp <- factor(dat$temp)  # Factor A
dat$feed <- factor(dat$feed)  # Factor B

# 3. Fit Split-Plot Model
fit <- aov(titer ~ temp * feed + Error(wp), data = dat)
summary(fit)
```

**Output interpretation:**
- `Error: wp` block: Factor `temp` tested against `Residuals` ($MS_{WP}$).
- `Error: Within` block: Factor `feed` & `temp:feed` tested against `Residuals` ($MS_{SP}$).

---

### 5. Split-Plot: Excel ToolPak & LibreOffice Calc Method
*(In case the question specifically asks for ToolPak steps)*

1. **Step 1 (Whole-Plot on Means):**
   - Run Single Factor ANOVA on whole-plot means.
   - **Scale up SS by $b$:**  
     $$SS_A = b \times SS_{Between}, \quad SS_{WP\ Error} = b \times SS_{Within}$$
2. **Step 2 (Two-Factor on Raw Data):**
   - Run Two-Factor ANOVA with Replication on raw data ($r$ rows per sample).
   - Extract: $SS_{Total}$, $SS_B$ (Columns), $SS_{AB}$ (Interaction).
3. **Step 3 (Subplot Error by Subtraction):**
   - $SS_{SP\ Error} = SS_{Total} - SS_A - SS_{WP\ Error} - SS_B - SS_{AB}$
   - $DF_{SP\ Error} = DF_{Total} - DF_A - DF_{WP\ Error} - DF_B - DF_{AB}$
   - $MS_{SP\ Error} = \frac{SS_{SP\ Error}}{DF_{SP\ Error}}$
   - P-values: `=F.DIST.RT(F_stat, df1, df2)` (Same formula in Excel & LibreOffice Calc).

---

# SIDE 2: RESPONSE SURFACE METHODOLOGY (RSM, CCD, BBD)

### 1. Coding Equations & Second-Order Model
- **Coding Formula:**
  $$x_i = \frac{X_i - X_{center}}{\Delta X / 2}$$
  Where $X_{center} = \frac{X_{high} + X_{low}}{2}$ and $\frac{\Delta X}{2} = \frac{X_{high} - X_{low}}{2}$.
- **Decoding Formula:**
  $$X_i = X_{center} + x_i \times \left(\frac{\Delta X}{2}\right)$$
- **Second-Order Polynomial Model:**
  $$y = \beta_0 + \sum \beta_i x_i + \sum \beta_{ii} x_i^2 + \sum \sum \beta_{ij} x_i x_j$$
  - $\beta_i$: Linear directional slope.
  - $\beta_{ii}$: Quadratic curvature along factor $i$.
  - $\beta_{ij}$: Two-way interaction / twist.

---

### 2. Design Selection: CCD vs. BBD

| Feature | Central Composite Design (CCD) | Box-Behnken Design (BBD) |
| :--- | :--- | :--- |
| **Geometry** | Cube + Star ($\pm \alpha$) + Center | Edge Midpoints + Center |
| **Extreme Corners** | **Yes** (tests $\pm 1, \pm 1, \pm 1$) | **NO extreme corners** (Safe for bio) |
| **Levels per Factor** | **5 levels** ($-\alpha, -1, 0, +1, +\alpha$) | **3 levels only** ($-1, 0, +1$) |
| **Total Runs ($k=3$)** | $2^k + 2k + n_0 = 8 + 6 + 6 = \mathbf{20}$ | $2k(k-1) + n_0 = 12 + 3 = \mathbf{15}$ |
| **Axial Distance $\alpha$** | Rotatable: $\alpha = (2^k)^{0.25}$; Face-Centered: $\alpha = 1.0$ | Not Applicable |

---

### 3. Tidy CSV Format & R Script for RSM (Memorize for Exam!)

Create `bbd.csv` in LibreOffice with coded columns:
```csv
x1,x2,x3,yield
-1,-1,0,31.8
1,-1,0,37.1
...
```

Type into R Terminal:
```r
library(rsm)

# 1. Read CSV file
dat <- read.csv("bbd.csv")

# 2. Fit Second-Order (SO) Model
fit <- rsm(yield ~ SO(x1, x2, x3), data = dat)
summary(fit)

# 3. Plots & Prediction at Optimum
contour(fit, ~ x1 + x2 + x3, image = TRUE)
predict(fit, data.frame(x1 = 0.115, x2 = 0.289, x3 = -0.207))
```

---

### 4. Output Interpretation & Canonical Analysis

#### A. ANOVA Breakdown
- **`FO(x1,x2,x3)`:** First-order linear main effects.
- **`TWI(x1,x2,x3)`:** Two-way cross-product interactions.
- **`PQ(x1,x2,x3)`:** Pure quadratic curvature terms ($x_1^2, x_2^2, x_3^2$).
- **Lack of Fit Test:**
  $$F_{LOF} = \frac{MS_{Lack\ of\ fit}}{MS_{Pure\ error}}$$
  > [!IMPORTANT]
  > **Crucial Rule:** If **$p > 0.05 \implies$ Fail to reject $H_0$** (GOOD! Model fits properly).

#### B. Stationary Point Coordinates
$$\mathbf{x}_0 = -\frac{1}{2} \mathbf{B}^{-1} \mathbf{b}$$
- Check whether coded coordinates fall within $[-1, +1]$. If outside, extrapolation is required.

#### C. Eigenanalysis (Eigenvalues $\lambda_1, \lambda_2, \dots, \lambda_k$ of Matrix $\mathbf{B}$)

| Signs of Eigenvalues ($\lambda_i$) | Nature of Stationary Point | Geometric Shape | Action |
| :--- | :--- | :--- | :--- |
| **All Negative ($\lambda_i < 0$)** | **Local Maximum** | **Peak (Hilltop)** | **Optimal condition found!** |
| **All Positive ($\lambda_i > 0$)** | **Local Minimum** | **Basin (Bowl)** | Minimum condition found. |
| **Mixed Signs ($+$ and $-$)** | **Saddle Point** | **Mountain Pass (Col)** | No unique optimum. |
| **Any $\lambda_i \approx 0$** | **Ridge System** | **Stationary / Rising Ridge** | Ridge analysis needed. |

---

## 3 Fatal Exam Traps to Remember

1. **Split-Plot Factor Trap:** In R, always convert `wp`, `temp`, and `feed` using `factor()`. If you omit `factor()`, R treats them as continuous numbers and fits linear regression instead of ANOVA!
2. **Excel/Calc Sum of Squares Scaling Trap:** In Step 1 of spreadsheet ANOVA, you **must** multiply Between SS and Within SS by the subplot count $b$.
3. **Lack-of-Fit P-Value Trap:** For factors, $p < 0.05$ indicates significance. For **Lack of Fit**, you **want $p > 0.05$** (proves the model adequately fits the surface).
