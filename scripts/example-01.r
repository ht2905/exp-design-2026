library(rsm)

expt_des <- bbd(
    k = 3,
    n0 = 3,
    block = FALSE,
    randomize = FALSE,
    coding = list(
        x1 ~ (nhiet_do - 40) / 5,
        x2 ~ (nuoc_lau_nha - 100) / 30,
        x3 ~ (luong_nuoc - 30) / 15
    )
)

print(expt_des)

# 1. Create vector of 15 responses
response_result <- c(
    12,14,15,16,12,
    13,14,11,10,11,
    23,21,24,11,9
)

# 2. Add column to expt_des
expt_des$response_result <- response_result

# 3. Verify table
print(expt_des)

rsm_result <- rsm(response_result ~ SO(x1,x2,x3), data = expt_des)
summary(rsm_result)


library(rsm)
expt_des <- bbd(
    k = 3,
    n0 = 3,
    block = FALSE,
    randomize = FALSE,
    coding = list(
        x1 ~ (nhiet_do - 40) / 5,
        x2 ~ (nuoc_lau_nha - 100) / 30,
        x3 ~ (luong_nuoc - 30) / 15
    )
)

print(expt_des)