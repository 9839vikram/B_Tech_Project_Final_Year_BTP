clear all;
clc;
B = 5*10^6; %bandwidth Hz
N0 = 10^-21; %-150 dBw/Hz
N = N0*B; % dBW
G1 = 10^-12; %-120 dB
G2 = 10^-14; %-140 dB
Pcircuit = 100; %watt
% For NOMA
count = 1;
for p = 1:1:100 %W
P1 = p*0.1; %allocate less power to UE1
P2 = p - P1;
R1 = B*log2(1 + P1*G1/N);
R2 = B*log2(1 + P2*G2/(P1*G2 + N));
R = R1 + R2;
SE(count) = R/B; % bit/sec/Hz
EE(count) = (R/(Pcircuit + p)); % bit/watt.sec
count = count + 1;
end
hold on;
plot(SE,EE,'k');
xlabel('SE (bit/sec/Hz)');
ylabel('EE (bit/joule)');
grid on;
%For OFDMA
count = 1;
greenpoint = 0;
maxEE = -1000;
for p = 1:1:100 %Watt
P1 = p/2;
P2 = p/2;
R1 = (B/2)*log2(1 + P1*G1/(N0*B/2));
R2 = (B/2)*log2(1 + P2*G2/(N0*B/2));
R = R1 + R2;
SE_line(count) = R/B; % bit/sec/Hz
EE_line(count) = (R/(Pcircuit + p)); % bit/watt.sec = Mbit/joule
count = count + 1;
end
hold on;
plot(SE_line,EE_line,'g-');
xlabel('SE (bit/sec/Hz)');
ylabel('EE (bit/joule)');
grid on;
legend('NOMA','OFDMA');