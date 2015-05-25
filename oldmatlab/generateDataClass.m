% GENERATEDATACLASS Tries to load a classification data set otherwise generates it.

try
  load sampledDataStoreClass.mat 
catch
 [void, errid] = lasterr;
 if strcmp(errid, '')
   numIn = 2;
   numTasks = 4;
   N = 500;
   numDataPerTask = N*ones(1, numTasks);
   numTasksTest = 3;
   NTest = 200;
   numDataPerTaskTest = NTest*ones(1, numTasksTest);
   % Theta is of the form [rbfInverseWidth, rbfMultiplier, noisePrecision, biasVariance]
   trueTheta = [2 10 1 0];
   trueTheta = thetaConstrain(trueTheta);
   [X, u] = sampleDataClass(trueTheta, numIn, numTasks, numDataPerTask);
   [testX, testU] = sampleDataClass(trueTheta, numIn, numTasksTest, numDataPerTaskTest);
   for task = 1:numTasks
     p = cummGaussian(u{task});
     r = rand(size(p));
     y{task} = 2*(r<p)-1;
   end
   for task = 1:numTasksTest
     p = cummGaussian(testU{task});
     r = rand(size(p));
     testY{task} = 2*(r<p)-1;
   end   
   save('sampledDataStoreClass.mat', 'numIn', 'numTasks', 'N', 'numDataPerTask', ...
	'numTasksTest', 'NTest', 'numDataPerTaskTest', 'trueTheta', 'X', ...
	'y', 'u', 'testX', 'testY', 'testU')
 end
end
