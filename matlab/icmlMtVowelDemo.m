% ICMLMTVOWELDEMO Recreate ICML experiment of multi-task IVM for classification of vowels.

% MTIVM

seed = 1e4;
optimiseNoise = 0;
display = 0;
innerIters = 200; % Number of scg iterations
outerIters = 5;

kernelType = 'ard';
noiseType = 'probit';
selectionCriterion = 'entropy';

generateVowelData;
numSpeakers = length(vowelBySpeakerX);

for dVal = [50 75 100 150 200 250];

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
			optimiseNoise, display, innerIters, outerIters);
      
      % Create ivm using learned kernel parameters.
      model = ivm(XNewSpeaker, yNewSpeaker, kernelType, noiseType, ...
                  selectionCriterion, size(XNewSpeaker, 1));
      
      model.kern = kernExpandParam(model.kern, kernExtractParam(models.task(1).kern));
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