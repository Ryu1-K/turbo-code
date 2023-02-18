%% BER�}��
figure(1)
FN = 'Times New Roman'; % �t�H���g��
FS = 14;                %�@�t�H���g�T�C�Y
LW = 2;                 %�@����
MS = 12;                % �}�[�J�[�T�C�Y

h = semilogy(SIM.EbN0,BER,'-x');
axis([min(SIM.EbN0) max(SIM.EbN0) 1e-5 1e-0]);
grid on;
hold on;
xlabel('E_b/N_0 [dB]');
ylabel('BER');

set(h,'Linewidth',LW,'MarkerSize',MS);
set(gca,'Linewidth',LW,'FontName',FN,'FontSize',FS);

%% FER�}��
figure(2)

g = semilogy(SIM.EbN0,FER,'-x');
axis([min(SIM.EbN0) max(SIM.EbN0) 1e-3 1e-0]);
grid on;
hold on;
xlabel('E_b/N_0 [dB]');
ylabel('FER');

set(g,'Linewidth',LW,'MarkerSize',MS);
set(gca,'Linewidth',LW,'FontName',FN,'FontSize',FS);