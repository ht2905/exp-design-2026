# Problem 3: Box-Behnken Design (BBD) for Surface Optimization

## Experimental Context
A bioprocess engineer is optimizing an enzymatic extraction process to maximize the recovery yield of a valuable bioactive compound. Three continuous factors are examined:
- **Factor 1 (`temp`)**: Reaction Temperature (°C) ranging from 30°C to 40°C (Center = 35°C, Step = 5°C).
- **Factor 2 (`enzyme`)**: Enzyme concentration (wt%) ranging from 0.5% to 1.5% (Center = 1.0%, Step = 0.5%).
- **Factor 3 (`time`)**: Reaction time (min) ranging from 15 min to 45 min (Center = 30 min, Step = 15 min).
- **Response Variable (`yield`)**: Bioactive extraction yield (%).

## Design Structure
Box-Behnken Design (BBD) does not contain points at the extreme vertices of the cubic domain, making it ideal for processes where extreme combinations (e.g., high temp + high enzyme + high time) would degrade the product or cause reactor fouling.
- 12 edge center points representing all pairs of $\pm 1$ levels with the remaining factor at 0.
- 3 replicated center points (0, 0, 0) for Pure Error estimation and Lack-of-Fit testing.
- Total runs: $N = 15$.

| Factor | Name | Low (-1) | Center (0) | High (+1) | Unit |
|---|---|---|---|---|---|
| $X_1$ | `temp` | 30.0 | 35.0 | 40.0 | °C |
| $X_2$ | `enzyme` | 0.5 | 1.0 | 1.5 | wt% |
| $X_3$ | `time` | 15.0 | 30.0 | 45.0 | min |
| Response | `yield` | — | — | — | % |

## Script Field Mapping (`bbd.R`)
```r
f           <- "datasets/bbd/data.csv"
factor_cols <- c("temp", "enzyme", "time")
resp_col    <- "yield"
```
