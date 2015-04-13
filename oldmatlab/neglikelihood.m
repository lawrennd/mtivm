function f = neglikelihood(lntheta, X, y, activeSet, prior)

% NEGLIKELIHOOD The negative likelihood of the GP.

noActiveSet = 0;
if nargin < 4
  prior = 0;
  noActiveSet = 1;
elseif isempty(activeSet)
  noActiveSet = 1;
end


lntheta = log(thetaConstrain(exp(lntheta)));
numTasks = length(X);
f = 0;
for task = 1:numTasks
  if noActiveSet
    useX = X{task};
    useY = y{task};
  else
    if isempty(activeSet{task})
      continue
    else
      useX = X{task}(activeSet{task}, :);
      useY = y{task}(activeSet{task});
    end
  end
  K{task} = kernel(useX, lntheta);
  [invK, U] = pdinv(K{task});
  
  f = f -.5*logdet(K{task}, U) - .5*useY'*invK*useY+0.5*size(useX, 1);
end
if prior
  f = f - sum(lntheta);
end

% To maximise likelihood we minimise -ve likelihood
f = -f;
