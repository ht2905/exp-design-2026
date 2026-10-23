library(stats)

path <- "data/ed_lecture-05.csv"
dat <- read.csv(path)

dat$pretreat <- factor(dat$pretreat)
dat$stain <- factor(dat$stain)

model <- aov(resistance ~ pretreat * stain, data = dat)

# ToolPak-style ANOVA table
tab <- anova(model)

ss_within <- sum(residuals(model)^2)
df_within <- df.residual(model)
ms_within <- ss_within / df_within

toolpak <- data.frame(
  `Source of Variation` = c(
    "Rows",
    "Columns",
    "Interaction",
    "Within",
    "Total"
  ),
  ss = c(
    tab["pretreat", "Sum Sq"],
    tab["stain", "Sum Sq"],
    tab["pretreat:stain", "Sum Sq"],
    ss_within,
    sum((dat$resistance - mean(dat$resistance))^2)
  ),
  df = c(
    tab["pretreat", "Df"],
    tab["stain", "Df"],
    tab["pretreat:stain", "Df"],
    df_within,
    nrow(dat) - 1
  )
)

toolpak$ms <- c(
  tab["pretreat", "Mean Sq"],
  tab["stain", "Mean Sq"],
  tab["pretreat:stain", "Mean Sq"],
  ms_within,
  NA
)

toolpak$F <- c(
  tab["pretreat", "F value"],
  tab["stain", "F value"],
  tab["pretreat:stain", "F value"],
  NA,
  NA
)

toolpak$`P-value` <- c(
  tab["pretreat", "Pr(>F)"],
  tab["stain", "Pr(>F)"],
  tab["pretreat:stain", "Pr(>F)"],
  NA,
  NA
)

toolpak$`F crit` <- c(
  qf(0.95, tab["pretreat", "Df"], df_within),
  qf(0.95, tab["stain", "Df"], df_within),
  qf(0.95, tab["pretreat:stain", "Df"], df_within),
  NA,
  NA
)

print(toolpak)