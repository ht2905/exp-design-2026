f <- "data.csv"
d <- read.csv(f)

y    <- d$conc # Response variable
wp   <- factor(d$temperature) # Hard-to-change (Whole-Plot) factor
sp   <- factor(d$concentration_type) # Easy-to-change (Subplot) factor
unit <- NULL # Three cases

if (is.null(unit)) {
  unit <- interaction(wp, ave(seq_along(y), wp, sp, FUN = seq_along))
} else if (length(unique(unit)) < length(y) / length(unique(sp))) {
  unit <- interaction(wp, unit)
}
dat <- data.frame(unit = factor(unit), wp, sp, y)

fit <- aov(y ~ wp * sp + Error(unit), data = dat)
cat("\n=== Input Data ===\n"); print(dat)
cat("\n=== Grand Mean ===\n", mean(y), "\n")
cat("\n=== Whole-Plot Unit Means ===\n"); print(aggregate(y ~ unit, data = dat, FUN = mean))
cat("\n=== Whole-Plot Factor (wp) Means ===\n"); print(aggregate(y ~ wp, data = dat, FUN = mean))
cat("\n=== Subplot Factor (sp) Means ===\n"); print(aggregate(y ~ sp, data = dat, FUN = mean))
cat("\n=== wp x sp Interaction Means ===\n"); print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

cat("\n=== Split-Plot ANOVA Results ===\n"); print(summary(fit))
s <- summary(fit)
ms_w <- s[[1]][[1]]["Residuals", "Mean Sq"]; df_w <- s[[1]][[1]]["Residuals", "Df"]
ms_s <- s[[2]][[1]]["Residuals", "Mean Sq"]; df_s <- s[[2]][[1]]["Residuals", "Df"]
f_wp <- ms_w / ms_s; p_wp <- 1 - pf(f_wp, df_w, df_s)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", nrow(dat) - 1, "\nTotal SS   :", round(sum((y - mean(y))^2), 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\nWP Error P :", round(p_wp, 5), "\n")
