# Chapter 05: Handwritten A4 Cheat Sheet Master Layout
*High-Density, Mobile-Responsive Reference Guide for Physical Transcription*

---

> [!IMPORTANT]
> **Instructions for the Student:**  
> Your professor allows you to bring **one handwritten A4 paper** (front and back) into the exam room.  
> Divide your physical sheet into two sides:
> - **SIDE 1:** Biostats Foundations & Split-Plot Design (Formulas, Excel 2-Step, Base R)
> - **SIDE 2:** Response Surface Methodology (Coding, CCD vs. BBD, `rsm` Package, Eigenanalysis)
> 
> The sections below are formatted in responsive Markdown cards with concise lines so you can read them comfortably on your phone while copying them onto your physical A4 paper.

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

### 2. Split-Plot Architecture
- **Whole-Plot Factor ($A$, HTC):** Hard-to-change (Temperature, Tank, Autoclave).
- **Subplot Factor ($B$, ETC):** Easy-to-change (Feeds, Stains, Aliquots).
- **Two Experimental Units:** Whole-Plot Unit (large) & Subplot Unit (small).
- **Two Error Terms:** $MS_{WP}$ tests Factor $A$; $MS_{SP}$ tests Factor $B$ and Interaction $A \times B$.
- **Fatal Error:** Never test Factor $A$ against $MS_{SP}$! That causes massive False Positives (Type I Error).

---

### 3. Split-Plot Degrees of Freedom & $F$-Tests
*(Where $a$ = levels of $A$, $b$ = levels of $B$, $r$ = whole-plot replicates)*

| Source of Variation | Degrees of Freedom ($df$) | Example ($a=2, b=4, r=3$) | $F$-Test Formula |
| :--- | :---: | :---: | :--- |
| **Factor A (WP)** | $a - 1$ | $2 - 1 = \mathbf{1}$ | $F_A = \frac{MS_A}{MS_{WP}}$ |
| **WP Error (Residuals)** | $a(r - 1)$ | $2(3 - 1) = \mathbf{4}$ | *(Denominator for A)* |
| **Factor B (SP)** | $b - 1$ | $4 - 1 = \mathbf{3}$ | $F_B = \frac{MS_B}{MS_{SP}}$ |
| **Interaction ($A \times B$)** | $(a - 1)(b - 1)$ | $(1)(3) = \mathbf{3}$ | $F_{AB} = \frac{MS_{AB}}{MS_{SP}}$ |
| **Subplot Error** | $a(r - 1)(b - 1)$ | $2(2)(3) = \mathbf{12}$ | *(Denominator for B & AB)* |
| **Total** | $abr - 1$ | $24 - 1 = \mathbf{23}$ | — |

---

### 4. Excel Two-Step ToolPak Method
1. **Step 1 (Whole-Plot on Means):**
   - Compute mean response for each whole plot.
   - Run **Data > Data Analysis > Anova: Single Factor** on whole-plot means.
   - **Scale up SS by $b$:**  
     $$SS_A = b \times SS_{Between}, \quad SS_{WP\ Error} = b \times SS_{Within}$$
2. **Step 2 (Subplot on Raw Data):**
   - Run **Anova: Two-Factor With Replication** on raw data (set rows/sample = $r$).
   - Extract: $SS_{Total}$, $SS_B$ (Columns), $SS_{AB}$ (Interaction).
3. **Step 3 (Subplot Error by Subtraction):**
   - $SS_{SP\ Error} = SS_{Total} - SS_A - SS_{WP\ Error} - SS_B - SS_{AB}$
   - $DF_{SP\ Error} = DF_{Total} - DF_A - DF_{WP\ Error} - DF_B - DF_{AB}$
   - $MS_{SP\ Error} = \frac{SS_{SP\ Error}}{DF_{SP\ Error}}$
   - P-values: `=F.DIST.RT(F_value, df1, df2)`

---

### 5. Base R Terminal Script

```r
# 1. Define factors (ensure wp IDs are unique: 1 to 6!)
A  <- factor(rep(c("A1", "A2"), each = 12))
B  <- factor(rep(1:4, times = 6))
wp <- factor(rep(1:6, each = 4))
y  <- c(...) # 24 response values

# 2. Fit split-plot model
dat <- data.frame(wp, A, B, y)
fit <- aov(y ~ A * B + Error(wp), data = dat)
summary(fit)
```

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

### 3. R Terminal Script (Using `library(rsm)`)

```r
library(rsm)

# 1. Generate BBD (k=3, n0=3) with coding
des <- bbd(
  k = 3, n0 = 3, block = FALSE, randomize = FALSE,
  coding = list(
    x1 ~ (Temp - 35) / 5,
    x2 ~ (Conc - 1.0) / 0.5,
    x3 ~ (Time - 30) / 15
  )
)

# 2. Attach response & fit second-order model
des$yield <- c(...) # 15 values
fit <- rsm(yield ~ SO(x1, x2, x3), data = des)
summary(fit)

# 3. Plots & Predictions
contour(fit, ~ x1 + x2 + x3, image = TRUE)
persp(fit, x2 ~ x1, zlab = "Yield")
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

1. **Split-Plot R Coding Trap:** Whole plots **must** have unique IDs (e.g., `1:6`). If you repeat `1:3` for each treatment, R will treat them as paired blocks instead of whole plots.
2. **Excel Sum of Squares Scaling Trap:** In Step 1 of Excel, you **must** multiply Between SS and Within SS by the subplot count $b$.
3. **Lack-of-Fit P-Value Trap:** For factors, $p < 0.05$ indicates significance. For **Lack of Fit**, you **want $p > 0.05$** (proves the model adequately fits the surface).

