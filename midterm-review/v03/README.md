# Experimental Design Midterm Exam: Master Self-Study Book (v03)
**Course:** BT317IU – Experimental Design & Biostatistics  
**Exam Format:** 2 Questions (50 Points Each, 100 Points Total)  
**Exam Conditions:** Base R Terminal only (R 4.x), Microsoft Excel (Data Analysis ToolPak & Formulas), No Internet, No Pre-made Scripts. One handwritten A4 sheet permitted.

---

## What is New in v03? (Mobile-Optimized & Responsive)
This third edition (v03) is completely optimized for readability on **all screen sizes, including smartphones and tablets**:
- **Zero ASCII Art Code Blocks:** All wide ASCII art, box-drawing characters (`┌──┐`), and fixed-width text diagrams have been replaced.
- **Native Mermaid Flowcharts:** Diagrams are rendered using responsive vector Mermaid syntax (`mermaid`) that automatically scales to any viewport width.
- **Responsive Markdown Tables & Cards:** Tables and callout blocks reflow naturally without horizontal scrolling or ugly line breaks on small screens.
- **Ultra-Readable Mobile Cheat Sheet:** The handwritten A4 template in Chapter 05 uses responsive Markdown cards with concise code lines (< 50 chars).

---

## Master Table of Contents

| File | Title | Description & Core Topics |
| :--- | :--- | :--- |
| **[`00_biostats_crash_course.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v03/00_biostats_crash_course.md)** | **Foundational Biostatistics Primer** | Core biostats from first principles: Population vs Sample, Variance ($s^2$), Standard Deviation ($s$), Standard Error ($SE$), $z$-test vs $t$-test flowchart, One-Way & Two-Way ANOVA (with/without replication), Post-hoc (Tukey/LSD), Non-parametric tests (Wilcoxon Rank-Sum, Signed-Rank, Kruskal-Wallis), Goodness of Fit ($\chi^2$ & Lack of Fit), and Correlation/Regression ($r, R^2, R^2_{adj}$). |
| **[`01_split_plot_design_and_analysis.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v03/01_split_plot_design_and_analysis.md)** | **Split-Plot Design & Analysis** | Split-Plot architecture flowchart, Whole-Plot (HTC) vs Subplot (ETC) factors, why two separate error variances are strictly required, Excel Two-Step ToolPak workflow with scaling rule ($b$), and Base R `aov(y ~ A * B + Error(wp))`. |
| **[`02_rsm_ccd_bbd.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v03/02_rsm_ccd_bbd.md)** | **RSM, CCD, & BBD** | Second-order response surfaces, factor coding math, CCD vs BBD geometry comparison flowchart, `library(rsm)` functions, Lack-of-Fit test, stationary point coordinates, and canonical eigenvalue analysis. |
| **[`03_question1_split_plot_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v03/03_question1_split_plot_exam_practice.md)** | **50-Pt Practice: Question 1 (Split-Plot)** | Bioreactor monoclonal antibody experiment ($N=24$), manual $df$ and $SS$ calculations, step-by-step Excel ToolPak walkthrough, Base R code, and output analysis. |
| **[`04_question2_rsm_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v03/04_question2_rsm_exam_practice.md)** | **50-Pt Practice: Question 2 (RSM/BBD)** | 3-factor enzymatic cell lysis optimization ($N=15$), R Terminal script, Lack-of-Fit test, stationary point decoding, and eigenanalysis proving a true local maximum. |
| **[`05_a4_cheat_sheet_handwritten_guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v03/05_a4_cheat_sheet_handwritten_guide.md)** | **Handwritten A4 Cheat Sheet Master Layout** | High-density reference layout for your permitted A4 sheet, formatted into responsive Markdown cards designed for physical handwriting. |

---

## Recommended Study Path
1. **Chapter 00:** Ensure 100% clarity on $t, F, SS, MS, df$, p-value, and ANOVA mechanics.
2. **Chapters 01 & 03:** Master Question 1 (Split-Plot in Excel & Base R Terminal).
3. **Chapters 02 & 04:** Master Question 2 (RSM, CCD, BBD in R Terminal).
4. **Chapter 05:** Transcribe the condensed cheat sheet onto your physical A4 sheet.

