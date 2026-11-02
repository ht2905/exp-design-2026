# ==============================================================================
# 4. CENTRAL COMPOSITE DESIGN (CCD) RSM (CONCISE EXAM EDITION - COMPLETE OUTPUT)
# ==============================================================================
# Config: Edit dataset name, formula, alpha, and factor midpoints & half-steps below
# ------------------------------------------------------------------------------
if (!requireNamespace("rsm", quietly = TRUE) && file.exists("../../renv.lock")) renv::load("../..")
suppressPackageStartupMessages(library(rsm))

f <- if (file.exists("data.csv")) "data.csv" else "midterm-review/exercises/exercise-05_ccd/data.csv"
d <- read.csv(f)

# Fit second-order quadratic model
fit   <- rsm(titer ~ SO(x1, x2, x3), data = d)
a_rot <- 1.682                                   # alpha = (2^3)^0.25 = 1.682
mid   <- c(temp = 35.0, do = 40.0, feed = 15.0) # Factor midpoints (centers)
stp   <- c(temp = 2.0,  do = 10.0, feed = 3.0)  # Half-step sizes

# 1. Overview & 2. Model Coefficients
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
