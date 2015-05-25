function y = ngaussian(x)

x2 = x.*x;
y = exp(-.5*x2);
y = y/sqrt(2*pi);
