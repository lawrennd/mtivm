% ICMLVOWELDEMO Try the IVM for classification of vowels.

% MTIVM

seed = 1e4;
options = ivmOptions();
options.display = 0;
options.kernIters = 200; % Number of scg iterations
options.noiseIters = 0;
options.extIters = 4;
options.kern = 'ard';
options.noise = 'probit';
options.selectionCriterion = 'entropy';


generateVowelData;
numSpeakers = length(vowelBySpeakerX);

generateVowelData;
numSpeakers = length(vowelBySpeakerX);

for dVal = [50 75 100 150 200]; 

  % Make results repeatable
  rand('seed', seed)
  randn('seed', seed)

  time = zeros(1, numSpeakers);
  confusMat = cell(1, numSpeakers);
  perCentCorrect = zeros(1, numSpeakers);

  for testSpeaker = 1:numSpeakers

    trainSpeakers = 1:numSpeakers;
    trainSpeakers(testSpeaker) = [];

    % Sort out the input data
    XTrain = [];
    for speaker = trainSpeakers
      XTrain = [XTrain; vowelBySpeakerX{speaker}];
    end
    XTest = vowelBySpeakerX{testSpeaker};
    XNewSpeaker  = XTest(1:6:end, :);
    XTest(1:6:end, :) = [];

    out = zeros(55, 11);

    initTime = cputime;

    for phonemeToPred = 1:11;

      % Extract labels for this phoneme
      for speaker = 1:length(vowelBySpeakerY)
	y{speaker} = vowelBySpeakerY{speaker}(:, phonemeToPred);
      end

      yTrain = [];
      for speaker = trainSpeakers
	yTrain = [yTrain; y{speaker}];
      end      
      yTest = y{testSpeaker};

      yNewSpeaker = yTest(1:6:end, :);
      yTest(1:6:end, :) = [];
      
      options.numActive = dVal;
      model = ivmRun(XTrain, yTrain, options);
      
      % Create ivm using learned kernel parameters.
      kern = model.kern;
      noise = model.noise;
      model = ivm(XNewSpeaker, yNewSpeaker, kernelType, noiseType, selectionCriterion, size(XNewSpeaker, 1));
      model.kern = kern;
      model.noise = noise;
      model = ivmOptimiseIVM(model, display);

      % Make predictions with this IVM.
      out(:, phonemeToPred) = ivmPosteriorMeanVar(model, XTest) + model.noise.bias;
      numTest = size(XTest, 1);

      % Compute binary classification error
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
    fprintf('Done speaker %d in %4.2f with %4.2f correct.\n', testSpeaker, ...
	    time(testSpeaker), perCentCorrect(testSpeaker))
    
    save(['icmlVowel_d' num2str(dVal) '_seed' num2str(seed)], 'confusMat', 'perCentCorrect', 'time')
  end
end