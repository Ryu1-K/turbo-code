clc; clear;

%% シミュレーションパラメータ
S.nworker   = 8;            % 並列実行数
S.EbN0      = 0:0.2:4;     % Eb/N0
S.nloop     = 1000;         % 試行回数
S.errmax    = S.nloop/10; 

%% 変調パラメータ
G.Q         = 2;            % 変調多値数
G.ml        = log2(G.Q);    % 変調レベル

%% 符号パラメータ
C.ndata     = 1000;         % 情報ビット長
C.rate      = 1/2;          % 符号化率
C.niter     = 8;            % 繰り返し回数
C.const_len = 4;            % 拘束長

%% 並列実行
tic;
ERR = zeros(length(S.EbN0),4);
parfor idx_worker = 1:S.nworker
    ERR_ = tuc2(S,G,C);     % tuc: turbodecoder, tuc_: APPdecoder
    ERR = ERR +  ERR_;
end
BER = ERR(:,1)./ERR(:,2);
FER = ERR(:,3)./ERR(:,4);
toc;

%% BER. FER図示
plot_ber;