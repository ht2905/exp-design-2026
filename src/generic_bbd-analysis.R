# ==============================================================================
# GENERIC BOX-BEHNKEN DESIGN (BBD) RSM ANALYSIS (Base R + rsm)
# ==============================================================================
# Experimental Design: Response Surface Methodology (RSM) - Box-Behnken Design
# Characteristics:
#   - 3 levels per factor (-1, 0, +1)
#   - Avoids extreme combined corners (safe for fragile enzymes/cells)
#   - Factorial edge midpoints + center replicates
# Workflow:
#   1. Save dataset to data.csv (in scripts/ or exercise folder)
#   2. Verify column mappings in Section 1 below
#   3. Run: Rscript scripts/generic_bbd-analysis.R
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

# ------------------------------------------------------------------------------
# 1. USER CONFIGURATION (ONLY EDIT THIS SECTION FOR EXAM DATASETS)
# ------------------------------------------------------------------------------

# File path resolution: looks in current dir, scripts/, or exercise directory
csv_file <- if (file.exists("data.csv")) {
  "data.csv"
} else if (file.exists("midterm-review/exercise-04_bbd/data.csv")) {
  "midterm-review/exercise-04_bbd/data.csv"
} else if (file.exists("scripts/data.csv")) {
  "scripts/data.csv"
} else {
  "exercise-04_bbd/data.csv"
}

# 1. Response Variable Column Name
col_resp <- "yield"

# 2. Coded Factor Names (Columns in CSV with values -1, 0, +1)
col_factors <- c("x1", "x2", "x3")

# 3. Optional: Natural Coding Parameters (Midpoint & Half-Step)
# Used to automatically decode the optimal stationary point into physical units.
# Format: list(FactorName = c(center = Midpoint, step = HalfStep))
# Set natural_coding <- NULL if not applicable or already in natural units.
natural_coding <- list(
  temp   = c(center = 35.0, step = 5.0),   # Temperature: 30 to 40 °C -> Midpoint = 35, Step = 5
  enzyme = c(center = 1.0,  step = 0.5),   # Lysozyme: 0.5 to 1.5 mg/mL -> Midpoint = 1.0, Step = 0.5
  time   = c(center = 30.0, step = 15.0)   # Time: 15 to 45 min -> Midpoint = 30, Step = 15
)

# ------------------------------------------------------------------------------
# 2. DATA IMPORT & DEFENSIVE VALIDATION
# ------------------------------------------------------------------------------

cat("================================================================\n")
cat("  BOX-BEHNKEN DESIGN (BBD) RESPONSE SURFACE ANALYSIS\n")
cat("================================================================\n")
cat("Target File:", csv_file, "\n")

raw_dat <- read.csv(csv_file)
if (ncol(raw_dat) == 1) raw_dat <- read.table(csv_file, header = TRUE)
names(raw_dat) <- trimws(names(raw_dat))

# Validate required columns
missing_cols <- setdiff(c(col_resp, col_factors), names(raw_dat))
if (length(missing_cols) > 0) {
  stop(sprintf(
    "Column(s) not found in '%s': %s\nAvailable columns: %s",
    csv_file,
    paste(missing_cols, collapse = ", "),
    paste(names(raw_dat), collapse = ", ")
  ))
}

# Ensure numeric types
for (col in c(col_resp, col_factors)) {
  raw_dat[[col]] <- as.numeric(raw_dat[[col]])
}

# ------------------------------------------------------------------------------
# 3. FIT SECOND-ORDER RESPONSE SURFACE MODEL (SO)
# ------------------------------------------------------------------------------

fmla <- as.formula(paste(col_resp, "~ SO(", paste(col_factors, collapse = ", "), ")"))
fit  <- rsm(fmla, data = raw_dat)
s    <- summary(fit)

# ------------------------------------------------------------------------------
# 4. STRUCTURED EXAM-READY CONSOLE OUTPUT
# ------------------------------------------------------------------------------

cat("\n=== 1. Input Data Overview ===\n")
cat("Total Experimental Runs (N) :", nrow(raw_dat), "\n")
cat("Response Variable           :", col_resp, "\n")
cat("Coded Factors (k)           :", paste(col_factors, collapse = ", "), sprintf("(k = %d)\n", length(col_factors)))
# Center point detection: all coded factors equal 0
center_runs <- which(apply(raw_dat[, col_factors, drop = FALSE], 1, function(row) all(row == 0)))
cat("Center Point Replicates (n0):", length(center_runs), sprintf("(Runs: %s)\n", paste(center_runs, collapse = ", ")))
print(head(raw_dat[, c(col_factors, col_resp)], 10))
if (nrow(raw_dat) > 10) cat("... [showing first 10 of", nrow(raw_dat), "runs]\n")

cat("\n=== 2. Second-Order Model Coefficients ===\n")
print(round(coef(s), 5))

