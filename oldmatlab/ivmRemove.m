function [activeSet, Kstore, M, L] = ivmRemove(X, theta, d, activeSet, diagK, ...
					       Kstore, M, L)

% IVMREMOVE Remove points from the IVM active set.
lntheta = log(theta);

% Create storage 
numTasks = length(X);
numData = zeros(1, numTasks);
J = 
diagK = cell(1, numTasks);

for task = 1:numTasks
  numData(task) = size(X{task}, 1);

  % Initialise Indices
  J{task} = 1:numData(task);
  J{task}(activeSet{task}) = [];
end
l = activeSet{task}(j);
% pointToSwap is j
a_ij = Kstore(l, i) - M(i, :)'*M(l, :);
Lambda(j, i) = diagA(i) + (sitePrecision(l)*a_ij*a_ij)...
    /(1-sitePrecision(l)*diagA(l));
H(j, i) = h(i) + a_ij*sitePrecision(l)*(h(l)-m(l))/(1-sitePrecision(l)*diagA(l));
nu = sqrt(sitePrecision(activeSet{task})) ...
     *(sqrt(sitePrecision(i))*Kstore(i, :)' ...
       - sqrt(sitePrecision(l))*Kstore(l, :)');

eta = sitePrecision(i)*diagK(i) + sitePrecision(l)*diagK(l) - 2* ...
      sqrt(sitePrecision(i))*sqrt(sitePrecision(l))*Kstore(i, l);

Delta = diag([sitePrecision(i) -sitePrecision(l)]);
gamma = [sitePrecision(i)*siteMean(i); -sitePrecision(l)*siteMean(l)];

% Information change
delta(j, i) = .5*(log(1-Lambda(j, i)*??)-log(1-diagA(l)*sitePrecision(l)));
% These next parts can be done more efficiently
delta_l = sparse(zeros(length(activeSet{task}), 1));
delta_l(j) = 1;
deltaTilda_l = delta_l*sqrt(eta);
nuTilde = 1/sqrt(eta)*nu;
[Lnorm1, Ltilde1, Dprime1, Lprime1] = updateCholesky(L{task}, [], (deltaTilda_l+nuTilda), '+');
[Lnorm2, Ltilde2, Dprime2, Lprime2] = updateCholesky(Lprime1, Dprime1, nuTilda, '-');

Mprime = M + (sqrt(sitePrecision(i)) - sqrt(sitePrecision(l)))*L{task}* ...
	 delta_l*Kstore(:, j)';

for k = 1:d
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
    lvec = sqrt(theta(3))*M{taskSelect}(:, i);
    l = sqrt(1 + theta(3)*diagK{taskSelect}(i) - lvec'*lvec);
    Kstore{taskSelect}(:, selectedNum+1) = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
    Kstore{taskSelect}(i, selectedNum+1) = Kstore{taskSelect}(i, selectedNum+1) + 1/theta(3); % introduce diagonal term
    muvec = (1/l)*(sqrt(theta(3))*Kstore{taskSelect}(:, selectedNum+1) - M{taskSelect}'*lvec); 
    
    L{taskSelect} = [L{taskSelect} zeros(selectedNum, 1); lvec' l];
    M{taskSelect} = [M{taskSelect}; muvec'];
    diagA{taskSelect} = diagA{taskSelect} - muvec.*muvec;
    
  else
    L{taskSelect} = sqrt(1 + theta(3)*diagK{taskSelect}(i));
    Kstore{taskSelect} = kernel(X{taskSelect}, lntheta, X{taskSelect}(i, :));
    Kstore{taskSelect}(i, 1) = Kstore{taskSelect}(i, 1) + 1/theta(3);
    
    M{taskSelect} = (1/L{taskSelect}*(sqrt(theta(3))*Kstore{taskSelect}(:, 1)))';
    diagA{taskSelect} = diagA{taskSelect} - M{taskSelect}'.*M{taskSelect}';
    
    
  end
  % Remove point from the non-active set and place in the active.
  J{taskSelect}(indexSelect(taskSelect)) = [];
  activeSet{taskSelect} = [activeSet{taskSelect}; i];
    
end






