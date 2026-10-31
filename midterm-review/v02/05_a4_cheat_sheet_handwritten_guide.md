# Chapter 05: Handwritten A4 Cheat Sheet Master Layout
*The High-Density, Error-Proof Reference Sheet to Transcribe onto Your Permitted A4 Paper*

---

> [!IMPORTANT]
> **Instructions for the Student:**  
> Your professor allows you to bring **one handwritten A4 sheet** (front and back) into the exam room.  
> Divide your sheet into two sides:
> - **SIDE 1:** Foundational Biostats & Split-Plot Analysis (Theory, Excel Two-Step, Base R)
> - **SIDE 2:** Response Surface Methodology (RSM, CCD, BBD, & R Terminal `rsm`)
> 
> Copy the compact boxes below directly onto your physical paper using a fine-tip pen.

---

# SIDE 1: BIOSTATS FOUNDATIONS & SPLIT-PLOT DESIGN

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. BIOSTATS CORE FORMULAS & DEFINITIONS                                                │
│ • Sum of Squares: SS = Σ (y - y_mean)^2  (Total squared variation).                   │
│ • Mean Square: MS = SS / df  (Sample variance).                                        │
│ • Test Statistic: t = Estimate / SE  (Signal / Noise ratio).                           │
│ • F-Statistic: F = MS_Treatment / MS_Error  (Ratio of two variances).                  │
│ • P-Value: Probability of seeing data this extreme IF H0 were true.                    │
│   If p < 0.05 ──► Reject H0 (Significant effect!).                                     │
│   If p ≥ 0.05 ──► Fail to reject H0 (Not significant).                                 │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 2. SPLIT-PLOT DESIGN ARCHITECTURE                                                      │
│ • Whole-Plot Factor A (HTC): Hard to change (Temperature, Autoclave, Tank).            │
│ • Subplot Factor B (ETC): Easy to change (Nutrients, Stains, Aliquots).                │
│ • Two Experimental Units: Whole-Plot Unit (large) & Subplot Unit (small).              │
│ • Two Error Terms: MS_WP tests Factor A; MS_SP tests Factor B and A:B.                 │
│ • Fatal Trap: NEVER test Factor A against MS_SP! (Causes massive False Positives).     │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 3. SPLIT-PLOT DEGREES OF FREEDOM & F-TESTS (a = A levels, b = B levels, r = WP reps)   │
│   Source              | DF              | Wood Example (a=2, b=4, r=3) | F-Test Formula│
│   --------------------|-----------------|------------------------------|---------------│
│   Factor A (WP)       | a - 1           | 2 - 1 = 1                    | MS_A / MS_WP  │
│   WP Error (Residual) | a(r - 1)        | 2(2)  = 4                    | (Denominator) │
│   Factor B (SP)       | b - 1           | 4 - 1 = 3                    | MS_B / MS_SP  │
│   Interaction (A x B) | (a - 1)(b - 1)  | (1)(3)= 3                    | MS_AB / MS_SP │
│   Subplot Error       | a(r - 1)(b - 1) | 2(2)(3)= 12                  | (Denominator) │
│   Total               | abr - 1         | 24 - 1 = 23                  |               │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 4. EXCEL TWO-STEP TOOLPAK METHOD                                                       │
│ Step 1 (Whole-Plot on Means):                                                          │
│   • Compute average response for each whole plot.                                      │
│   • Data > Data Analysis > Anova: Single Factor on whole-plot means.                   │
│   • SCALE UP SS BY b: SS_A = b * SS_Between;   SS_WP_Error = b * SS_Within             │
│ Step 2 (Subplot on Raw Data):                                                          │
│   • Data Analysis > Anova: Two-Factor With Replication on raw data (rows/sample = r).  │
│   • Extract: SS_Total, SS_B (Columns), SS_AB (Interaction).                            │
│ Step 3 (Subplot Error by Subtraction):                                                 │
│   • SS_SP_Error = SS_Total - SS_A - SS_WP_Error - SS_B - SS_AB                         │
│   • DF_SP_Error = DF_Total - DF_A - DF_WP_Error - DF_B - DF_AB                         │
│   • MS_SP_Error = SS_SP_Error / DF_SP_Error                                            │
│   • P-values in Excel: =F.DIST.RT(F_value, df1, df2)                                   │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 5. BASE R TERMINAL SCRIPT                                                              │
│   A    <- factor(rep(c("A1", "A2"), each = 12))  # Whole-plot factor                   │
│   B    <- factor(rep(1:4, times = 6))            # Subplot factor                      │
│   wp   <- factor(rep(1:6, each = 4))             # UNIQUE WP IDs (1 to 6!)             │
│   resp <- c(...)                                 # Response vector (24 values)         │
│   dat  <- data.frame(wp, A, B, resp)                                                   │
│   fit  <- aov(resp ~ A * B + Error(wp), data = dat)                                    │
│   summary(fit)                                                                         │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# SIDE 2: RESPONSE SURFACE METHODOLOGY (RSM, CCD, BBD)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. CODING EQUATIONS & SECOND-ORDER MODEL                                               │
│ • Coding Formula: x_i = (X_i - X_center) / (ΔX / 2)                                    │
│   where X_center = (X_high + X_low)/2  and  ΔX/2 = (X_high - X_low)/2                  │
│ • Decoding: X_i = X_center + x_i * (ΔX / 2)                                            │
│ • Second-Order Model: y = b0 + Σ bi*xi + Σ bii*xi^2 + ΣΣ bij*xi*xj                     │
│   bi = linear slopes; bii = quadratic curvature; bij = two-way interaction/twist.      │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 2. DESIGN SELECTION: CCD vs BBD                                                        │
│ Feature            | Central Composite (CCD)        | Box-Behnken (BBD)                │
│ -------------------|--------------------------------|--------------------------------- │
│ Points geometry    | Cube + Star (±α) + Center      | Edge Midpoints + Center          │
│ Extreme corners    | YES (tests ±1, ±1, ±1)         | NO EXTREME CORNERS (Safe for bio)│
│ Levels per factor  | 5 levels (-α, -1, 0, +1, +α)   | 3 levels only (-1, 0, +1)        │
│ Run count (k=3)    | 2^k + 2k + n0 = 8 + 6 + 6 = 20 | 2k(k-1) + n0 = 12 + 3 = 15 runs  │
│ Axial distance α   | Rotatable: α = (2^k)^0.25      | Not applicable                   │
│                    | Face-Centered: α = 1.0         |                                  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 3. R TERMINAL SCRIPT (USING LIBRARY(RSM))                                              │
│   library(rsm)                                                                         │
│   des <- bbd(k = 3, n0 = 3, block = FALSE, randomize = FALSE,                          │
│              coding = list(x1 ~ (Temp - 35)/5,                                         │
│                            x2 ~ (Conc - 1.0)/0.5,                                      │
│                            x3 ~ (Time - 30)/15))                                       │
│   des$yield <- c(...)                                                                  │
│   fit <- rsm(yield ~ SO(x1, x2, x3), data = des)                                       │
│   summary(fit)                                                                         │
│   contour(fit, ~ x1 + x2 + x3, image = TRUE)  # Slices of response surface             │
│   persp(fit, x2 ~ x1, zlab = "Yield")         # 3D wireframe plot                      │
│   predict(fit, data.frame(x1 = 0.115, x2 = 0.289, x3 = -0.207))  # Max yield           │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 4. DECODING OUTPUT & CANONICAL ANALYSIS                                                │
│ A. ANOVA Breakdown:                                                                    │
│   • FO(x1,x2,x3)  = First-order linear main effects.                                   │
│   • TWI(x1,x2,x3) = Two-way interactions (twist).                                      │
│   • PQ(x1,x2,x3)  = Pure quadratic curvature (x1^2, x2^2, x3^2).                      │
│   • Lack of Fit: H0: Model fits adequately. F_LOF = MS_LOF / MS_PureError.             │
│     CRITICAL: IF p > 0.05 ──► FAIL TO REJECT H0 (GOOD! Model fits properly).           │
│                                                                                        │
│ B. Stationary Point (x0 = -0.5 * B^-1 * b):                                            │
│   • Check if coded coordinates lie inside [-1, +1]. If outside ──► Extrapolation!      │
│                                                                                        │
│ C. Eigenanalysis (Eigenvalues λ1, λ2, ..., λk of matrix B):                            │
│   • ALL NEGATIVE (λi < 0)  ──► LOCAL MAXIMUM (Hilltop / Optimal Peak!).                │
│   • ALL POSITIVE (λi > 0)  ──► LOCAL MINIMUM (Basin / Valley bottom).                  │
│   • MIXED SIGNS (+ and -)  ──► SADDLE POINT (Minimax / Mountain Col).                  │
│   • ANY λi ≈ 0             ──► RIDGE SYSTEM (Stationary / Rising Ridge).               │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 3 Fatal Exam Traps to Avoid

1. **Split-Plot R Coding Trap:** Always ensure whole-plot units have **unique IDs** (`wp <- factor(rep(1:6, each = 4))`). If you repeat `1, 2, 3, 1, 2, 3`, R will assume whole plots in Treatment 1 and Treatment 2 are paired blocks!
2. **Excel Sums of Squares Scaling Trap:** When running `Anova: Single Factor` on whole-plot means in Excel, you **must** multiply Between SS and Within SS by the number of subplots $b$.
3. **Lack-of-Fit P-Value Trap:** For treatment effects, $p < 0.05$ is desired (significant effect). For **Lack of Fit**, you **want $p > 0.05$** (fail to reject $H_0 \implies$ model fits well).

