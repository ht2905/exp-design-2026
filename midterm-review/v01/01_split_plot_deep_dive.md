# Chapter 01: Split-Plot Experimental Design & Analysis
*From Core Statistical Intuition to Practical Implementation in Excel and Base R*

---

## 1. What is a Split-Plot Design? (The Wet-Lab Reality)

In introductory statistics courses, experimental design is almost always taught as a **Completely Randomized Design (CRD)** or a **Factorial Design**:
- You take $N$ identical test tubes or petri dishes.
- You assign every treatment combination in completely random order.
- Every single run is an independent preparation and execution.

### The Wet-Lab Dilemma: Hard-to-Change Factors
In actual biotechnology and wet-lab experiments, **pure complete randomization is often physically impossible or ridiculously inefficient**.

Consider this classic example:
You want to test the effect of **Incubation Temperature** ($30^\circ\text{C}$ vs $37^\circ\text{C}$) and **Nutrient Media Formulation** (Media 1, 2, 3, 4) on cell growth.
- To run this as a Completely Randomized Design with 3 replicates, you need $2 \times 4 \times 3 = 24$ runs.
- In a *true* CRD, the sequence of all 24 runs must be completely randomized. Run 1 might be $37^\circ\text{C}$, Run 2 at $30^\circ\text{C}$, Run 3 at $37^\circ\text{C}$, Run 4 at $30^\circ\text{C}$...
- Think about what that requires: you would have to adjust, stabilize, heat up, and cool down your large incubator or bioreactor **24 separate times**! This would take weeks and cost a fortune.

### The Smart Engineering Solution: The Split-Plot Structure
Instead of resetting the incubator 24 times, a sensible scientist does this:
1. Turn the incubator to $37^\circ\text{C}$. Place a large batch / rack of cell cultures inside.
2. Inside that single incubator run, divide the culture into 4 separate flasks or multi-well plates, each receiving one of the 4 Media formulations (Media 1, 2, 3, 4).
3. Repeat this process 3 times for $37^\circ\text{C}$ and 3 times for $30^\circ\text{C}$ (total 6 incubator runs).

```
========================================================================================
                      SPLIT-PLOT EXPERIMENT ARCHITECTURE
========================================================================================
WHOLE-PLOT LEVEL:
  Hard-to-Change Factor: Temperature (A)
  Experimental Unit: Entire Incubator Run / Board / Fermenter Batch (Whole Plot)
  Replication: r = 3 batches per temperature (Total 6 Whole Plots)

                     [ Incubator Run 1: 37°C ]          [ Incubator Run 2: 30°C ]
                     ┌───────────────────────┐          ┌───────────────────────┐
                     │ Well 1: Media A       │          │ Well 1: Media C       │
SUBPLOT LEVEL:       │ Well 2: Media B       │          │ Well 2: Media A       │
  Easy-to-Change     │ Well 3: Media C       │          │ Well 3: Media D       │
  Factor: Media (B)  │ Well 4: Media D       │          │ Well 4: Media B       │
                     └───────────────────────┘          └───────────────────────┘
                     Subplot Unit = Single Well         Subplot Unit = Single Well
========================================================================================
```

This is a **Split-Plot Design**:
1. **Whole-Plot (WP):** The larger experimental unit receiving the **Hard-to-Change (HTC)** factor (e.g., Incubator batch, Pretreated wood board, Fermenter tank).
2. **Subplot (SP):** The smaller experimental unit within each whole plot receiving the **Easy-to-Change (ETC)** factor (e.g., Aliquots, Cut pieces of board, Microplate wells).

---

## 2. The Statistical Heart: Why Regular 2-Way ANOVA is Completely WRONG

> [!CAUTION]
> **The Most Common Exam Trap:**  
> If you analyze a split-plot experiment using standard Two-Way ANOVA (CRD), your answer is **statistically invalid**, and your professor will give you zero points for the analysis.

### Why does standard ANOVA fail?
In standard Two-Way ANOVA, the software assumes all 24 observations were independently randomized to individual units. It calculates **one single pooled error term** (Residual Error with 16 degrees of freedom).

