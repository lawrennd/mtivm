function [K, rbfPart, distMat] = kernel(X, lntheta, Xprime)

% KERNEL Return the kernel matrix

theta = thetaConstrain(exp(lntheta));

if nargin < 3
  distMat = dist2(X, X);
  factor = theta(1)/2;
  rbfPart = theta(2)*exp(-distMat*factor);
  K = rbfPart + 1/theta(3)*eye(size(X, 1)) + theta(4);
else  
  distMat = dist2(X, Xprime);
  factor = theta(1)/2;
  rbfPart = theta(2)*exp(-distMat*factor);
  K = rbfPart + theta(4);
end



