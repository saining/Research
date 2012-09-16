randn('state',0');
[A,B] = randprob;
parameters(A,B);
Y0 = guess;
[fn, Yn] = sg_min(Y0,'newton','euclidean');