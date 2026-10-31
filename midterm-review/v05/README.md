# Experimental Design Midterm Exam: Master Self-Study Book (v05)
**Course:** BT317IU – Experimental Design & Biostatistics  
**Exam Format:** 2 Questions (50 Points Each, 100 Points Total)  
**Professor's Exam Expectations:**
- **Question 1 (50 pts):** Split-Plot Experimental Design & Analysis. *Professor expects Microsoft Excel Data Analysis ToolPak* (or manual arithmetic). Can also be answered/verified via Base R Terminal.
- **Question 2 (50 pts):** Response Surface Methodology (RSM), CCD & BBD. *Professor expects R Terminal exclusively* (`library(rsm)`).
- **Your Personal Strategy:** You plan to solve **both questions using R Terminal via CSV files created in LibreOffice**, while knowing the exact ToolPak steps to satisfy your professor's grading rubric.

---

## What is New in v05? (Intuitive, Step-by-Step Math)

This fifth edition (v05) is specifically designed for biology students **without an advanced math or engineering background**:
1. **Demystified Math:** Rather than presenting cold, intimidating matrix formulas ($-\frac{1}{2}\mathbf{B}^{-1}\mathbf{b}$ or $\sum\sum(\alpha\beta)^2$), every mathematical step is explained using simple arithmetic (adding, subtracting, dividing, and basic high-school algebra).
2. **"Why This Number Exists":** We explain the intuitive mechanical reason behind every calculation—why we square deviations, why we divide by degrees of freedom, why the scaling factor $b$ is needed, and why eigenvalues indicate hilltops vs. saddles.
3. **Dual-Track Presentation:**
   - **Track 1 (The Professor's Expected Track):** Question 1 is worked out primarily using the **Excel ToolPak 2-Step Method** (with clear spreadsheet cell formulas), and Question 2 is solved using **R Terminal (`rsm`)**.
   - **Track 2 (Your Track - R via CSV):** Both questions are equipped with ready-made, copy-paste **Base R scripts** reading tidy CSV files created in LibreOffice.
4. **Mobile & Exam Ready:** Clean, responsive formatting that reads easily on a smartphone and condenses cleanly onto one double-sided handwritten A4 sheet.

---

## Master Table of Contents

| File | Title | Description & Core Focus |
| :--- | :--- | :--- |
| **[`00_biostats_crash_course.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v05/00_biostats_crash_course.md)** | **Foundational Biostatistics Primer** | Core biostatistics explained without math jargon: What is a variance? Why square numbers? What is a degree of freedom really? What does $F$ measure? What is a p-value? |
| **[`01_split_plot_design_and_analysis.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v05/01_split_plot_design_and_analysis.md)** | **Split-Plot Design & Analysis** | Split-Plot biology concepts, why regular ANOVA fails, step-by-step arithmetic of Sums of Squares, the **Expected Excel ToolPak method** (with scaling factor $b$), and the **R via CSV method**. |
| **[`02_rsm_ccd_bbd.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v05/02_rsm_ccd_bbd.md)** | **RSM, CCD, & BBD Deep-Dive** | Why we need second-order quadratic models, coding formulas explained with basic arithmetic, CCD vs BBD geometry, Lack-of-Fit intuition, stationary point concept, and plain-English eigenanalysis. |
| **[`03_question1_split_plot_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v05/03_question1_split_plot_exam_practice.md)** | **50-Pt Practice: Question 1 (Split-Plot)** | Bioreactor monoclonal antibody experiment ($N=24$). Solved primarily via **Excel ToolPak & formulas** (professor's expectation) and completely via **Base R via CSV** (your exam weapon). |
| **[`04_question2_rsm_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v05/04_question2_rsm_exam_practice.md)** | **50-Pt Practice: Question 2 (RSM/BBD)** | Enzymatic lysis optimization ($N=15$). Structured into a LibreOffice CSV, solved in R Terminal with `rsm`, full output interpretation, Lack-of-Fit test, and stationary point calculation. |
| **[`05_a4_cheat_sheet_handwritten_guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/v05/05_a4_cheat_sheet_handwritten_guide.md)** | **Handwritten A4 Cheat Sheet Master Layout** | High-density reference layout for your permitted A4 paper. Side 1: Split-Plot (R script + Excel steps); Side 2: RSM & Eigenanalysis. |

---

## Suggested Study Path
1. Read **Chapter 00** to demystify standard biostatistical terms ($SS, MS, df, F, p$).
2. Read **Chapter 01** and work through **Chapter 03** for Question 1 (understand what ToolPak does, then master the 5-line R solution).
3. Read **Chapter 02** and work through **Chapter 04** for Question 2 (master the R Terminal commands and eigenvalue rules).
4. Transcribe **Chapter 05** onto your physical A4 sheet by hand.

