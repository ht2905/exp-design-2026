# ==============================================================================
# Exercise 01: RCBD Split-Plot Design Analysis in Base R
# ==============================================================================
# Experimental Design Context:
# - Blocks (r = 4): Replicate blocks in field (e.g. soil/location gradients)
# - Whole-Plot Factor A: Irrigation (3 levels) -> Hard-to-change factor
# - Subplot Factor B: Fertilizer (2 levels)    -> Easy-to-change factor
# - Response: Plant Height (cm)
# - Total Whole Plots: 4 blocks * 3 irrigation = 12 whole plots
# - Total Subplots: 12 whole plots * 2 fertilizers = 24 observations
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Configuration & Input (Only modify this section in the exam!)
# ------------------------------------------------------------------------------
# CSV file path
csv_file <- if (file.exists("exercise-01_rcbd-split-plot/data.csv")) {
  "exercise-01_rcbd-split-plot/data.csv"
} else {
  "data.csv"
}

# Column mappings: match your exam dataset column names here
col_resp  <- "plant_height"  # Response variable
col_wp    <- "irrigation"    # Hard-to-change (Whole-Plot) factor
col_sp    <- "fertilizer"    # Easy-to-change (Subplot) factor
col_block <- "block"         # Replicate block (nuisance factor)

# Read raw data
raw_dat <- read.csv(csv_file)
names(raw_dat) <- trimws(names(raw_dat))

# Standardize columns into generic names (y, wp, sp, block)
# (Zero code changes needed below this line!)
dat <- data.frame(
  block = factor(raw_dat[[col_block]]),
  wp    = factor(raw_dat[[col_wp]]),
  sp    = factor(raw_dat[[col_sp]]),
  y     = raw_dat[[col_resp]]
)

# ------------------------------------------------------------------------------
# 2. Fit Split-Plot Model
# ------------------------------------------------------------------------------
# In a Randomized Complete Block Split-Plot design:
# Error(block / wp) tells R:
#   - Whole-plot units are the combinations of block and wp.
#   - wp is tested against Whole-Plot Error: MS(block:wp) [df = 6]
#   - sp and interaction (wp:sp) are tested against Subplot Error: MS(Within) [df = 9]
fit <- aov(y ~ wp * sp + Error(block / wp), data = dat)

# ------------------------------------------------------------------------------
# 3. Calculate Treatment Means
# ------------------------------------------------------------------------------
cat("\n=== Input Data ===\n")
print(dat)

cat("\n=== Grand Mean ===\n")
print(mean(dat$y))

cat("\n=== Block Means ===\n")
print(aggregate(y ~ block, data = dat, FUN = mean))

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
ms_wp <- s[[2]][[1]]["Residuals", "Mean Sq"]
df_wp <- s[[2]][[1]]["Residuals", "Df"]
ms_sp <- s[[3]][[1]]["Residuals", "Mean Sq"]
df_sp <- s[[3]][[1]]["Residuals", "Df"]

f_wp <- ms_wp / ms_sp
p_wp <- 1 - pf(f_wp, df_wp, df_sp)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", total_df, "\n")
cat("Total SS   :", round(total_ss, 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\n")
cat("WP Error P :", round(p_wp, 5), "\n")
