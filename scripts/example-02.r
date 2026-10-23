library(rsm)

expt_des <- bbd(
    k = 3,
    n0 = 3,
    block = FALSE,
    randomize = FALSE,
    coding = list(
        x1 ~ (vec1-30)/15,
        x2 ~ (vec2-200)/100,
        x3 ~ (vec-25/10)
    )
)

print(expt_des)

# 1. Create vector of 15 responses
response_result <- c(
    10.20,13.40,12.60,14.20,11.00,
    13.80,13.00,15.00,10.60,13.00,
    13.40,15.00
)

# 2. Add column to expt_des
expt_des$response_result <- response_result

# 3. Verify table
print(expt_des)

rsm_result <- rsm(response_result ~ SO(x1,x2,x3), data = expt_des)
summary(rsm_result)