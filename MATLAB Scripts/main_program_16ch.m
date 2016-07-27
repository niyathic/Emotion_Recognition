% Created by Irene Vigue Guix to work with OpenBCI
% June 20th 2016 - Brooklyn, NY (OpenBCI HQ)

%% Channel's information
% 	Channel 1-8: OpenBCI Board
%   Channel 9-12: Daisy Module

%% GENERAL PARAMETERS

clear all;
close all;
clc;

% Load txt file.
load ('Contempt1.txt');
txtfile = Contempt1; 
savefig('Contempt1');

% Create general variables for the main terms
raw_data = txtfile(:,2:13);
emg_data = raw_data (2:2:end,:);

% Band-pass Filtering Paramaters
N_ch = 12;              % Number of channels
tsamp = 8;              % Period
fsamp = 125;            % Sampling frequency
f_low = 50;             % Cut frequency for high-pass filter
f_high = 1;             % Cut frequency for low-pass filter


%% PRE-PROCESSING

% Bandpass Filter
for i=1:N_ch
    EMG(:,i)= bandpass_filter_16ch(emg_data(:,i), fsamp, f_low, f_high);
end

%% PLOT

figure('Name','EMG Data from OpenBCI Board and Daisy Module (Band-pass filtered)','NumberTitle','off')
plot(EMG);
title ('EMG Data from OpenBCI Board and Daisy Module (Band-pass filtered)');
xlabel('Time (ms)');
ylabel('Ampitude (\muV)');
legend('Ch 1','Ch 2','Ch 3','Ch 4','Ch 5','Ch 6','Ch 7','Ch 8','Ch 9','Ch 10','Ch 11','Ch 12');

%% figure('Name','EMG Data from OpenBCI Board and Daisy Module (Non filtered)','NumberTitle','off')
% plot(emg_data);
% title ('EMG Data from OpenBCI Board and Daisy Module (Non filtered)');
% xlabel('Time (ms)');
% ylabel('Ampitude (\muV)');
% legend('Ch 1','Ch 2','Ch 3','Ch 4','Ch 5','Ch 6','Ch 7','Ch 8','Ch 9','Ch 10','Ch 11','Ch 12');


 