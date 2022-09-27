function ocv=OCVfromSOCtemp(soc,temp,model)
% This function returns the fully rested open-circuit-voltage of an LiPB
% cell given its soc.
% Syntax: ocv=OCVfromSOCtemp(soc,temp,model)
% where soc is cell state of charge between 0 and 1,
% temp is cell temperature in degrees celsius,
% and model is a cell model structure.

soccol = soc(:); % force soc to be col-vector
SOC = model.SOC(:); % force to be col vector... 03/24/10
OCV0 = model.OCV0(:); % force to be col vector... 03/24/10
OCVrel = model.OCVrel(:); % force to be col vector... 03/24/10
if isscalar(temp), 
  tempcol = temp*ones(size(soccol)); % replicate for all socs
else
  tempcol = temp(:); % force to be col vector
end
diffSOC=SOC(2)-SOC(1);
ocv=zeros(size(soccol));
I1=find(soccol <= SOC(1)); %if ~isempty(I1), disp('low soc'); end
I2=find(soccol >= SOC(end)); %if ~isempty(I2), disp('high soc'); end
I3=find(soccol > SOC(1) & soccol < SOC(end));
I6=isnan(soccol);

% for voltages less than 0% soc... 07/26/06
% extrapolate off low end of table (for SOC(1) < 0... 03/23/10)
if ~isempty(I1),
  dv = (OCV0(2)+tempcol.*OCVrel(2)) - (OCV0(1)+tempcol.*OCVrel(1));
  ocv(I1)= (soccol(I1)-SOC(1)).*dv(I1)/diffSOC + OCV0(1)+tempcol(I1).*OCVrel(1);
end

% for voltages greater than 100% soc... 07/26/06
% extrapolate off high end of table (for SOC(end) > 1... 03/23/10)
if ~isempty(I2),
  dv = (OCV0(end)+tempcol.*OCVrel(end)) - (OCV0(end-1)+tempcol.*OCVrel(end-1));
  ocv(I2) = (soccol(I2)-SOC(end)).*dv(I2)/diffSOC + OCV0(end)+tempcol(I2).*OCVrel(end);
end

% for normal soc range...
% manually interpolate (10x faster than "interp1")
I4=(soccol(I3)-SOC(1))/diffSOC; % for SOC(1) < 0... 03/23/10
I5=floor(I4); I45 = I4-I5; omI45 = 1-I45;
ocv(I3)=OCV0(I5+1).*omI45 + OCV0(I5+2).*I45;
ocv(I3)=ocv(I3) + tempcol(I3).*(OCVrel(I5+1).*omI45 + OCVrel(I5+2).*I45);
ocv(I6)=0; % replace NaN SOCs with zero voltage... 03/23/10
ocv = reshape(ocv,size(soc));