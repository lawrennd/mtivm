function models = mtivmRun(XTrain, yTrain, kernelType, noiseType, ...
                           selectionCriterion, dVal, prior, display, ...
                           innerIters, outerIters, tieStructure)

% MTIVMRUN Run multi-task IVM on a data-set.

% MTIVM

% Intitalise MT-IVM

models = mtivm(XTrain, yTrain, kernelType, noiseType, selectionCriterion, dVal);
if nargin > 10
  % Some of the kernel parameters are constrained to equal each other.
  for taskNo = 1:models.numTasks
    models.task(taskNo).kern = cmpndTieParameters(models.task(taskNo).kern, ...
                                                  tieStructure);
  end
end

% Optimise MT-IVM
models = mtivmOptimise(models, prior, display, innerIters, outerIters);
