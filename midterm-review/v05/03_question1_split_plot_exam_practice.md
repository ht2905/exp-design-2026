# Chapter 03: 50-Point Mock Exam – Question 1 (Split-Plot)
*Complete Practice Exam Problem Structured to Satisfy ToolPak Grading While Equipping You to Solve in R*

---

## The Exam Question Prompt (50 Points)

### Scenario:
A bioprocess team is optimizing upstream monoclonal antibody (mAb) production in Chinese Hamster Ovary (CHO) cell culture.

The experiment evaluates two factors on **Antibody Titer (g/L)**:
1. **Operating Temperature (Factor A):** A Hard-to-Change (HTC) factor evaluated at 2 levels:
   - Level 1: $32^\circ\text{C}$ (Mild hypothermia)
   - Level 2: $37^\circ\text{C}$ (Standard physiological)
2. **Nutrient Feed Formulation (Factor B):** An Easy-to-Change (ETC) factor evaluated at 4 levels:
   - Feed 1: Basal Control
   - Feed 2: Amino Acid Enriched
   - Feed 3: Lipid Supplemented
   - Feed 4: Trace Metal Fortified

### Execution:
Because heating and stabilizing 50-L fermenters takes days, running 24 completely randomized tank setups was physically impossible. Instead:
- The team ran **6 bioreactor tanks in total** (3 tanks at $32^\circ\text{C}$ and 3 tanks at $37^\circ\text{C}$).
- Culture from each tank was split into **4 separate culture vessels**, each randomly assigned one of the 4 Feeds.
- Antibody titer ($\text{g/L}$) was measured after 14 days ($N = 2 \times 3 \times 4 = 24$ total observations).

---

### The Raw Experimental Data

| Tank (Whole Plot) | Temperature ($A$) | Feed 1 (Basal) | Feed 2 (Amino) | Feed 3 (Lipid) | Feed 4 (Trace) | Tank Mean ($\bar{y}_{i\cdot k}$) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Tank 1** | $32^\circ\text{C}$ (1) | 5.00 | 6.62 | 9.45 | 6.02 | **6.7725** |
| **Tank 2** | $32^\circ\text{C}$ (1) | 3.95 | 6.00 | 6.86 | 4.26 | **5.2675** |
| **Tank 3** | $32^\circ\text{C}$ (1) | 4.76 | 6.34 | 9.13 | 5.93 | **6.5400** |
| **Tank 4** | $37^\circ\text{C}$ (2) | 4.84 | 6.24 | 7.31 | 6.13 | **6.1300** |
| **Tank 5** | $37^\circ\text{C}$ (2) | 3.07 | 3.71 | 6.85 | 3.53 | **4.2900** |
| **Tank 6** | $37^\circ\text{C}$ (2) | 2.53 | 4.32 | 5.34 | 3.44 | **3.9075** |
| **Feed Mean ($\bar{y}_{\cdot j \cdot}$)** | — | **4.025** | **5.538** | **7.490** | **4.885** | **Grand Mean = 5.485** |

---

