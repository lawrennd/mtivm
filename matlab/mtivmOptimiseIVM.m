function models = mtivmOptimiseIVM(models, display)

% MTIVMOPTIMISEIVM Does point selection for a point-set IVM model.

% MTIVM

if nargin < 2
  display = 1;
end

numTasks = length(models.task);
for taskNo = 1:numTasks
  models.task(taskNo) = ivmInit(models.task(taskNo), ceil(models.d*1.2/numTasks));
  numDataPerTask(taskNo) = size(models.task(taskNo).X, 1);
  models.task(taskNo).J = 1:numDataPerTask(taskNo);
end

% Set first infoChange to NaN
trackInfoChange(1) = NaN;
trackInfoChange = zeros(1, models.d);
logLikelihoodRemain = zeros(1, models.d);
dLogLikelihood = zeros(1, models.d);

for k = 1:models.d
  
  for taskNo = 1:numTasks
    if length(models.task(taskNo).J) > 0
      [indexSelect(taskNo), infoChange(taskNo)] = selectPoint(models.task(taskNo));
    else
      infoChange(taskNo) = NaN;
      indexSelect(taskNo) = [];
    end
  end
  switch models.selectionCriterion
   case 'entropy'
    [trackInfoChange(k) , taskSelect] = max(infoChange);
   case 'random'
      taskSelect = ceil(rand(1)*numTasks);
      trackInfoChange(k) = infoChange(taskSelect);
  end
  jPos = indexSelect(taskSelect);
  i = models.task(taskSelect).J(jPos);

  models.taskOrder(k) = taskSelect;
  selectedNum = length(models.task(taskSelect).I);

  models.task(taskSelect) = ivmAddPoint(models.task(taskSelect), i);

  if display
    for taskNo = 1:models.numTasks
      logLikelihoods = log(ivmLikelihoods(models.task(taskNo)));
      dLogLikelihood(k) = dLogLikelihood(k) ...
	  + sum(sum(logLikelihoods));
      logLikelihoodRemain(k) = logLikelihoodRemain(k) ...
	  + sum(sum(logLikelihoods(models.task(taskNo).J, :)));
    end
    fprintf('%ith inclusion, remaining log Likelihood %2.4f', ...
	    k, logLikelihoodRemain(k))
    falsePositives(k) = 0;
    truePositives(k) = 0;
    totalNeg = 0;
    totalPos = 0;
    for taskNo = 1:models.numTasks
      switch models.task(taskNo).noise.type
       case {'probit', 'heaviside'}
	for i = 1:size(models.task(taskNo).y, 2)
	  falsePositives(k) = falsePositives(k) ...
	      + sum(...
		  sign(models.task(taskNo).mu(models.task(taskNo).J, i) ...
		       +models.task(taskNo).noise.bias(i)) ...
		  ~=models.task(taskNo).y(models.task(taskNo).J, i) ...
		  & models.task(taskNo).y(models.task(taskNo).J, i)==-1);
	  truePositives(k) = truePositives(k) ...
	      + sum(...
		  sign(models.task(taskNo).mu(models.task(taskNo).J, i) ...
		       +models.task(taskNo).noise.bias(i)) ...
		  ~=models.task(taskNo).y(models.task(taskNo).J, i) ...
		  & models.task(taskNo).y(models.task(taskNo).J, i)==1);
	end
	totalNeg = totalNeg + sum(sum(models.task(taskNo).y==-1));
	totalPos = totalPos + sum(sum(models.task(taskNo).y==1));
       otherwise
      end  
    end
    if totalNeg & totalPos
      fprintf(', falsePos %2.4f, truePos %2.4f\n', ...
	      sum(falsePositives(k))./totalNeg, ...
	      sum(truePositives(k))./totalPos);
    else
      fprintf('\n')
    end
  end
end
models.trackInfoChange = trackInfoChange;




