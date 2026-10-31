# Chapter 05: Handwritten A4 Cheat Sheet Master Layout
*The High-Density, Error-Proof Reference Sheet to Transcribe onto Your Permitted A4 Paper*

---

> [!IMPORTANT]
> **Instructions for the Student:**  
> Your professor allows you to bring **one handwritten A4 paper** (front and back) into the exam room.  
> Divide your sheet into two sides:
> - **SIDE 1:** Split-Plot Experimental Design & Analysis (Theory, Excel, & Base R)
> - **SIDE 2:** Response Surface Methodology (RSM, CCD, BBD, & R Terminal `rsm`)
> 
> Copy the compact boxes below directly onto your physical paper using a fine-tip pen.

---

# SIDE 1: SPLIT-PLOT EXPERIMENTAL DESIGN

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. CORE INTUITION & EXPERIMENTAL UNITS                                                 │
│ • Whole-Plot (WP): Unit receiving Hard-to-Change (HTC) factor (Incubator, Board, Tank). │
│ • Subplot (SP): Smaller unit inside WP receiving Easy-to-Change (ETC) factor.         │
│ • FATAL MISTAKE: Never use standard CRD 2-Way ANOVA! It pools errors and tests HTC    │
│   factor against small SP error -> MASSIVE TYPE I ERROR (False Positives!).           │
│ • Split-Plot has TWO separate randomizations -> TWO SEPARATE ERROR TERMS!              │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 2. STATISTICAL MODEL & DEGREES OF FREEDOM (a = A levels, b = B levels, r = WP reps)    │
│   y_ijk = μ + α_i + ρ_k + ε_(i)k^WP + β_j + (αβ)_ij + ε_ijk^SP                         │
│                                                                                        │
│   Source              | DF              | Wood Ex (a=2, b=4, r=3) | Test Denominator   │
│   --------------------|-----------------|-------------------------|------------------- │
│   Factor A (WP)       | a - 1           | 2 - 1 = 1               | MS_WP (WP Error)   │
│   WP Error            | a(r - 1)        | 2(2)  = 4               | (Denominator)      │
│   Factor B (SP)       | b - 1           | 4 - 1 = 3               | MS_SP (SP Error)   │
│   Interaction (A x B) | (a - 1)(b - 1)  | (1)(3)= 3               | MS_SP (SP Error)   │
│   SP Error (Residual) | a(r - 1)(b - 1) | 2(2)(3)= 12             | (Denominator)      │
│   Total               | abr - 1         | 24 - 1 = 23             |                    │
│                                                                                        │
│   F_A = MS_A / MS_WP      [df = a-1, a(r-1)]                                           │
│   F_B = MS_B / MS_SP      [df = b-1, a(r-1)(b-1)]                                      │
│   F_AB = MS_AB / MS_SP    [df = (a-1)(b-1), a(r-1)(b-1)]                               │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 3. EXCEL TWO-STEP TOOLPAK METHOD                                                       │
│ Step 1 (Whole-Plot on Means):                                                          │
│   • Calculate mean of each whole-plot unit (e.g. 6 board means).                       │
│   • Run Data > Data Analysis > Anova: Single Factor on means.                          │
│   • SCALE UP SS BY SUBPLOT COUNT b:                                                    │
│       SS_A = b * SS_Between;   SS_WP_Error = b * SS_Within                             │
│ Step 2 (Subplot on Raw Data):                                                          │
│   • Run Data Analysis > Anova: Two-Factor With Replication on raw data.                │
│   • Extract: SS_Total, SS_B (Columns), SS_AB (Interaction).                            │
│ Step 3 (Subtraction for Subplot Error):                                                │
│   • SS_SP_Error = SS_Total - SS_A - SS_WP_Error - SS_B - SS_AB                         │
│   • DF_SP_Error = DF_Total - DF_A - DF_WP_Error - DF_B - DF_AB                         │
│   • MS_SP_Error = SS_SP_Error / DF_SP_Error                                            │
│   • P-values in Excel: =F.DIST.RT(F_value, df1, df2)                                   │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 4. BASE R TERMINAL SCRIPT (MEMORIZE THIS EXACT CODE!)                                  │
│                                                                                        │
│   # 1. Define vectors                                                                  │
│   A    <- factor(c(...))                  # Whole-plot factor (e.g. rep(1:2, each=12)) │
│   B    <- factor(c(...))                  # Subplot factor (e.g. rep(1:4, times=6))    │
│   wp   <- factor(c(...))                  # UNIQUE WP IDs! (e.g. rep(1:6, each=4))     │
│   resp <- c(...)                          # Raw response data                          │
│   dat  <- data.frame(wp, A, B, resp)                                                   │
│                                                                                        │
│   # 2. Fit Split-Plot ANOVA                                                            │
│   fit <- aov(resp ~ A * B + Error(wp), data = dat)                                     │
│   summary(fit)                                                                         │
│                                                                                        │
│   # Output interpretation:                                                             │
│   # Error: wp       -> Tests Factor A against Residuals (WP Error)                     │
│   # Error: Within   -> Tests Factor B & A:B against Residuals (SP Error)               │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

