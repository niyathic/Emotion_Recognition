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
load ('Happiness1.txt');
txtfile = Happiness1; 
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

% Linear regression
avg = load('avg_wo_contempt_2fear.txt');
lin = linspace(0,1000,12);
for x = 1:8
    [p(x,:),s(x,:),mu] = polyfit(lin,avg(x,:),6);
    [y(x,:),delta(x,:)] = polyconf(p(x,:),M2(1,:),s(x,:));
    [y2(x,:),delta2(x,:)] = polyval(p(x,:),M2(1,:),s(x,:));  
end

error = sum(delta2');
compare(M2(1,:),p(1,:))
% Calculate percentages
for x = 1:8
    percentage(x) = error(x)./sum(error);
end
disgust2 = (percentage(1,3) + percentage(1,4))./2;
percentage(1,3) = disgust2;
percentage(1,4:7) = percentage(1,5:8);
percentage(:,8) = [];
fear2 = (percentage(1,2) + percentage(1,7))./2;
percentage(:,7) = [];
percentage2 = (percentage/sum(percentage))*100;

% Plot chart
emotion_label = {'Sadness: ','Fear: ','Disgust ','Anger: ','Surprise: ','Happiness: '};
percentage_label = {' %',' %',' %',' %',' %',' %'};

for x = 1:6
    labels(:,x) = strcat(emotion_label(x),num2str(percentage2(x),'%1.1f'),percentage_label(x));
end

pie(percentage2,labels);