% Matlab code for the analytical plot of outage probability in FD Cooperative NOMA 
clc;
close all;
clear all; 
SNR_db = -10:5:40; % transmit SNR in dB scale 
SNR_Linear = db2pow(SNR_db); % transmit SNR in linear scale 
a1 = 0.1; % power-allocation coefficient for the user1
a2 = 1 - a1; % power-allocation coefficient for the weak user2 
R1 = 3; % target data rate for user1 in bps/Hz
R2 = 0.5; % target data rate for user2 in bps/Hz
d = 0.3; % Normalized distance between BS and user1
alpha = 2; % path-loss exponent 
Omega_1 = d^(-alpha); % mean square value of the channel coefficient between BS and user1
Omega_LI = db2pow(-15); % mean square value of the self-interference channel
Omega_2 = 1; % mean-square value of the channel coefficients between BS and user2
gamma_th1_FD = 2^R1 - 1; % SNR threshold for user1 in FD operation
gamma_th2_FD = 2^R2 - 1; % SNR threshold for user2 in FD operation
gamma_th1_HD = 2^(2*R1) - 1; % SNR threshold for user1 in HD operation
gamma_th2_HD = 2^(2*R2) - 1; % SNR threshold for user2 in HD operation
tau_1 = gamma_th2_FD./ (SNR_Linear * ( a2 - a1 * gamma_th2_FD ) );
beta_1 = gamma_th1_FD ./ (a1 * SNR_Linear);
theta_1 = max(tau_1, beta_1);
beta_2 = gamma_th1_HD ./ (a1 * SNR_Linear);
tau_2 = gamma_th2_HD./ (SNR_Linear * ( a2 - a1 * gamma_th2_HD ) );
theta_2 = max(tau_2, beta_2);
varpi = 1; % For FD operation

% Calculation of outage probabilities 

Outage_P1_FD = 1 - ( Omega_1 * exp( - theta_1 / Omega_1 ) ./ ( Omega_1 + SNR_Linear .* theta_1 * Omega_LI) ); % Eqn. (10) - User 1 - FD

Outage_P2_FD = 1 - Omega_1 * exp( - ( (tau_1/Omega_1 ) + ( gamma_th2_FD./ (SNR_Linear * Omega_2 ) ) ) ) ./ ...
                    (Omega_1 + SNR_Linear .* varpi .* tau_1 * Omega_LI); % Eqn. (14) - User 2 - FD

Outage_P1_HD = 1 - exp(-theta_2 / Omega_1); % Eqn (12) - User 1 - HD

Outage_P2_HD = 1 - exp( - ( tau_2 / Omega_1 ) - ( gamma_th2_HD ./ ( SNR_Linear * Omega_2 ) ) ); % Eqn. (17) - User 2 - HD

% Plotting 

figure;

semilogy(SNR_db, Outage_P1_FD, '-sr', SNR_db, Outage_P1_HD, '-<k', SNR_db, Outage_P2_FD, '-ob', SNR_db, Outage_P2_HD, '->g');
grid on;

xlabel('SNR (dB)');
ylabel('Outage Probability');
title('Outage Probability vs SNR Plot for FD and HD NOMA');
legend({'User1 - FD-NOMA', 'User1 - HD-NOMA', 'User2 - FD-NOMA', 'User2 - HD-NOMA'}, 'Location', 'Best', 'FontSize', 15);

