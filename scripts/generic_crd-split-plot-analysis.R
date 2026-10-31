csv_file <- if (file.exists("data.csv")) "data.csv" else "exercise-02_crd-split-plot/data.csv"

# Column mappings: match your exam dataset column names here
col_resp  <- "resistance"  # Response variable
col_wp    <- "pretreat"    # Hard-to-change (Whole-Plot) factor
col_sp    <- "stain"       # Easy-to-change (Subplot) factor
col_block <- "board"       # Replicate block (nuisance factor)

raw_dat <- read.csv(csv_file)
if (ncol(raw_dat) == 1) raw_dat <- read.table(csv_file, header = TRUE)
names(raw_dat) <- trimws(names(raw_dat))

block_ids <- if (col_block %in% names(raw_dat)) {
  raw_dat[[col_block]]
} else {
  rep_idx <- ave(seq_len(nrow(raw_dat)), raw_dat[[col_wp]], raw_dat[[col_sp]], FUN = seq_along)
  interaction(raw_dat[[col_wp]], rep_idx)
}

dat <- data.frame(
  block = factor(block_ids),
  wp    = factor(raw_dat[[col_wp]]),
  sp    = factor(raw_dat[[col_sp]]),
  y     = raw_dat[[col_resp]]
)

fit <- aov(y ~ wp * sp + Error(block), data = dat)

cat("\n=== Input Data ===\n")
print(dat)

cat("\n=== Grand Mean ===\n")
print(mean(dat$y))

cat("\n=== Whole-Plot Unit Means ===\n")
print(aggregate(y ~ block, data = dat, FUN = mean))

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
