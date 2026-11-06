renv::use("rsm", attach = TRUE)

expt_des <- bbd(
    k=3,
    n0=3,
    block=FALSE,
    randomize=FALSE,
    coding=list(
        x1 ~(temp-35)/5,
        x2 ~(enzyme-1)/0.5,
        x3 ~(time-30)/15
    )
)
print(expt_des)

response_result <- c(
    31.8,37.1,39.3,39.4,39,
    40.3,35.3,39.8,35.2,42.4,
    34.9,38.7,45.3,45,45.3
)
expt_des$response_result <- response_result
print(expt_des)

rsm_result <- rsm(response_result ~ SO(x1,x2,x3), data=expt_des)
summary(rsm_result)
