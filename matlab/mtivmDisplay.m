function mtivmDisplay(models);

% MTIVMDISPLAY Display the mtivm model.

% MTIVM

for taskNo = 1:models.numTasks
  ivmDisplay(models.task(taskNo));
end