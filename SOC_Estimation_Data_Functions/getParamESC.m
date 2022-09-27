% function theParam = getParamESC(paramName,temperature,model)
%
% This function returns the values of the specified ESC cell-model
% parameter 'paramName' for the temperatures in 'temperature' for the 
% cell model data stored in 'model'.  
%
% In the standard ESC model, 'paramName' may be one of:
%    'QParam', 'RCParam', 'RParam', 'R0Param', 'MParam', 'M0Param',
%    'etaParam', or 'GParam' 
% (not case sensitive).

% Copyright (c) 2015 by Gregory L. Plett of the University of Colorado 
% Colorado Springs (UCCS). This work is licensed under a Creative Commons 
% Attribution-NonCommercial-ShareAlike 4.0 Intl. License, v. 1.0.
% It is provided "as is", without express or implied warranty, for 
% educational and informational purposes only.
%
% This file is provided as a supplement to: Plett, Gregory L., "Battery
% Management Systems, Volume I, Battery Modeling," Artech House, 2015.

function theParam = getParamESC(paramName,temp,model)
  theFields = fieldnames(model); % get list of fields stored in model
  match = strcmpi(paramName,theFields); % see if any match desired data
  if ~match, % if not, throw an error
    error('Parameter "%s" does not exist in model',paramName);
  end
  fieldName = char(theFields(match)); % case-sensitive field name

  % if model contains data at only one temperature
  if isscalar(model.temps),
    if model.temps ~= temp, % check whether requested data exists
      error('Model does not contain requested data at this temperature');
    end
    theParam = model.(fieldName);
    return
  end

  % Otherwise, model has multiple temperatures. Bound input "temp" between
  % mininum and maximum stored temperature to prohibit "NaN" in output
  theParamData = model.(fieldName);
  temp = max(min(temp,max(model.temps)),min(model.temps)); 
  ind = find(model.temps == temp); % see if there is an exact match to
  if ~isempty(ind), % avoid call to (slow) interp1 whenever possible
    if size(theParamData,1) == 1,
      theParam = theParamData(ind);
    else
      theParam = theParamData(ind,:);
    end
  else % if there is not an exact match, we interpolate between parameter
    theParam = interp1(model.temps,theParamData,temp,'spline'); % values
  end  % stored at different temperatures
