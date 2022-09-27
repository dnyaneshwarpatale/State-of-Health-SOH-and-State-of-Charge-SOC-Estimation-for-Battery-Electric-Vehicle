function soc=SOCfromOCVtemp(ocv,temp,model)
% This function returns an estimate of soc from a fully rested open-circuit-voltage 
% of an LiPB cell

ocvcol = ocv(:); % force ocv to be col-vector
OCV = model.OCV(:); % force to be col vector... 03/24/10
SOC0 = model.SOC0(:); % force to be col vector... 03/24/10
SOCrel = model.SOCrel(:); % force to be col vector... 03/24/10
if isscalar(temp), 
  tempcol = temp*ones(size(ocvcol)); % replicate temperature for all ocvs
else
  tempcol = temp(:); % force to be col vector
end
diffOCV=OCV(2)-OCV(1);
soc=zeros(size(ocvcol));
I1=find(ocvcol <= OCV(1));
I2=find(ocvcol >= OCV(end));
I3=find(ocvcol > OCV(1) & ocvcol < OCV(end));
I6=isnan(ocvcol);

% for socs lower than lowest voltage
% extrapolate off low end of table
dz = (SOC0(2)+tempcol.*SOCrel(2)) - (SOC0(1)+tempcol.*SOCrel(1));
soc(I1)= (ocvcol(I1)-OCV(1)).*dz(I1)/diffOCV + SOC0(1)+tempcol(I1).*SOCrel(1);

% for socs higher than highest voltage
% extrapolate off high end of table
dz = (SOC0(end)+tempcol.*SOCrel(end)) - (SOC0(end-1)+tempcol.*SOCrel(end-1));
soc(I2) = (ocvcol(I2)-OCV(end)).*dz(I2)/diffOCV + SOC0(end)+tempcol(I2).*SOCrel(end);

% for normal soc range...
% manually interpolate (10x faster than "interp1")
I4=(ocvcol(I3)-OCV(1))/diffOCV;
I5=floor(I4);
soc(I3)=SOC0(I5+1).*(1-(I4-I5)) + SOC0(I5+2).*(I4-I5);
soc(I3)=soc(I3) + tempcol(I3).*(SOCrel(I5+1).*(1-(I4-I5)) + SOCrel(I5+2).*(I4-I5));
soc(I6) = 0; % replace NaN OCVs with zero SOC... 03/23/10
soc = reshape(soc,size(ocv));