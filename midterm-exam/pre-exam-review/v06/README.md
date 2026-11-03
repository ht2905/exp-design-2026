# Experimental Design Midterm Exam: Master Self-Study Book (v06)
**Course:** BT317IU – Experimental Design & Biostatistics  
**Exam Format:** 2 Questions (50 Points Each, 100 Points Total)  
**Professor's Exam Expectations:**
- **Question 1 (50 pts):** Split-Plot Experimental Design & Analysis. *Professor expects Microsoft Excel Data Analysis ToolPak* (or manual arithmetic). Can also be answered/verified via Base R Terminal.
- **Question 2 (50 pts):** Response Surface Methodology (RSM), CCD & BBD. *Professor expects R Terminal exclusively* (`library(rsm)`).
- **Your Personal Strategy:** You plan to solve **both questions using R Terminal via CSV files created in LibreOffice**, while knowing the exact ToolPak steps to satisfy your professor's grading rubric.

---

## What is New in v06? (Biology-First, Zero Math Overload)

This sixth edition (v06) is specially customized for **biomedical and wet-lab scientists**:
1. **No Intimidating Equations:** All RSM mathematical equations (Greek-letter summation series $\sum\sum\beta_{ij} x_i x_j$, calculus derivatives, matrix formulas, and Euclidean distance formulas) have been replaced with **intuitive wet-lab biological explanations**.
2. **The Biological Peak:** Curvature and quadratic modeling are explained through cell biology and enzyme kinetics (rising reaction rates until thermal denaturation/inhibition causes yield to drop, creating a natural hilltop).
3. **Bench Protocol Coding:** Coding is treated like a simple 3-point bench setting dial ($-1$ Low, $0$ Center, $+1$ High) with direct, one-step physical decoding.
4. **Sign-Only Eigenanalysis:** You don't need matrix decomposition or eigenvectors. You simply check the **signs ($+$ or $-$)** of R's eigenvalues: **All negative = Mountain Peak (Maximum Yield)**.
5. **Strict AGENTS.md Compliance:** 100% Obsidian-compatible Mermaid flowcharts and Markdown tables throughout.

---

## Master Table of Contents

| File | Title | Description & Core Focus |
| :--- | :--- | :--- |
| **[`00_biostats_crash_course.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/00_biostats_crash_course.md)** | **Foundational Biostatistics Primer** | Core biostatistics explained without math jargon: What is a variance? Why square numbers? What is a degree of freedom really? What does $F$ measure? What is a p-value? |
| **[`01_split_plot_design_and_analysis.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/01_split_plot_design_and_analysis.md)** | **Split-Plot Design & Analysis** | Split-Plot biology concepts, why regular ANOVA fails, step-by-step arithmetic of Sums of Squares, the **Expected Excel ToolPak method** (with scaling factor $b$), and the **R via CSV method**. |
| **[`02_rsm_ccd_bbd.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/02_rsm_ccd_bbd.md)** | **RSM, CCD, & BBD for Biologists** | Why biological reactions peak, 3-point bench coding, CCD vs BBD safety for fragile enzymes, Lack-of-Fit intuition ($p > 0.05$), and sign-based peak identification. |
| **[`03_question1_split_plot_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/03_question1_split_plot_exam_practice.md)** | **50-Pt Practice: Question 1 (Split-Plot)** | Bioreactor monoclonal antibody experiment ($N=24$). Solved primarily via **Excel ToolPak & formulas** (professor's expectation) and completely via **Base R via CSV** (your exam weapon). |
| **[`04_question2_rsm_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/04_question2_rsm_exam_practice.md)** | **50-Pt Practice: Question 2 (RSM/BBD)** | Enzymatic lysis optimization ($N=15$). Structured into a LibreOffice CSV, solved in R Terminal with `rsm`, full output interpretation, Lack-of-Fit test, and stationary point calculation. |
| **[`05_a4_cheat_sheet_handwritten_guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/05_a4_cheat_sheet_handwritten_guide.md)** | **Handwritten A4 Cheat Sheet Master Layout** | High-density reference layout for your permitted A4 paper. Side 1: Split-Plot (R script + Excel steps); Side 2: RSM & Eigenanalysis. |
| **[`06_midterm_scripts-guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v06/06_midterm_scripts-guide.md)** | **ED Midterm Scripts Guide** | Practical workflow flowchart and terminal instructions for running split-plot automation scripts. |

---

## Suggested Study Path
1. Read **Chapter 00** to demystify standard biostatistical terms ($SS, MS, df, F, p$).
2. Read **Chapter 01** and work through **Chapter 03** for Question 1 (understand what ToolPak does, then master the 5-line R solution).
3. Read **Chapter 02** and work through **Chapter 04** for Question 2 (master the R Terminal commands and eigenvalue rules).
4. Transcribe **Chapter 05** onto your physical A4 sheet by hand.
