% GENERATEMTREGRESSIONDATA Tries to load a point-set regression sampled data set otherwise generates it.


try
  load mtRegressionData.mat 
catch
  noFile = 0;
  verString = version;
  if str2double(verString(1:3)) > 6.1
    [void, errid] = lasterr;
    if strcmp(errid, '')
      noFile = 1;
    end
  else
    errMsg = lasterr;
    if findstr(errMsg, 'read file')
      noFile = 1;
    end
  end
  if noFile
    fprintf('File not available ... generating data ... this will take some time\n');
    
    numIn = 4;
    numTasks = 4;
    N = 2000;
    numDataPerTask = N*ones(1, numTasks);
    numTasksTest = 10;
    NTest = 500;
    numDataPerTaskTest = NTest*ones(1, numTasksTest);

    trueKern.inputDimension = numIn;
    trueKern.Kstore = [];
    trueKern.diagK = [];
    trueKern.type = 'sqexp';
    trueKern = kernParamInit(trueKern);
    trueKern.rbfVariance = 1;
    trueKern.inverseWidth = 1;
    trueKern.whiteVariance = 0.01;
    trueKern.biasVariance = eps;

    [X, y] = mtSampleData(trueKern, numIn, numTasks, numDataPerTask);
    [testX, testY] = mtSampleData(trueKern, numIn, numTasksTest, numDataPerTaskTest);
    
    save('mtRegressionData.mat', 'trueKern', 'X', ...
         'y', 'testX', 'testY')
  else
    error(lasterr)
  end
end