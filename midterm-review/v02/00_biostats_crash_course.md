# Chapter 00: Foundational Biostatistics Crash Course
*A Complete, Plain-English Guide to Core Statistical Concepts from First Principles*

---

## Roadmap of This Chapter

This chapter covers all the fundamental statistical concepts you were taught in Biostatistics, explained clearly with direct mathematical definitions and practical meaning:

1. **Descriptive Statistics & Spread:** Population vs. Sample, Variance, Standard Deviation, and Standard Error.
2. **Probability Distributions:** Normal ($Z$), Student's $t$, Chi-Square ($\chi^2$), and Fisher's $F$.
3. **Hypothesis Testing:** $H_0$, $H_1$, Test Statistics, p-values, $\alpha$-threshold, and Type I / Type II Errors.
4. **Comparing Means:** $z$-test vs. $t$-test (One-sample, Independent Two-sample, Paired).
5. **ANOVA (Analysis of Variance):**
   - Why multiple $t$-tests fail (Family-wise Error Rate).
   - One-Way ANOVA ($SS_{Between}$ vs. $SS_{Within}$).
   - Post-hoc tests (Tukey's HSD, Fisher's LSD).
   - Two-Way ANOVA **Without Replication** (Block Designs).
   - Two-Way ANOVA **With Replication** (Interaction effects).
6. **Non-Parametric Tests:** When to use ranks (Wilcoxon Rank-Sum / Mann-Whitney, Wilcoxon Signed-Rank, Kruskal-Wallis).
7. **Goodness of Fit:** $\chi^2$ Goodness-of-Fit test vs. Regression Goodness-of-Fit / Lack of Fit.
8. **Correlation & Regression:** Pearson's $r$, Coefficient of Determination $R^2$, Adjusted $R^2$, and Residuals.

---

## 1. Descriptive Statistics & Spread

### A. Population vs. Sample
- **Population:** The entire collection of all possible individuals, cells, or measurements of interest.  
  - Fixed true parameters are written with **Greek letters**:
    - Population Mean: $\mu$
    - Population Variance: $\sigma^2$
    - Population Standard Deviation: $\sigma$
- **Sample:** A subset of $n$ observations drawn randomly from the population.  
  - Estimates calculated from sample data are written with **Latin letters**:
    - Sample Mean: $\bar{y} = \frac{1}{n} \sum_{i=1}^n y_i$
    - Sample Variance: $s^2 = \frac{1}{n-1} \sum_{i=1}^n (y_i - \bar{y})^2$
    - Sample Standard Deviation: $s = \sqrt{s^2}$

---

### B. Variance vs. Standard Deviation vs. Standard Error

These three terms measure spread, but at completely different levels:

                      VARIANCE vs STANDARD DEVIATION vs STANDARD ERROR
========================================================================================
1. VARIANCE (s²):
   • Formula: s² = Σ $(y_i - \bar{y})$² / (n - 1)
   • Units: Squared units (e.g., mg²/mL²). Not directly intuitive.
   • Meaning: The average squared distance of individual data points from the mean.

2. STANDARD DEVIATION (s):
   • Formula: s = √s²
   • Units: Original units (e.g., mg/mL).
   • Meaning: How much individual raw observations vary from cell to cell or tube to tube.
   • It describes the SPREAD OF THE DATA.

3. STANDARD ERROR OF THE MEAN (SE or SEM):
   • Formula:
$$$
SE = \frac{s}{\sqrt{n}}
$$$

   • Units: Original units (e.g., mg/mL).
   • Meaning: How precisely your sample mean (y_bar) estimates the true population mean (μ).
   • It describes the UNCERTAINTY OF THE MEAN.

> [!IMPORTANT]
> **Why divide by $\sqrt{n}$ for Standard Error?**  
> If you measure 1 tube, your result might fluctuate wildly. But if you measure 100 tubes and compute their average, that average will be much closer to the true mean. As sample size $n$ increases, standard deviation $s$ stays roughly constant, but **Standard Error ($s / \sqrt{n}$) shrinks toward zero**.

---

## 2. Probability Distributions: The Big Four

Statistical tests depend on four theoretical probability distributions:

| Distribution | Symbol | What It Represents | Where It Is Used |
| :--- | :---: | :--- | :--- |
| **Standard Normal** | $Z \sim \mathcal{N}(0, 1)$ | Bell curve with mean $\mu = 0$ and standard deviation $\sigma = 1$. Symmetric. | $z$-tests (when population $\sigma$ is known or $n$ is very large). |
| **Student's $t$** | $t(df)$ | Bell-shaped but with **heavier, fatter tails** than normal. | $t$-tests and regression coefficient tests (when sample $s$ replaces $\sigma$). |
| **Chi-Square** | $\chi^2(df)$ | Sum of squared independent standard normal variables: $\sum Z_i^2$. Strictly positive ($\ge 0$), skewed right. | Testing variances, $\chi^2$ Goodness of Fit, Contingency tables. |
| **Fisher's $F$** | $F(df_1, df_2)$ | **Ratio of two independent variances**: $\frac{\chi^2_1 / df_1}{\chi^2_2 / df_2} = \frac{MS_1}{MS_2}$. Strictly positive ($\ge 0$). | **ANOVA tables**, Split-Plot F-tests, and Regression Lack-of-Fit tests. |

### Why Does the $t$-Distribution Have "Fatter Tails"?
When you do not know the true population standard deviation $\sigma$, you must estimate it using the sample standard deviation $s$. Because $s$ itself varies from sample to sample, there is extra uncertainty. The $t$-distribution accounts for this extra uncertainty by having fatter tails.  
As sample size grows ($df > 30$ or $df \to \infty$), $s$ becomes an exact estimate of $\sigma$, and the $t$-distribution becomes identical to the standard normal $Z$-distribution.

---

## 3. Hypothesis Testing Mechanics

Every hypothesis test follows a 5-step mathematical procedure:

```
Step 1: State Hypotheses (H0 vs H1)
Step 2: Choose Significance Threshold (α = 0.05)
Step 3: Calculate Test Statistic (t, F, z, or χ²) = (Observed Signal) / (Background Noise)
Step 4: Determine P-Value from the theoretical distribution
Step 5: Make Decision (Reject H0 if p < α; Fail to reject H0 if p ≥ α)
```

### A. The Null ($H_0$) and Alternative ($H_1$) Hypotheses
- **$H_0$ (Null Hypothesis):** Baseline claim of "no difference", "no effect", or "equality".  
  - *Example:* $\mu_1 = \mu_2$ (two drug treatments produce equal antibody yield).
- **$H_1$ (Alternative Hypothesis):** Claim that a real effect or difference exists.  
  - **Two-tailed:** $\mu_1 \ne \mu_2$ (treatments differ in either direction).
  - **One-tailed:** $\mu_1 > \mu_2$ or $\mu_1 < \mu_2$ (treatment is specifically greater or smaller).

---

### B. What is a P-Value Really?

> [!IMPORTANT]
> **Formal Definition:**  
> The **p-value** is the probability of obtaining an experimental test statistic **at least as extreme** as the one observed, **assuming the null hypothesis ($H_0$) is strictly true**.

- **Small p-value ($p < 0.05$):** It is extremely unlikely ($< 5\%$ chance) that random experimental noise could produce a difference this large. Therefore, we **reject $H_0$** and conclude the effect is statistically significant.
- **Large p-value ($p \ge 0.05$):** Random laboratory noise could easily produce a difference of this size. We **fail to reject $H_0$** (insufficient evidence to claim a real difference).

---

### C. Type I Error, Type II Error, and Statistical Power

| Reality in Nature | Decision: Fail to Reject $H_0$ | Decision: Reject $H_0$ (Claim Effect) |
| :--- | :---: | :---: |
| **$H_0$ is True** (No real effect) | **Correct Decision** ($1 - \alpha$) | **TYPE I ERROR ($\alpha$, False Positive)** |
| **$H_1$ is True** (Real effect exists) | **TYPE II ERROR ($\beta$, False Negative)** | **CORRECT DECISION (Power = $1 - \beta$)** |

- **Type I Error ($\alpha$, False Positive):** You claim a drug works when in reality it does nothing. We strictly limit this risk by setting $\alpha = 0.05$ ($5\%$).
- **Type II Error ($\beta$, False Negative):** A drug actually works, but your sample size was too small or noise was too high to detect it.
- **Statistical Power ($1 - \beta$):** The probability of correctly detecting a real effect. Increasing sample size $n$ increases power.

---

## 4. Comparing Means: $z$-Test vs. $t$-Test