### Sub-Questions (50 Points Total):
1. **(10 Points)** Identify the design. State the **Whole-Plot Unit** and **Subplot Unit**, and explain why a regular Two-Way ANOVA leads to a false-positive conclusion.
2. **(15 Points)** Construct the complete Split-Plot ANOVA Table. Show all degrees of freedom ($df$), Sum of Squares ($SS$), Mean Squares ($MS$), and $F$-tests.
3. **(10 Points - The Professor's ToolPak Method)** Detail the exact step-by-step procedure to generate this table in Microsoft Excel using Data Analysis ToolPak and cell formulas (explain the scaling factor $b$).
4. **(10 Points - Your R Terminal Method)** Provide the tidy CSV structure and the complete Base R Terminal code to import the CSV, fit the model, and verify the ANOVA table.
5. **(5 Points)** State your statistical conclusions at $\alpha = 0.05$ and give concrete recommendations to the bioprocess team.

---

## Detailed Model Solution

### Part 1: Design Identification & Experimental Units (10 Points)

1. **Design Name:** A **$2 \times 4$ Factorial Treatment Structure in a Split-Plot Design Structure**.
2. **Experimental Units:**
   - **Whole-Plot Unit:** The **individual 50-L Bioreactor Tank** (6 units total). Receives the Hard-to-Change factor: Temperature.
   - **Subplot Unit:** The **mini-bioreactor culture vessel** sampled from each tank (24 units total). Receives the Easy-to-Change factor: Feed formulation.
3. **Why Regular ANOVA Fails:**
   - Temperature was only replicated **3 times per level** (6 tanks total), giving only **4 degrees of freedom** for whole-plot error.
   - Regular Two-Way ANOVA mistakenly assumes all 24 observations were independent temperature runs, pooling large tank-to-tank noise with tiny flask-to-flask noise.
   - Testing Temperature against this falsely small pooled error produces $F = 9.67, p = 0.0067$ (falsely claiming temperature is significant).
   - In reality, when tested against the true tank error, $F = 2.91, p = 0.163$ (not significant). Regular ANOVA commits a **Type I Error (False Positive)**.

---

### Part 2: Complete Split-Plot ANOVA Table (15 Points)

#### 1. Simple Degrees of Freedom Arithmetic:
- Number of temperatures ($a$): 2 $\implies df = a - 1 = \mathbf{1}$
- Tanks per temperature ($r$): 3 $\implies \text{Whole-Plot Error } df = a(r - 1) = 2(2) = \mathbf{4}$
- Number of feeds ($b$): 4 $\implies df = b - 1 = \mathbf{3}$
- Interaction ($Temp \times Feed$): $(a - 1)(b - 1) = (1)(3) = \mathbf{3}$
- Total observations: $N = 24 \implies df = N - 1 = \mathbf{23}$
- Subplot Error $df$: $23 - 1 - 4 - 3 - 3 = \mathbf{12}$

#### 2. Sums of Squares & Mean Squares:
- $SS_{Total} = \mathbf{71.98}$
- $SS_{Temp} = \mathbf{12.06} \implies MS_{Temp} = \frac{12.06}{1} = \mathbf{12.056}$
- $SS_{WP\ Error} = \mathbf{16.55} \implies MS_{WP\ Error} = \frac{16.55}{4} = \mathbf{4.137}$
- $SS_{Feed} = \mathbf{39.09} \implies MS_{Feed} = \frac{39.09}{3} = \mathbf{13.029}$
- $SS_{Interaction} = \mathbf{0.88} \implies MS_{Interaction} = \frac{0.88}{3} = \mathbf{0.295}$
- $SS_{SP\ Error} = 71.98 - 12.06 - 16.55 - 39.09 - 0.88 = \mathbf{3.40} \implies MS_{SP\ Error} = \frac{3.40}{12} = \mathbf{0.284}$

#### 3. $F$-Test Calculations:
- **Temperature:** $F = \frac{MS_{Temp}}{MS_{WP\ Error}} = \frac{12.056}{4.137} = \mathbf{2.91}, \quad p = \mathbf{0.163}$
- **Feed:** $F = \frac{MS_{Feed}}{MS_{SP\ Error}} = \frac{13.029}{0.284} = \mathbf{45.94}, \quad p = \mathbf{7.47 \times 10^{-7}}$
- **Interaction:** $F = \frac{MS_{Interaction}}{MS_{SP\ Error}} = \frac{0.295}{0.284} = \mathbf{1.04}, \quad p = \mathbf{0.410}$

#### Master Split-Plot ANOVA Table

| Source of Variation | DF | Sum of Squares (SS) | Mean Square (MS) | F-Ratio | p-value | Significance ($\alpha=0.05$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Temperature (Factor A)** | **1** | **12.06** | **12.056** | **2.91** | **0.163** | Not Significant |
| **WP Error (Tanks)** | **4** | **16.55** | **4.137** | — | — | *(Denominator for Factor A)* |
| **Feed Formulation (Factor B)** | **3** | **39.09** | **13.029** | **45.94** | **$< 0.001$** | **Highly Significant (***)** |
| **Temperature $\times$ Feed** | **3** | **0.88** | **0.295** | **1.04** | **0.410** | Not Significant |
| **Subplot Error** | **12** | **3.40** | **0.284** | — | — | *(Denominator for B & AB)* |
| **Total** | **23** | **71.98** | — | — | — | — |

---

### Part 3: The Professor's Expected ToolPak Method (10 Points)

Write these exact steps on your exam paper:

1. **Step 1: Single Factor ANOVA on Tank Averages**
   - Calculate the 6 tank averages: `=AVERAGE(C2:F2)`.
   - Place the $32^\circ\text{C}$ averages in Column J and $37^\circ\text{C}$ averages in Column K.
   - Go to **Data > Data Analysis > Anova: Single Factor** on `J1:K4`.
   - **Scale up by $b = 4$:**  
     Because averages have $1/4$ the variance of individual numbers, multiply the ToolPak SS by $b = 4$:
     $$SS_{Temp} = 4 \times 3.014 = \mathbf{12.056}$$
     $$SS_{WP\ Error} = 4 \times 4.137 = \mathbf{16.550}$$
2. **Step 2: Two-Factor ANOVA on Raw Data**
   - Arrange data with Rows = Temperature ($r = 3$ rows per temperature) and Columns = Feeds.
   - Go to **Data > Data Analysis > Anova: Two-Factor With Replication** (Rows per sample = 3).
   - Extract: $SS_{Total} = \mathbf{71.98}$, $SS_{Columns} = \mathbf{39.09}$, $SS_{Interaction} = \mathbf{0.88}$.
3. **Step 3: Subplot Error by Subtraction**
   $$SS_{SP\ Error} = 71.98 - 12.056 - 16.550 - 39.09 - 0.88 = \mathbf{3.40}$$
   $$DF_{SP\ Error} = 23 - 1 - 4 - 3 - 3 = \mathbf{12}, \quad MS_{SP\ Error} = \frac{3.40}{12} = \mathbf{0.284}$$
4. **Step 4: P-Values by Formula**
   - Temperature: `=F.DIST.RT(2.91, 1, 4)` $\rightarrow \mathbf{0.163}$
   - Feed: `=F.DIST.RT(45.94, 3, 12)` $\rightarrow \mathbf{7.47 \times 10^{-7}}$
   - Interaction: `=F.DIST.RT(1.04, 3, 12)` $\rightarrow \mathbf{0.410}$

---

### Part 4: Your R Terminal Solution via CSV (10 Points)

#### 1. The Tidy CSV File (`split_plot.csv`):
In LibreOffice Calc, create 4 columns and export as `split_plot.csv`:
```csv
wp,temp,feed,titer
1,32C,1,5.00
1,32C,2,6.62
1,32C,3,9.45
1,32C,4,6.02
2,32C,1,3.95
...
6,37C,4,3.44
```

#### 2. The Base R Script:
```r
# 1. Read CSV file
dat <- read.csv("split_plot.csv")

# 2. Tell R that wp, temp, and feed are categories (NOT continuous numbers!)
dat$wp   <- factor(dat$wp)    # Unique Tank ID (1 to 6)
dat$temp <- factor(dat$temp)  # Factor A
dat$feed <- factor(dat$feed)  # Factor B

# 3. Fit Split-Plot Model
# Error(wp) tells R to use whole-plot error for temp and subplot error for feed!
fit <- aov(titer ~ temp * feed + Error(wp), data = dat)

# 4. View results
summary(fit)
```

**Actual R Output:**
```
Error: wp
          Df Sum Sq Mean Sq F value Pr(>F)
temp       1  12.06  12.056   2.914  0.163
Residuals  4  16.55   4.137               

Error: Within
          Df Sum Sq Mean Sq F value   Pr(>F)    
feed       3  39.09  13.029   45.94 7.47e-07 ***
temp:feed  3   0.88   0.295    1.04     0.41    
Residuals 12   3.40   0.284                     
```

---

### Part 5: Statistical Conclusions & Recommendations (5 Points)

1. **Temperature ($p = 0.163 > 0.05$):** Fail to reject $H_0$. Temperature is not statistically significant. The difference between $32^\circ\text{C}$ and $37^\circ\text{C}$ is within normal tank-to-tank batch noise.
2. **Feed Formulation ($p = 7.47 \times 10^{-7} < 0.001$):** Reject $H_0$. Feed has an overwhelming, highly significant impact on antibody yield. Feed 3 (Lipid-supplemented) produced the highest mean titer ($7.49\text{ g/L}$ vs $4.03\text{ g/L}$ for basal control).
3. **Interaction ($p = 0.410 > 0.05$):** Fail to reject $H_0$. Interaction is not significant; Feed 3 performs best at both temperatures.
4. **Engineering Recommendation:** Standardize on **Feed 3 (Lipid Supplement)**, yielding an approximate **$86\%$ titer increase**. Because temperature has no significant effect, operate at the standard $37^\circ\text{C}$ condition for faster cell growth.

