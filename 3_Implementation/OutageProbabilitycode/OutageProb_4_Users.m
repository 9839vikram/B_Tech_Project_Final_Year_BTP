% Outage probability vs SNR for three users

clc;
close all;
clear all;

SNR_dB = -10:5:40; % transmit SNR in dB scale 
SNR_linear = db2pow(SNR_dB); % transmit SNR in linear scale(convert db to power) 

a1 = 0.1; % power-allocation coefficient for the user1
a2 = 0.2; % power-allocation coefficient for the user2 
a3 = 0.3; % power-allocation coefficient for the user2
a4 = 0.4;
R1 = 1;   % target data rate for User1 in bps/Hz
R2 = 0.5; % target data rate for User2 in bps/Hz
R3 = 0.4; % target data rate for User3 in bps/Hz
R4 = 0.3;
d = 0.3;  % Normalized distance between BS and user1

alpha = 2;% path-loss exponent 

Omega_1 = d^(-alpha); % mean square value of the channel coefficient between BS and User1

Omega_LI = db2pow(-15); % mean square value of the self-interference channel

Omega_2 = 1; % mean-square value of the channel coefficients between BS and User2
R_1 = 2^R1 - 1; % SNR threshold for user1 

R_2 = 2^R2 - 1; % SNR threshold for user2
R_3 = 2^R3 - 1; % SNR threshold for user3
R_4 = 2^R4 - 1;
tau_1 = R_2./ (SNR_linear * ( a2 - a1 * R_2 ) );
tau_2 = R_3./ (SNR_linear * (a3-a1 * R_3));
tau_3 = R_4./ (SNR_linear * (a4-a1 *R_4));
beta_1 = R_1 ./ (a1 * SNR_linear);

theta_1 = max(tau_1, beta_1);
varpi = 1;         % For Full Duplex operation

% Calculation of outage probabilities 

Outage_P1 = 1 - ( Omega_1 * exp( - theta_1 / Omega_1 ) ./ ( Omega_1 + SNR_linear .* theta_1 * Omega_LI) ); % User1

Outage_P2 = 1 - Omega_1 * exp( - ( (tau_1/Omega_1 ) + ( R_2./ (SNR_linear * Omega_2 ) ) ) ) ./ ...
                    (Omega_1 + SNR_linear .* varpi .* tau_1 * Omega_LI);
                
Outage_P3 = 1 - Omega_1 * exp( - ( (tau_2/Omega_1 ) + ( R_3./ (SNR_linear * Omega_2 ) ) ) ) ./ ...
                    (Omega_1 + SNR_linear .* varpi .* tau_2 * Omega_LI);
Outage_P4 = 1 - Omega_1 * exp( - ( (tau_3/Omega_1 ) + ( R_4./ (SNR_linear * Omega_2 ) ) ) ) ./ ...
                    (Omega_1 + SNR_linear .* varpi .* tau_3 * Omega_LI);
%Plotting 

figure;
semilogy(SNR_dB, Outage_P1, '-sr', SNR_dB, Outage_P2, '-og', SNR_dB, Outage_P3, '->k', SNR_dB, Outage_P4, '-pb');
grid on;

xlabel('SNR (dB)');
ylabel('Outage Probability');
title('Outage Probability vs SNR Plot for four users');
legend({'User1 - NOMA','User2 -NOMA','User3 -NOMA','User4 -NOMA'}, 'Location', 'Best', 'FontSize', 15);
