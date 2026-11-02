# ==============================================================================
# 1. CRD SPLIT-PLOT (CONCISE EXAM EDITION - COMPLETE OUTPUT)
# ==============================================================================
# Config: Edit the 4 lines below to match your exam paper
# ------------------------------------------------------------------------------
f <- if (file.exists("data.csv")) "data.csv" else "scripts/data.csv"
d <- read.csv(f)

y    <- d$conc                # Response variable
wp   <- factor(d$temperature) # Hard-to-change (Whole-Plot) factor
sp   <- factor(d$concentration_type) # Easy-to-change (Subplot) factor
unit <- NULL                  # Set to NULL for Case A; or d$rep / d$tank if given

# Whole-Plot Unit Resolution (Handles Case A, B, and C)
if (is.null(unit)) {
  unit <- interaction(wp, ave(seq_along(y), wp, sp, FUN = seq_along))
} else if (length(unique(unit)) < length(y) / length(unique(sp))) {
  unit <- interaction(wp, unit) # Guard: auto-combine if rep repeats 1..r
}
dat <- data.frame(unit = factor(unit), wp, sp, y)

# Fit Model & Output All Summary Means
fit <- aov(y ~ wp * sp + Error(unit), data = dat)
cat("\n=== Input Data ===\n"); print(dat)
cat("\n=== Grand Mean ===\n", mean(y), "\n")
cat("\n=== Whole-Plot Unit Means ===\n"); print(aggregate(y ~ unit, data = dat, FUN = mean))
cat("\n=== Whole-Plot Factor (wp) Means ===\n"); print(aggregate(y ~ wp, data = dat, FUN = mean))
cat("\n=== Subplot Factor (sp) Means ===\n"); print(aggregate(y ~ sp, data = dat, FUN = mean))
cat("\n=== wp x sp Interaction Means ===\n"); print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

# Split-Plot ANOVA Table & Table 4 Extras
cat("\n=== Split-Plot ANOVA Results ===\n"); print(summary(fit))
s <- summary(fit)
ms_w <- s[[1]][[1]]["Residuals", "Mean Sq"]; df_w <- s[[1]][[1]]["Residuals", "Df"]
ms_s <- s[[2]][[1]]["Residuals", "Mean Sq"]; df_s <- s[[2]][[1]]["Residuals", "Df"]
f_wp <- ms_w / ms_s; p_wp <- 1 - pf(f_wp, df_w, df_s)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", nrow(dat) - 1, "\nTotal SS   :", round(sum((y - mean(y))^2), 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\nWP Error P :", round(p_wp, 5), "\n")
