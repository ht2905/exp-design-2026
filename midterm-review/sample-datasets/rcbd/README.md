# Problem 2: Split-Plot Design in RCBD (Randomized Complete Block Design)

## Experimental Context
An agricultural research station investigates the effects of 4 different pasture types and 2 mineral supplement formulations on dairy cow milk yield over 3 distinct seasons of the year.
- **Nuisance / Blocking Factor (`block`)**: Season of the year (`block`: `1`, `2`, `3`). Environmental conditions, baseline forage availability, and ambient temperature vary across seasons.
- **Hard-to-Change Factor (Whole-Plot Factor, `wp`)**: Pasture Treatment (`pasture`: `1`, `2`, `3`, `4`). Dividing and managing large grazing fields for herds of cattle is labor-intensive and costly. Within each season (block), 4 distinct pasture plots are set up.
- **Easy-to-Change Factor (Subplot Factor, `sp`)**: Mineral Supplement (`mineral`: `1`, `2`). Mineral formulations are administered directly via individual feeding troughs within each pasture plot.
- **Response Variable (`y`)**: Milk yield (`milk` in kg).

## Design Structure
| Component | Factor / Stratum | Levels / Count | Details |
|---|---|---|---|
| Block Factor (`block`) | Season | 3 seasons (1, 2, 3) | Nuisance variance control |
| Whole-Plot Factor (`wp`) | `pasture` | 4 pasture types (1, 2, 3, 4) | Assigned to fields within season |
| Subplot Factor (`sp`) | `mineral` | 2 supplements (1, 2) | Administered within pasture |
| Response (`y`) | `milk` | 24 observations | Milk production (kg) |

## Script Field Mapping (`rcbd.R`)
```r
f     <- "datasets/rcbd/data.csv"
y     <- d$milk
wp    <- factor(d$pasture)
sp    <- factor(d$mineral)
block <- factor(d$block)
```

> [!NOTE]
> In historical exam records, row 20 (Block 3, Pasture 2, Mineral 2) had a typographical entry of `3` kg instead of `33` kg. In `datasets/rcbd/data.csv`, this has been corrected to `33` kg to reflect true biological yields (mean ~31 kg).
