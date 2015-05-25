function k = kerneldiag(X, lntheta)

% KERNELDIAG returns the diagonal of a kernel matrix

theta = exp(lntheta);
rbfPart = ones(size(X, 1), 1);
k = rbfPart*theta(2) + 1/theta(3) + theta(4);
  





