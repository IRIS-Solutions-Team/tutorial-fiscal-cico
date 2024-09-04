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

sr0 = simulate( ...
    mr_debt, dr, 1:40 ...
    , prependInput=true ...
);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sr = simulate( ...
    mr_debt, dr, 1:500 ...
    , prependInput=true ...
    , method="stacked" ...
    , startIter="data" ...
    , blocks=false ...
);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return


sn0 = simulate( ...
    mn_debt, dr, 1:40 ...
    , prependInput=true ...
);

sn = simulate( ...
    mn_debt, dr, 1:40 ...
    , prependInput=true ...
    , method="stacked" ...
);

srmc0 = databank.minusControl(mr, sr0, dr);
srmc = databank.minusControl(mr, sr, dr);
snmc0 = databank.minusControl(mn, sn0, dn);
snmc = databank.minusControl(mn, sn, dn);


ch = Chartpack();
ch.Range = 0:40;
ch.Round = 8;
ch.Transform = @(x) 100*x;
ch + ["C", "I", "dPc^4", "R^4", "W_Pc", "N", "^ PcG_NGDP", "^ Bg_NGDP/4", "^ TXls_NGDP"];

chartDb = databank.merge("horzcat", srmc, snmc, srmc0, snmc0);
draw(ch, chartDb);

visual.hlegend("bottom", "Ricardian", "Non-Ricardian");


