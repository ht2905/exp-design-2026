# Experimental Design Midterm Exam: Master Self-Study Book (v02)
**Course:** BT317IU – Experimental Design & Biostatistics  
**Exam Format:** 2 Questions (50 Points Each, 100 Points Total)  
**Exam Rules:** Base R Terminal only (R 4.x), Microsoft Excel (Data Analysis ToolPak & Formulas), No Internet, No Pre-made Scripts. One handwritten A4 sheet permitted.

---

## What is New in v02?
This second edition (v02) is built specifically to address core statistical foundations:
- **No confusing metaphors or "mental anchors":** Direct, clean mathematical and statistical definitions.
- **Dedicated Biostatistics Primer (`00_biostats_crash_course.md`):** Complete, plain-English breakdown of core concepts: factors, levels, degrees of freedom, Sum of Squares, Mean Squares, $t$-tests, $F$-tests, p-values, Type I/II errors, and $R^2$.
- **Direct Bridge to Exam Topics:** Every basic concept is explicitly connected to where and how it appears in Split-Plot ANOVA tables and RSM regression outputs.
- **Strictly Aligned Practice Problems:** Step-by-step numeric walkthroughs for both Question 1 (Split-Plot) and Question 2 (RSM / BBD / CCD).

---

## Master Table of Contents

| File | Title | Key Contents |
| :--- | :--- | :--- |
| **[`00_biostats_crash_course.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v02/00_biostats_crash_course.md)** | **Foundational Biostatistics Primer** | Complete guide to core biostats: Population vs Sample, Variance ($s^2$), Standard Deviation ($s$), Standard Error ($SE$), $z$-test vs $t$-test (one-sample, 2-sample, paired), One-Way & Two-Way ANOVA (with/without replication), Post-hoc (Tukey/LSD), Non-parametric tests (Wilcoxon Rank-Sum, Wilcoxon Signed-Rank, Kruskal-Wallis), Goodness of Fit ($\chi^2$ & Lack of Fit), and Correlation/Regression ($r, R^2, R^2_{adj}$). |
| **[`01_split_plot_design_and_analysis.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v02/01_split_plot_design_and_analysis.md)** | **Split-Plot Design & Analysis** | Hard-to-change vs easy-to-change factors, experimental units, the two error variances, ANOVA table arithmetic, Excel 2-step method, and Base R `aov()`. |
| **[`02_rsm_ccd_bbd.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v02/02_rsm_ccd_bbd.md)** | **RSM, CCD, & BBD** | Second-order model, factor coding math, CCD vs BBD geometry, `library(rsm)` functions, Lack-of-Fit test, stationary point math, and eigenvalue analysis. |
| **[`03_question1_split_plot_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v02/03_question1_split_plot_exam_practice.md)** | **50-Pt Practice: Question 1 (Split-Plot)** | Realistic wet-lab scenario, full dataset, manual calculations, step-by-step Excel ToolPak walkthrough, Base R code, and output interpretation. |
| **[`04_question2_rsm_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v02/04_question2_rsm_exam_practice.md)** | **50-Pt Practice: Question 2 (RSM/BBD)** | 3-factor BBD optimization, full dataset, R Terminal code, annotated output, stationary point decoding, eigenanalysis, and biological conclusion. |
| **[`05_a4_cheat_sheet_handwritten_guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v02/05_a4_cheat_sheet_handwritten_guide.md)** | **Handwritten A4 Cheat Sheet Master Layout** | Compact, high-density reference sheet designed to be copied directly onto your permitted A4 paper (Front: Split-Plot; Back: RSM/CCD/BBD). |

---

## Suggested Study Path
1. Read **Chapter 00** first to ensure you have 100% clarity on what $t$, $F$, $SS$, $MS$, $df$, and p-value actually mean.
2. Read **Chapter 01** and work through **Chapter 03** for Question 1 (Split Plot in Excel & Base R).
3. Read **Chapter 02** and work through **Chapter 04** for Question 2 (RSM, CCD, BBD in R Terminal).
4. Transcribe **Chapter 05** onto your A4 paper by hand.

