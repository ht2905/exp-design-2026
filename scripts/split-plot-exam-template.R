# ==============================================================================
# MASTER EXAM TEMPLATE: SPLIT-PLOT DESIGN ANOVA (Base R)
# ==============================================================================
# Use this template during your exam for ANY split-plot problem.
# You only need to edit SECTION 1. Sections 2 to 5 remain 100% untouched.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. USER CONFIGURATION (ONLY EDIT THIS SECTION IN YOUR EXAM)
# ------------------------------------------------------------------------------

# --- Choose Input Mode: "CSV" or "MANUAL" ---
data_mode <- "CSV"

if (data_mode == "CSV") {
  # --- MODE A: Load from CSV File ---
  csv_file  <- if (file.exists("data.csv")) {
    "data.csv"
  } else if (file.exists("exercise-01_rcbd-split-plot/data.csv")) {
    "exercise-01_rcbd-split-plot/data.csv"
  } else {
    "exercise-02_crd-split-plot/data.csv"
  }
  col_resp  <- "plant_height"  # Name of response column (Y)
  col_wp    <- "irrigation"    # Name of Hard-to-Change (Whole-Plot) factor
  col_sp    <- "fertilizer"    # Name of Easy-to-Change (Subplot) factor
  col_block <- "block"         # Name of Block column (or Whole-Plot unit)
  
  raw_dat <- read.csv(csv_file)
  if (ncol(raw_dat) == 1) raw_dat <- read.table(csv_file, header = TRUE)
  names(raw_dat) <- trimws(names(raw_dat))
  
  raw_y     <- raw_dat[[col_resp]]
  raw_wp    <- raw_dat[[col_wp]]
  raw_sp    <- raw_dat[[col_sp]]
  raw_block <- raw_dat[[col_block]]
  
} else {
  # --- MODE B: Manual Vector Entry (if no CSV provided in exam) ---
  raw_y     <- c(38.2, 32.5, 35.6, 30.2, 28.4, 34.1) # Responses
  raw_wp    <- c(1, 1, 2, 2, 3, 3)                   # Whole-Plot Factor A
  raw_sp    <- c(1, 2, 1, 2, 2, 1)                   # Subplot Factor B
  raw_block <- c(1, 1, 1, 1, 1, 1)                   # Block or WP unit ID
}

# --- Choose Design Structure ---
# TRUE  = Split-Plot in RCBD (Field/Greenhouse default): Error(block / wp)
# FALSE = Split-Plot with CRD Whole Plots (Lab/Batches/Boards): Error(block)
has_blocks <- TRUE

# Standardize into clean working dataframe
dat <- data.frame(
  block = factor(raw_block),
  wp    = factor(raw_wp),
  sp    = factor(raw_sp),
  y     = raw_y
)

# ------------------------------------------------------------------------------
# 2. Fit Split-Plot ANOVA Model (DO NOT EDIT)
# ------------------------------------------------------------------------------
fit <- if (has_blocks) {
  aov(y ~ wp * sp + Error(block / wp), data = dat)
} else {
  aov(y ~ wp * sp + Error(block), data = dat)
}

# ------------------------------------------------------------------------------
# 3. Calculate Means (DO NOT EDIT)
# ------------------------------------------------------------------------------
cat("\n=== Grand Mean ===\n")
print(mean(dat$y))

cat("\n=== Block / WP-Unit Means ===\n")
print(aggregate(y ~ block, data = dat, FUN = mean))

cat("\n=== Whole-Plot Factor (wp) Means ===\n")
print(aggregate(y ~ wp, data = dat, FUN = mean))

cat("\n=== Subplot Factor (sp) Means ===\n")
print(aggregate(y ~ sp, data = dat, FUN = mean))

cat("\n=== wp × sp Interaction Means ===\n")
print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

# ------------------------------------------------------------------------------
# 4. View Results (DO NOT EDIT)
# ------------------------------------------------------------------------------
cat("\n=== Split-Plot ANOVA Results ===\n")
print(summary(fit))

# ------------------------------------------------------------------------------
# 5. Optional: Table 4 Extras (Total DF/SS, WP Error F/P)
# ------------------------------------------------------------------------------
# Use if professor blanks out Total row or WP Error F/P
total_df <- nrow(dat) - 1
total_ss <- sum((dat$y - mean(dat$y))^2)

s <- summary(fit)
wp_stratum <- if (has_blocks) s[[2]][[1]] else s[[1]][[1]]
sp_stratum <- s[[length(s)]][[1]]

ms_wp <- wp_stratum["Residuals", "Mean Sq"]
df_wp <- wp_stratum["Residuals", "Df"]
ms_sp <- sp_stratum["Residuals", "Mean Sq"]
df_sp <- sp_stratum["Residuals", "Df"]

f_wp <- ms_wp / ms_sp
p_wp <- 1 - pf(f_wp, df_wp, df_sp)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", total_df, "\n")
cat("Total SS   :", round(total_ss, 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\n")
cat("WP Error P :", round(p_wp, 5), "\n")
