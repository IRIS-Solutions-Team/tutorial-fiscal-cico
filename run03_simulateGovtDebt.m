%% Simulate Permanent Government Debt Increase

close all
clear

load mat/createModel.mat mr mn


mr_debt = mr;
mr_debt.ss_Bg_NGDP = 4*0.20;

mn_debt = mn;
mn_debt.ss_Bg_NGDP = 4*0.20;

mr_debt = steady(mr_debt);
mr_debt = solve(mr_debt);

mn_debt = steady(mn_debt);
mn_debt = solve(mn_debt);

dr = databank.forModel(mr, 1:40);
dn = databank.forModel(mn, 1:40);

sr = simulate( ...
    mr_debt, dr, 1:40, ...
    "prependInput", true ...
);

sn = simulate( ...
    mn_debt, dr, 1:40, ...
    "prependInput", true ...
);

srmc = databank.minusControl(mr, sr, dr);
snmc = databank.minusControl(mn, sn, dn);


ch = Chartpack();
ch.Range = 0:40;
ch.Round = 8;
ch.Transform = @(x) 100*x;
ch + ["C", "I", "dPc^4", "R^4", "W_Pc", "N", "^ PcG_NGDP", "^ Bg_NGDP/4", "^ TXls_NGDP"];

chartDb = databank.merge("horzcat", srmc, snmc);
draw(ch, chartDb);

visual.hlegend("bottom", "Ricardian", "Non-Ricardian");


