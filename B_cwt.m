
L = length(t); 
dT = mean(t(2:L)-t(1:L-1));        
%compute baseline------------------------------------------------------------------------------
[fitinit, gofinit] = PWP.smoothBaseLine(t, s,0.999);
baseline=fitinit(t);
sB=s;%-baseline;
%FFT------------------------------------------------------------------------------
% [f,P1]=PWP.FFTP1(t,sB);
%find main HZ ------------------------------------------------------------------------------
            L = length(t);                
            T = mean(t(2:L)-t(1:L-1));           
            Fs = 1/T;      
            Y=fft(s);
            f = Fs*(0:fix(L/2))/L;
            P2 = abs(Y/L);
            P1 = P2(1:fix(L/2+1));
            P1(2:end-1) = 2*P1(2:end-1);
wname = 'db4'; % 小波名称
level = 4; % 分解级数
[C,L] = wavedec(sB,level,wname); % 小波分解
A = cell(1,level);
D = cell(1,level);
for i = 1:level
    A{i} = wrcoef('a',C,L,wname,i); % 近似系数
    D{i} = wrcoef('d',C,L,wname,i); % 细节系数
end
%find main HZ ------------------------------------------------------------------------------
[~,iw]=max(P1(f<30));
[Anoise,omeganoise]=max(P1(f>45));
w=f(iw);
zqFr=1/w;
zqN=fix(zqFr/dT);
% % 绘制结果
figure(1);
subplot(level+1,1,1);
plot(t,sB);hold on
title('原始信号');

for i = 1:level
    figure(1);
    subplot(level+1,1,i+1);
    plotyy(t,A{i},t,D{i});
    title(['近似系数和细节系数（级别 ' num2str(i) '）']);
end
sfH=sB;
for i=[1 2  ]
    sfH=sfH-D{i};
end


