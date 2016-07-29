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
load ('Anger4.txt');
txtfile = Anger4; 
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

% Load statistical data from emotional expression trials
min = load('min_wo_contempt_2fear.txt');
max = load('max_wo_contempt_2fear.txt');
avg = load('avg_wo_contempt_2fear.txt');

% Find difference between data points and average
N = abs(M/(sum(M)));
N2 = [N;N;N;N;N;N;N;N];
diff = abs(N2 - avg);
S = sum(diff,2);

% Test whether data points are in range
inrange_min = N2 >= min;
inrange_max = N2 <= max;
inrange = inrange_min + inrange_max == 2;   
S2 = sum(inrange,2);

% Ratio of data in range to difference between data and average
ratio = S2./S;
S3 = sum(ratio);

% Calculate percentages
S4 = [S3;S3;S3;S3;S3;S3;S3;S3];
percentage = (ratio./S4)*100;                        % Higher ratios indicate higher percentages in chart
percentage2 = percentage';
disgust2 = (percentage2(1,3) + percentage2(1,4))/2;  % Condense disgust types 1 and 2 into 1 type
percentage2(1,3) = disgust2;
percentage2(1,4:7) = percentage2(1,5:8);
percentage2(:,8) = [];
fear2 = (percentage2(1,2) + percentage2(1,7))/2;     % Condense fear types 1 and 2 into 1 type
percentage2(:,7) = [];
percentage3 = (percentage2/sum(percentage2))*100;    % Recalculate percentages

% Plot chart
emotion_label = {'Sadness: ','Fear: ','Disgust ','Anger: ','Surprise: ','Happiness: '};
percentage_label = {' %',' %',' %',' %',' %',' %'};

for x = 1:6
    labels(:,x) = strcat(emotion_label(x),num2str(percentage3(x),'%1.1f'),percentage_label(x));
end

pie(percentage3,labels);