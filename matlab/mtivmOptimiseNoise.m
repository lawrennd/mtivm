function models = mtivmOptimiseNoise(models, display, iters);

% MTIVMOPTIMISENOISE Optimise the noise parameters.

% MTIVM

if nargin < 3
  iters = 500;
  if nargin < 2
    display = 1;
  end
end
options = foptions;
if display
  options(1) = 1;
end
options(14) = iters;

for taskNo = 1:models.numTasks
  models.task(taskNo) = optimiseParams('noise', 'scg', ...
                                       'ivmNegLogLikelihood', ...
                                       'ivmNegGradientNoise', ...
                                       options, ...
                                       models.task(taskNo));
end