function f = mtivmKernelObjective(params, models)

% MTIVMKERNELOBJECTIVE Likelihood approximation for multi-task IVM.

% MTIVM

if nargin < 3
  prior = 1;
end
f = 0;
numTasks = length(models.task);
for taskNo = 1:numTasks
  f = f + ivmKernelObjective(params, models.task(taskNo));
end