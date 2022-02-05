% Get Data
if  ~exist('data','var')
    % provide the directory as a string to below function. In this case we
    % have a working directory '09-28-2021', where all the files are
    % located.
    data = TDTbin2mat('09-28-2021');
end

% Filter out the slow fluctuation
ftype = 'high';
n = 2;
Fs = 1.017252624511719e+03;
Wn = 0.05/((Fs/10)/2);
[a,b] = butter(n,Wn,ftype);

idx_remove = 1;

% downsample 10x
data405 = data.streams.('x405C').data(idx_remove:end);
data405 = downsample(data405,10);

data465 = data.streams.('x465C').data(idx_remove:end);
data465 = downsample(data465,10);

%Baseline the 465 using the 405
bls = polyfit(data405, data465, 1);
Y_fit = bls(1) .* data405 + bls(2);
Y_dF = data465 - Y_fit;

%dFF using 405 fit as baseline
% Now I am able to harness the Data. But I dont see 540nm channel in the
% data.
% 
dFF.(IdChannel{channel}).raw = 100*(Y_dF)./Y_fit;
dFF.(IdChannel{channel}).zscore = zscore(dFF.(IdChannel{channel}).raw);
dFF.(IdChannel{channel}).filt = filtfilt(a,b,double(dFF.(IdChannel{channel}).raw));
dFF.(IdChannel{channel}).zscorefilt = filtfilt(a,b,double(dFF.(IdChannel{channel}).zscore));