Let's look at the mathematical reality:
1. **At the Whole-Plot Level:**  
   How many independent incubator runs did you do for Temperature? Only **6 runs** (3 at $37^\circ\text{C}$, 3 at $30^\circ\text{C}$)!  
   You have only 6 independent whole-plot units, meaning you have only:
   $$\text{Total Whole-Plot DF} = 6 - 1 = 5$$
   $$\text{Factor A (Temperature) DF} = 2 - 1 = 1$$
   $$\text{Whole-Plot Error DF} = 5 - 1 = 4$$
   You only have **4 degrees of freedom** to estimate the experimental error between incubator runs!

2. **At the Subplot Level:**  
   Within each incubator run, the 4 media formulations are compared directly under identical incubator conditions. Fluctuations in incubator temperature affect all 4 wells equally!  
   Therefore, comparisons between media formulations are **much more precise** than comparisons between incubator runs.

### The Fatal Consequence of Pooling Errors
If you run a standard CRD ANOVA:
- It pools the large Whole-Plot Error variance ($\sigma^2_{WP}$) and the smaller Subplot Error variance ($\sigma^2_{SP}$) into a single average error ($\sigma^2_{pooled}$).
- The Whole-Plot Factor (Temperature) gets tested against this pooled error using 16 DF instead of 4 DF!
- **Result:** The denominator mean square is falsely too small, the F-statistic is artificially inflated, and the p-value becomes falsely significant! You commit a severe **Type I Error (False Positive)**.

> [!IMPORTANT]
> **Golden Rule of Split-Plot Design:**  
> A Split-Plot experiment has **TWO separate experimental units**, **TWO separate randomizations**, and therefore **TWO SEPARATE ERROR TERMS**:
> 1. $\text{Error}_1$ (**Whole-Plot Error**): Tests the Whole-Plot Factor (Factor A).
> 2. $\text{Error}_2$ (**Subplot Error**): Tests the Subplot Factor (Factor B) and the Interaction ($A \times B$).

---

## 3. The Mathematical Model & Degrees of Freedom

### The Statistical Model
For a split-plot design with whole-plot factor $A$ ($a$ levels), subplot factor $B$ ($b$ levels), and $r$ whole-plot replicates (or blocks):

$$y_{ijk} = \mu + \alpha_i + \rho_k + \epsilon_{(i)k}^{WP} + \beta_j + (\alpha\beta)_{ij} + \epsilon_{ijk}^{SP}$$

Where:
- $\mu$: Overall grand mean.
- $\alpha_i$: Fixed effect of Whole-Plot factor $A$ ($i = 1, \dots, a$).
- $\rho_k$: Effect of replicate/block $k$ ($k = 1, \dots, r$).
- $\epsilon_{(i)k}^{WP}$: **Whole-Plot Error** (random error among whole plots within level $i$). $\epsilon_{(i)k}^{WP} \sim \mathcal{N}(0, \sigma^2_{WP})$.
- $\beta_j$: Fixed effect of Subplot factor $B$ ($j = 1, \dots, b$).
- $(\alpha\beta)_{ij}$: Interaction effect between $A$ and $B$.
- $\epsilon_{ijk}^{SP}$: **Subplot Error** (random error among subplots within whole plot $ik$). $\epsilon_{ijk}^{SP} \sim \mathcal{N}(0, \sigma^2_{SP})$.

### Degrees of Freedom (DF) Arithmetic

Let's assume $a$ levels of Factor A, $b$ levels of Factor B, and $r$ replicates of each whole-plot factor level (so total whole plots = $a \times r$, and total observations $N = a \times b \times r$):

| Source of Variation | Degrees of Freedom (General) | Wood Example ($a=2, b=4, r=3, N=24$) | Error Term Used for F-test |
| :--- | :--- | :--- | :--- |
| **Whole-Plot Section:** | | | |
| Factor A (Whole-Plot) | $a - 1$ | $2 - 1 = \mathbf{1}$ | $\mathbf{MS_{WP}}$ |
| Whole-Plot Error (WP Error) | $a(r - 1)$ | $2(3 - 1) = \mathbf{4}$ | — |
| *(Whole-Plot Total)* | $ar - 1$ | $2(3) - 1 = \mathbf{5}$ | — |
| **Subplot Section:** | | | |
| Factor B (Subplot) | $b - 1$ | $4 - 1 = \mathbf{3}$ | $\mathbf{MS_{SP\ Error}}$ |
| Interaction ($A \times B$) | $(a - 1)(b - 1)$ | $(2 - 1)(4 - 1) = \mathbf{3}$ | $\mathbf{MS_{SP\ Error}}$ |
| Subplot Error (SP Error) | $a(r - 1)(b - 1)$ | $2(3 - 1)(4 - 1) = \mathbf{12}$ | — |
| **Total** | $abr - 1 = N - 1$ | $24 - 1 = \mathbf{23}$ | — |

