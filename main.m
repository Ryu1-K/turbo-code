clc; clear;

%% �V�~�����[�V�����p�����[�^
S.nworker   = 8;            % ������s��
S.EbN0      = 0:0.2:4;     % Eb/N0
S.nloop     = 1000;         % ���s��
S.errmax    = S.nloop/10; 

%% �ϒ��p�����[�^
G.Q         = 2;            % �ϒ����l��
G.ml        = log2(G.Q);    % �ϒ����x��

%% �����p�����[�^
C.ndata     = 1000;         % ���r�b�g��
C.rate      = 1/2;          % ��������
C.niter     = 8;            % �J��Ԃ���
C.const_len = 4;            % �S����

%% ������s
tic;
ERR = zeros(length(S.EbN0),4);
parfor idx_worker = 1:S.nworker
    ERR_ = tuc2(S,G,C);     % tuc: turbodecoder, tuc_: APPdecoder
    ERR = ERR +  ERR_;
end
BER = ERR(:,1)./ERR(:,2);
FER = ERR(:,3)./ERR(:,4);
toc;

%% BER. FER�}��
plot_ber;