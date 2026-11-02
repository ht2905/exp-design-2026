# ==============================================================================
# QUESTION 1: RCBD SPLIT-PLOT (EXAM SCRIPT)
# ==============================================================================
f <- if (file.exists("data_q1_split_plot.csv")) "data_q1_split_plot.csv" else "data.csv"
d <- read.csv(f)

y     <- d$milk         # Response variable
wp    <- factor(d$pasture) # Hard-to-change (Whole-Plot) factor
sp    <- factor(d$mineral) # Easy-to-change (Subplot) factor
block <- factor(d$block)   # Nuisance block (Season)
dat   <- data.frame(block, wp, sp, y)

# Fit Model & Output All Summary Means
fit <- aov(y ~ wp * sp + Error(block / wp), data = dat)
cat("\n=== Input Data ===\n"); print(dat)
cat("\n=== Grand Mean ===\n", mean(y), "\n")
cat("\n=== Block Means ===\n"); print(aggregate(y ~ block, data = dat, FUN = mean))
cat("\n=== Whole-Plot Factor (wp) Means ===\n"); print(aggregate(y ~ wp, data = dat, FUN = mean))
cat("\n=== Subplot Factor (sp) Means ===\n"); print(aggregate(y ~ sp, data = dat, FUN = mean))
cat("\n=== wp x sp Interaction Means ===\n"); print(aggregate(y ~ wp + sp, data = dat, FUN = mean))

# Split-Plot ANOVA Table & Table 4 Extras
cat("\n=== Split-Plot ANOVA Results ===\n"); print(summary(fit))
s <- summary(fit)
ms_w <- s[[2]][[1]]["Residuals", "Mean Sq"]; df_w <- s[[2]][[1]]["Residuals", "Df"]
ms_s <- s[[3]][[1]]["Residuals", "Mean Sq"]; df_s <- s[[3]][[1]]["Residuals", "Df"]
f_wp <- ms_w / ms_s; p_wp <- 1 - pf(f_wp, df_w, df_s)

cat("\n=== Optional: Table 4 Extras ===\n")
cat("Total DF   :", nrow(dat) - 1, "\nTotal SS   :", round(sum((y - mean(y))^2), 2), "\n")
cat("WP Error F :", round(f_wp, 2), "\nWP Error P :", round(p_wp, 5), "\n")
