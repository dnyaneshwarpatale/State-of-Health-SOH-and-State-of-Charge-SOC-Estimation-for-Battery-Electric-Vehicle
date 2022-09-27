function docv=dOCVfromSOCtemp(soc,temp,model)
% This function returns the derivative of OCV with respect to SOC for 
% a lithium-ion cell given its soc.

soccol = soc(:); % force soc to be col-vector
SOC = model.SOC(:); % force to be col vector... 03/24/10
dOCV0 = model.dOCV0(:); % force to be col vector... 03/24/10
dOCVrel = model.dOCVrel(:); % force to be col vector... 03/24/10
if isscalar(temp), 
  tempcol = temp*ones(size(soccol)); % replicate for all socs
else
  tempcol = temp(:); % force to be col vector
end
diffSOC=SOC(2)-SOC(1);
docv=zeros(size(soccol));
I1=find(soccol <= SOC(1)); %if ~isempty(I1), disp('low soc'); end
I2=find(soccol >= SOC(end)); %if ~isempty(I2), disp('high soc'); end
I3=find(soccol > SOC(1) & soccol < SOC(end));
I6=isnan(soccol);

% for voltages less than 0% soc... 07/26/06
% extrapolate off low end of table (for SOC(1) < 0... 03/23/10)
if ~isempty(I1),
  dv = (dOCV0(2)+tempcol.*dOCVrel(2)) - (dOCV0(1)+tempcol.*dOCVrel(1));
  docv(I1)= (soccol(I1)-SOC(1)).*dv(I1)/diffSOC + dOCV0(1)+tempcol(I1).*dOCVrel(1);
end

% for voltages greater than 100% soc... 07/26/06
% extrapolate off high end of table (for SOC(end) > 1... 03/23/10)
if ~isempty(I2),
  dv = (dOCV0(end)+tempcol.*dOCVrel(end)) - (dOCV0(end-1)+tempcol.*dOCVrel(end-1));
  docv(I2) = (soccol(I2)-SOC(end)).*dv(I2)/diffSOC + dOCV0(end)+tempcol(I2).*dOCVrel(end);
end

% for normal soc range...
% manually interpolate (10x faster than "interp1")
I4=(soccol(I3)-SOC(1))/diffSOC; % for SOC(1) < 0... 03/23/10
I5=floor(I4); I45 = I4-I5; omI45 = 1-I45;
docv(I3)=dOCV0(I5+1).*omI45 + dOCV0(I5+2).*I45;
docv(I3)=docv(I3) + tempcol(I3).*(dOCVrel(I5+1).*omI45 + dOCVrel(I5+2).*I45);
docv(I6)=0; % replace NaN SOCs with zero voltage... 03/23/10
docv = reshape(docv,size(soc));