%% Comparative static for govt debt

close all
clear

load mat/createModel.mat mn

mn = alter(mn, 10);
mn.ss_Bg_NGDP = linspace(0, 4*2, 10);

mn = steady(mn);

figure( );

subplot(2,2,1);
plot( 100*real(mn.Bg_NGDP)/4, 100*(real(mn.R).^4-1) );
grid on
xlabel('Govt Debt to GDP Annualized');
ylabel('Interest Rate Annualized');

subplot(2,2,2);
plot( 100*real(mn.Bg_NGDP)/4, real(mn.C));
grid on
xlabel('Govt Debt to GDP Annualized');
ylabel('Consumption');

subplot(2,2,3);
plot( 100*real(mn.Bg_NGDP)/4, real(mn.I));
grid on
xlabel('Govt Debt to GDP Annualized');
ylabel('Investment');

subplot(2,2,4);
plot( 100*real(mn.Bg_NGDP)/4, real(mn.W_Pc));
grid on
xlabel('Govt Debt to GDP Annualized');
ylabel('Real Wage');