```
========================================================================================
                      HOW TO CHOOSE BETWEEN z-TEST AND t-TEST
========================================================================================
                               Do you know the true
                           Population Variance (σ²)?
                                    │
                    ┌───────────────┴───────────────┐
                   YES                              NO
                    │                               │
              Use z-TEST                       Use t-TEST
      (Rare in wet-lab biology)        (Standard in biological research)
                                                    │
                         ┌──────────────────────────┼──────────────────────────┐
                         ▼                          ▼                          ▼
                 ONE-SAMPLE t-TEST         INDEPENDENT TWO-SAMPLE        PAIRED t-TEST
               Compares 1 sample mean              t-TEST            Same subjects measured
               against a known target      Compares 2 separate        before and after or
                 (e.g., μ0 = 100).          unrelated groups.         in matched pairs.
========================================================================================
```

---

### A. The $z$-Test
Used only when the population variance $\sigma^2$ is known or sample size $n$ is massive ($n > 1000$):
$$z = \frac{\bar{y} - \mu_0}{\sigma / \sqrt{n}}$$

---

### B. The One-Sample $t$-Test
Tests whether a single sample mean $\bar{y}$ differs from a hypothesized standard value $\mu_0$:
$$t = \frac{\bar{y} - \mu_0}{s / \sqrt{n}}, \quad df = n - 1$$

---

### C. The Independent Two-Sample $t$-Test
Compares two completely independent treatment groups (e.g., Control cells vs. Drug-treated cells):
$$t = \frac{\bar{y}_1 - \bar{y}_2}{SE(\bar{y}_1 - \bar{y}_2)}$$

Assuming equal variances (pooled variance $s_p^2$):
$$s_p^2 = \frac{(n_1 - 1)s_1^2 + (n_2 - 1)s_2^2}{n_1 + n_2 - 2}$$
$$t = \frac{\bar{y}_1 - \bar{y}_2}{\sqrt{s_p^2 \left(\frac{1}{n_1} + \frac{1}{n_2}\right)}}, \quad df = n_1 + n_2 - 2$$

---

### D. The Paired $t$-Test
Used when measurements are taken on the **same biological sample before and after treatment** (or on matched pairs, like left kidney vs. right kidney):
1. Calculate the difference for each pair: $d_i = y_{1,i} - y_{2,i}$.
2. Compute the mean difference $\bar{d}$ and standard deviation of differences $s_d$.
3. Run a one-sample $t$-test on the differences:
   $$t = \frac{\bar{d} - 0}{s_d / \sqrt{n}}, \quad df = n - 1$$

*Why use a paired test?* Pairing eliminates subject-to-subject baseline variation, vastly reducing background noise and boosting statistical power.

---

## 5. Analysis of Variance (ANOVA)

### A. Why Not Just Run Multiple $t$-Tests? (Family-wise Error Rate)
Suppose you have 4 feed broths (A, B, C, D) and want to know which one is best.  
To compare all pairs using $t$-tests, you need $\binom{4}{2} = 6$ individual pairwise $t$-tests:
$$A \text{ vs } B, \quad A \text{ vs } C, \quad A \text{ vs } D, \quad B \text{ vs } C, \quad B \text{ vs } D, \quad C \text{ vs } D$$

If each test has a Type I error rate of $\alpha = 0.05$, the probability of committing **at least one false positive** across all 6 tests explodes:
$$\text{Family-wise Error Rate} = 1 - (1 - \alpha)^k = 1 - (1 - 0.05)^6 = 1 - 0.735 = \mathbf{0.265} \quad (26.5\%!)$$

You have a $26.5\%$ chance of finding a "statistically significant" result purely by luck!  
**ANOVA solves this problem** by performing **one single omnibus test** comparing all group means simultaneously at strict $\alpha = 0.05$.

---

### B. One-Way ANOVA: Partitioning Variation
One-Way ANOVA tests whether the means of $k$ groups are equal:
- $H_0: \mu_1 = \mu_2 = \dots = \mu_k$
- $H_1: \text{At least one group mean is different.}$

It breaks total variation into two components:
$$SS_{Total} = SS_{Between} + SS_{Within}$$

```
                                ONE-WAY ANOVA TABLE
Source of Variation | DF    | Sum of Squares (SS) | Mean Square (MS) | F-Statistic
--------------------|-------|---------------------|------------------|---------------------------
Between Groups      | k - 1 | SS_Between          | MS_B = SS_B/(k-1)| F = MS_Between / MS_Within
Within Groups (Err) | N - k | SS_Within           | MS_W = SS_W/(N-k)|
Total               | N - 1 | SS_Total            |                  |
```