Notice the beautiful arithmetic:
$$\text{DF}_{Total} = \text{DF}_A + \text{DF}_{WP} + \text{DF}_B + \text{DF}_{AB} + \text{DF}_{SP\ Error}$$
$$23 = 1 + 4 + 3 + 3 + 12$$

### The F-Ratios (Hypothesis Testing)
1. **Testing Factor A (Hard-to-Change):**
   $$F_A = \frac{MS_A}{MS_{WP}} \quad \text{with } df = (a-1, \, a(r-1))$$
2. **Testing Factor B (Easy-to-Change):**
   $$F_B = \frac{MS_B}{MS_{SP\ Error}} \quad \text{with } df = (b-1, \, a(r-1)(b-1))$$
3. **Testing Interaction ($A \times B$):**
   $$F_{AB} = \frac{MS_{AB}}{MS_{SP\ Error}} \quad \text{with } df = ((a-1)(b-1), \, a(r-1)(b-1))$$

---

## 4. Excel Analysis: The Two-Step ToolPak Method

Microsoft Excel's Data Analysis ToolPak does not have a button called "Split-Plot ANOVA".  
However, as demonstrated in your course materials (`ED_practice.ods`), your professor expects you to construct the exact Split-Plot table using a simple, brilliant **Two-Step ToolPak Procedure**.

### Walkthrough using the Wood Resistance Dataset
- **Factor A (Pretreatment):** 2 levels (1 and 2).
- **Factor B (Stain):** 4 levels (1, 2, 3, 4).
- **Whole Plots:** 6 boards total (3 boards pretreated with 1; 3 boards pretreated with 2).
- **Subplots:** 4 pieces per board (each gets 1 stain). Total $N = 24$.

```
Board 1 (Pretreat 1): Stain 3=40.8, Stain 1=43.0, Stain 2=51.8, Stain 4=45.5  -> Mean = 45.275
Board 2 (Pretreat 1): Stain 2=60.9, Stain 4=55.3, Stain 3=51.1, Stain 1=57.4  -> Mean = 56.175
Board 3 (Pretreat 1): Stain 1=52.8, Stain 3=51.7, Stain 4=55.3, Stain 2=59.2  -> Mean = 54.750
Board 4 (Pretreat 2): Stain 2=53.5, Stain 4=32.5, Stain 1=46.6, Stain 3=35.4  -> Mean = 42.000
Board 5 (Pretreat 2): Stain 4=44.6, Stain 1=52.2, Stain 3=45.9, Stain 2=48.3  -> Mean = 47.750
Board 6 (Pretreat 2): Stain 1=32.1, Stain 4=30.1, Stain 2=34.4, Stain 3=32.2  -> Mean = 32.200
```

---

### Step 1: Whole-Plot Analysis on Board Averages
1. In Excel, calculate the average resistance for each of the 6 boards (3 for Pretreat 1, 3 for Pretreat 2):
   ```
   Pretreat 1:  [ 45.275,  56.175,  54.750 ]
   Pretreat 2:  [ 42.000,  47.750,  32.200 ]
   ```
2. Go to `Data` $\rightarrow$ `Data Analysis` $\rightarrow$ `Anova: Single Factor`.
   - Input range: The two columns/rows above.
3. ToolPak outputs:
   - Between Groups SS = $195.51$ (DF = 1, MS = $195.51$)
   - Within Groups SS = $193.84$ (DF = 4, MS = $48.46$)
   - $F = \frac{195.51}{48.46} = 4.03$, $p = 0.115$.

