%% Get Data
% Provide the directory as a string to below function. In this case, we have 
% a data directory '09-28-2021', where all the files are located.

if  ~exist('data','var')
    % parsing data
    animalType = '187_188';
    dataPath = dir(['../Fiberphotometry data/' animalType]);
    dataMap = readData(dataPath);
end
%% Display Data
% 
% 
% ObjectID: FibPho1
% 
% StoreID: 405A
% 
% StoreID: 465A
% 
% StoreID: 560B
% 
% ObjectID: FibPho2
% 
% StoreID: 405C
% 
% StoreID: 465C
% 
% StoreID: 560D

signalFibPho1 = {'x405A','x465A','x560B'};
for i= signalFibPho1
    plot(data.streams.(i{:}).data);
    hold on;
end
hold off;
legend(signalFibPho1);
slope = data.streams.('x405C').data
signalFibPho2 = {'x405C','x465C','x560D'};
for i= signalFibPho2
    plot(data.streams.(i{:}).data);
    hold on;
end
hold off;
legend(signalFibPho2);
%% Normalized Data

signalFibPho1 = {'x405A','x465A','x560B'};
x405 = data.streams.(signalFibPho1{1}).data;
x465 = data.streams.(signalFibPho1{2}).data;
x560 = data.streams.(signalFibPho1{3}).data;

[x465N1,x560N1] = getNormalizedSignal(x405,x465,x560);
figure;
plot(x465);
hold on;
plot(x465N1);
legend
hold off;
plot(x560);
hold on;
plot(x560N1);
legend;
hold off;

signalFibPho2 = {'x405C','x465C','x560D'};
x405 = data.streams.(signalFibPho2{1}).data;
x465 = data.streams.(signalFibPho2{2}).data;
x560 = data.streams.(signalFibPho2{3}).data;

[x465N2,x560N2] = getNormalizedSignal(x405,x465,x560);
plot(x465);
hold on;
plot(x465N2);
hold off;
legend
plot(x560);
hold on;
plot(x560N2);
legend;
hold off;
%% Local functions

function dataMap = readData(dataPath)
dataMap = containers.Map;
for i = 1:length(dataPath)
    %data = TDTbin2mat('09-28-2021');
    data = TDTbin2mat.TDTbin2mat([dataPath(i).folder filesep dataPath(i).name]);
    if ~isempty(data)
        dataMap = [dataMap; containers.Map(dataPath(i).name,data)]; %# ok
    end
end
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