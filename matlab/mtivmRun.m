function models = mtivmRun(XTrain, yTrain, kernelType, noiseType, ...
                           selectionCriterion, dVal, optimiseNoise, display, ...
                           innerIters, outerIters, ...
                           noiseTieStructure, kernelTieStructure)

% MTIVMRUN Run multi-task IVM on a data-set.

% MTIVM

% Intitalise MT-IVM
models = mtivm(XTrain, yTrain, kernelType, noiseType, selectionCriterion, dVal);
if nargin > 11 & ~isempty(noiseTieStructure)
  % Some of the noise parameters are constrained equal to each other
  for taskNo = 1:models.numTasks
    models.task(taskNo).noise = cmpndTieParameters(models.task(taskNo).noise, ...
                                                  noiseTieStructure);
  end
end

if nargin > 10 & ~isempty(kernelTieStructure)
  % Some of the kernel parameters are constrained to equal each other.
  for taskNo = 1:models.numTasks
    models.task(taskNo).kern = cmpndTieParameters(models.task(taskNo).kern, ...
                                                  kernelTieStructure);
  end
end

% Optimise MT-IVM
models = mtivmOptimise(models, optimiseNoise, display, innerIters, outerIters);