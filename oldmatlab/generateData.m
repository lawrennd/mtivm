% GENERATEDATA Tries to load a sampled data set otherwise generates it.

try
  load sampledDataStore.mat 
catch
 [void, errid] = lasterr;
 if strcmp(errid, '')
   numIn = 4;
   numTasks = 4;
   N = 2000;
   numDataPerTask = N*ones(1, numTasks);
   numTasksTest = 10;
   NTest = 500;
   numDataPerTaskTest = NTest*ones(1, numTasksTest);
   % Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
   trueTheta = [1 1 100 0];
   trueTheta = thetaConstrain(trueTheta);
   [X, y] = sampleData(trueTheta, numIn, numTasks, numDataPerTask);
   [testX, testY] = sampleData(trueTheta, numIn, numTasksTest, numDataPerTaskTest);

   save('sampledDataStore.mat', 'numIn', 'numTasks', 'N', 'numDataPerTask', ...
	'numTasksTest', 'NTest', 'numDataPerTaskTest', 'trueTheta', 'X', ...
	'y', 'testX', 'testY')
 end
end