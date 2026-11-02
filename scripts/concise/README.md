# Exam-Optimized Concise Scripts (Complete Output Edition)

This folder contains **ultra-dense, handwrite-friendly versions** of all four core experimental design scripts.

### Design Principles:
1. **Short, linear code:** No long `if-else` guessing ladders. Clean and easy to handwrite onto physical A4 paper.
2. **Explicit manual config:** Simply map your 3–4 variables (`y`, `wp`, `sp`, `unit` or `mid`/`stp`) at the top of the script.
3. **100% Complete Output:** Retains every single output from the original full generic scripts (all means, interaction means, ANOVA tables, Total SS/DF, WP Error F/P, coefficients, $R^2$, Lack-of-Fit test, stationary points, eigenvalues/vectors, and predicted optima).

---

## Script Index & File Links

| Script File | Target Experimental Design | Lines | Manual Config Items |
| :--- | :--- | :---: | :--- |
| **[`scripts/concise/crd_split_plot.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/crd_split_plot.R)** | **CRD Split-Plot** | **25** | `y`, `wp`, `sp`, `unit` (`NULL` or `d$rep` / `d$tank`) |
| **[`scripts/concise/rcbd_split_plot.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/rcbd_split_plot.R)** | **RCBD Split-Plot** | **25** | `y`, `wp`, `sp`, `block` |
| **[`scripts/concise/bbd_rsm.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/bbd_rsm.R)** | **Box-Behnken (BBD)** | **28** | Formula `y ~ SO(x1, x2, x3)`, `mid`, `stp` |
| **[`scripts/concise/ccd_rsm.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/ccd_rsm.R)** | **Central Composite (CCD)** | **29** | Formula `y ~ SO(x1, x2, x3)`, `a_rot`, `mid`, `stp` |

---

## Clean Handwritten Code (Copy Directly to A4 Paper)

### SIDE 1: Split-Plot Designs

#### 1. CRD Split-Plot ([`crd_split_plot.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/crd_split_plot.R))
```r
d <- read.csv("data.csv")

# 1. Config: edit column names to match your exam paper
y    <- d$conc                # Response variable
wp   <- factor(d$temperature) # Hard-to-change (Whole-Plot) factor
sp   <- factor(d$concentration_type) # Easy-to-change (Subplot) factor
unit <- NULL                  # Set NULL for Case A; or d$rep / d$tank if given

# 2. Whole-plot unit resolution (Case A, B, and C)
if (is.null(unit)) {
  unit <- interaction(wp, ave(seq_along(y), wp, sp, FUN = seq_along))
} else if (length(unique(unit)) < length(y) / length(unique(sp))) {
  unit <- interaction(wp, unit) # Guard: auto-combine if rep repeats 1..r
}
dat <- data.frame(unit = factor(unit), wp, sp, y)

# 3. Model & All Output Means
fit <- aov(y ~ wp * sp + Error(unit), data = dat)
cat("\n=== Input Data ===\n"); print(dat)
cat("\n=== Grand Mean ===\n", mean(y), "\n")
cat("\n=== Whole-Plot Unit Means ===\n"); print(aggregate(y ~ unit, data = dat, FUN = mean))
cat("\n=== Whole-Plot Factor (wp) Means ===\n"); print(aggregate(y ~ wp, data = dat, FUN = mean))
cat("\n=== Subplot Factor (sp) Means ===\n"); print(aggregate(y ~ sp, data = dat, FUN = mean))
cat("\n=== wp x sp Interaction Means ===\n"); print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

# 4. Split-Plot ANOVA Table & Table 4 Extras
cat("\n=== Split-Plot ANOVA Results ===\n"); print(summary(fit))
s <- summary(fit)
ms_w <- s[[1]][[1]]["Residuals", "Mean Sq"]; df_w <- s[[1]][[1]]["Residuals", "Df"]
ms_s <- s[[2]][[1]]["Residuals", "Mean Sq"]; df_s <- s[[2]][[1]]["Residuals", "Df"]
f_wp <- ms_w / ms_s; p_wp <- 1 - pf(f_wp, df_w, df_s)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", nrow(dat) - 1, "\nTotal SS   :", round(sum((y - mean(y))^2), 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\nWP Error P :", round(p_wp, 5), "\n")
```

---

