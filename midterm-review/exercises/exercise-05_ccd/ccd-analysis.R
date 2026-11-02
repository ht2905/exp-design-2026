# ==============================================================================
# EXERCISE 05: CENTRAL COMPOSITE DESIGN (CCD) ANALYSIS (R Terminal)
# ==============================================================================
# Biological Scenario: Optimizing Monoclonal Antibody (mAb) Production in CHO Cells
# Factors:
#   - Temperature (X1): 31.64 to 38.36 °C (Center = 35.0 °C, Half-step = 2.0 °C)
#   - Dissolved Oxygen (X2): 23.18 to 56.82 % (Center = 40.0 %, Half-step = 10.0 %)
#   - Feed Rate (X3): 9.95 to 20.05 g/L/d (Center = 15.0 g/L/d, Half-step = 3.0 g/L/d)
# Response: mAb Titer (titer, g/L)
# Geometry: Rotatable CCD (k = 3, alpha = 2^(3/4) = 1.682, N = 20)
# ==============================================================================

# Ensure project environment and packages are loaded if run from subfolder
if (!requireNamespace("rsm", quietly = TRUE)) {
  p <- "."
  for (i in 1:4) {
    if (file.exists(file.path(p, "renv.lock"))) {
      renv::load(normalizePath(p))
      break
    }
    p <- file.path("..", p)
  }
}
suppressPackageStartupMessages(library(rsm))

csv_file <- if (file.exists("data.csv")) {
  "data.csv"
} else if (file.exists("midterm-review/exercise-05_ccd/data.csv")) {
  "midterm-review/exercise-05_ccd/data.csv"
} else {
  "exercise-05_ccd/data.csv"
}

col_resp    <- "titer"
col_factors <- c("x1", "x2", "x3")

natural_coding <- list(
  temp = c(center = 35.0, step = 2.0),
  do   = c(center = 40.0, step = 10.0),
  feed = c(center = 15.0, step = 3.0)
)

raw_dat <- read.csv(csv_file)
if (ncol(raw_dat) == 1) raw_dat <- read.table(csv_file, header = TRUE)
names(raw_dat) <- trimws(names(raw_dat))

fmla <- as.formula(paste(col_resp, "~ SO(", paste(col_factors, collapse = ", "), ")"))
fit  <- rsm(fmla, data = raw_dat)
s    <- summary(fit)

cat("================================================================\n")
cat("  EXERCISE 05: CCD SECOND-ORDER RESPONSE SURFACE SUMMARY\n")
cat("================================================================\n")
print(s)

cat("\n=== Lack-of-Fit Test ===\n")
if (!is.null(s$lof)) {
  f_val <- s$lof["Lack of fit", "F value"]
  p_val <- s$lof["Lack of fit", "Pr(>F)"]
  cat(sprintf("F_LOF = %.4f, p-value = %.5f\n", f_val, p_val))
  if (p_val > 0.05) {
    cat("Conclusion: Fail to reject H0 (p > 0.05). Second-order quadratic model fits adequately!\n")
  } else {
    cat("Conclusion: Reject H0 (p <= 0.05). Significant lack of fit detected.\n")
  }
}

cat("\n=== Canonical Optimization ===\n")
xs <- s$canonical$xs
cat("Stationary Point (Coded):\n")
print(xs)

dist_origin <- sqrt(sum(xs^2))
cat(sprintf("Distance from center ||x0||: %.4f (Rotatable alpha = 1.682)\n", dist_origin))
if (dist_origin <= 1.682) {
  cat("  -> Inside rotatable sphere. Solution is physically valid and reliable.\n")
} else {
  cat("  -> Warning: Stationary point extrapolated beyond the rotatable sphere!\n")
}

cat("\nStationary Point (Physical Units):\n")
factor_names <- names(natural_coding)
for (i in seq_along(col_factors)) {
  cf <- col_factors[i]
  fn <- factor_names[i]
  ctr <- natural_coding[[i]]["center"]
  stp <- natural_coding[[i]]["step"]
  nat_val <- ctr + xs[cf] * stp
  cat(sprintf("  %-15s (%s) : %8.4f\n", fn, cf, nat_val))
}

evals <- s$canonical$eigen$values
cat("\nEigenvalues:\n")
print(evals)
if (all(evals < 0)) {
  cat("Verdict: All eigenvalues < 0 -> Stationary point is a UNIQUE LOCAL MAXIMUM (Peak).\n")
} else if (all(evals > 0)) {
  cat("Verdict: All eigenvalues > 0 -> Stationary point is a UNIQUE LOCAL MINIMUM (Pit).\n")
} else {
  cat("Verdict: Mixed eigenvalue signs -> Stationary point is a SADDLE POINT.\n")
}

new_pt <- as.data.frame(as.list(xs))
cat(sprintf("\nPredicted Max Titer at Optimum: %.4f g/L\n", as.numeric(predict(fit, new_pt))))
cat("================================================================\n")
