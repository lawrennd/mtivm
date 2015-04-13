function displayTasks(X, y, theta, activeSet);

% DISPLAYTASKS Show the results.

if nargin < 4
  noActiveSet = 1;
else
  noActiveSet = 0;
end

lntheta = log(theta);
numTasks = length(X);
for task = 1:numTasks
  if noActiveSet
    useX = X{task};
    useY = y{task};
  else
    if isempty(activeSet{task})
      continue
    end
    useX = X{task}(activeSet{task}, :);
    useY = y{task}(activeSet{task});
  end
  
  K = kernel(useX, lntheta);
  invK = pdinv(K);
  A{task} = pdinv(invK + theta(3)*eye(size(useX, 1)));
  
  fbar{task} = kernel(useX, lntheta, useX)*invK*useY;
  figure, plot(useX, useY, 'rx');
  hold on
  errorbar(useX, fbar{task}, sqrt(diag(A{task})), 'bo');


end
