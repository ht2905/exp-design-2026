# Midterm Examination Blueprint & Question Prediction Guide
**Course:** Experimental Design (BI313IU)  
**Instructor:** Dr. Nguyễn Tấn Khôi – School of Biotechnology, International University (VNU-HCMC)  
**Format:** Open-book exam (Calculators not required; Excel permitted; R Terminal scripts used for rapid verification)  
**Total Points:** 100 Points | **Duration:** 90–120 Minutes

---

## 1. Executive Summary & Predicted Structure

Based on analysis of past midterm exams (2020, 2022) and course lecture materials, the midterm exam consistently follows a **two-question structure (50 points each)**:

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                    MIDTERM EXAM STRUCTURE (100 POINTS)                       │
├──────────────────────────────────────────────────────────────────────────────┤
│  QUESTION 1: Split-Plot Design Analysis (50 Points)                         │
│  • Agricultural / Food / Bioprocess experiment                               │
│  • RCBD or CRD layout (Hard-to-Change vs Easy-to-Change factors)             │
│  • Sub-questions: Design ID, Hypotheses, HTC/ETC factors, Units,             │
│    ANOVA Table (WP Error vs SP Error), and Biological Conclusion             │
├──────────────────────────────────────────────────────────────────────────────┤
│  QUESTION 2: Response Surface Methodology (RSM) Optimization (50 Points)     │
│  • 3-Factor Box-Behnken (BBD) or Central Composite Design (CCD)              │
│  • Sub-questions: Design Rationale & Coding Equations, 2nd-Order Model,      │
│    ANOVA Decomposition (FO, TWI, PQ), Lack-of-Fit Diagnostic,                │
│    Stationary Point (Coded & Natural), Canonical Eigenvalues, & Next Step    │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Detailed Breakdown of Question 1: Split-Plot Design (50 Points)

### Typical Context & Scenarios
- **Scenario A (Pasture & Feed - 2022 style):** 24 dairy cows evaluated for milk yield under 4 pasture types (WP) and 2 mineral feeds (SP), blocked across 3 seasons.
- **Scenario B (Meat Tenderization - 2020 style):** 24 carcasses split into halves; one half tunnel cooled, one conventional cooled (SP), across low/high muscle pH (WP).
- **Scenario C (Bioreactor Cell Culture):** Bioreactors operated at different temperatures (WP: $32^\circ\text{C}$ vs $37^\circ\text{C}$), split into culture vessels receiving different nutrient feed media (SP).

### Expected Sub-Questions & Mark Distribution

| Sub-Question | Points | Professor's Specific Requirement | Key Concept / Catch |
| :--- | :---: | :--- | :--- |
| **a. Design Identification & Hypotheses** | 10 pts | State $H_0$ and $H_1$ for Whole-Plot, Subplot, and Interaction. Name the exact design (Split-Plot in CRD or Split-Plot in RCBD). | Must write 3 distinct null/alternative hypothesis pairs ($\mu_A, \mu_B, (\alpha\beta)_{ij} = 0$). |
| **b. HTC vs ETC & Experimental Units** | 10 pts | Identify Hard-to-Change (Whole-Plot) and Easy-to-Change (Subplot) factors. Explicitly name the **Whole-Plot Unit** and **Subplot Unit**. | **Crucial:** The WP unit is the larger entity (e.g., pasture field, carcass, or bioreactor tank); the SP unit is the divided part (e.g., individual cow half, culture vessel). |
| **c. Economic / Operational Rationale** | 10 pts | Explain why Split-Plot was chosen instead of a Completely Randomized Factorial Design (CRD). | **Key Phrase:** *Operational constraint & economic cost*. It is practically impossible or prohibitively expensive to reset the HTC factor (temperature, pasture) independently for every single run. Split-plot sacrifices WP precision to gain high precision on the SP factor and interaction. |
| **d. ANOVA Table & Statistical Decisions** | 20 pts | Compute degrees of freedom ($df$), Sum of Squares ($SS$), Mean Squares ($MS$), $F$-ratios, and $p$-values. State conclusion at $\alpha = 0.05$. | **The #1 Grading Trap:** The Whole-Plot factor MUST be tested against **Whole-Plot Error** ($MS_{\text{WP Error}}$), NOT Residual Subplot Error! Testing against Subplot Error inflates the Type I error rate (false positive). |

---

## 3. Detailed Breakdown of Question 2: Response Surface Methodology (50 Points)

### Typical Context & Scenarios
- **Scenario A (Bioprocess Yield):** Optimizing enzyme lysis, extraction yield, or bacterial biomass using 3 quantitative factors (Temperature $X_1$, Enzyme concentration $X_2$, Incubation time $X_3$).
- **Scenario B (Mechanical/Chemical Process - 2022 style):** Minimizing mass loss $M$ [g] or maximizing output using factors $L$, $D_{\text{in}}$, $D_{\text{out}}$.

### Expected Sub-Questions & Mark Distribution

| Sub-Question | Points | Professor's Specific Requirement | Key Concept / Catch |
| :--- | :---: | :--- | :--- |
| **a. Design Rationale & Factor Coding** | 15 pts | State the objective of RSM. Provide the factor coding formulas ($x_i$). Explain why BBD (or CCD) was chosen over standard factorials. | **BBD Advantage:** Only 3 factor levels ($-1, 0, +1$); no extreme corner combinations ($(\pm 1, \pm 1, \pm 1)$ avoided), which protects fragile enzymes or cells from denaturation; requires fewer runs ($N = 12 + n_0$). |
| **b. Parameter Optimization & ANOVA** | 25 pts | Fit the second-order model $\hat{y} = \beta_0 + \sum \beta_i x_i + \sum \beta_{ii} x_i^2 + \sum \beta_{ij} x_i x_j$. Present the ANOVA table, Lack-of-Fit test, Stationary Point ($\mathbf{x}_0$) in coded and natural units, Canonical eigenvalues ($\lambda_i$), and predicted optimum $\hat{y}_0$. | 1. **Lack-of-Fit:** $p > 0.05 \implies$ Adequate model (no significant lack of fit).<br>2. **Canonical Analysis:** All $\lambda_i < 0 \implies$ Unique Local Maximum; all $\lambda_i > 0 \implies$ Unique Local Minimum.<br>3. **Physical conversion:** $X_i = \text{Midpoint}_i + x_{0,i} \times \text{Step}_i$. |
| **c. Final Step / Verification Run** | 10 pts | What is the final step required in this optimization workflow? | **Wet-Lab Confirmatory Experiment:** You must run 3–5 replicate experiments at the calculated physical optimum $(X_1^*, X_2^*, X_3^*)$ to verify that the empirical yield falls within the 95% prediction interval of $\hat{y}_0$. |

---

## 4. Cheat-Sheet Mapping: Which Script to Use When

```
Exam Question Type
 ├── Split-Plot Design
 │    ├── Completely Randomized (no blocks) ──> scripts/concise/crd_split_plot.R
 │    └── Randomized Complete Block (blocks) ──> scripts/concise/rcbd_split_plot.R
 └── Response Surface Methodology (RSM)
      ├── Box-Behnken Design (3 levels: -1, 0, +1) ──> scripts/concise/bbd_rsm.R
      └── Central Composite Design (5 levels: -α, -1, 0, +1, +α) ──> scripts/concise/ccd_rsm.R
```