- **Between Groups Variance ($MS_{Between}$):** Measures how much group averages spread around the grand mean. Contains treatment effect + random noise.
- **Within Groups Variance ($MS_{Within}$):** Measures how much individual samples spread within their own group. Contains **pure random noise only**.
- **The $F$-Test:**
  $$F = \frac{MS_{Between}}{MS_{Within}} = \frac{\text{Treatment Effect} + \text{Noise}}{\text{Noise}}$$
  - If $H_0$ is true (no treatment effect), $F \approx 1.0$.
  - If $H_1$ is true (treatment works), $F \gg 1.0 \implies p < 0.05 \implies$ **Reject $H_0$**.

---

### C. Post-Hoc Multiple Comparison Tests (Tukey vs. LSD)
ANOVA only tells you that *at least one* group differs from the others; it does **not** tell you *which specific pairs* differ. To find out, you run a **Post-Hoc Test**:

1. **Fisher's LSD (Least Significant Difference):**  
   Runs standard $t$-tests between all pairs without adjusting for multiple testing.  
   *Risk:* High Type I error (too liberal).
2. **Tukey's HSD (Honestly Significant Difference):**  
   Specifically adjusts the critical threshold using the Studentized Range distribution ($q$).  
   *Advantage:* Strictly controls the family-wise error rate at $\alpha = 0.05$. Preferred in modern biological science.

---

### D. Two-Way ANOVA: Without Replication vs. With Replication

```
========================================================================================
                   TWO-WAY ANOVA: WITHOUT REPLICATION vs WITH REPLICATION
========================================================================================
FEATURE              | WITHOUT REPLICATION                | WITH REPLICATION
---------------------|------------------------------------|-------------------------------------
Replicates per cell  | Exactly 1 observation per cell     | 2 or more observations per cell
Design type          | Randomized Block Design (RCBD)     | Full Factorial Design
Interaction Term     | CANNOT be tested (assumed 0)       | CAN be tested (Factor A x Factor B)
Residual Error       | Confounded with interaction        | Pure within-cell replicate error
========================================================================================
```

#### 1. Two-Way ANOVA Without Replication (Randomized Complete Block Design):
- You have two factors (e.g., Factor A = Treatment, Factor B = Block/Batch), but you test **only one sample** per combination.
- ANOVA Table Structure:
  $$SS_{Total} = SS_A + SS_{Block} + SS_{Residual}$$
  $$df_{Total} = (a-1) + (b-1) + (a-1)(b-1)$$
  $$F_A = \frac{MS_A}{MS_{Residual}}, \quad F_{Block} = \frac{MS_{Block}}{MS_{Residual}}$$
- *Limitation:* You **cannot** test whether Factor A interacts with Factor B because there are no replicates to estimate within-cell variance.

#### 2. Two-Way ANOVA With Replication:
- You test multiple independent replicates ($n \ge 2$) in every single combination cell.
- ANOVA Table Structure:
  $$SS_{Total} = SS_A + SS_B + SS_{A \times B} + SS_{Within}$$
  $$F_A = \frac{MS_A}{MS_{Within}}, \quad F_B = \frac{MS_B}{MS_{Within}}, \quad F_{AB} = \frac{MS_{AB}}{MS_{Within}}$$
- *Capability:* You can now explicitly test the **Interaction ($A \times B$)**: does the effect of Factor A depend on the level of Factor B?

---

## 6. Non-Parametric Tests (When Assumptions Fail)

Standard parametric tests ($t$-test, ANOVA) rely on three strict assumptions:
1. **Normality:** Data in each group follows a normal distribution.
2. **Homoscedasticity:** Variances are equal across groups ($s_1^2 \approx s_2^2$).
3. **Independence:** Observations are independent.

When data is severely skewed, contains extreme outliers, or consists of ordinal ranking scores, parametric tests give invalid p-values. In such cases, we switch to **Non-Parametric Tests**, which replace raw numbers with **ranks** (1st, 2nd, 3rd...):

| Parametric Test | Non-Parametric Equivalent | How It Works |
| :--- | :--- | :--- |
| **Independent 2-sample $t$-test** | **Wilcoxon Rank-Sum Test** (also called **Mann-Whitney U Test**) | Combines all observations from both groups, ranks them from smallest to largest, and tests if the sum of ranks differs between groups. |
| **Paired $t$-test** | **Wilcoxon Signed-Rank Test** | Calculates paired differences ($d_i$), ranks the absolute differences $|d_i|$, attaches original signs ($+$ or $-$), and tests if positive ranks balance negative ranks. |
| **One-Way ANOVA** | **Kruskal-Wallis Test** | Ranks all observations across $k$ groups and tests whether mean rank sums differ significantly ($\chi^2$-statistic). |

