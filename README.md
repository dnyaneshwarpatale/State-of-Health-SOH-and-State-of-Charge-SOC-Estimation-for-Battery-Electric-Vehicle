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

### So, Averaged weighted least square(AWTLS) can be used with advantaged of all methods:

### Result when Total capacity is constant throughout the time.

![Result_FIxed_SOC](https://user-images.githubusercontent.com/108146924/192443910-fa04fee7-b196-4f3a-a0a4-011e8cfa3441.jpg)

#### RMS Errors in percentage

rms(errWLS) = 0.3775

rms(errWTLS) = 0.6633

rms(errTLS) = 0.3396

rms(errAWTLS) =  0.3199


### Result when we use decresing total capacity over the algoritm update index.

![Result_Variable_SOC](https://user-images.githubusercontent.com/108146924/192444027-51e8529b-2f3a-4846-bec7-b0abd495f0de.jpg)

#### RMS Errors in percentage

rmsErrWLS =    0.4599

rmsErrWTLS =    0.9993

rmsErrTLS =    0.5010

rmsErrAWTLS =    0.5273





## 2. State of Charge(SOC) Estimation
Enhanced Self-correcting(ESC) Behavioral model is considered while modelling the battery or cell.
Model consist practical parameters like temperature, hysteresis effect.
To form such model data from practical tests are requires which is taken from Department of Electrical and Computer Engineering, University of Colorado at Colorado Springs,1420 Austin Bluffs Parkway, Colorado Springs, USA


### Kalman Filter estimation can be used to estimation when we are considering linear systems but it fails for non -linear system so we are using Extended Kalman Filter(EKF).

EKF makes two asssumptions whhile adapting general sequential inferenve equation to a nonlinear system

1. When computing estimates of the output of non-linear funstion EKF assumes expctation of function equals to functio of expectation which is not true in practical

2. When computing covariance estimates, EKF uses Taylor-series expansion to linearise the sysyem equations around the presenting point.

Further EKF have Prediction steps and model correction steps in its model

### Results of SOC Estimation 

![Result_SOC](https://user-images.githubusercontent.com/108146924/192445379-5e5cc1b3-3a80-4a1c-9937-518743f41ae9.jpg)


### Errors at SOC Estimation

![Result_Errors](https://user-images.githubusercontent.com/108146924/192445475-f12f1532-8f2d-4cab-8d42-bcde79fa1cf3.jpg)

