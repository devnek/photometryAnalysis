function [x465N,x560N] = getNormalizedSignal(x405,x465,x560)
arguments
    x405 single
    x465 single
    x560 single
end
x465N = getNormalSignal(x405,x465);
x560N = getNormalSignal(x405,x560);
end

function Y_fit = getNormalSignal(X,Y)
X1 = smooth(X);
Y1 = smooth(Y);
bls = polyfit(X1, Y1, 1);
Y_fit = bls(1).*X + bls(2);
end