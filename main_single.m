clc; clear;

%% シミュレーションパラメータ
SIM.nworker   = 1;            % 並列実行数
SIM.EbN0      = 0:0.2:4;     % Eb/N0
SIM.nloop     = 1000;         % 試行回数
SIM.errmax    = SIM.nloop/10; 

%% 変調パラメータ
G.Q         = 2;            % 変調多値数
G.ml        = log2(G.Q);    % 変調レベル

%% 符号パラメータ
CP.ndata     = 1024;         % 情報ビット長
CP.rate      = 1/2;          % 符号化率
CP.niter     = 8;            % 繰り返し回数
CP.constLength = 4;            % 拘束長

%% シングル実行
tic;
RES = main_task(SIM,G,CP);     % tuc: turbodecoder, tuc_: APPdecoder
BER = RES(:,1)./RES(:,2);
FER = RES(:,3)./RES(:,4);
toc;

%% BER. FER図示
plot_ber;