#### 2. RCBD Split-Plot ([`rcbd_split_plot.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/rcbd_split_plot.R))
```r
d <- read.csv("data.csv")

# 1. Config: edit column names to match your exam paper
y     <- d$cell_growth  # Response variable
wp    <- factor(d$temp) # Hard-to-change (Whole-Plot) factor
sp    <- factor(d$medium) # Easy-to-change (Subplot) factor
block <- factor(d$block) # Nuisance block (Day/Operator/Field)
dat   <- data.frame(block, wp, sp, y)

# 2. Model & All Output Means
fit <- aov(y ~ wp * sp + Error(block / wp), data = dat)
cat("\n=== Input Data ===\n"); print(dat)
cat("\n=== Grand Mean ===\n", mean(y), "\n")
cat("\n=== Block Means ===\n"); print(aggregate(y ~ block, data = dat, FUN = mean))
cat("\n=== Whole-Plot Factor (wp) Means ===\n"); print(aggregate(y ~ wp, data = dat, FUN = mean))
cat("\n=== Subplot Factor (sp) Means ===\n"); print(aggregate(y ~ sp, data = dat, FUN = mean))
cat("\n=== wp x sp Interaction Means ===\n"); print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

# 3. Split-Plot ANOVA Table & Table 4 Extras
cat("\n=== Split-Plot ANOVA Results ===\n"); print(summary(fit))
s <- summary(fit)
ms_w <- s[[2]][[1]]["Residuals", "Mean Sq"]; df_w <- s[[2]][[1]]["Residuals", "Df"]
ms_s <- s[[3]][[1]]["Residuals", "Mean Sq"]; df_s <- s[[3]][[1]]["Residuals", "Df"]
f_wp <- ms_w / ms_s; p_wp <- 1 - pf(f_wp, df_w, df_s)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", nrow(dat) - 1, "\nTotal SS   :", round(sum((y - mean(y))^2), 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\nWP Error P :", round(p_wp, 5), "\n")
```

---

### SIDE 2: Response Surface Methodology (RSM)

#### 3. Box-Behnken Design ([`bbd_rsm.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/bbd_rsm.R))
```r
library(rsm)
d <- read.csv("data.csv")

# 1. Config: model formula and factor midpoints & half-steps
fit <- rsm(yield ~ SO(x1, x2, x3), data = d)
mid <- c(temp = 35.0, enzyme = 1.0, time = 30.0) # Midpoints
stp <- c(temp = 5.0,  enzyme = 0.5, time = 15.0) # Half-steps

# 2. Model Summary & Coefficients
s  <- summary(fit)
xs <- s$canonical$xs; ev <- s$canonical$eigen$values; d0 <- sqrt(sum(xs^2))

cat("\n=== 1. Input Data Overview ===\nN:", nrow(d), "| Factors: x1, x2, x3 | Centers:", sum(d$x1 == 0 & d$x2 == 0 & d$x3 == 0), "\n")
print(head(d[, c("x1", "x2", "x3", "yield")], 10))

cat("\n=== 2. Second-Order Model Coefficients ===\n"); print(round(coef(s), 5))
cat("Residual Std Error:", round(s$sigma, 5), "on", s$df[2], "DF | R-sq:", round(s$r.squared, 5), "| Adj R-sq:", round(s$adj.r.squared, 5), "\n")

# 3. ANOVA Table & 4. Lack of Fit Diagnostic
cat("\n=== 3. ANOVA Decomposition (FO, TWI, PQ, Lack of Fit) ===\n"); print(s$lof)
cat("\n=== 4. Lack of Fit Diagnostic (Model Adequacy) ===\n")
f_l <- s$lof["Lack of fit", "F value"]; p_l <- s$lof["Lack of fit", "Pr(>F)"]
cat(sprintf("F_LOF = %.4f (df=%d,%d) | p = %.5f -> %s\n", f_l, s$lof["Lack of fit", "Df"], s$lof["Pure error", "Df"], p_l,
            if (p_l > 0.05) "ADEQUATE FIT (Fail to reject H0, p > 0.05)" else "LACK OF FIT DETECTED (p <= 0.05)"))

# 5. Coded Stationary Point & 6. Natural Physical Units
cat("\n=== 5. Stationary Point (x0) in Coded Units ===\n"); print(round(xs, 5))
cat(sprintf("Distance ||x0|| : %.4f -> %s\n", d0, if (d0 <= 1) "Inside BBD domain (||x0|| <= 1.0)" else "Outside domain"))
cat("\n=== 6. Stationary Point in Natural Physical Units ===\n"); print(round(mid + xs * stp, 4))

# 7. Canonical / Eigenanalysis & 8. Predicted Optimum
cat("\n=== 7. Canonical / Eigenanalysis (Surface Characterization) ===\nEigenvalues:\n"); print(round(ev, 4))
cat("Surface Topology:", if (all(ev < 0)) "UNIQUE LOCAL MAXIMUM (Mountain Peak / Optimum)" else if (all(ev > 0)) "UNIQUE LOCAL MINIMUM (Valley)" else "SADDLE POINT (Minimax)", "\n")
cat("\nEigenvectors (Canonical Axes):\n"); print(round(s$canonical$eigen$vectors, 4))

cat("\n=== 8. Predicted Response at Stationary Point (y_opt) ===\n")
cat("Predicted yield at Stationary Point:", round(as.numeric(predict(fit, as.data.frame(as.list(xs)))), 4), "\n")
```

