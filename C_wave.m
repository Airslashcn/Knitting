% figure(33)
% subplot(2,1,1);plot(t,sfNew,'r');hold on
tc=t-t(1);sc=sfH;%*Hf_flag+sf*(Hf_flag==0);
% figure(31)
%   plot(tc,sc,'r');hold on
[tc ,sc]=PWP.cutStEd(tc,sc,fix(1.0*zqN),1);
% figure(31)
%  plot(tc,sc,'b');
 
[~,iw]=max(P1(f<2));
ws=f(iw);
[w,Nper]=PWP.findrightw(tc,sc,ws*2*pi);
Ltt= (2*pi/w)*(Nper-1);
 sc(tc>Ltt+tc(1))=[];
 tc(tc>Ltt+tc(1))=[];
 Nper=Nper-1;

% figure(31)
%  plot(tc,sc,'g');
 Lt=tc(end)-tc(1);
 Ltt= (2*pi/w)*Nper;

fprintf('w %f\n',w)
zqreal=2*pi/w;
zqNN=100;
tcq=linspace(tc(1),tc(end),Nper*zqNN)';
scq = interp1(tc,sc,tcq);
%nomarlized time
tcq=Nper*(tcq-tcq(1))/(tc(end)-tc(1)); 
dt=1/zqNN;
%Read multiple Gaussian PW
t1per=tcq(1:zqNN);
%[tMG,sMG,maxlocMG]=PWP.GetInput(t1per,Nper,type);
%nomarlized signal
MinS=zeros(1,Nper-1);
MaxS=zeros(1,Nper-1);maxloc=zeros(1,Nper-1);
pyU=0;pyD=0.5;
maxlocU=ones(1,Nper-1);maxlocD=ones(1,Nper-1);minloc=ones(1,Nper-1);
% plot(tcq,scq,'b');
[LowVal, LocLow] = findpeaks (-scq);
[LowVal2, LocLow2] = findpeaks (-LowVal);
figure(33)
plot(scq);hold on
plot(LocLow,-LowVal,'-')
% for i=2:Nper-1
%     st=fix((i-1)*zqNN+1);
%     ed=fix((i)*zqNN);
%     [MinS(i),minloc(i)]=min(scq(st-fix(zqNN/5):st+fix(zqNN/1.5)));
%     [MaxS(i),maxlocU(i)]=max(scq([st:ed]+fix(pyU*zqNN)));
%     [~,maxlocD(i)]=max(1-scq([st:ed]+fix(pyD*zqNN)));
%     minloc(i)=minloc(i)+st-1;
%     maxlocU(i)=maxlocU(i)+st-1;
%     figure(33)
%     plot([minloc(i) minloc(i)]*1,[-10 0],'linewidth',1);hold on
%     plot([maxlocU(i) maxlocU(i)]*1,[5 15],'linewidth',1);hold on
%     
%     figure(34)
%     subplot(nw,nw,i);
%     plot(scq(st:ed),'r','linewidth',1);hold on
% end
%     figure(33)
%     plot(scq,'k--','linewidth',3);hold on
% nw=fix(sqrt(Nper))+1;
% for i=1:Nper-2
%     figure(34)
%     subplot(nw,nw,i);
%     plot(scq(minloc(i):minloc(i+1)),'k','linewidth',3);hold on
%     xl(i)=60/(minloc(i+1)-minloc(i))/dt;
% end



