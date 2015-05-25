function [activeSet, Kstore, M, L, siteMean, sitePrecision] = ivmSelectClass(X, y, bias, theta, d)

% IVMSELECTCLASS Select an IVM data set from multiple classification tasks.

lntheta = log(theta);

% Create storage 
numTasks = length(X);
numData = zeros(1, numTasks);
KStore = cell(1, numTasks);
J = cell(1, numTasks);
activeSet = cell(1, numTasks);
diagK = cell(1, numTasks);

h = cell(1, numTasks);
siteMean = cell(1, numTasks);
sitePrecision = cell(1, numTasks);
nu = cell(1, numTasks);
z = cell(1, numTasks);
alpha = cell(1, numTasks);

L = cell(1, numTasks);
M = cell(1, numTasks);
for task = 1:numTasks
  numData(task) = size(X{task}, 1);
  % Initialise Indices
  J{task} = 1:numData(task);

  % Initialise 
  diagK{task} = kerneldiag(X{task}, lntheta);
  diagA{task} = diagK{task};
  sitePrecision{task} = repmat(theta(3), numData(task), 1);
  h{task} = zeros(numData(task), 1);
  siteMean{task} = sparse(zeros(numData(task), 1));
  sitePrecision{task} = sparse(zeros(numData(task), 1));
  nu{task} = zeros(numData(task), 1);
  sqrtOnePlusA = sqrt(1+diagA{task});
  z{task} = y{task}.*bias{task}./sqrtOnePlusA;
  alpha{task} = y{task}.*ngaussian(z{task})./(cummGaussian(z{task}).*sqrtOnePlusA);
  nu{task} = alpha{task}.*(alpha{task}+bias{task}./(1+diagA{task}));
end


for k = 1:d
  for task = 1:numTasks
    delta = -.5*log2(1-diagA{task}(J{task}).*nu{task}(J{task}));
    if ~isempty(delta)
      [infoChange(task), indexSelect(task)] = max(delta);
      if sum(delta==infoChange(task))==length(delta);
	indexSelect(task) = ceil(rand(1)*length(delta));
      end
    else
      infoChange(task) = NaN;
      indexSelect(task) = [];
    end
  end
  [void, taskSelect] = max(infoChange); 
  i = J{taskSelect}(indexSelect(taskSelect));
  selectedNum = length(activeSet{taskSelect});
  
  % update p_i and m_i
  sqrtOnePlusA = sqrt(1+diagA{taskSelect}(i));
  z{taskSelect}(i) = y{taskSelect}(i)*(h{taskSelect}(i) + bias{taskSelect})/sqrtOnePlusA;
  alpha{taskSelect}(i) = y{taskSelect}(i)*ngaussian(z{taskSelect}(i))/(cummGaussian(z{taskSelect}(i))*sqrtOnePlusA);
  nu{taskSelect}(i) = alpha{taskSelect}(i)*(alpha{taskSelect}(i) + (h{taskSelect}(i) + bias{taskSelect})/(1 + diagA{taskSelect}(i)));
  sitePrecision{taskSelect}(i) = nu{taskSelect}(i)/(1-diagA{taskSelect}(i)*nu{taskSelect}(i));
  siteMean{taskSelect}(i) = h{taskSelect}(i) + alpha{taskSelect}(i)/nu{taskSelect}(i);
  
  if selectedNum > 0 % is this the first point from that task?
    % Update L, M and A with selected point
    lvec = sqrt(sitePrecision{taskSelect}(i))*M{taskSelect}(:, i);
    l = sqrt(1 + sitePrecision{taskSelect}(i)*diagK{taskSelect}(i) - lvec'*lvec);
    Kstore{taskSelect}(:, selectedNum+1) = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
    Kstore{taskSelect}(i, selectedNum+1) = Kstore{taskSelect}(i, selectedNum+1); + 1/theta(3); % introduce diagonal term
    muvec = (1/l)*(sqrt(sitePrecision{taskSelect}(i))*Kstore{taskSelect}(:, selectedNum+1) - M{taskSelect}'*lvec); 
    
    L{taskSelect} = [L{taskSelect} zeros(selectedNum, 1); lvec' l];
    M{taskSelect} = [M{taskSelect}; muvec'];
    diagA{taskSelect} = diagA{taskSelect} - muvec.*muvec;
    
  else
    L{taskSelect} = sqrt(1 + sitePrecision{taskSelect}(i)*diagK{taskSelect}(i));
    Kstore{taskSelect} = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
    Kstore{taskSelect}(i, 1) = Kstore{taskSelect}(i, 1) + 1/theta(3);
    
    M{taskSelect} = (1/L{taskSelect}*(sqrt(sitePrecision{taskSelect}(i))*Kstore{taskSelect}(:, 1)))';
    diagA{taskSelect} = diagA{taskSelect} - M{taskSelect}'.*M{taskSelect}';
    
    
  end
  % Remove point from the non-active set and place in the active.
  J{taskSelect}(indexSelect(taskSelect)) = [];
  activeSet{taskSelect} = [activeSet{taskSelect}; i];
    
end






