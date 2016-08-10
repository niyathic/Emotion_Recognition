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
load ('Happiness3.txt');
txtfile = Happiness3; 
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
for x = 1:12
    N(x) = abs(M(x)./sum(M));
end
N2 = [N;N;N;N;N;N;N;N];
diff = abs(N2 - avg);
S = sum(diff,2);

% Test whether data points are in range
inrange_min = N2 >= min;
inrange_max = N2 <= max;
inrange = inrange_min + inrange_max == 2;
range = max - min;
% S2 = sum(inrange,2);

% Ratio of data in range to difference between data and average
M2 = [M;M;M;M;M;M;M;M];
for x=1:8
    for y=1:12
        if inrange(x,y) == 1
            ratio(x,y) = 1/diff(x,y)
        else ratio(x,y) = 1/((diff(x,y))./(M2(x,y) - max(x,y)));
        end
    end
end
ratio2 = ratio';
S3 = sum(ratio2);

% Calculate percentages
S4 = sum(S3);
percentage = (S3./S4)*100;                       % Higher ratios indicate higher percentages in chart
disgust2 = (percentage(1,3) + percentage(1,4))/2;  % Condense disgust types 1 and 2 into 1 type
percentage(1,3) = disgust2;
percentage(1,4:7) = percentage(1,5:8);
percentage(:,8) = [];
fear2 = (percentage(1,2) + percentage(1,7))/2;     % Condense fear types 1 and 2 into 1 type
percentage(:,7) = [];
percentage3 = (percentage/sum(percentage))*100;    % Recalculate percentages

% Plot chart
emotion_label = {'Sadness: ','Fear: ','Disgust ','Anger: ','Surprise: ','Happiness: '};
percentage_label = {' %',' %',' %',' %',' %',' %'};

for x = 1:6
    labels(:,x) = strcat(emotion_label(x),num2str(percentage3(x),'%1.1f'),percentage_label(x));
end

pie(percentage3,labels);