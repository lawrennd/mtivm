function g = neggradientEM(lntheta, X, A, fbar, activeSet, prior)

% NEGGRADIENTEM The negative gradients with respect to parameters for the M-step.

lntheta = log(thetaConstrain(exp(lntheta)));
numTasks = length(X);
g = zeros(1, 4);
for task = 1:numTasks
  if isempty(activeSet{task})
    continue
  end
  [K, rbfPart, distMat] = kernel(X{task}(activeSet{task}, :), lntheta);
  theta = exp(lntheta);
  theta = thetaConstrain(theta);
  invK = pdinv(K);
  covGrad = -.5*invK + 0.5*invK*(fbar{task}*fbar{task}' + A{task})*invK;
  g(1) = g(1) -.5*sum(sum(covGrad.*rbfPart.*distMat))*theta(1);
  g(2) = g(2) + sum(sum(covGrad.*rbfPart/(theta(2))))*theta(2);
  g(3) = g(3) - sum(sum(covGrad.*eye(length(activeSet{task}))))/theta(3);
  g(4) = g(4) + sum(sum(covGrad))*theta(4);
end
if prior
  g = g - 1;
end

% To maximise likelihood we minimise -ve likelihood
g = -g;


