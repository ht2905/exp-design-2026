# ==============================================================================
# Exercise 02: CRD Split-Plot Design Analysis in Base R
# ==============================================================================
# Experimental Design Context:
# - Design: Split-Plot with Completely Randomized Design (CRD) at whole-plot level.
#   Notice: There is NO nuisance blocking factor (no days, operators, or fields).
# - Whole-Plot Units (wplot): 6 wooden boards (3 boards per pretreatment).
# - Whole-Plot Factor A: Pretreat (2 levels) -> Hard-to-change factor (applied to entire boards).
# - Subplot Factor B: Stain (4 levels)       -> Easy-to-change factor (applied to cut pieces).
# - Response: Resistance (water resistance property of wood).
# - Total Whole Plots: 2 pretreatments * 3 replicates = 6 boards.
# - Total Subplots: 6 boards * 4 stains = 24 observations.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Configuration & Input (Only modify this section in the exam!)
# ------------------------------------------------------------------------------
# CSV file path
csv_file <- if (file.exists("exercise-02_crd-split-plot/data.csv")) {
  "exercise-02_crd-split-plot/data.csv"
} else {
  "data.csv"
}

# Column mappings: match your exam dataset column names here
col_resp  <- "resistance"  # Response variable
col_wp    <- "pretreat"    # Hard-to-change (Whole-Plot) factor
col_sp    <- "stain"       # Easy-to-change (Subplot) factor

# Read raw data
raw_dat <- read.csv(csv_file)
names(raw_dat) <- trimws(names(raw_dat))

# Assign Whole-Plot Unit IDs:
# If CSV has a board/batch/unit column, use it; otherwise assign 1:6
wplot_ids <- if ("board" %in% names(raw_dat)) {
  raw_dat[["board"]]
} else {
  rep(1:6, times = 4)
}

# Standardize columns into generic names (y, wp, sp, wplot)
# (Zero code changes needed below this line!)
dat <- data.frame(
  wplot = factor(wplot_ids),
  wp    = factor(raw_dat[[col_wp]]),
  sp    = factor(raw_dat[[col_sp]]),
  y     = raw_dat[[col_resp]]
)

# ------------------------------------------------------------------------------
# 2. Fit Split-Plot Model
# ------------------------------------------------------------------------------
# In a CRD Split-Plot design:
# Error(wplot) tells R:
#   - Whole-plot experimental units are the 6 boards (wplot).
#   - wp is tested against Whole-Plot Error: MS(wplot) [df = 4]
#   - sp and interaction (wp:sp) are tested against Subplot Error: MS(Within) [df = 12]
fit <- aov(y ~ wp * sp + Error(wplot), data = dat)

# ------------------------------------------------------------------------------
# 3. Calculate Treatment Means
# ------------------------------------------------------------------------------
cat("\n=== Input Data ===\n")
print(dat)

cat("\n=== Grand Mean ===\n")
print(mean(dat$y))

cat("\n=== Whole-Plot Unit (Board) Means ===\n")
print(aggregate(y ~ wplot, data = dat, FUN = mean))

cat("\n=== Whole-Plot Factor (wp) Means ===\n")
print(aggregate(y ~ wp, data = dat, FUN = mean))

cat("\n=== Subplot Factor (sp) Means ===\n")
print(aggregate(y ~ sp, data = dat, FUN = mean))

cat("\n=== wp × sp Interaction Means ===\n")
print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

# ------------------------------------------------------------------------------
# 4. View Results
# ------------------------------------------------------------------------------
cat("\n=== Split-Plot ANOVA Results ===\n")
print(summary(fit))

# ------------------------------------------------------------------------------
# 5. Optional: Table 4 Extras (Total DF/SS, WP Error F/P)
# ------------------------------------------------------------------------------
# Only use if professor asks to fill in omitted fields
total_df <- nrow(dat) - 1
total_ss <- sum((dat$y - mean(dat$y))^2)

s <- summary(fit)
ms_wp <- s[["Error: wplot"]][[1]]["Residuals", "Mean Sq"]
df_wp <- s[["Error: wplot"]][[1]]["Residuals", "Df"]
ms_sp <- s[["Error: Within"]][[1]]["Residuals", "Mean Sq"]
df_sp <- s[["Error: Within"]][[1]]["Residuals", "Df"]

f_wp <- ms_wp / ms_sp
p_wp <- 1 - pf(f_wp, df_wp, df_sp)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", total_df, "\n")
cat("Total SS   :", round(total_ss, 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\n")
cat("WP Error P :", round(p_wp, 5), "\n")
