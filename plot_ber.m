%% BER図示
figure(1)
FN = 'Times New Roman'; % フォント名
FS = 14;                %　フォントサイズ
LW = 2;                 %　線幅
MS = 12;                % マーカーサイズ

h = semilogy(SIM.EbN0,BER,'-x');
axis([min(SIM.EbN0) max(SIM.EbN0) 1e-5 1e-0]);
grid on;
hold on;
xlabel('E_b/N_0 [dB]');
ylabel('BER');

set(h,'Linewidth',LW,'MarkerSize',MS);
set(gca,'Linewidth',LW,'FontName',FN,'FontSize',FS);

%% FER図示
figure(2)

g = semilogy(SIM.EbN0,FER,'-x');
axis([min(SIM.EbN0) max(SIM.EbN0) 1e-3 1e-0]);
grid on;
hold on;
xlabel('E_b/N_0 [dB]');
ylabel('FER');

set(g,'Linewidth',LW,'MarkerSize',MS);
set(gca,'Linewidth',LW,'FontName',FN,'FontSize',FS);