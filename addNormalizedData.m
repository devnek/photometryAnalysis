function addNormalizedData(data,R)
import mlreportgen.report.*
import mlreportgen.dom.*

signalFibPho1 = {'x405A','x465A','x560B'};




plotNormalizedData(data,signalFibPho1);

signalFibPho2 = {'x405C','x465C','x560D'};


plotNormalizedData(data,signalFibPho2);
add(R,Figure)
end


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

function plotNormalizedData(data,signalFibPho)

startOffset = 20000;

fs1 = data.streams.(signalFibPho{1}).fs;
fs2 = data.streams.(signalFibPho{2}).fs;
fs3 = data.streams.(signalFibPho{3}).fs;
assert(fs1 == fs2, [signalFibPho{1} 'and ' signalFibPho{2} ' are in different rate']);
assert(fs1 == fs3, [signalFibPho{1} 'and ' signalFibPho{3} ' are in different rate']);

x405 = data.streams.(signalFibPho{1}).data;
x465 = data.streams.(signalFibPho{2}).data;
x560 = data.streams.(signalFibPho{3}).data;

t0 = 1/fs1;
time = t0:t0:t0*length(x405);

[x465N1,x560N1] = getNormalizedSignal(x405,x465,x560);
ax1 = subplot(3,1,1);
set( get(ax1,'XLabel'), 'String', 'time in sec' );
%xlabel('time in sec')
plot(time(startOffset:end),x465(startOffset:end));
hold on;
plot(time(startOffset:end),x465N1(startOffset:end));
legend('x465','Normalized x465');
hold off;

ax2 = subplot(3,1,2);
set( get(ax2,'XLabel'), 'String', 'time in sec' );
%xlabel('time in sec')
plot(time(startOffset:end),x560(startOffset:end));
hold on;
plot(time(startOffset:end),x560N1(startOffset:end));
legend('x560','Normalized x560');
hold off;

ax3 = subplot(3,1,3);
eventPlot(ax3,data.epocs);
linkaxes([ax1,ax2],'x');
linkaxes([ax1,ax3],'x');
xlim([time(startOffset) time(end)])

end