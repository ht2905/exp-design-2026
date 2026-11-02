renv::use("rsm", attach = TRUE)

f <- "data.csv"
d <- read.csv(f)

factor_cols <- c("temp", "do", "feed") # Three factors
resp_col    <- "titer" # Response variable
a_rot       <- 1.682 # Axial rotatable (\alpha axis)
mid         <- c(temp = 35.0, do = 40.0, feed = 15.0)
stp         <- c(temp = 2.0,  do = 10.0, feed = 3.0)

if (!all(c("x1", "x2", "x3") %in% names(d))) {
  d$x1 <- (d[[factor_cols[1]]] - mid[1]) / stp[1]
  d$x2 <- (d[[factor_cols[2]]] - mid[2]) / stp[2]
  d$x3 <- (d[[factor_cols[3]]] - mid[3]) / stp[3]
}

fit <- rsm(as.formula(paste(resp_col, "~ SO(x1, x2, x3)")), data = d)

s  <- summary(fit)
xs <- s$canonical$xs; ev <- s$canonical$eigen$values; d0 <- sqrt(sum(xs^2))

cat("\n=== 1. Input Data Overview & Design Geometry ===\n")
cat("N:", nrow(d), "| Factors:", paste(factor_cols, collapse = ", "), "-> Coded: x1, x2, x3 | Centers:", sum(d$x1 == 0 & d$x2 == 0 & d$x3 == 0), "\n")
cat(sprintf("Rotatability alpha: %.4f | Coding: x1=(%s-%.1f)/%.1f | x2=(%s-%.1f)/%.1f | x3=(%s-%.1f)/%.1f\n",
            a_rot,
            factor_cols[1], mid[1], stp[1],
            factor_cols[2], mid[2], stp[2],
            factor_cols[3], mid[3], stp[3]))
print(head(d[, c(factor_cols, "x1", "x2", "x3", resp_col)], 10))

cat("\n=== 2. Second-Order Model Coefficients ===\n"); print(round(coef(s), 5))
cat("Residual Std Error:", round(s$sigma, 5), "on", s$df[2], "DF | R-sq:", round(s$r.squared, 5), "| Adj R-sq:", round(s$adj.r.squared, 5), "\n")

cat("\n=== 3. ANOVA Decomposition (FO, TWI, PQ, Lack of Fit) ===\n"); print(s$lof)
cat("\n=== 4. Lack of Fit Diagnostic (Model Adequacy) ===\n")
f_l <- s$lof["Lack of fit", "F value"]; p_l <- s$lof["Lack of fit", "Pr(>F)"]
cat(sprintf("F_LOF = %.4f (df=%d,%d) | p = %.5f -> %s\n", f_l, s$lof["Lack of fit", "Df"], s$lof["Pure error", "Df"], p_l,
            if (p_l > 0.05) "ADEQUATE FIT (Fail to reject H0, p > 0.05)" else "LACK OF FIT DETECTED (p <= 0.05)"))

cat("\n=== 5. Stationary Point (x0) in Coded Units ===\n"); print(round(xs, 5))
cat(sprintf("Distance ||x0|| : %.4f -> %s\n", d0, if (d0 <= a_rot) sprintf("Inside CCD domain (||x0|| <= %.4f)", a_rot) else "Outside domain"))
cat("\n=== 6. Stationary Point in Natural Physical Units ===\n"); print(round(mid + xs * stp, 4))

cat("\n=== 7. Canonical / Eigenanalysis (Surface Characterization) ===\nEigenvalues:\n"); print(round(ev, 4))
cat("Surface Topology:", if (all(ev < 0)) "UNIQUE LOCAL MAXIMUM (Mountain Peak / Optimum)" else if (all(ev > 0)) "UNIQUE LOCAL MINIMUM (Valley)" else "SADDLE POINT (Minimax)", "\n")
cat("\nEigenvectors (Canonical Axes):\n"); print(round(s$canonical$eigen$vectors, 4))

cat("\n=== 8. Predicted Response at Stationary Point (y_opt) ===\n")
cat(sprintf("Predicted %s at Stationary Point: %.4f\n", resp_col, as.numeric(predict(fit, as.data.frame(as.list(xs))))))
