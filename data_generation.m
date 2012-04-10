% Classe 1

mu_1 = [0 0];
Sigma_1 = [4 1.7 ; 1.7 1];
classe_1 = mvnrnd(mu_1, Sigma_1, 150);

% Classe 2.1
mu_2_1 = [0 3];
Sigma_2_1 = [.25 0; 0 .25];
classe_2_1 = mvnrnd(mu_2_1, Sigma_2_1, 100);

% Classe 2.2
mu_2_2 = [4 3];
Sigma_2_2 = [4 -1.7; -1.7 1];
classe_2_2 = mvnrnd(mu_2_2, Sigma_2_2, 50);

classe_2 = [classe_2_1; classe_2_2];

classe_1 = [classe_1, repmat(1, 150, 1)];
classe_2 = [classe_2, repmat(2, 150, 1)];

data = [classe_1; classe_2];
data = data(randperm(size(data,1)),:);

clear('mu_1', 'Sigma_1', 'mu_2_1', 'Sigma_2_1', 'mu_2_2', 'Sigma_2_2', ...
    'classe_2_1', 'classe_2_2', 'classe_1', 'classe_2');

% plot(classe_1(:, 1), classe_1(:, 2), 'bO', ...
%    classe_2(:, 1), classe_2(:, 2), 'gX');

% plot(classe_1(:, 1), classe_1(:, 2), 'bO', ...
%    classe_2_1(:, 1), classe_2_1(:, 2), 'gX', ...
%    classe_2_2(:, 1), classe_2_2(:, 2), 'rX');