function f = mtkernelObjective(params, models, prior)

% MTKERNELOBJECTIVE Likelihood approximation for multi-task IVM.

% MTIVM

if nargin < 3
  prior = 1;
end
f = 0;
numTasks = length(models.task);
for taskNo = 1:numTasks
  f = f + kernelObjective(params, models.task(taskNo), prior);
end