% simCell: Simulate the ESC cell model
%
% [vk,rck,hk,zk,sik,OCV] = simCell(ik,T,deltaT,model,z0,iR0,h0)
%
% Inputs:  ik    = vector input current (A)
%          T     = temperature (degC)
%          deltaT= sample period (s)
%          model = ESC model structure
%          z0    = initial cell SOC (0..1)
%          iR0   = initial RC-filter current state (A)
%          h0    = initial hysteresis state (0..1)
%
% Outputs: vk    = cell voltage (V)
%          rck   = RC-filter resistor current(s) (A)
%          hk    = hysteresis state (0..1)
%          zk    = cell state-of-charge (0..1)
%          sk    = instantaneous hysteresis state [-1,1]
%          OCV   = cell OCV value (V)
%
% Important note: time vector corresponding to ik assumed to be
%          tk    = (0:length(ik)-1)*deltaT, 
% where deltaT = sampling period of model.  Same time vector corresponds 
% to output values, so first entry in all outputs corresponds to 
% tk = 0 (state has not yet advanced), next entry corresponds to 
% tk = deltaT; etc.

function [vk,rck,hk,zk,sik,OCV] = simCell(ik,T,deltaT,model,z0,iR0,h0)
  % Force data to be column vector(s)
  ik = ik(:); iR0 = iR0(:);
 
  % Get model parameters from model structure
  RCfact = exp(-deltaT./abs(getParamESC('RCParam',T,model)))';
  G = getParamESC('GParam',T,model);
  Q = getParamESC('QParam',T,model);
  M = getParamESC('MParam',T,model);
  M0 = getParamESC('M0Param',T,model);
  RParam = getParamESC('RParam',T,model);
  R0Param = getParamESC('R0Param',T,model);
  etaParam = getParamESC('etaParam',T,model);
  
  etaik = ik; etaik(ik<0) = etaParam*ik(ik<0);

  % Simulate the dynamic states of the model
  rck = zeros(length(RCfact),length(etaik)); rck(:,1) = iR0;
  for k = 2:length(ik),
    rck(:,k) = diag(RCfact)*rck(:,k-1) + (1-RCfact)*etaik(k-1);
  end
  rck = rck';
  zk = z0-cumsum([0;etaik(1:end-1)])*deltaT/(Q*3600); 
  if any(zk>1.1),
    warning('Current may have wrong sign as SOC > 110%');
  end
  
  % Hysteresis stuff
  hk=zeros([length(ik) 1]); hk(1) = h0; sik = 0*hk;
  fac=exp(-abs(G*etaik*deltaT/(3600*Q)));
  for k=2:length(ik),
    hk(k)=fac(k-1)*hk(k-1)-(1-fac(k-1))*sign(ik(k-1));
    sik(k) = sign(ik(k));
    if abs(ik(k))<Q/100, sik(k) = sik(k-1); end
  end
    
  % Compute output equation
  OCV = OCVfromSOCtemp(zk,T,model);
  
  vk = OCV - rck*RParam' - ik.*R0Param + M*hk + M0*sik;
return