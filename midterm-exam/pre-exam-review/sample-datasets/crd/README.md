# Problem 1: Split-Plot Design in CRD (Completely Randomized Design)

## Experimental Context
A biotechnology fermentation laboratory is optimizing an enzymatic hydrolysis process. 
- **Hard-to-Change Factor (Whole-Plot Factor, `wp`)**: Digestion Temperature (`temperature` in °C: `150`, `175`, `200`). Adjusting the main batch incubators requires hours to stabilize thermal equilibrium. Each incubator run represents a distinct whole-plot unit (`unit`), with 3 replicates per temperature level (total of 9 whole plots / incubator runs).
- **Easy-to-Change Factor (Subplot Factor, `sp`)**: Enzyme/Substrate Concentration formulation (`concentration_type`: `Type_A`, `Type_B`, `Type_C`, `Type_D`). Once an incubator is at temperature, four separate flasks containing different formulation types can easily be placed inside simultaneously.
- **Response Variable (`y`)**: Product Concentration (`conc` in g/L).

## Design Structure
| Component | Factor / Stratum | Levels / Count | Details |
|---|---|---|---|
| Whole-Plot Factor (`wp`) | `temperature` | 3 (150, 175, 200 °C) | Hard to reset between runs |
| Whole-Plot Units (`unit`) | Incubator batches | 9 (3 replicates per temp) | Completely randomized assignment |
| Subplot Factor (`sp`) | `concentration_type` | 4 (Type_A, Type_B, Type_C, Type_D) | Randomized within each incubator |
| Response (`y`) | `conc` | 36 observations | Continuous (g/L) |

## Script Field Mapping (`crd.R`)
```r
f    <- "datasets/crd/data.csv"
y    <- d$conc
wp   <- factor(d$temperature)
sp   <- factor(d$concentration_type)
unit <- factor(d$unit) # or NULL for automatic interaction grouping
```
