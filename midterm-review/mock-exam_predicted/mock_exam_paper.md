# THE INTERNATIONAL UNIVERSITY (IU) – VIETNAM NATIONAL UNIVERSITY – HCMC
## SCHOOL OF BIOTECHNOLOGY
### MIDTERM EXAMINATION: EXPERIMENTAL DESIGN (BI313IU)
**Instructor:** Dr. Nguyễn Tấn Khôi  
**Duration:** 90–120 Minutes | **Total Marks:** 100 Points  
**Format:** Open-Book Examination (Excel spreadsheet and R Terminal scripts permitted; no calculators)

---

### GENERAL INSTRUCTIONS
1. This is an open-book examination.
2. ABSOLUTELY NO group work or unauthorized communication.
3. Show all mathematical degrees of freedom ($df$), hypotheses ($H_0, H_1$), test statistics, decision rules, and biological interpretations clearly.
4. You may use Base R / R Terminal to compute and verify ANOVA tables, Lack-of-Fit tests, and canonical response surface optimizations.

---

## QUESTION 1 (50 Points) – Split-Plot Design

An experiment was conducted to investigate the effect of **four different pasture management treatments** (Pasture 1, 2, 3, 4) and **two mineral supplement regimens** (Mineral 1: Standard, Mineral 2: Fortified) on **milk yield (kg/cow/day)**.

Due to seasonal environmental variability across the production year, the experiment was conducted across **three distinct seasons of the year** (Season 1: Spring, Season 2: Summer, Season 3: Fall), which serve as experimental blocks ($b = 3$). A total of 24 dairy cows were assigned to the treatments.

In each season:
- 4 large pasture paddocks were established. Each pasture paddock was randomly allocated one of the four pasture management treatments.
- Within each pasture paddock, cows were assigned to receive either Mineral Supplement 1 or Mineral Supplement 2.

The recorded milk yields ($\text{kg}$) are displayed below:

| Block (Season) | Pasture (WP) | Mineral (SP) | Milk Yield ($y$, kg) |
| :---: | :---: | :---: | :---: |
| 1 | 4 | 2 | 30 |
| 1 | 4 | 1 | 29 |
| 1 | 1 | 2 | 27 |
| 1 | 1 | 1 | 25 |
| 1 | 2 | 1 | 26 |
| 1 | 2 | 2 | 28 |
| 1 | 3 | 2 | 26 |
| 1 | 3 | 1 | 24 |
| 2 | 2 | 1 | 32 |
| 2 | 2 | 2 | 37 |
| 2 | 1 | 2 | 30 |
| 2 | 1 | 1 | 31 |
| 2 | 4 | 1 | 34 |
| 2 | 4 | 2 | 37 |
| 2 | 3 | 1 | 33 |
| 2 | 3 | 2 | 32 |
| 3 | 1 | 2 | 34 |
| 3 | 1 | 1 | 31 |
| 3 | 2 | 1 | 30 |
| 3 | 2 | 2 | 35 |
| 3 | 4 | 2 | 36 |
| 3 | 4 | 1 | 38 |
| 3 | 3 | 1 | 33 |
| 3 | 3 | 2 | 32 |

### Sub-Questions:
a. **(10 Points)** State the statistical hypotheses ($H_0$ and $H_1$) for the Pasture factor, the Mineral factor, and their interaction. What specific experimental design is this?  
b. **(10 Points)** Determine which factor is Hard-to-Change (HTC) and which is Easy-to-Change (ETC). Explicitly specify the **Whole-Plot Experimental Unit** and the **Subplot Experimental Unit**.  
c. **(10 Points)** Explain why this experiment was organized as a Split-Plot design rather than a Completely Randomized Factorial Design. Discuss the practical, physical, and economic reasons.  
d. **(20 Points)** Perform the complete Split-Plot ANOVA test. State the degrees of freedom ($df$), Sum of Squares ($SS$), Mean Squares ($MS$), $F$-values, and $p$-values. Clearly explain which error term is used to test the Whole-Plot factor and why. Draw final conclusions regarding the treatment effects on milk yield at significance level $\alpha = 0.05$.

---

