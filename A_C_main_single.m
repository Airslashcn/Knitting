for num=7
    Lcut=0.10;
    Rcut=0.95;%cut signal
    
    path='.\data\20220709\';% real path
    type='sin';  % tri sin pw

    Dname=dir(path);
    name=Dname(num+2).name;
    PWP=PulseWavePre;
    filterflag=1;
    Hf_flag=1;Hhz=20; % filter flag
    HZprint_flag=0;
    
    strloc=strfind(name,'-');
    namepart={};
    for ipart=1:length(strloc)-1
        namepart{ipart}=name(strloc(ipart)+1:strloc(ipart+1)-1);
    end
    
    
    fprintf('%d %s\n',num,name)
    target_line=PWP.readlines([path,name],8);
    strst=strfind(target_line,'Offset: ');
    stred=strfind(target_line,' V ');
    if(isempty(stred))
        stred=strfind(target_line,' mV ');
        Offset=str2num(target_line(strst+8:stred-1));
    else
        Offset=str2num(target_line(strst+8:stred-1))*(1000);
    end
    fprintf('Offset %f \n',Offset)
    data=csvread([path,name],11);
    ZoF=1;
    if(strcmp(namepart{1},'plainL')  && (strcmp(namepart{6},'0') ||strcmp(namepart{6},'200') ))
    ZoF=-1
    end
    [t,s]=A_cut(path,name,PWP,Offset,ZoF);
    B_fft
    C_wave
    nameTitle=name;
    D_errorBar_forsin

    savepath='.\data\sinsave\'; %save path
    save([savepath,nameTitle(1:end-4),'.mat'],'R2Dc_all','DU_vec','Sen_vec',...
    'tMean','scqMean','scqMean2','PDmaxR','sMGMean','R2_1','R2_v')

    csvwrite(['.\CSVWrite\',nameTitle],[ tMean(1:1:end)',scqMean2(1:1:end)' ])
    csvwrite(['.\CSVOrin\',nameTitle],[tO',scqO2'])

end