# SIDE 2: RESPONSE SURFACE METHODOLOGY (RSM, CCD, BBD)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. CODING TRANSFORMATION & MODEL EQUATION                                              │
│ • Coding Formula: x_i = (X_i - X_center) / (ΔX / 2)                                    │
│   where X_center = (X_high + X_low)/2  and  ΔX/2 = (X_high - X_low)/2                  │
│ • Second-Order Model: y = b0 + Σ bi*xi + Σ bii*xi^2 + ΣΣ bij*xi*xj                     │
│   bi = linear slopes; bii = quadratic curvature; bij = two-way interaction/twist.      │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 2. DESIGN SELECTION: CCD vs BBD                                                        │
│                                                                                        │
│ Feature            | Central Composite (CCD)        | Box-Behnken (BBD)                │
│ -------------------|--------------------------------|--------------------------------- │
│ Points geometry    | Cube + Star (±α) + Center      | Edge Midpoints + Center          │
│ Extreme corners    | YES (runs at ±1, ±1, ±1)       | NO EXTREME CORNERS (Safe for bio)│
│ Levels per factor  | 5 levels (-α, -1, 0, +1, +α)   | 3 levels only (-1, 0, +1)        │
│ Run count (k=3)    | 2^k + 2k + n0 = 8 + 6 + 6 = 20 | 2k(k-1) + n0 = 12 + 3 = 15 runs  │
│ Axial distance α   | Rotatable: α = (2^k)^0.25      | Not applicable                   │
│                    | Face-Centered: α = 1.0         |                                  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 3. R TERMINAL SCRIPT (USING LIBRARY(RSM))                                              │
│                                                                                        │
│   library(rsm)                                                                         │
│                                                                                        │
│   # Generate BBD (k=3, n0=3) with coding                                               │
│   des <- bbd(k = 3, n0 = 3, block = FALSE, randomize = FALSE,                          │
│              coding = list(x1 ~ (Temp - 35)/5,                                         │
│                            x2 ~ (Conc - 1.0)/0.5,                                      │
│                            x3 ~ (Time - 30)/15))                                       │
│                                                                                        │
│   # Attach response & fit Second-Order (SO) model                                      │
│   des$yield <- c(...)                                                                  │
│   fit <- rsm(yield ~ SO(x1, x2, x3), data = des)                                       │
│   summary(fit)                                                                         │
│                                                                                        │
│   # Useful diagnostic plots                                                            │
│   contour(fit, ~ x1 + x2 + x3, image = TRUE)                                           │
│   persp(fit, x2 ~ x1, zlab = "Yield", col = "lightblue")                               │
│   steepest(fit, dist = seq(0, 2, by = 0.5))  # If climbing to higher peak               │
├────────────────────────────────────────────────────────────────────────────────────────┤
│ 4. DECODING THE OUTPUT & CANONICAL ANALYSIS                                            │
│                                                                                        │
│ A. ANOVA Breakdown:                                                                    │
│   • FO(x1,x2,x3)  = First-order linear main effects.                                   │
│   • TWI(x1,x2,x3) = Two-way interactions (twist).                                      │
│   • PQ(x1,x2,x3)  = Pure quadratic curvature (x1^2, x2^2, x3^2).                      │
│   • Lack of fit   = Discrepancy between model and surface.                             │
│     H0: Model fits adequately. TEST: F_LOF = MS_LOF / MS_PureError.                    │
│     IF p > 0.05 -> FAIL TO REJECT H0 (GOOD! Model fits properly).                     │
│                                                                                        │
│ B. Stationary Point (x0 = -0.5 * B^-1 * b):                                            │
│   • Check if coded coordinates lie inside [-1, +1]. If outside -> Extrapolation!       │
│                                                                                        │
│ C. Eigenanalysis (Eigenvalues λ1, λ2, ..., λk of matrix B):                            │
│   • ALL NEGATIVE (λi < 0)  -> LOCAL MAXIMUM (Hilltop / Optimal Peak!).                 │
│   • ALL POSITIVE (λi > 0)  -> LOCAL MINIMUM (Basin / Valley bottom).                   │
│   • MIXED SIGNS (+ and -)  -> SADDLE POINT (Minimax / Mountain Col).                   │
│   • ANY λi ≈ 0             -> RIDGE SYSTEM (Stationary / Rising Ridge).                │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 3 Fatal Exam Traps to Double-Check

1. **In Split-Plot R Terminal:** Did you create a **unique** whole-plot factor (`wp <- factor(rep(1:6, each=4))`)? If you code it `1, 2, 3, 1, 2, 3`, R will mistakenly treat it as blocks instead of whole plots!
2. **In Excel Split-Plot:** Did you multiply the whole-plot means SS by the number of subplots $b$? If you forget to multiply by $b$, your $SS_{A}$ and $SS_{WP}$ will be off by a factor of $b$!
3. **In RSM Lack-of-Fit:** Did you remember that a **large p-value ($p > 0.05$)** is what you want for Lack of Fit? In hypothesis testing, $p < 0.05$ usually means "significant", but for Lack of Fit, $p < 0.05$ means your model **failed**! $p > 0.05$ means your quadratic model is **adequate**.

