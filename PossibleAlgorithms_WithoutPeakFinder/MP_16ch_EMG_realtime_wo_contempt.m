% Created by Niyathi Chakrapani and Irene Vigue Guix to work with OpenBCI
% June 22th 2016 - Brooklyn, NY (OpenBCI HQ)

%% Channel's information
% 	Channel 1-8: OpenBCI Board
%   Channel 9-12: Daisy Module

%% GENERAL PARAMETERS

clear all;
close all;
clc;

% Load txt file.
load ('Disgust4.txt');
txtfile = Disgust4; 
% Need to edit "happiness1",anger1,happiness2,sadness1,anger3,sadness5,disgust2,disgust5,contempt3,surprise2,contempt2,contempt1,sadness2,fear1,contempt4,contempt5,happiness4,surprise3,sadness3,disgust2,anger4,anger5,sadness4,surprise4,surprise5
% Great: fear4,happiness3,fear3,happiness5,disgust4,disgust1,fear2,disgust3
% Good: anger2,surprise1,disgust4

% Create general variables for the main terms
raw_data = txtfile(:,2:13);
emg_data = raw_data (2:2:end,:);

% Band-pass Filtering Paramaters
N_Ch = 12;                      % Number of Channels
Ts = 8;                         % Sampling Interval (ms)
Fs = 125;                       % Sampling Frequency (Hz)
Fn = Fs/2;                      % Nyquisst Frequency
F_Low = 50;                     % Cut frequency for high-pass filter
F_High = 1;                     % Cut frequency for low-pass filter

%% PRE-PROCESSING

% Bandpass Filter
for i=1:N_Ch
    EMG(:,i)= bandpass_filter(emg_data(:,i), Fs, F_Low, F_High);
end

% Create EMG variables
EMG_1 = EMG(:,1);                   % Data Channel 1
EMG_2 = EMG(:,2);                   % Data Channel 2
EMG_3 = EMG(:,3);                   % Data Channel 3
EMG_4 = EMG(:,4);                   % Data Channel 4
EMG_5 = EMG(:,5);                   % Data Channel 5
EMG_6 = EMG(:,6);                   % Data Channel 6
EMG_7 = EMG(:,7);                   % Data Channel 7
EMG_8 = EMG(:,8);                   % Data Channel 8
EMG_9 = EMG(:,9);                   % Data Channel 9
EMG_10 = EMG(:,10);                 % Data Channel 10
EMG_11 = EMG(:,11);                 % Data Channel 11
EMG_12 = EMG(:,12);                 % Data Channel 12
L_EMG = size(EMG,1);                % Length of Data Vector
T = linspace(0,L_EMG,L_EMG)*Ts;     % Create Time Vector
t = 1:length(EMG);

%% PLOT

% figure('Name','EMG Data from OpenBCI Board and Daisy Module (Band-pass filtered)','NumberTitle','off')
% plot(EMG);
% title ('EMG Data from OpenBCI Board and Daisy Module (Band-pass filtered)');
% xlabel('Time (ms)');
% ylabel('Ampitude (\muV)');
% legend('Ch 1','Ch 2','Ch 3','Ch 4','Ch 5','Ch 6','Ch 7','Ch 8','Ch 9','Ch 10','Ch 11','Ch 12');

% Save plot image
% savefig('EMG');

%% PROCESSING

% Find maximum of each channel
M = max(EMG);

% Define emotion statistic variables
min = load('min_wo_contempt.txt');
max = load('max_wo_contempt.txt');
avg = load('avg_wo_contempt.txt');

% Ratio of data points in range to total difference between data points and averages
N = abs(M/(sum(M)));
N2 = [N;N;N;N;N;N;N];
diff = abs(N2 - avg);

S = sum(diff,2);

inrange_min = N2 >= min;
inrange_max = N2 <= max;
inrange = inrange_min + inrange_max == 2;
S2 = sum(inrange,2);
ratio = S2./S;
S3 = sum(ratio);

% Plot pie chart
S4 = [S3;S3;S3;S3;S3;S3;S3];
percentage = (ratio./S4)*100;
percentage2 = percentage';

emotion_label = {'Sadness: ','Fear: ','Disgust Expression 1: ','Disgust Expression 2: ','Anger: ','Surprise: ','Happiness: '};
percentage_label = {' %',' %',' %',' %',' %',' %',' %'};

for x = 1:7
    labels(:,x) = strcat(emotion_label(x),num2str(percentage2(x),'%1.1f'),percentage_label(x));
end

pie(percentage,labels);