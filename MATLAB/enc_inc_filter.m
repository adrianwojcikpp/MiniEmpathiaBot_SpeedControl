%% Infinite impulse response filter unit test
%%% File info 
%
% *************************************************************************
%
%  @file     enc_inc_filter.m
%  @author   Adrian Wojcik
%  @version  3.0
%  @date     27-Apr-2024 19:57:18
%  @brief    Simple IIR filter for incremental encoder
%
% *************************************************************************
%
close all; clc;
clear variables;

%% FILTER EXAMPLE 
% -- SAMPLE TIME ----------------------------------------------------------
ts = 0.01; % [s]
fs = 1/ts;  % [Hz]

% -- S-OPERATOR -----------------------------------------------------------
s = tf('s');

% -- FILTER PARAMS --------------------------------------------------------
T = 2*ts;

% -- CONTINUOUS TRANSFER FUNCTION -----------------------------------------
G = (1 / (1 + T*s))^2;

% -- DISCRETIZATION -------------------------------------------------------
H = c2d(G, ts, 'zoh');

% -- FILTER RESPONSE COMPUTING --------------------------------------------

% Filter frequency response
% no. of samples
n = 10^4; % [-]
% frequency vector
frange = (-1/2 : 1/n : 1/2-1/n); % [-]
fhvec = frange*fs;               % [Hz]
% amplitude response
%Ahvec_v1 = abs(freqz(b,a, 2*pi*frange)); % [-] frequency response
Ahvec_v1 = abs(freqz(H.num{1},H.den{1}, 2*pi*frange)); % [-] frequency response
Ahvec_v1 = 20*log10(Ahvec_v1); % [dB]

%% EXPORT FILTER TO .C/.H FILES
biquad_coeffs = generate_biquad_df1('enc_A_LPF', H.num{1}, H.den{1});
biquad_coeffs = generate_biquad_df1('enc_B_LPF', H.num{1}, H.den{1});

%% Plot results
hold on;
grid on;
plot(fhvec, Ahvec_v1, '-');
ylabel("Amplitude response [dB]"); 
xlabel("Frequnecy [Hz]"); 
hold off;

%% MOVE .C/.H AND .CSV FILES TO Components CATALOG
srcDest = '../Components/Src';
cFiles = dir('*.c');
csvFiles = dir('*.csv');
for i = 1:length(cFiles)
    movefile(cFiles(i).name, fullfile(srcDest, cFiles(i).name));
end
for i = 1:length(csvFiles)
    movefile(csvFiles(i).name, fullfile(srcDest, csvFiles(i).name));
end

incDest = '../Components/Inc';
hFiles = dir('*.h');
for i = 1:length(hFiles)
    movefile(hFiles(i).name, fullfile(incDest, hFiles(i).name));
end