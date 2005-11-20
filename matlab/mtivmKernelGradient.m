function g = mtivmKernelGradient(params, models)

% MTIVMKERNELGRADIENT Gradient on likelihood approximation for multi-task IVM.

% MTIVM

if nargin < 3
  prior = 1;
end

g = zeros(size(params));
for taskNo = 1:models.numTasks
  if(length(models.task(taskNo).I)>0) % It's possible that this task wasn't used.
    g = g + ivmKernelGradient(params, models.task(taskNo));
  end
end
  
