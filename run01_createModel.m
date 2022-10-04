%% Read and Calibrate Model


%% Clear Workspace

close all
clear


%% Create Model Object from Model File(s)

m = Model.fromFile( ...
    "model-source/pam2_ce_v2.model", ...
    "growth", true ...
);


%% Calibrate Parameters

% Steady-State Parameters

m.beta = 1.03^(-1/4);
m.beta_P = 0.5;
m.beta_K = 1;
m.eta = 0;
m.delta = 0.04;
m.nu = 0;
m.nu0 = 0;
m.mu_C = 1.20;
m.mu_I = 1.20;
m.mu_Y = 1.50;
m.n = 0.35;
m.gamma_N = 0.65;


% Directly Calibrated Steady-State Characteristics

m.ss_dA = 1.02^(1/4);
m.ss_dPc = 1.025^(1/4);

m.ss_Bg_NGDP = 0;
m.ss_PcG_NGDP = 0;


% Transitory Parameters

m.psi_DLI = 0;
m.psi_C = 0.7;
m.rho_W = 0.7;
m.rho_A = 0.8;
m.xi_Pc = 200;
m.xi_Pi = 100;
m.xi_I = 1;


% Monetary Policy Reaction Parameters

m.rho_R = 0.7;
m.rho_R_bar = 0.9;
m.kappa_dPc = 3.5;


% Fiscal Policy Reaction Parameters

m.lambda_G1 = 0;
m.lambda_G2 = 0.2;
m.lambda_TXls1 = 0.2;
m.lambda_TXls2 = 0;



%% Calculate Steady State Using Reverse Engineering

m.PIEy_NGDP = 0;
m.PcC_Vh_nu0 = 0;
m.upsilon = 1;
m.N = 1;

m.A = 1;%complex(1, m.ss_dA);
m.Pc = 1;%complex(1, m.ss_dPc);

m = steady( ...
    m, ...
    'exogenize', {'N', 'PIEy_NGDP', 'PcC_Vh_nu0'}, ...
    'endogenize', {'upsilon', 'mu_Y', 'nu0'}, ...
    'fixLevel', {'A', 'Pc'} ...
);

mr = m;


%% Create a Non-Ricardian Version of the Model

mn = m;
mn.nu = 0.03;
mn.psi_DLI = 0.7;
mn.psi_C = 0.3;

mn = steady( ...
    mn, ...
    'Exogenize', {'PcC_Vh_nu0'}, ...
    'Endogeniz=', {'nu0'}, ...
    'Fix', {'A', 'Pc'} ...
);

checkSteady(mn);

table([mr, mn], {'SteadyLevel', 'SteadyChange', 'Form', 'Description'})


%% Calculate First-Order Solution

mr = solve(mr);
mn = solve(mn);


%% Save Model Object for Further Use

save mat/createModel.mat mr mn


