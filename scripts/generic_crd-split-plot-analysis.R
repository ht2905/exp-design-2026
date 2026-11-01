csv_file <- "data.csv"

# Column mappings: match your exam dataset column names here
col_resp <- "conc"                # Response variable (e.g. protein yield mg/mL)
col_wp   <- "temperature"         # Hard-to-change (Whole-Plot) factor
col_sp   <- "concentration_type"  # Easy-to-change (Subplot) factor

# Whole-Plot Unit Mapping:
# - Scenario A (3-column CSV: resp, wp, sp)          -> Set col_unit <- NULL
# - Scenario B (Replicate column repeats 1..r)       -> Set col_unit <- "rep" (guard auto-combines)
# - Scenario C (Explicit unique unit IDs like 1..6)  -> Set col_unit <- "tank" (or "board")
col_unit <- NULL

# Defensive whitespace trimming
col_resp <- trimws(col_resp)
col_wp   <- trimws(col_wp)
col_sp   <- trimws(col_sp)
if (!is.null(col_unit)) col_unit <- trimws(col_unit)

raw_dat <- read.csv(csv_file)
if (ncol(raw_dat) == 1) raw_dat <- read.table(csv_file, header = TRUE)
names(raw_dat) <- trimws(names(raw_dat))

# Validate required columns exist in data
missing_cols <- setdiff(c(col_resp, col_wp, col_sp), names(raw_dat))
if (length(missing_cols) > 0) {
  stop(sprintf(
    "Column(s) not found in '%s': %s\nAvailable columns: %s",
    csv_file,
    paste(missing_cols, collapse = ", "),
    paste(names(raw_dat), collapse = ", ")
  ))
}

has_unit <- !is.null(col_unit) && nzchar(col_unit) && (col_unit %in% names(raw_dat))
unit_ids <- if (has_unit) {
  unit_val <- raw_dat[[col_unit]]
  n_total_units <- nrow(raw_dat) / length(unique(raw_dat[[col_sp]]))
  # Guard: If replicate numbers repeat per treatment (e.g. 1..r), combine with wp
  if (length(unique(unit_val)) < n_total_units) {
    interaction(raw_dat[[col_wp]], unit_val)
  } else {
    unit_val
  }
} else {
  rep_idx <- ave(seq_len(nrow(raw_dat)), raw_dat[[col_wp]], raw_dat[[col_sp]], FUN = seq_along)
  interaction(raw_dat[[col_wp]], rep_idx)
}

dat <- data.frame(
  unit = factor(unit_ids),
  wp   = factor(raw_dat[[col_wp]]),
  sp   = factor(raw_dat[[col_sp]]),
  y    = raw_dat[[col_resp]]
)

fit <- aov(y ~ wp * sp + Error(unit), data = dat)

cat("\n=== Input Data ===\n")
print(dat)

cat("\n=== Grand Mean ===\n")
print(mean(dat$y))

cat("\n=== Whole-Plot Unit Means ===\n")
print(aggregate(y ~ unit, data = dat, FUN = mean))

cat("\n=== Whole-Plot Factor (wp) Means ===\n")
print(aggregate(y ~ wp, data = dat, FUN = mean))

cat("\n=== Subplot Factor (sp) Means ===\n")
print(aggregate(y ~ sp, data = dat, FUN = mean))

cat("\n=== wp × sp Interaction Means ===\n")
print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

cat("\n=== Split-Plot ANOVA Results ===\n")
print(summary(fit))

total_df <- nrow(dat) - 1
total_ss <- sum((dat$y - mean(dat$y))^2)

s <- summary(fit)
ms_wp <- s[[1]][[1]]["Residuals", "Mean Sq"]
df_wp <- s[[1]][[1]]["Residuals", "Df"]
ms_sp <- s[[2]][[1]]["Residuals", "Mean Sq"]
df_sp <- s[[2]][[1]]["Residuals", "Df"]

f_wp <- ms_wp / ms_sp
p_wp <- 1 - pf(f_wp, df_wp, df_sp)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", total_df, "\n")
cat("Total SS   :", round(total_ss, 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\n")
cat("WP Error P :", round(p_wp, 5), "\n")
