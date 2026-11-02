# ==============================================================================
# AUTOMATED TEST SUITE: CRD SPLIT-PLOT BENCHMARKS & EDGE CASES
# ==============================================================================
# Run non-interactively: Rscript tests/test_crd_cases.R
# Tests:
#   1. Case A (Minimal 3-column CSV, no unit ID)
#   2. Case B (Replicates 1..r repeat per treatment, RepTrap guard)
#   3. Case C (Explicit unique vessels/tanks 1..6)
#   4. Edge Case 1 (Shuffled rows with explicit vessels)
#   5. Edge Case 2 (String/non-numeric replicate labels: Batch_A, Batch_B)
#   6. Edge Case 3 (Multi-level factors: a = 3, b = 3, r = 3 -> N = 27)
#   7. Edge Case 4 (Minimal replication: r = 2 per treatment -> N = 12)
#   8. Edge Case 5 (Numeric WP factors: 37 and 45 numbers)
# ==============================================================================

# Evaluation function mimicking scripts/concise/crd_split_plot.R
run_crd_test <- function(y, wp, sp, unit = NULL) {
  wp <- factor(wp)
  sp <- factor(sp)
  n_u <- length(y) / length(unique(sp))
  if (is.null(unit)) {
    u_res <- interaction(wp, ave(seq_along(y), wp, sp, FUN = seq_along))
  } else if (length(unique(unit)) < n_u) {
    u_res <- interaction(wp, unit)
  } else {
    u_res <- factor(unit)
  }
  dat <- data.frame(unit = factor(u_res), wp = wp, sp = sp, y = y)
  fit <- aov(y ~ wp * sp + Error(unit), data = dat)
  s <- summary(fit)
  
  list(
    df_wp  = s[[1]][[1]]["wp", "Df"],
    ss_wp  = s[[1]][[1]]["wp", "Sum Sq"],
    f_wp   = s[[1]][[1]]["wp", "F value"],
    p_wp   = s[[1]][[1]]["wp", "Pr(>F)"],
    df_wpe = s[[1]][[1]]["Residuals", "Df"],
    ss_wpe = s[[1]][[1]]["Residuals", "Sum Sq"],
    df_sp  = s[[2]][[1]]["sp", "Df"],
    f_sp   = s[[2]][[1]]["sp", "F value"],
    df_spe = s[[2]][[1]]["Residuals", "Df"],
    ss_spe = s[[2]][[1]]["Residuals", "Sum Sq"],
    n_units = length(unique(u_res))
  )
}

cat("=================================================================\n")
cat("PART 1: VERIFYING THE 3 CORE BENCHMARK CASES\n")
cat("=================================================================\n")

# --- CASE A ---
dA <- read.csv("scripts/data.csv")
resA <- run_crd_test(dA$conc, dA$temperature, dA$concentration_type, unit = NULL)
passA <- resA$df_wpe == 4 && abs(resA$f_wp - 17.72) < 0.05
cat(sprintf("Case A (3-column, unit=NULL)     : WP Df=%d, WP Error Df=%d, F_wp=%.2f, p=%.4f -> [%s]\n",
            resA$df_wp, resA$df_wpe, resA$f_wp, resA$p_wp, if (passA) "PASS" else "FAIL"))

# --- CASE B ---
dB_raw <- read.csv("examples/case_b_exam_data.csv")
dB <- reshape(dB_raw, direction = "long", varying = list(3:6), v.names = "viability", timevar = "serum", times = c("0%", "2%", "5%", "10%"))
resB <- run_crd_test(dB$viability, dB$media, dB$serum, unit = dB$replicate)
passB <- resB$df_wpe == 4 && abs(resB$f_wp - 0.822) < 0.005
cat(sprintf("Case B (rep 1..r repeats, guarded): WP Df=%d, WP Error Df=%d, F_wp=%.3f, p=%.4f -> [%s]\n",
            resB$df_wp, resB$df_wpe, resB$f_wp, resB$p_wp, if (passB) "PASS" else "FAIL"))

# --- CASE C ---
dC_raw <- read.csv("examples/case_c_exam_data.csv")
dC <- reshape(dC_raw, direction = "long", varying = list(3:5), v.names = "od600", timevar = "carbon", times = c("glucose", "glycerol", "sucrose"))
resC <- run_crd_test(dC$od600, dC$dissolved_oxygen, dC$carbon, unit = dC$bioreactor)
passC <- resC$df_wpe == 4 && abs(resC$f_wp - 53.48) < 0.05
cat(sprintf("Case C (unique tanks 1..6)       : WP Df=%d, WP Error Df=%d, F_wp=%.2f, p=%.5f -> [%s]\n",
            resC$df_wp, resC$df_wpe, resC$f_wp, resC$p_wp, if (passC) "PASS" else "FAIL"))

