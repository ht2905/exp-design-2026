# Experimental Design Midterm Exam: Master Self-Study Book (v04)
**Course:** BT317IU – Experimental Design & Biostatistics  
**Exam Format:** 2 Questions (50 Points Each, 100 Points Total)  
**Exam Conditions:** Base R Terminal only (R 4.x), Microsoft Excel / LibreOffice Calc (Data Analysis ToolPak & Formulas), No Internet, No Pre-made Scripts. One handwritten A4 sheet permitted.

---

## What is New in v04? (Three-Way Split-Plot & Linux/CachyOS Ready)

In this fourth edition (v04), all Split-Plot guides and mock problems have been upgraded to provide **three complete, distinct workflows**:
1. **The R Way (Your Primary Exam Strategy):** Clean, 5-line Base R Terminal workflow using `aov(y ~ A * B + Error(wp))` with zero dependencies and automatic error routing.
2. **The Expected Excel ToolPak Way:** The two-step procedure (`Anova: Single Factor` with scaling factor $b$ + `Anova: Two-Factor With Replication` + Subtraction) expected by professors who teach using MS Office.
3. **The LibreOffice Calc Way (Linux / CachyOS):** How to run the exact same analysis locally on CachyOS using `/usr/bin/localc` and its built-in `Data > Statistics > ANOVA` tools.

All diagrams use mobile-responsive Mermaid and native Markdown tables so you can read them comfortably on a smartphone.

---

## Master Table of Contents

| File | Title | Description & Core Topics |
| :--- | :--- | :--- |
| **[`00_biostats_crash_course.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v04/00_biostats_crash_course.md)** | **Foundational Biostatistics Primer** | Core biostats from first principles: Population vs Sample, Variance ($s^2$), Standard Deviation ($s$), Standard Error ($SE$), $z$-test vs $t$-test flowchart, One-Way & Two-Way ANOVA (with/without replication), Post-hoc (Tukey/LSD), Non-parametric tests (Wilcoxon Rank-Sum, Signed-Rank, Kruskal-Wallis), Goodness of Fit ($\chi^2$ & Lack of Fit), and Correlation/Regression ($r, R^2, R^2_{adj}$). |
| **[`01_split_plot_design_and_analysis.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v04/01_split_plot_design_and_analysis.md)** | **Split-Plot Design & Analysis** | Split-Plot architecture flowchart, Whole-Plot (HTC) vs Subplot (ETC) factors, dual error variances, and full guides for **The R Way**, **The Excel ToolPak Way**, and **The LibreOffice Calc Way**. |
| **[`02_rsm_ccd_bbd.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v04/02_rsm_ccd_bbd.md)** | **RSM, CCD, & BBD** | Second-order response surfaces, factor coding math, CCD vs BBD geometry comparison flowchart, `library(rsm)` functions, Lack-of-Fit test, stationary point coordinates, and canonical eigenvalue analysis. |
| **[`03_question1_split_plot_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v04/03_question1_split_plot_exam_practice.md)** | **50-Pt Practice: Question 1 (Split-Plot)** | Bioreactor monoclonal antibody experiment ($N=24$), manual $df$ and $SS$ calculations, and full step-by-step solutions in **Base R**, **Excel ToolPak**, and **LibreOffice Calc**. |
| **[`04_question2_rsm_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v04/04_question2_rsm_exam_practice.md)** | **50-Pt Practice: Question 2 (RSM/BBD)** | 3-factor enzymatic cell lysis optimization ($N=15$), R Terminal script, Lack-of-Fit test, stationary point decoding, and eigenanalysis proving a true local maximum. |
| **[`05_a4_cheat_sheet_handwritten_guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v04/05_a4_cheat_sheet_handwritten_guide.md)** | **Handwritten A4 Cheat Sheet Master Layout** | High-density reference layout for your permitted A4 sheet, prioritizing the concise 5-line Base R script alongside spreadsheet cheat notes. |

---

## Recommended Study Path
1. **Chapter 00:** Ensure 100% clarity on $t, F, SS, MS, df$, p-value, and ANOVA mechanics.
2. **Chapters 01 & 03:** Master Question 1 (Split-Plot in R Terminal, with Excel/Calc theory as backup).
3. **Chapters 02 & 04:** Master Question 2 (RSM, CCD, BBD in R Terminal).
4. **Chapter 05:** Transcribe the condensed cheat sheet onto your physical A4 sheet.

