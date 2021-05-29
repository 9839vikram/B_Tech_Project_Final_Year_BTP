% Outage probability for the two users

clc; 
close all; 
clear all;

SNR_dB = -10:5:40; % transmit SNR in dB scale 
SNR_linear = db2pow(SNR_dB); % transmit SNR in linear scale(convert db to power) 

a1 = 0.2; % power-allocation coefficient for the strong user user1
a2 = 1 - a1; % power-allocation coefficient for the weak user user2 

R1 = 3; % target data rate for user1 in bps/Hz
R2 = 0.5; % target data rate for user2 in bps/Hz

d = 0.3; % Normalized distance between BS and user1

alpha = 2; % path-loss exponent 

Omega_1 = d^(-alpha); % mean square value of the channel coefficient between BS and user1
Omega_LI = db2pow(-15); % mean square value of the self-interference channel

Omega_2 = 1; % mean-square value of the channel coefficients between BS and user2

R_1 = 2^R1 - 1; % SNR threshold for user 1 
R_2 = 2^R2 - 1; % SNR threshold for user 2

tau_1 = R_2./ (SNR_linear * ( a2 - a1 * R_2 ) );
beta_1 = R_1 ./ (a1 * SNR_linear);

theta_1 = max(tau_1, beta_1);
varpi = 1; % For FD operation

% Calculation of outage probabilities 

Outage_P1 = 1 - ( Omega_1 * exp( - theta_1 / Omega_1 ) ./ ( Omega_1 + SNR_linear .* theta_1 * Omega_LI) ); % User1

Outage_P2 = 1 - Omega_1 * exp( - ( (tau_1/Omega_1 ) + ( R_2./ (SNR_linear * Omega_2 ) ) ) ) ./ ...
                    (Omega_1 + SNR_linear .* varpi .* tau_1 * Omega_LI);
%Plotting 

figure;
semilogy(SNR_dB, Outage_P1, '-sr', SNR_dB, Outage_P2, '-og');
grid on;

xlabel('SNR (dB)');
ylabel('Outage Probability');
title('Outage Probability vs SNR for two users');
legend({'User1 - NOMA','User2 -NOMA'}, 'Location', 'Best', 'FontSize', 15);