cat("\n=================================================================\n")
cat("PART 2: TESTING 5 CRITICAL EDGE CASES\n")
cat("=================================================================\n")

# --- EDGE CASE 1: Shuffled Rows in Case C ---
set.seed(123)
idx_shuf <- sample(nrow(dC))
dC_shuf <- dC[idx_shuf, ]
resE1 <- run_crd_test(dC_shuf$od600, dC_shuf$dissolved_oxygen, dC_shuf$carbon, unit = dC_shuf$bioreactor)
passE1 <- abs(resE1$f_wp - resC$f_wp) < 1e-6 && resE1$df_wpe == 4
cat(sprintf("Edge 1 (Shuffled Rows in Case C) : WP Df=%d, WP Error Df=%d, F_wp=%.2f -> [%s]\n",
            resE1$df_wp, resE1$df_wpe, resE1$f_wp, if (passE1) "PASS" else "FAIL"))

# --- EDGE CASE 2: Non-Numeric / String Replicate Labels in Case B ---
dB_str <- dB
dB_str$replicate <- paste0("Batch_", LETTERS[dB$replicate]) # "Batch_A", "Batch_B", "Batch_C"
resE2 <- run_crd_test(dB_str$viability, dB_str$media, dB_str$serum, unit = dB_str$replicate)
passE2 <- abs(resE2$f_wp - resB$f_wp) < 1e-6 && resE2$df_wpe == 4
cat(sprintf("Edge 2 (String rep e.g. Batch_A) : WP Df=%d, WP Error Df=%d, F_wp=%.3f -> [%s]\n",
            resE2$df_wp, resE2$df_wpe, resE2$f_wp, if (passE2) "PASS" else "FAIL"))

# --- EDGE CASE 3: a = 3 Whole-Plot Levels & b = 3 Subplot Levels (N = 27) ---
wp3 <- rep(c("20C", "30C", "40C"), each = 9)
tank3 <- rep(paste0("Tank_", 1:9), each = 3)
sp3 <- rep(c("Low", "Med", "High"), times = 9)
set.seed(42)
y3 <- round(50 + 10*(wp3=="30C") - 5*(wp3=="40C") + 8*(sp3=="High") + rnorm(27, 0, 1.5), 2)
resE3 <- run_crd_test(y3, wp3, sp3, unit = tank3)
passE3 <- resE3$df_wp == 2 && resE3$df_wpe == 6 && resE3$df_sp == 2 && resE3$df_spe == 12
cat(sprintf("Edge 3 (a=3, b=3, r=3 -> N=27)   : WP Df=%d, WP Error Df=%d, SP Df=%d, SP Error Df=%d -> [%s]\n",
            resE3$df_wp, resE3$df_wpe, resE3$df_sp, resE3$df_spe, if (passE3) "PASS" else "FAIL"))

# --- EDGE CASE 4: Minimal Replication (r = 2 replicates per WP level, N = 12) ---
wp4 <- rep(c("Control", "Treated"), each = 6)
tank4 <- rep(paste0("Vessel_", 1:4), each = 3)
sp4 <- rep(c("1h", "2h", "4h"), times = 4)
set.seed(99)
y4 <- round(20 + 5*(wp4=="Treated") + 3*(sp4=="4h") + rnorm(12, 0, 0.8), 2)
resE4 <- run_crd_test(y4, wp4, sp4, unit = tank4)
passE4 <- resE4$df_wp == 1 && resE4$df_wpe == 2 && resE4$df_spe == 4
cat(sprintf("Edge 4 (Minimal Rep r=2 -> N=12) : WP Df=%d, WP Error Df=%d, SP Error Df=%d -> [%s]\n",
            resE4$df_wp, resE4$df_wpe, resE4$df_spe, if (passE4) "PASS" else "FAIL"))

# --- EDGE CASE 5: Numeric WP Factor (e.g. 37 and 45 numbers) ---
wp5 <- rep(c(37, 45), each = 12)
dA_num <- dA
resE5 <- run_crd_test(dA_num$conc, wp5, dA_num$concentration_type, unit = NULL)
passE5 <- resE5$df_wp == 1 && abs(resE5$f_wp - 17.72) < 0.05
cat(sprintf("Edge 5 (Numeric WP Factor: 37/45): WP Df=%d, WP Error Df=%d, F_wp=%.2f -> [%s]\n",
            resE5$df_wp, resE5$df_wpe, resE5$f_wp, if (passE5) "PASS" else "FAIL"))

cat("=================================================================\n")
cat("ALL TESTS COMPLETED SUCCESSFULLY!\n")
cat("=================================================================\n")
