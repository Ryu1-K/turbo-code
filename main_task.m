function RES = main_task(SIM,G,CP)

%% 生成多項式設定
switch(CP.constLength)
    case 3
        trellis = poly2trellis(3,[7 5],7);
    case 4
        trellis = poly2trellis(4,[13 15],13);
    case 5
        trellis = poly2trellis(5,[37 33],37);
end

%% レート整合マスク設定
switch(CP.rate)
    case 1/2
        CP.rate_mask_ = logical([1 1 0 1 0 1])';
    case 1/3
        CP.rate_mask_ = logical([1 1 1 1 1 1])';
end
CP.code_len_ = 3*CP.ndata +  4*(CP.constLength-1);
CP.rate_mask = CP.rate_mask_(:,ones(1,ceil(CP.code_len_/6)));
CP.rate_mask = CP.rate_mask(1:CP.code_len_);

%% 初期設定
ConEnc = comm.ConvolutionalEncoder(trellis,'TerminationMethod','Terminated');
APPDec = comm.APPDecoder(trellis,'Algorithm','True APP','TerminationMethod','Terminated');

RES = zeros(length(SIM.EbN0),4);
for idx_En = 1:length(SIM.EbN0)
    CH.N0 = 10^(-SIM.EbN0(idx_En)/10)/(G.ml*CP.rate);
    for idx_loop = 1:ceil(SIM.nloop/SIM.nworker)
        %% データ生成
        TX.b = randi([0 1], CP.ndata, 1);
        
        %% ターボ符号器: TX.c_ = tucEnc(TX.b,intrlvrInd)
        intrlvrInd = randperm(CP.ndata);    % データの順番入れ替え
        dataEnc1 = step(ConEnc,TX.b);
        dataEnc2 = step(ConEnc,TX.b(intrlvrInd));   % 順番を入れ替えた情報ビットでencode
        dataEnc  = [dataEnc1(1:2:2*CP.ndata) dataEnc1(2:2:2*CP.ndata) dataEnc2(2:2:2*CP.ndata)]';
        TX.c_    = dataEnc(:);  % dataEncを列ベクトルに
        TX.c_    = [TX.c_; dataEnc1(2*CP.ndata+1:end); dataEnc2(2*CP.ndata+1:end)];
        
        %% レート整合
        TX.c = TX.c_(CP.rate_mask);
        
        %% BPSK
        TX.x = 2 * TX.c - 1;
        
        %% AWGN
        RX.z = (randn(size(TX.x)) + 1i * randn(size(TX.x))) * sqrt(CH.N0/2);
        RX.y = TX.x + RX.z;
        
        %% LLR-BPSK
        llr = 4 * real(RX.y) / CH.N0;
        
        %% レート復元
        llr_ = zeros(CP.code_len_,1);
        llr_(CP.rate_mask) = llr;   % llr_のindexがCP.rate_maskの1のところにllrが入っている？
        
        %% ターボ復号器: RX.b = tucDec(llr_,intrlvrInd)
        temp = reshape(llr_(1:3*CP.ndata),3,[])';
        tail = reshape(llr_(3*CP.ndata+1:end),[],2);
        llr1 = temp(:,1:2)'; 
        llr1  = [llr1(:); tail(:,1)];
        
        llr2  = [temp(intrlvrInd,1) temp(:,3)]'; 
        llr2  = [llr2(:); tail(:,2)];
        
        llr1_pri = zeros(CP.ndata,1);

        for iter = 1:CP.niter
            % 復号器 1
            llr1_app = step(APPDec, [llr1_pri; zeros(CP.constLength-1,1)], llr1);
            llr2_pri = llr1_app(1:CP.ndata) - llr1(1:2:2*CP.ndata);
            
            % インターリーバ
            llr2_pri = llr2_pri(intrlvrInd);
            
            % 復号器 2
            llr2_app = step(APPDec, [llr2_pri; zeros(CP.constLength-1,1)], llr2);
            llr1_pri = llr2_app(1:CP.ndata) - llr2(1:2:2*CP.ndata);
            
            % デインターリーバ
            llr1_pri(intrlvrInd) = llr1_pri;
        end
        tmp(intrlvrInd,1)  = llr2_app(1:CP.ndata)+llr2_pri;
        RX.b = tmp > 0;
        
        %% error
        noe = sum(TX.b ~= RX.b);
        noef = noe~=0;
        RES(idx_En, 1) = RES(idx_En, 1) + noe;
        RES(idx_En, 2) = RES(idx_En, 2) + numel(TX.b);
        RES(idx_En, 3) = RES(idx_En, 3) + noef;
        RES(idx_En, 4) = RES(idx_En, 4) + 1;
        
        if(RES(idx_En,3)>(SIM.errmax/SIM.nworker))
            break;
        end
    end
end