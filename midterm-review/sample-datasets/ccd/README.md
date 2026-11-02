# Problem 4: Central Composite Design (CCD) for Bioreactor Optimization

## Experimental Context
A pharmaceutical team is optimizing monoclonal antibody expression in fed-batch mammalian cell culture. Three continuous factors governing bioreactor performance are investigated:
- **Factor 1 (`temp`)**: Cultivation Temperature (°C) with center at 35.0°C and step size 2.0°C.
- **Factor 2 (`do`)**: Dissolved Oxygen setpoint (%) with center at 40.0% and step size 10.0%.
- **Factor 3 (`feed`)**: Nutrient Feed Rate (g/L/h) with center at 15.0 g/L/h and step size 3.0 g/L/h.
- **Response Variable (`titer`)**: Expressed protein titer (g/L).

## Design Structure
A standard rotatable Central Composite Design ($k = 3$) with $\alpha = 2^{3/4} \approx 1.682$:
- **Factorial Points ($2^3 = 8$)**: All combinations of $\pm 1$ ($x_1, x_2, x_3 \in \{-1, +1\}$).
- **Axial / Star Points ($2k = 6$)**: Points along the coordinate axes at distance $\pm \alpha = \pm 1.682$ to allow estimation of pure quadratic curvature.
- **Center Points ($n_0 = 6$)**: Replicated center runs $(0, 0, 0)$ to establish uniform variance of prediction and compute Pure Error DF = 5.
- Total runs: $N = 20$.

| Factor | Name | $-\alpha$ (-1.682) | Low (-1) | Center (0) | High (+1) | $+\alpha$ (+1.682) | Unit |
|---|---|---|---|---|---|---|---|
| $X_1$ | `temp` | 31.64 | 33.00 | 35.00 | 37.00 | 38.36 | °C |
| $X_2$ | `do` | 23.18 | 30.00 | 40.00 | 50.00 | 56.82 | % |
| $X_3$ | `feed` | 9.95 | 12.00 | 15.00 | 18.00 | 20.05 | g/L/h |
| Response | `titer` | — | — | — | — | — | g/L |

## Script Field Mapping (`ccd.R`)
```r
f           <- "datasets/ccd/data.csv"
factor_cols <- c("temp", "do", "feed")
resp_col    <- "titer"
a_rot       <- 1.682
mid         <- c(temp = 35.0, do = 40.0, feed = 15.0)
stp         <- c(temp = 2.0,  do = 10.0, feed = 3.0)
```
