function [X, y, K] = mtSampleData(kernStruct, numIn, numTasks, numDataPerTask);

% MTSAMPLEDATA This function samples a multi-task dataset from a given covariance funciton.

% MTIVM

X = cell(1, numTasks);
K = cell(1, numTasks);
y = cell(1, numTasks);

for task = 1:numTasks
  X{task} = zeros(numDataPerTask(task), numIn);
  X{task}(1:floor(numDataPerTask(task)/2), :) = ...
      randn(floor(numDataPerTask(task)/2), numIn)*.25+1;
  X{task}(floor(numDataPerTask(task)/2)+1:end, :) = ...
      randn(ceil(numDataPerTask(task)/2), numIn)*.25-1;
  K{task} = kernCompute(X{task}, kernStruct);
  y{task} = gsamp(zeros(numDataPerTask(task), 1), K{task}, 1)';
end
