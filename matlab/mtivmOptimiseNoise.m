function models = mtivmOptimiseNoise(models, prior, display, iters);

% MTIVMOPTIMISENOISE Optimise the noise parameters.

% MTIVM

if nargin < 4
  iters = 500;
  if nargin < 3
    display = 1;
    if nargin < 2
      prior = 0;
    end
  end
end
options = foptions;
if display
  options(1) = 1;
end
options(14) = iters;

for taskNo = 1:models.numTasks
  models.task(taskNo) = optimiseParams('noise', 'scg', ...
                                       'negIvmLogLikelihood', ...
                                       'negIvmGradientNoise', ...
                                       options, ...
                                       models.task(taskNo), ...
                                       prior);
end