function g = mtkernelGradient(params, models, prior)

% MTKERNELGRADIENT Gradient on likelihood approximation for multi-task IVM.

% MTIVM

if nargin < 3
  prior = 1;
end

g = zeros(size(params));
for taskNo = 1:models.numTasks
  g = g + kernelGradient(params, models.task(taskNo), prior);
end
  