---

#### 4. Central Composite Design ([`ccd_rsm.R`](file:///home/ht2905/projects/exp-design_2026-2027/scripts/concise/ccd_rsm.R))
```r
library(rsm)
d <- read.csv("data.csv")

# 1. Config: model formula, alpha, and factor midpoints & half-steps
fit   <- rsm(titer ~ SO(x1, x2, x3), data = d)
a_rot <- 1.682                                   # alpha = (2^3)^0.25 = 1.682
mid   <- c(temp = 35.0, do = 40.0, feed = 15.0) # Midpoints
stp   <- c(temp = 2.0,  do = 10.0, feed = 3.0)  # Half-steps

# 2. Model Summary & Coefficients
s  <- summary(fit)
xs <- s$canonical$xs; ev <- s$canonical$eigen$values; d0 <- sqrt(sum(xs^2))

cat("\n=== 1. Input Data Overview & Design Geometry ===\nN:", nrow(d), "| Factors: x1, x2, x3 | Centers:", sum(d$x1 == 0 & d$x2 == 0 & d$x3 == 0), "\n")
cat(sprintf("Rotatability alpha: %.4f | Observed max |x|: %.4f (Rotatable CCD)\n", a_rot, max(abs(d$x1))))
print(head(d[, c("x1", "x2", "x3", "titer")], 10))

cat("\n=== 2. Second-Order Model Coefficients ===\n"); print(round(coef(s), 5))
cat("Residual Std Error:", round(s$sigma, 5), "on", s$df[2], "DF | R-sq:", round(s$r.squared, 5), "| Adj R-sq:", round(s$adj.r.squared, 5), "\n")

# 3. ANOVA Table & 4. Lack of Fit Diagnostic
cat("\n=== 3. ANOVA Decomposition (FO, TWI, PQ, Lack of Fit) ===\n"); print(s$lof)
cat("\n=== 4. Lack of Fit Diagnostic (Model Adequacy) ===\n")
f_l <- s$lof["Lack of fit", "F value"]; p_l <- s$lof["Lack of fit", "Pr(>F)"]
cat(sprintf("F_LOF = %.4f (df=%d,%d) | p = %.5f -> %s\n", f_l, s$lof["Lack of fit", "Df"], s$lof["Pure error", "Df"], p_l,
            if (p_l > 0.05) "ADEQUATE FIT (Fail to reject H0, p > 0.05)" else "LACK OF FIT DETECTED (p <= 0.05)"))

# 5. Coded Stationary Point & 6. Natural Physical Units
cat("\n=== 5. Stationary Point (x0) in Coded Units ===\n"); print(round(xs, 5))
cat(sprintf("Distance ||x0|| : %.4f -> %s\n", d0, if (d0 <= a_rot) sprintf("Inside domain (||x0|| <= alpha = %.4f)", a_rot) else "Outside domain"))
cat("\n=== 6. Stationary Point in Natural Physical Units ===\n"); print(round(mid + xs * stp, 4))

# 7. Canonical / Eigenanalysis & 8. Predicted Optimum
cat("\n=== 7. Canonical / Eigenanalysis (Surface Characterization) ===\nEigenvalues:\n"); print(round(ev, 4))
cat("Surface Topology:", if (all(ev < 0)) "UNIQUE LOCAL MAXIMUM (Mountain Peak / Optimum)" else if (all(ev > 0)) "UNIQUE LOCAL MINIMUM (Valley)" else "SADDLE POINT (Minimax)", "\n")
cat("\nEigenvectors (Canonical Axes):\n"); print(round(s$canonical$eigen$vectors, 4))

cat("\n=== 8. Predicted Response at Stationary Point (y_opt) ===\n")
cat("Predicted titer at Stationary Point:", round(as.numeric(predict(fit, as.data.frame(as.list(xs)))), 4), "\n")
```
