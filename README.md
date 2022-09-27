# State-of-Health-SOH-and-State-of-Charge-SOC-Estimation-for-Battery-Electric-Vehicle

## 1. State of Health(SOH) Estimation:
Total Capacity is used as parameter which shows state of health of battery.

### Different methods can be used to estimate the Total capacity as we cant measure it directly.

### Weighted least square(WLS) is a generalization of ordinary least squares and linear regression in which knowledge of the variance of observations is incorporated into the regression.

1. WLS takes care of only one error in measurement but we have two errors: Process error and measurement error


### Total least square(TLS) takes care of error in two quantities(Process + Measurement erroes)

Takes care of two errors but 
1. No closed form solution in general case
2. No recursive update for general case
3. Takes a all previous values in consideration so huge memory requirement

### Weighted Total Least Square(WTLS) takes care of all above disadvantages of of TLS but it requires too much of compurtational power

### So, Aweraged weighted least square(AWTLS) can be used with advantaged of all methods:

### Result when Total capacity is constant throughout the time.

![Result_FIxed_SOC](https://user-images.githubusercontent.com/108146924/192443910-fa04fee7-b196-4f3a-a0a4-011e8cfa3441.jpg)


### Result when we use decresing total capacity over the algoritm update index.

![Result_Variable_SOC](https://user-images.githubusercontent.com/108146924/192444027-51e8529b-2f3a-4846-bec7-b0abd495f0de.jpg)


