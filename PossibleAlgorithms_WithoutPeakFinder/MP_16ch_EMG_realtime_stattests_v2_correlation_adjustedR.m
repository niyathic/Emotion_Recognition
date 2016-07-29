% Created by Niyathi Chakrapani to work with OpenBCI
% June 22nd 2016 - Brooklyn, NY (OpenBCI HQ)

%% Channel information
% 	Channel 1-8: OpenBCI Board
%   Channel 9-12: Daisy Module

%% GENERAL PARAMETERS

clear all;
close all;
clc;

% Load .txt file.
load ('Happiness2.txt');
txtfile = Happiness2; 
% Need to edit "happiness1",anger1,happiness2,sadness1,anger3,sadness5,disgust2,disgust5,contempt3,surprise2,contempt2,contempt1,sadness2,fear1,contempt4,contempt5,happiness4,surprise3,sadness3,disgust2,anger4,anger5,sadness4,surprise4,surprise5
% Great: fear4,happiness3,fear3,happiness5,disgust4,disgust1,fear2,disgust3
% Good: anger2,surprise1

% Create general variables and parameters
raw_data = txtfile(:,2:13);
emg_data = raw_data (2:2:end,:);
N_Ch = 12;                      % Number of Channels
Fs = 125;                       % Sampling Frequency (Hz)
F_Low = 50;                     % Cut frequency for high-pass filter
F_High = 1;                     % Cut frequency for low-pass filter

%% PROCESSING
for i=1:N_Ch
    EMG(:,i)= bandpass_filter(emg_data(:,i), Fs, F_Low, F_High);
end

% Find maximum of each channel
M = max(EMG);
M2 = M./sum(M);

% Load statistical data from emotional expression trials
avg = load('avg_wo_contempt_2fear.txt');
a1 = avg(1,:);
a2 = avg(2,:);
a3 = avg(3,:);
a4 = avg(4,:);
a5 = avg(5,:);
a6 = avg(6,:);
a7 = avg(7,:);
a8 = avg(8,:);

mdl1 = fitlm(a1,M2);
mdl2 = fitlm(a2,M2); 
mdl3 = fitlm(a3,M2);
mdl4 = fitlm(a4,M2); 
mdl5 = fitlm(a5,M2);
mdl6 = fitlm(a6,M2); 
mdl7 = fitlm(a7,M2);
mdl8 = fitlm(a8,M2); 

Rsquareds = [mdl1.Rsquared.Adjusted mdl2.Rsquared.Adjusted mdl3.Rsquared.Adjusted mdl4.Rsquared.Adjusted mdl5.Rsquared.Adjusted mdl6.Rsquared.Adjusted mdl7.Rsquared.Adjusted mdl8.Rsquared.Adjusted];

for x = 1:8
    percentage(x) = Rsquareds(x)./sum(Rsquareds);
end
disgust2 = (percentage(1,3) + percentage(1,4))./2;
percentage(1,3) = disgust2;
percentage(1,4:7) = percentage(1,5:8);
percentage(:,8) = [];
fear2 = (percentage(1,2) + percentage(1,7))/2;
percentage(:,7) = [];
percentage2 = (percentage/sum(percentage))*100;

% Plot chart
emotion_label = {'Sadness: ','Fear: ','Disgust ','Anger: ','Surprise: ','Happiness: '};
percentage_label = {' %',' %',' %',' %',' %',' %'};

for x = 1:6
    labels(:,x) = strcat(emotion_label(x),num2str(percentage2(x),'%1.1f'),percentage_label(x));
end

pie(percentage2,labels);