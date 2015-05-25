function g = neggradient(lntheta, X, y, activeSet, prior)

% NEGGRADIENT The gradients of the netative likelihood with respect to parameters.

noActiveSet = 0;
if nargin < 4
  prior = 0;
  noActiveSet = 1;
elseif isempty(activeSet)
  noActiveSet = 1;
end
lntheta = log(thetaConstrain(exp(lntheta)));
numTasks = length(X);
g = zeros(1, 4);
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
  
  [K, rbfPart, distMat] = kernel(useX, lntheta);
  theta = exp(lntheta);
  theta = thetaConstrain(theta);
  invK = pdinv(K);
  invKy = invK*useY;
  covGrad = -.5*invK + 0.5*invKy*invKy';
  g(1) = g(1) -.5*sum(sum(covGrad.*rbfPart.*distMat))*theta(1);
  g(2) = g(2) + sum(sum(covGrad.*rbfPart/(theta(2))))*theta(2);
  g(3) = g(3) - sum(sum(covGrad.*eye(size(useX, 1))))/theta(3);
  g(4) = g(4) + sum(sum(covGrad))*theta(4);
end
if prior
  g = g - 1;
end

% To maximise likelihood we minimise -ve likelihood
g = -g;


