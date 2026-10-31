# ==============================================================================
# Exercise 01: Split-Plot Design Analysis in Base R
# ==============================================================================
# Experimental Design Context:
# - Blocks (r = 4): Replicate blocks in the field (e.g. soil/location gradients)
# - Whole-Plot Factor A: Irrigation (3 levels) -> Hard-to-change factor
# - Subplot Factor B: Fertilizer (2 levels)    -> Easy-to-change factor
# - Response: Plant Height (cm)
# - Total Whole Plots: 4 blocks * 3 irrigation = 12 whole plots
# - Total Subplots: 12 whole plots * 2 fertilizers = 24 observations
# ==============================================================================

# 1. Read CSV file
dat <- read.csv("exercise-01/split-plot-data.csv")

# 2. Convert design factors to categorical variables (factors)
dat$block        <- factor(dat$block)        # 4 blocks
dat$irrigation   <- factor(dat$irrigation)   # Factor A (Whole-Plot)
dat$fertilizer   <- factor(dat$fertilizer)   # Factor B (Subplot)

# 3. Fit Split-Plot Model
# In a Randomized Complete Block Split-Plot design:
# Error(block/irrigation) tells R:
#   - Whole-plot units are the combinations of block and irrigation (block:irrigation).
#   - Irrigation is tested against Whole-Plot Error: MS(block:irrigation) [df = 6]
#   - Fertilizer and Interaction are tested against Subplot Error: MS(Within) [df = 9]
fit <- aov(plant_height ~ irrigation * fertilizer + Error(block/irrigation), data = dat)

# 4. View results
summary(fit)
