% ICMLMTVOWELDEMO Try the multi-task IVM for classification of vowels.

% MTIVM

seed = 1e4;
prior = 0;
display = 0;
innerIters = 100; % Number of scg iterations
outerIters = 4;

%kernelType = 'ARD';
kernelType = {'rbfard', 'linard', 'bias', 'white'};
% constrain ARD input scale parameters in the two kernels to equal one another.
tieStructure = {[3 14], ...
                [4 15], ...
                [5 16], ...
                [6 17], ...
                [7 18], ...
                [8 19], ...
                [9 20], ...
                [10 21], ...
                [11 22], ...
                [12 23]};
noiseType = 'probit';
selectionCriterion = 'entropy';

generateVowelData;
numSpeakers = length(vowelBySpeakerX);

for dVal = [100 200 300 400 500 700]; 

  % Make results repeatable
  rand('seed', seed)
  randn('seed', seed)

  time = zeros(1, numSpeakers);
  confusMat = cell(1, numSpeakers);
  perCentCorrect = zeros(1, numSpeakers);

  for testSpeaker = 1:numSpeakers

    trainSpeakers = 1:numSpeakers;
    trainSpeakers(testSpeaker) = [];

    out = zeros(55, 11);

    XTrain = vowelBySpeakerX(trainSpeakers);
    XTest = vowelBySpeakerX{testSpeaker};

    XNewSpeaker  = XTest(1:6:end, :);
    XTest(1:6:end, :) = [];

    initTime = cputime;

    for phonemeToPred = 1:11;
      
      for speaker = 1:length(vowelBySpeakerY)
	y{speaker} = vowelBySpeakerY{speaker}(:, phonemeToPred);
      end
      
      yTrain = y(trainSpeakers);
      yTest = y{testSpeaker};

      yNewSpeaker = yTest(1:6:end, :);
      yTest(1:6:end, :) = [];

      models = mtivmRun(XTrain, yTrain, kernelType, ...
			noiseType, selectionCriterion, dVal, ...
			prior, display, innerIters, outerIters, tieStructure);
      
      % Create ivm using learned kernel parameters.
      model = ivm(XNewSpeaker, yNewSpeaker, kernelType, noiseType, ...
                  selectionCriterion, size(XNewSpeaker, 1));
      model.kern = cmpndTieParameters(model.kern, tieStructure);

      model.kern = kernExpandParam(kernExtractParam(models.task(1).kern), ...
                                   model.kern);
      model = ivmOptimiseIVM(model, display);
      
      % Make predictions with this IVM
      out(:, phonemeToPred) = ivmPosteriorMeanVar(model, XTest) + model.noise.bias;
      numTest = size(XTest, 1);

      % Compute binary classification error rate
      errorRate = 1- sum(sign(out(:, phonemeToPred))==yTest)/numTest;
      fprintf('Phoneme %d finished, error rate %4.2f.\n', phonemeToPred, errorRate);
    end
    time(testSpeaker) = cputime - initTime;

    % Test overall predictions assigning class to max(out)
    fullY = vowelBySpeakerY{testSpeaker};
    fullY(1:6:end, :) = [];
    [void, classPred] = max(out, [], 2);
    [void, classTrue] = max(fullY, [], 2);
    
    confusMat{testSpeaker} = zeros(11);
    for i = 1:length(classPred)
      confusMat{testSpeaker}(classPred(i), classTrue(i)) = confusMat{testSpeaker}(classPred(i), classTrue(i)) +1; 
    end
    perCentCorrect(testSpeaker) = sum(diag(confusMat{testSpeaker}))/sum(sum(confusMat{testSpeaker}))*100;

    % Report to user
    fprintf('Done speaker %d in %4.2f with %4.2f correct.\n', testSpeaker, ...
	    time(testSpeaker), perCentCorrect(testSpeaker))
    
    save(['icmlMtVowel_d' num2str(dVal) '_seed' num2str(seed)], 'confusMat', 'perCentCorrect', 'time')
  end
end