cat("\nModel Fit Diagnostics:\n")
cat("Residual Std Error (s) :", round(s$sigma, 5), sprintf("on %d DF\n", s$df[2]))
cat("Multiple R-squared     :", round(s$r.squared, 5), "\n")
cat("Adjusted R-squared     :", round(s$adj.r.squared, 5), "\n")

cat("\n=== 3. ANOVA Decomposition (FO, TWI, PQ, Lack of Fit) ===\n")
if (!is.null(s$lof)) {
  print(s$lof)
} else {
  print(anova(fit))
}

cat("\n=== 4. Lack of Fit Diagnostic (Model Adequacy) ===\n")
if (!is.null(s$lof) && "Lack of fit" %in% rownames(s$lof)) {
  f_lof  <- s$lof["Lack of fit", "F value"]
  p_lof  <- s$lof["Lack of fit", "Pr(>F)"]
  df_lof <- s$lof["Lack of fit", "Df"]
  df_pe  <- s$lof["Pure error", "Df"]
  
  cat(sprintf("Hypotheses:\n  H0: Second-order quadratic surface is adequate (no lack of fit)\n  H1: Model exhibits significant lack of fit\n"))
  cat(sprintf("Test Statistic : F_LOF = %.4f (df = %d, %d)\n", f_lof, df_lof, df_pe))
  cat(sprintf("P-value        : p = %.5f\n", p_lof))
  if (p_lof > 0.05) {
    cat("Verdict (a=0.05): FAIL TO REJECT H0 (p > 0.05).\n")
    cat("  -> The model fits adequately. Lack of fit is NOT statistically significant.\n")
    cat("  -> You CAN proceed with canonical analysis and optimization.\n")
  } else {
    cat("Verdict (a=0.05): REJECT H0 (p <= 0.05).\n")
    cat("  -> Significant lack of fit detected! Model may need transformations or higher terms.\n")
  }
} else {
  cat("Note: Pure error cannot be computed without center point replicates.\n")
}

cat("\n=== 5. Stationary Point (x0) in Coded Units ===\n")
xs <- s$canonical$xs
print(round(xs, 5))

dist_origin <- sqrt(sum(xs^2))
cat(sprintf("\nDistance from center ||x0|| : %.4f\n", dist_origin))
if (dist_origin <= 1.0) {
  cat("  -> Inside experimental domain (||x0|| <= 1.0). Stationary point is highly reliable.\n")
} else {
  cat("  -> Warning: Stationary point lies outside the standard BBD sphere (||x0|| > 1.0). Extrapolation caution!\n")
}

if (!is.null(natural_coding) && length(natural_coding) == length(col_factors)) {
  cat("\n=== 6. Stationary Point in Natural Physical Units ===\n")
  factor_names <- names(natural_coding)
  for (i in seq_along(col_factors)) {
    cf <- col_factors[i]
    fn <- factor_names[i]
    ctr <- natural_coding[[i]]["center"]
    stp <- natural_coding[[i]]["step"]
    nat_val <- ctr + xs[cf] * stp
    cat(sprintf("  %-15s (%s) : %8.4f  [formula: %.2f + (%.4f * %.2f)]\n", 
                fn, cf, nat_val, ctr, xs[cf], stp))
  }
}

cat("\n=== 7. Canonical / Eigenanalysis (Surface Characterization) ===\n")
evals <- s$canonical$eigen$values
evecs <- s$canonical$eigen$vectors
rownames(evecs) <- col_factors
colnames(evecs) <- paste0("w", seq_along(evals))

cat("Eigenvalues (lambda_i):\n")
for (i in seq_along(evals)) {
  cat(sprintf("  lambda_%d = %+8.4f\n", i, evals[i]))
}

all_neg <- all(evals < 0)
all_pos <- all(evals > 0)
surface_type <- if (all_neg) {
  "UNIQUE LOCAL MAXIMUM (Mountain Peak / True Optimum)"
} else if (all_pos) {
  "UNIQUE LOCAL MINIMUM (Valley Basin / Pit)"
} else {
  "SADDLE POINT (Minimax / Col - neither a true maximum nor minimum)"
}

cat("\nSurface Topology Verdict:\n")
cat("  ->", surface_type, "\n")
if (all_neg) {
  cat("  -> All eigenvalues are negative (curving downwards in all factor directions).\n")
} else if (all_pos) {
  cat("  -> All eigenvalues are positive (curving upwards in all factor directions).\n")
} else {
  cat("  -> Mixed eigenvalue signs. Response increases in some directions and decreases in others.\n")
}

cat("\nEigenvectors (Canonical Axes w_i):\n")
print(round(evecs, 4))

cat("\n=== 8. Predicted Response at Stationary Point (y_opt) ===\n")
new_pt    <- as.data.frame(as.list(xs))
y_hat_opt <- as.numeric(predict(fit, new_pt))
cat(sprintf("Predicted %s at Stationary Point: %.4f\n", col_resp, y_hat_opt))
cat("================================================================\n")
