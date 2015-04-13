function [activeSet, Kstore, M] = origIvmSelect(X, theta, d)

% IVMSELECT Select an IVM data set from multiple tasks.
lntheta = log(theta);

% Create storage 
numTasks = length(X);
numData = zeros(1, numTasks);
KStore = cell(1, numTasks);
J = cell(1, numTasks);
activeSet = cell(1, numTasks);
diagK = cell(1, numTasks);
L = cell(1, numTasks);
M = cell(1, numTasks);

for task = 1:numTasks
  numData(task) = size(X{task}, 1);

  % Initialise Indices
  J{task} = 1:numData(task);

  % Initialise 
  diagK{task} = kerneldiag(X{task}, lntheta);
  diagA{task} = diagK{task};

  [infoChange(task), indexSelect(task)] = max(diagK{task});
end

[void, taskSelect] = max(infoChange); 
i = J{taskSelect}(indexSelect(taskSelect));

k = 1;

% Update L, M and A with selected point
L{taskSelect} = sqrt(1 + 1/theta(3)*diagK{taskSelect}(i));
Kstore{taskSelect} = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
Kstore{taskSelect}(i, 1) = Kstore{taskSelect}(i, 1) + theta(3);

M{taskSelect} = (1/L{taskSelect}*(sqrt(1/theta(3))*Kstore{taskSelect}(:, 1)))';
diagA{taskSelect} = diagA{taskSelect} - M{taskSelect}'.*M{taskSelect}';

% Remove point from the non-active set and place in the active.
J{taskSelect}(indexSelect(taskSelect)) = [];
activeSet{taskSelect} = [activeSet{taskSelect}; i];

% Update change log
infoChangeLog(1) = NaN;


for k = 2:d
  for task = 1:numTasks
    delta = -.5*log2(1-diagA{task}(J{task}));
    if ~isempty(delta)
      [infoChange(task), indexSelect(task)] = max(delta);
    else
      infoChange(task) = NaN;
      indexSelect(task) = [];
    end
  end
  [void, taskSelect] = max(infoChange); 
  i = J{taskSelect}(indexSelect(taskSelect));
  selectedNum = length(activeSet{taskSelect});
  if selectedNum > 0
    % Update L, M and A with selected point
    lvec = sqrt(1/theta(3))*M{taskSelect}(:, i);
    l = sqrt(1 + 1/theta(3)*diagK{taskSelect}(i) - lvec'*lvec);
    Kstore{taskSelect}(:, selectedNum+1) = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
    Kstore{taskSelect}(i, selectedNum+1) = Kstore{taskSelect}(i, selectedNum+1) + theta(3); % introduce diagonal term
    muvec = (1/l)*sqrt(theta(3))*(Kstore{taskSelect}(:, selectedNum+1) - M{taskSelect}'*M{taskSelect}(:, i)); % Neil's
    
    L{taskSelect} = [L{taskSelect} zeros(selectedNum, 1); lvec' l];
    M{taskSelect} = [M{taskSelect}; muvec'];
    diagA{taskSelect} = diagA{taskSelect} - muvec.*muvec;
    
  else
    L{taskSelect} = sqrt(1 + 1/theta(3)*diagK{taskSelect}(i));
    Kstore{taskSelect} = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
    Kstore{taskSelect}(i, 1) = Kstore{taskSelect}(i, 1) + theta(3);
    
    M{taskSelect} = (1/L{taskSelect}*(sqrt(1/theta(3))*Kstore{taskSelect}(:, 1)))';
    diagA{taskSelect} = diagA{taskSelect} - M{taskSelect}'.*M{taskSelect}';
    
    
  end
  % Remove point from the non-active set and place in the active.
  J{taskSelect}(indexSelect(taskSelect)) = [];
  activeSet{taskSelect} = [activeSet{taskSelect}; i];
    
end






