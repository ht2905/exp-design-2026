# ==============================================================================
# EXERCISE 04: BOX-BEHNKEN DESIGN (BBD) ANALYSIS (R Terminal)
# ==============================================================================
# Biological Scenario: Recombinant Protein Extraction via Enzymatic Lysis
# Factors:
#   - Temperature (X1): 30 to 40 °C (Center = 35 °C, Half-step = 5 °C)
#   - Lysozyme Conc (X2): 0.5 to 1.5 mg/mL (Center = 1.0 mg/mL, Half-step = 0.5 mg/mL)
#   - Incubation Time (X3): 15 to 45 min (Center = 30 min, Half-step = 15 min)
# Response: Protein Yield (yield, mg/g dry cell weight)
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
} else if (file.exists("midterm-review/exercise-04_bbd/data.csv")) {
  "midterm-review/exercise-04_bbd/data.csv"
} else {
  "exercise-04_bbd/data.csv"
}

col_resp    <- "yield"
col_factors <- c("x1", "x2", "x3")

natural_coding <- list(
  temp   = c(center = 35.0, step = 5.0),
  enzyme = c(center = 1.0,  step = 0.5),
  time   = c(center = 30.0, step = 15.0)
)

raw_dat <- read.csv(csv_file)
if (ncol(raw_dat) == 1) raw_dat <- read.table(csv_file, header = TRUE)
names(raw_dat) <- trimws(names(raw_dat))

fmla <- as.formula(paste(col_resp, "~ SO(", paste(col_factors, collapse = ", "), ")"))
fit  <- rsm(fmla, data = raw_dat)
s    <- summary(fit)

cat("================================================================\n")
cat("  EXERCISE 04: BBD SECOND-ORDER RESPONSE SURFACE SUMMARY\n")
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
cat(sprintf("\nPredicted Max Yield at Optimum: %.4f mg/g\n", as.numeric(predict(fit, new_pt))))
cat("================================================================\n")