---

## 7. Goodness of Fit Tests

"Goodness of Fit" evaluates **how well observed sample data matches a theoretical or mathematical model**.

### A. Chi-Square ($\chi^2$) Goodness-of-Fit Test (Categorical Data)
Compares observed categorical counts ($O_i$) against theoretical expected counts ($E_i$):
$$\chi^2 = \sum_{i=1}^k \frac{(O_i - E_i)^2}{E_i}, \quad df = k - 1 - p$$

- *Classic Biology Example:* Mendelian genetics predicts an $F_2$ dihybrid phenotypic ratio of $9:3:3:1$. You count 160 offspring:
  - If observed counts are close to expected: $\chi^2 \approx 0 \implies p > 0.05 \implies$ Data fits Mendelian theory!
  - If observed counts deviate significantly: $\chi^2$ is large $\implies p < 0.05 \implies$ Reject Mendelian theory (e.g., genetic linkage exists).

---

### B. Regression Goodness of Fit vs. Lack-of-Fit Test
In Response Surface Methodology and regression:
1. **$R^2$ (Overall Goodness of Fit):** Measures what fraction of total variation is captured by the model ($R^2 = 1 - \frac{SS_{Residual}}{SS_{Total}}$). High $R^2$ ($> 0.90$) means good fit.
2. **Lack of Fit Test (Model Adequacy Test):**
   Splits Residual Sum of Squares into two independent components:
   $$SS_{Residual} = SS_{Lack\ of\ fit} + SS_{Pure\ error}$$
   $$F_{LOF} = \frac{MS_{Lack\ of\ fit}}{MS_{Pure\ error}}$$
   - **$H_0$:** The fitted model adequately represents the true surface.
   - **$H_1$:** The model suffers from significant lack of fit (higher-order curvature or missing variables).
   - **Crucial Rule:** You **WANT $p > 0.05$**! A large p-value fails to reject $H_0$, proving your quadratic response surface model is valid.

---

## 8. Correlation & Regression ($r$ vs. $R^2$)

### A. Pearson Correlation Coefficient ($r$)
Measures the **strength and direction of a linear relationship** between two continuous variables ($X$ and $Y$):
$$r = \frac{\sum (X_i - \bar{X})(Y_i - \bar{Y})}{\sqrt{\sum (X_i - \bar{X})^2 \sum (Y_i - \bar{Y})^2}}$$

- **Range:** $-1.0 \le r \le +1.0$.
- $r = +1.0$: Perfect positive linear correlation (as $X$ increases, $Y$ increases).
- $r = -1.0$: Perfect negative linear correlation (as $X$ increases, $Y$ decreases).
- $r = 0.0$: No linear relationship between $X$ and $Y$.
- *Correlation does NOT imply causation!*

---

### B. Coefficient of Determination ($R^2$)
In simple linear regression ($y = \beta_0 + \beta_1 x$), $R^2 = r^2$.  
In multiple regression and RSM ($y = \beta_0 + \beta_1 x_1 + \dots + \beta_{11} x_1^2 + \dots$):
$$R^2 = 1 - \frac{SS_{Residual}}{SS_{Total}} = \frac{SS_{Model}}{SS_{Total}}$$

- **Interpretation:** The percentage of total variation in the response variable ($y$) that is explained by the regression model.
  - If $R^2 = 0.94$, then $94\%$ of the variation in protein yield is explained by temperature, pH, and time; only $6\%$ remains as unexplained random noise.

---

### C. Residuals ($e_i$)
The residual is the vertical distance between the actual observed data point and the model's fitted prediction:
$$e_i = y_i - \hat{y}_i$$

- If $e_i > 0$: The actual biological yield was higher than the model predicted.
- If $e_i < 0$: The actual biological yield was lower than predicted.
- **Residual Assumptions for Valid Inference:**
  1. Residuals must be normally distributed (checked via Normal Q-Q plot: points must lie along a diagonal straight line).
  2. Residuals must have constant variance across all fitted values (homoscedasticity; checked via Residuals vs. Fitted plot: points must form a uniform horizontal band, not a funnel).
  3. Residuals must be independent (no autocorrelation).
