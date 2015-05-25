function [theta, activeSet] = ivmRun(X, y, theta, d, innerIters, outerIters)

% IVMRUN Run an ivm on multi-task data.

em = 0;
for i = 1:outerIters
  [activeSet, Kstore, M, L, sitePrecision] = ivmSelect(X, theta, d);
  theta = optimiseTheta(X, y, sitePrecision, activeSet, M, L, theta, innerIters, em);
  fprintf('Outer iteration %d complete\n', i)
end
