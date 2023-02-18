clc; clear;

%% �V�~�����[�V�����p�����[�^
SIM.nworker   = 1;            % ������s��
SIM.EbN0      = 0:0.2:4;     % Eb/N0
SIM.nloop     = 1000;         % ���s��
SIM.errmax    = SIM.nloop/10; 

%% �ϒ��p�����[�^
G.Q         = 2;            % �ϒ����l��
G.ml        = log2(G.Q);    % �ϒ����x��

%% �����p�����[�^
CP.ndata     = 1024;         % ���r�b�g��
CP.rate      = 1/2;          % ��������
CP.niter     = 8;            % �J��Ԃ���
CP.constLength = 4;            % �S����

%% �V���O�����s
tic;
RES = main_task(SIM,G,CP);     % tuc: turbodecoder, tuc_: APPdecoder
BER = RES(:,1)./RES(:,2);
FER = RES(:,3)./RES(:,4);
toc;

%% BER. FER�}��
plot_ber;