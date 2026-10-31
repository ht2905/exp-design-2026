# Experimental Design Midterm Exam: Master Self-Study Guide
**Course:** BT317IU – Experimental Design / Biostatistics  
**Exam Format:** 2 Questions (50 Points Each, 100 Points Total)  
**Permitted Aids:** One handwritten A4 sheet of paper. Base R in R Terminal & Microsoft Excel. No Internet access.

---

## Welcome & Overview

This self-study book is designed specifically for your midterm exam. As a bioinformatician in a wet-lab oriented biotechnology class, you need to master both:
1. **The deep statistical intuition** (why each formula works, why traditional tests fail, how degrees of freedom are divided, how error terms are chosen).
2. **The exact operational execution** in Excel and base R Terminal (the exact syntax, data reshaping, commands, and outputs you need to handwrite and replicate under strict exam conditions).

---

## Exam Blueprint & Point Distribution

```
========================================================================================
MIDTERM EXAM (100 POINTS TOTAL)
========================================================================================
├── QUESTION 1: Split-Plot Experimental Design & Analysis (50 Points)
│   ├── Part A: Design Identification & Experimental Unit Justification (10 pts)
│   ├── Part B: Complete Split-Plot ANOVA Table Construction & EMS (15 pts)
│   ├── Part C: Excel Analysis ToolPak / Formula Execution (10 pts)
│   ├── Part D: Base R Terminal Implementation (10 pts)
│   └── Part E: Wet-Lab Biological Interpretation & Decisions (5 pts)
│
└── QUESTION 2: Response Surface Methodology (RSM), CCD & BBD (50 Points)
    ├── Part A: Design Selection (CCD vs BBD) & Factor Coding Equations (10 pts)
    ├── Part B: R Terminal Model Fitting (`SO`) & Parameter Estimates (10 pts)
    ├── Part C: ANOVA Decomposition & Lack-of-Fit Interpretation (10 pts)
    ├── Part D: Stationary Point & Canonical / Eigenanalysis (10 pts)
    └── Part E: Optimization Decision & Contour Visualization Interpretation (10 pts)
========================================================================================
```

---

## Guide Structure & Table of Contents

| File | Title | Description |
| :--- | :--- | :--- |
| **[`01_split_plot_deep_dive.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/01_split_plot_deep_dive.md)** | **Split-Plot Design: Theory, Excel & Base R** | Deep conceptual root of split-plot designs, hard-to-change vs easy-to-change factors, two error variances, expected mean squares, Excel 2-step ToolPak method, and base R `aov()` with `Error()`. |
| **[`02_rsm_ccd_bbd_deep_dive.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/02_rsm_ccd_bbd_deep_dive.md)** | **RSM, CCD, & BBD: Theory, Modeling & R Terminal** | Response surface methodology from screening to optimization, CCD vs BBD geometry, rotatability, coding transformations, `rsm` package commands, lack-of-fit testing, stationary points, and eigenvalue analysis. |
| **[`03_question1_split_plot_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/03_question1_split_plot_exam_practice.md)** | **50-Pt Mock Exam: Question 1 (Split-Plot)** | Realistic biotechnology bioreactor experiment. Full question prompt, complete manual calculations, step-by-step Excel instructions, R Terminal commands, and model answers. |
| **[`04_question2_rsm_exam_practice.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/04_question2_rsm_exam_practice.md)** | **50-Pt Mock Exam: Question 2 (RSM/BBD)** | Realistic protein extraction optimization experiment. Full question prompt, R Terminal code execution, annotated R outputs, stationary point decoding, eigenanalysis, and wet-lab recommendations. |
| **[`05_a4_cheat_sheet_handwritten_guide.md`](file:///home/ht2905/projects/exp-design_2026-2027/midterm-review/05_a4_cheat_sheet_handwritten_guide.md)** | **Handwritten A4 Cheat Sheet Master Layout** | Exact high-density, condensed reference sheet designed to be copied directly onto your permitted A4 sheet. Front side: Split-Plot; Back side: RSM/CCD/BBD. |

---

## How to Study for This Exam

1. **Phase 1 (Concepts & Root Logic):** Read Chapters 01 and 02. Make sure you understand *why* whole-plots have larger error variance and *why* stationary point eigenvalues tell you if a peak is a mountain top or a saddle.
2. **Phase 2 (Hands-on Practice):** Open an empty R Terminal (and Excel) and work through the mock exams in Chapters 03 and 04 without looking at the solutions. Verify your numbers match the provided output.
3. **Phase 3 (A4 Sheet Preparation):** Copy the layout in Chapter 05 by hand onto clean A4 paper. Handwriting the code and equations commits the syntax to muscle memory, guaranteeing zero panic in the exam hall.

