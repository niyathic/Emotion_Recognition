% Created by Niyathi Chakrapani to work with OpenBCI
% June 22nd 2016 - Brooklyn, NY (OpenBCI HQ)

%% Channel information
% 	Channel 1-8: OpenBCI Board
%   Channel 9-12: Daisy Module

%% GENERAL PARAMETERS

clear all;
close all;
clc;

% Load data files.
M = THE TEXTFILE;
M2 = M';
load('Sadness1.csv');
load('Sadness2.csv');
load('Surprise1.csv');
load('Anger1.csv');
load('Anger2.csv');
load('Happiness1.csv');
load('Disgust1.csv');
load('Fear1.csv');

% Create general variables and parameters
raw_sadness1 = Sadness1(:,2:13);
emg_sadness1 = raw_sadness1(2:2:end,:);
raw_surprise1 = Surprise1(:,2:13);
emg_surprise1 = raw_surprise1(2:2:end,:);
raw_anger1 = Anger1(:,2:13);
emg_anger1 = raw_anger1(2:2:end,:);
raw_happiness1 = Happiness1(:,2:13);
emg_happiness1 = raw_happiness1(2:2:end,:);
raw_disgust1 = Disgust1(:,2:13);
emg_disgust1 = raw_disgust1(2:2:end,:);
raw_fear1 = Fear1(:,2:13);
emg_fear1 = raw_fear1(2:2:end,:);
N_Ch = 12;                      % Number of Channels
Fs = 125;                       % Sampling Frequency (Hz)
F_Low = 50;                     % Cut frequency for high-pass filter
F_High = 1;                     % Cut frequency for low-pass filter

%% PROCESSING
for i=1:N_Ch
    EMG_sadness1(:,i) = bandpass_filter(emg_sadness1(:,i), Fs, F_Low, F_High);
    EMG_surprise1(:,i) = bandpass_filter(emg_surprise1(:,i), Fs, F_Low, F_High);
    EMG_anger1(:,i) = bandpass_filter(emg_anger1(:,i), Fs, F_Low, F_High);
    EMG_happiness1(:,i) = bandpass_filter(emg_happiness1(:,i), Fs, F_Low, F_High);
    EMG_disgust1(:,i) = bandpass_filter(emg_disgust1(:,i), Fs, F_Low, F_High);
    EMG_fear1(:,i) = bandpass_filter(emg_fear1(:,i), Fs, F_Low, F_High);
end

% Find trials
trial_sadness1 = Sadness1(:,20);
trial_surprise1 = Surprise1(:,20);
trial_anger1 = Anger1(:,20);
trial_happiness1 = Happiness1(:,20);
trial_disgust1 = Disgust1(:,20);
trial_fear1 = Fear1(:,20);
a = find(trial_sadness1==2)./2;
% b = find(trial_surprise1==2)./2;
c = find(trial_anger1==2)./2;
% d = find(trial_happiness1==2)./2;
% e = find(trial_disgust1==2)./2;
f = find(trial_fear1==2)./2;
a2 = a+50;
% b2 = b+50;
c2 = c+50;
% d2 = d+50;
% e2 = e+50;
f2 = f+50;

% Find peaks within trials
for x = 1:10
    for y = 1:12
        peaks_sadness1(x,y) = max(emg_sadness1(a(x,1):a2(x,1),y));
%        peaks_surprise1(x,y) = max(emg_surprise1(b(x,1):b2(x,1),y));
        peaks_anger1(x,y) = max(emg_anger1(c(x,1):c2(x,1),y));
%        peaks_happiness1(x,y) = max(emg_happiness1(d(x,1):d2(x,1),y));
%        peaks_disgust1(x,y) = max(emg_disgust1(e(x,1):e2(x,1),y));
        peaks_fear1(x,y) = max(emg_fear1(f(x,1):f2(x,1),y));
    end
end

% Find average peak per channel, per emotion
peaks = [mean(peaks_sadness1);mean(peaks_anger1);mean(peaks_fear1)];


% Linear regression
lin = linspace(0,1000,12);
for x = 1:6
    [p(x,:),s(x,:),mu] = polyfit(lin,peaks(x,:),6);
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