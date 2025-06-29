% step3_dataset_generation.m
% Generate dataset and save to .mat file for AOA MUSIC estimation

% Parameters
num_samples = 100;    % Total number of samples
M = 8;                % Number of antennas
K = 3;                % Number of sources
N = 1024;              % Number of snapshots
d = 0.5;              % Distance between antennas (normalized to wavelength)
wavelength = 0.01;    % Wavelength
SNR = 20;             % Signal-to-noise ratio in dB

% Arrays to hold samples
X_data = cell(num_samples, 1);
DoA_labels = cell(num_samples, 1);

% Generate samples
for i = 1:num_samples
    % Generate random DoAs between -60 and 60 degrees
    DoAs = sort(-60 + 120 * rand(1, K));
    DoA_labels{i} = DoAs;

    % Convert to radians
    theta = DoAs * pi / 180;

    % Steering matrix
    A = zeros(M, K);
    for k = 1:K
        A(:, k) = exp(-1j * 2 * pi * d * (0:M-1)' * sin(theta(k)) / wavelength);
    end

    % Signal matrix (source signals)
    S = randn(K, N) + 1j * randn(K, N);

    % Received signal
    X = A * S;

    % Add noise
    noise_power = 10^(-SNR/10);
    noise = sqrt(noise_power/2) * (randn(M, N) + 1j * randn(M, N));
    X_noisy = X + noise;

    % Store
    X_data{i} = X_noisy;
end

% Save to file
save('aoa_dataset.mat', 'X_data', 'DoA_labels');
disp('Dataset saved to aoa_dataset.mat');
