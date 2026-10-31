# ==============================================================================
# Exercise 01: Split-Plot Design Analysis in Base R
# ==============================================================================
# Experimental Design Context:
# - Blocks (r = 4): Replicate blocks in field (e.g. soil/location gradients)
# - Whole-Plot Factor A: Irrigation (3 levels) -> Hard-to-change factor
# - Subplot Factor B: Fertilizer (2 levels)    -> Easy-to-change factor
# - Response: Plant Height (cm)
# - Total Whole Plots: 4 blocks * 3 irrigation = 12 whole plots
# - Total Subplots: 12 whole plots * 2 fertilizers = 24 observations
# ==============================================================================

# 1. Read CSV file (supports running from repo root or exercise-01 folder)
csv_file <- if (file.exists("exercise-01/split-plot-data.csv")) {
  "exercise-01/split-plot-data.csv"
} else {
  "split-plot-data.csv"
}

dat <- read.csv(csv_file)

# 2. Convert design factors to categorical variables (factors)
dat$block      <- factor(dat$block)       # 4 blocks
dat$irrigation <- factor(dat$irrigation)  # Factor A (Whole-Plot)
dat$fertilizer <- factor(dat$fertilizer)  # Factor B (Subplot)

# 3. Fit Split-Plot Model
# In a Randomized Complete Block Split-Plot design:
# Error(block / irrigation) tells R:
#   - Whole-plot units are the combinations of block and irrigation.
#   - Irrigation is tested against Whole-Plot Error:
#     MS(block:irrigation) [df = 6]
#   - Fertilizer and Interaction are tested against Subplot Error:
#     MS(Within) [df = 9]
fit <- aov(
  plant_height ~ irrigation * fertilizer + Error(block / irrigation),
  data = dat
)

# 4. Calculate treatment means
cat("\n=== Grand Mean ===\n")
print(mean(dat$plant_height))

cat("\n=== Block Means ===\n")
print(aggregate(
  plant_height ~ block,
  data = dat,
  FUN = mean
))

cat("\n=== Irrigation Means (Factor A) ===\n")
print(aggregate(
  plant_height ~ irrigation,
  data = dat,
  FUN = mean
))

cat("\n=== Fertilizer Means (Factor B) ===\n")
print(aggregate(
  plant_height ~ fertilizer,
  data = dat,
  FUN = mean
))

cat("\n=== Irrigation × Fertilizer Means ===\n")
print(aggregate(
  plant_height ~ irrigation + fertilizer,
  data = dat,
  FUN = mean
))

# 5. View results
cat("\n=== Input Data ===\n")
print(dat)

cat("\n=== Split-Plot ANOVA Results ===\n")
print(summary(fit))