## QUESTION 2 (50 Points) – Response Surface Methodology (RSM)

A biotechnology team is optimizing downstream enzymatic cell lysis to maximize the extraction of a recombinant therapeutic enzyme (**Protein Yield**, measured in **mg / g dry cell weight**).

Three critical quantitative factors were selected for optimization:
1. **Lysis Temperature ($X_1$, $^\circ\text{C}$):** Low = $30^\circ\text{C}$, Center = $35^\circ\text{C}$, High = $40^\circ\text{C}$
2. **Lysozyme Concentration ($X_2$, mg/mL):** Low = $0.5\text{ mg/mL}$, Center = $1.0\text{ mg/mL}$, High = $1.5\text{ mg/mL}$
3. **Incubation Time ($X_3$, min):** Low = $15\text{ min}$, Center = $30\text{ min}$, High = $45\text{ min}$

The team selected a **Box-Behnken Design (BBD)** with $k = 3$ factors and $n_0 = 3$ center point replicates ($N = 15$ experimental runs total). The experimental data is tabulated below:

| Run | Temp ($X_1$, $^\circ\text{C}$) | Lysozyme ($X_2$, mg/mL) | Time ($X_3$, min) | Coded $x_1$ | Coded $x_2$ | Coded $x_3$ | Protein Yield ($y$, mg/g) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | 30 | 0.5 | 30 | -1 | -1 | 0 | 31.8 |
| 2 | 40 | 0.5 | 30 | +1 | -1 | 0 | 37.1 |
| 3 | 30 | 1.5 | 30 | -1 | +1 | 0 | 39.3 |
| 4 | 40 | 1.5 | 30 | +1 | +1 | 0 | 39.4 |
| 5 | 30 | 1.0 | 15 | -1 | 0 | -1 | 39.0 |
| 6 | 40 | 1.0 | 15 | +1 | 0 | -1 | 40.3 |
| 7 | 30 | 1.0 | 45 | -1 | 0 | +1 | 35.3 |
| 8 | 40 | 1.0 | 45 | +1 | 0 | +1 | 39.8 |
| 9 | 35 | 0.5 | 15 | 0 | -1 | -1 | 35.2 |
| 10 | 35 | 1.5 | 15 | 0 | +1 | -1 | 42.4 |
| 11 | 35 | 0.5 | 45 | 0 | -1 | +1 | 34.9 |
| 12 | 35 | 1.5 | 45 | 0 | +1 | +1 | 38.7 |
| 13 | 35 | 1.0 | 30 | 0 | 0 | 0 | 45.3 |
| 14 | 35 | 1.0 | 30 | 0 | 0 | 0 | 45.0 |
| 15 | 35 | 1.0 | 30 | 0 | 0 | 0 | 45.3 |

### Sub-Questions:
a. **(15 Points)** Describe the experimental design process. State the purpose of Response Surface Methodology. Provide the exact mathematical coding equations to convert natural physical variables $(X_1, X_2, X_3)$ to dimensionless coded variables $(x_1, x_2, x_3)$. Explain two reasons why a **Box-Behnken Design (BBD)** was preferred over a Central Composite Design (CCD) for this wet-lab experiment.  
b. **(25 Points)** Perform the second-order response surface calculations:
   - State the fitted regression equation.
   - Present the ANOVA table with First-Order (FO), Two-Way Interaction (TWI), and Pure Quadratic (PQ) partitions.
   - Conduct the **Lack-of-Fit test** at $\alpha = 0.05$ (state $H_0, H_1, F_{\text{LOF}}$, and $p$-value) to evaluate model adequacy.
   - Calculate the **Stationary Point ($\mathbf{x}_0$)** in coded units and convert it to **natural physical units** ($^\circ\text{C}$, mg/mL, min). Is it inside the experimental domain?
   - Perform **Canonical / Eigenanalysis** on the surface curvature to prove whether the stationary point is a true Maximum, Minimum, or Saddle Point.
   - Calculate the predicted optimum Protein Yield ($\hat{y}_{\text{opt}}$).  
c. **(10 Points)** What is the critical final step that must be conducted in this optimization process before implementing these parameters in routine production?
