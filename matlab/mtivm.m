function models = mtivm(X, y, kernelType, noiseType, selectionCriterion, d)

% MTIVM Initialise an multi-task ivm model.

% MTIVM

if nargin < 6
  d = [];
end
models.kernelType = kernelType;
models.noiseType = noiseType;
models.selectionCriterion = selectionCriterion;

models.numTasks = length(X);
for taskNo = 1:models.numTasks
  models.task(taskNo) = ...
      ivm(X{taskNo}, y{taskNo}, kernelType, ...
	  noiseType, selectionCriterion, d);
end
models.d = d;
% Remove fields from the sub-structures.
for taskNo = 1:models.numTasks
  rmfield(models.task, 'd');
end