> [!IMPORTANT]
> **The Scaling Factor ($b = 4$):**  
> Because each whole-plot average is the mean of $b = 4$ individual observations, the Sums of Squares on the means must be multiplied by $b = 4$ to obtain the true Sums of Squares for the individual observation scale:
> $$SS_{Pretreat} = 195.51 \times 4 = \mathbf{782.04}$$
> $$SS_{WP\ Error} = 193.84 \times 4 = \mathbf{775.36}$$
> $$MS_{Pretreat} = \frac{782.04}{1} = \mathbf{782.04}$$
> $$MS_{WP\ Error} = \frac{775.36}{4} = \mathbf{193.84}$$
> Notice that $F = \frac{782.04}{193.84} = \mathbf{4.03}$ (identical to the means test!).

---

### Step 2: Full Two-Factor ANOVA on Raw Data
1. Arrange the raw data into a Two-Factor table (Rows = Pretreatment, Columns = Stains) with 3 rows per pretreatment.
2. Go to `Data` $\rightarrow$ `Data Analysis` $\rightarrow$ `Anova: Two-Factor With Replication`.
   - Rows per sample: 3.
3. From the resulting ANOVA table, copy these exact values:
   - $SS_{Total} = \mathbf{2038.72}$ ($DF = 23$)
   - $SS_{Stain} = \mathbf{266.01}$ ($DF = 3$)
   - $SS_{Interaction} = \mathbf{62.79}$ ($DF = 3$)

---

### Step 3: Assemble the Final Split-Plot ANOVA Table by Subtraction
Now create your master table in Excel:

1. **Calculate Subplot Error SS by subtraction:**
   $$SS_{SP\ Error} = SS_{Total} - SS_{Pretreat} - SS_{WP\ Error} - SS_{Stain} - SS_{Interaction}$$
   $$SS_{SP\ Error} = 2038.72 - 782.04 - 775.36 - 266.01 - 62.79 = \mathbf{152.52}$$

2. **Calculate Subplot Error DF by subtraction:**
   $$DF_{SP\ Error} = 23 - 1 - 4 - 3 - 3 = \mathbf{12}$$

3. **Calculate Mean Squares:**
   $$MS_{Stain} = \frac{266.01}{3} = \mathbf{88.67}$$
   $$MS_{Interaction} = \frac{62.79}{3} = \mathbf{20.93}$$
   $$MS_{SP\ Error} = \frac{152.52}{12} = \mathbf{12.71}$$

4. **Calculate F-Statistics and P-Values:**
   - **Pretreatment:**
     $$F = \frac{MS_{Pretreat}}{MS_{WP\ Error}} = \frac{782.04}{193.84} = \mathbf{4.03}$$
     In Excel: `=F.DIST.RT(4.03, 1, 4)` $\rightarrow \mathbf{0.115}$
   - **Stain:**
     $$F = \frac{MS_{Stain}}{MS_{SP\ Error}} = \frac{88.67}{12.71} = \mathbf{6.98}$$
     In Excel: `=F.DIST.RT(6.98, 3, 12)` $\rightarrow \mathbf{0.006}$
   - **Interaction:**
     $$F = \frac{MS_{Interaction}}{MS_{SP\ Error}} = \frac{20.93}{12.71} = \mathbf{1.65}$$
     In Excel: `=F.DIST.RT(1.65, 3, 12)` $\rightarrow \mathbf{0.231}$

### Final Split-Plot ANOVA Table

