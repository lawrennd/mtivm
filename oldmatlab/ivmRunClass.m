function [theta, activeSet] = ivmRunClass(X, y, bias, theta, d, innerIters, outerIters)

% IVMRUNCLASS Run an ivm on multi-task classification data.

em = 0;
for i = 1:outerIters
  [activeSet, Kstore, M, L, siteMean, sitePrecision] = ivmSelectClass(X, y, bias, theta, d);
  theta = optimiseTheta(X, siteMean, sitePrecision, activeSet, M, L, theta, innerIters, em);
  disp(theta)
  fprintf('Outer iteration %d complete\n', i)
end
