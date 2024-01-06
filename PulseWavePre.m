classdef PulseWavePre
   properties
      Value {mustBeNumeric}
   end
   methods
        function [tMG,sMG,maxlocMG]=GetInput(~,t1per,Nper,type)
            path='.\Input\';
            load([path,type])
            zqNN=length(t1per);
            dt=1/zqNN;
            %tMG=[0,tMG];sMG=[0,sMG];
            sMG = interp1(tMG,sMG,t1per);
            s1per=sMG;
            [~,maxlocMG]=max(sMG);
            for i=2:Nper
                sMG=[sMG;s1per];
            end
            tMG=[0:zqNN*Nper]'*dt;tMG(end)=[];
        end
        
        function [f,P1]=FFTP1(~,t,s)
            L = length(t);                
            T = mean(t(2:L)-t(1:L-1));           
            Fs = 1/T;      
            Y=fft(s);
            f = Fs*(0:fix(L/2))/L;
            P2 = abs(Y/L);
            P1 = P2(1:fix(L/2+1));
            P1(2:end-1) = 2*P1(2:end-1);
        end
        
        function [m, v]=MeanAndErrorBar(~,vec)
                m=mean(vec);
                v=sqrt(var(vec));
            end

            function target_line=readlines(~,name,line_num)
                fid=fopen(name);
                for i=1:line_num-1
                    fgetl(fid);
                end
                target_line=fgetl(fid);
                fclose(fid);
            end

            function [fitresult, gof] = smoothBaseLine(~,t, s,para)

            [xData, yData] = prepareCurveData( t, s );

            % Set up fittype and options.
            ft = fittype( 'smoothingspline' );
            opts = fitoptions( 'Method', 'SmoothingSpline' );
            opts.Normalize = 'on';
            opts.SmoothingParam = para;

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
        end
        
        function [t ,s]=cutStEd(~,tc,sc,zqNN,N)
            for i=1:N
            Llo=length(sc);
            [~,NlocL]=min(sc(1:zqNN));


            [~,NlocR]=min(sc(Llo-zqNN:Llo));


            NlocR=Llo;%-zqNN+NlocR-1;
            rg=[NlocL:NlocR];
            try
            tc=tc(rg);sc=sc(rg);
            catch
                fprintf('L %d St %d ed %d\n',Llo,NlocL,NlocR)
            end
            end
            t=tc;s=sc;
            %  plot(tc(1:zqNN),sc(1:zqNN),'g');hold on
            % plot(tc(Llo-zqNN:Llo),sc(Llo-zqNN:Llo),'k');hold on
        end
        
        function sf=FilterBandStop(~,t,Hz,s)
            L = length(t);                
            T = mean(t(2:L)-t(1:L-1));           
            Fs = 1/T;    

            fp1=[Hz-1,Hz+1];
            fs1=[Hz-0.5, Hz+0.5];
            Fs2=Fs/2;
            Wp=fp1/Fs2; Ws=fs1/Fs2;
            Rp=3; Rs=20;
            [n,wn]=buttord(Wp,Ws,Rp,Rs);
            [b2,a2]=butter(n,wn,'stop');
            sf=filter(b2,a2,s);
        end

        function sf=FilterHigh(~,t,Hz,s)
            L = length(t);                
            T = mean(t(2:L)-t(1:L-1));           
            Fs = 1/T;   

            Nfir = 50;
            Fst = Hz;

            firf = designfilt('lowpassfir','FilterOrder',Nfir, ...
                'CutoffFrequency',Fst,'SampleRate',Fs);

            sf = filtfilt(firf,s);
        end
        
        function [w,Nper]=findrightw(obj,t,sB,ws)
            dt=1e-3;
            tcq=t(1):dt:t(end);
            tcq=tcq';
            scq = interp1(t,sB,tcq);

            [f,P1]=obj.FFTP1(t,sB);
            [~,w]=max(P1(f<2));

            wsv=[ws-0.1:0.1:ws+0.1];
            for iws=1:length(wsv)
                wsin=wsv(iws);
                [~, gof] = FourierFit(t,sB/max(sB),0,wsin);
                rs(iws)=gof.rsquare;
            end
            [~, b]=max(rs);
            [fitFourier, gof] = FourierFit(t,sB/max(sB),1,wsv(b));
            w=fitFourier.w;
            zqNN=fix(1./(w/2/pi)/dt);
            Nper=round(length(scq)/zqNN);
        end
        
        function R2=ComputeR2(obj,y,ypred)
            SStot=sum((y-mean(y)).^2);
            SSres=sum( (y-ypred).^2 );
            SSreg=sum( (ypred-mean(y)).^2 );

             R2=1-SSres/SStot;
           % R2=SSreg/SStot;
        end
        

        function [IM,s1]=IntMean(obj,s)
            IM=zeros(size(s));
            L=length(s);
            IM(1)=s(1);
            for i=2:length(s)
                IM(i)=IM(i-1)+s(i);
            end
            M=[1:L];M=reshape(M,size(s));
            IM=IM./M;
            s1=s-IM*1;
        end
        function [sMGMean,partv]=PeriAve(obj,sMGDs,Nsamp,pers,plotflag)
            sMGMean=zeros(1,Nsamp);
            partv=[];
            for i=1:pers
                part=sMGDs(1+Nsamp*i-Nsamp:Nsamp*i)/pers;
                sMGMean=sMGMean+part;
                if(plotflag)
                    figure(123)
                    plot(part*pers);hold on
                end
                partv=[partv,part*pers];
            end
        end
% strloc=strfind(name,'-');
% namepart={};
% for ipart=1:length(strloc)-1
% namepart{ipart}=name(strloc(ipart)+1:strloc(ipart+1)-1);
% end
% % namepart{1}
% % namepart{length(strloc)-1}
% if( strcmp(namepart{length(strloc)-1} ,'PW' )  )
%     newname=[name(1:strloc(length(strloc)-1)),'0',name(strloc(length(strloc))   :end ) ];
% else
%     newname=name;
% end
% copyfile([path,name],['.\pw2\',newname])
        
   end
end