| Source | DF | SS | MS | F | p-value | Decision ($\alpha=0.05$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Pretreatment (WP Factor)** | 1 | 782.04 | 782.04 | **4.03** | 0.115 | Fail to reject $H_0$ (Not Significant) |
| **WP Error (Whole Plots)** | 4 | 775.36 | 193.84 | — | — | — |
| **Stain (Subplot Factor)** | 3 | 266.01 | 88.67 | **6.98** | **0.006** | **Reject $H_0$ (Significant)** |
| **Pretreat $\times$ Stain** | 3 | 62.79 | 20.93 | **1.65** | 0.231 | Fail to reject $H_0$ (Not Significant) |
| **Subplot Error** | 12 | 152.52 | 12.71 | — | — | — |
| **Total** | 23 | 2038.72 | — | — | — | — |

---

## 5. Base R Terminal: The Clean, Minimal Code

In the exam, you have no internet and no pre-made scripts. You must handwrite this base R code on your A4 paper and type it directly into R Terminal.

### The Exact R Script

```r
# ==============================================================
# SPLIT-PLOT ANALYSIS IN BASE R TERMINAL
# ==============================================================

# 1. Enter the response data vector (24 values)
resistance <- c(
  53.5, 32.5, 46.6, 35.4,   # Board 4 (Pretreat 2)
  44.6, 52.2, 45.9, 48.3,   # Board 5 (Pretreat 2)
  40.8, 43.0, 51.8, 45.5,   # Board 1 (Pretreat 1)
  60.9, 55.3, 51.1, 57.4,   # Board 2 (Pretreat 1)
  32.1, 30.1, 34.4, 32.2,   # Board 6 (Pretreat 2)
  52.8, 51.7, 55.3, 59.2    # Board 3 (Pretreat 1)
)

# 2. Define Factors
pretreat <- factor(c(
  2,2,2,2,  2,2,2,2,  1,1,1,1,  1,1,1,1,  2,2,2,2,  1,1,1,1
))

stain <- factor(c(
  2,4,1,3,  4,1,3,2,  3,1,2,4,  2,4,3,1,  1,4,2,3,  1,3,4,2
))

# 3. Define the UNIQUE Whole-Plot (Board) ID (1 to 6)
wp <- factor(c(
  4,4,4,4,  5,5,5,5,  1,1,1,1,  2,2,2,2,  6,6,6,6,  3,3,3,3
))

# 4. Construct Data Frame
dat <- data.frame(wp, pretreat, stain, resistance)

# 5. Fit Split-Plot Model using aov() with Error()
# Formula: Response ~ WP_Factor * SP_Factor + Error(Whole_Plot_Unit)
fit <- aov(resistance ~ pretreat * stain + Error(wp), data = dat)

# 6. Display the ANOVA Summary Table
summary(fit)
```

### What R Terminal Outputs:

```
Error: wp
          Df Sum Sq Mean Sq F value Pr(>F)
pretreat   1  782.0   782.0   4.034  0.115
Residuals  4  775.4   193.8               

Error: Within
               Df Sum Sq Mean Sq F value  Pr(>F)   
stain           3 266.01   88.67   6.976 0.00569 **
pretreat:stain  3  62.79   20.93   1.647 0.23091   
Residuals      12 152.52   12.71                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

### Deconstructing the R Output:
1. **`Error: wp` Section:**  
   - This is the **Whole-Plot analysis**.  
   - `pretreat`: $DF = 1, SS = 782.0, MS = 782.0$.  
   - `Residuals`: This is $WP\ Error$ with $DF = 4, SS = 775.4, MS = 193.8$.  
   - $F = \frac{782.0}{193.8} = 4.034, p = 0.115$.
2. **`Error: Within` Section:**  
   - This is the **Subplot analysis**.  
   - `stain`: $DF = 3, SS = 266.01, MS = 88.67$.  
   - `pretreat:stain`: $DF = 3, SS = 62.79, MS = 20.93$.  
   - `Residuals`: This is $SP\ Error$ with $DF = 12, SS = 152.52, MS = 12.71$.  
   - Stain $F = \frac{88.67}{12.71} = 6.976, p = 0.00569$ (Significant!).  
   - Interaction $F = \frac{20.93}{12.71} = 1.647, p = 0.23091$ (Not Significant).

---

## 6. Crucial Exam Tips & Pitfalls for Split Plot

> [!WARNING]
> **Trap 1: How Whole Plots are coded in R**  
> If you code boards as `1, 2, 3` for Pretreat 1 and `1, 2, 3` for Pretreat 2, R thinks Board 1 in Pretreat 1 and Board 1 in Pretreat 2 are the *same physical board*!  
> That would create an accidental blocking structure.  
> **Fix:** Ensure whole plot IDs are **unique** (e.g. 1 to 6), OR use:  
> `Error(pretreat/board)` or `wp <- interaction(pretreat, board)`.

> [!TIP]
> **Trap 2: Which factor is more powerful?**  
> An exam question will often ask: *"Which factor is tested with greater precision?"*  
> **Answer:** The **Subplot factor (Stain)** is tested with greater precision because it has more degrees of freedom ($12$ vs $4$) and a much smaller error variance ($12.71$ vs $193.84$).  
> **Practical consequence:** In laboratory experimental design, always put your **most important factor** at the **subplot level** if possible!

