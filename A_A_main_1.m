
for num=1:5;
path='.\Health\';% real path

Dname=dir(path);
name=Dname(num+2).name
PWP=PulseWavePre;
filterflag=1;
Hf_flag=1;Hhz=10; % filter flag
HZprint_flag=1;

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

[t,s]=A_cut(path,name,PWP,Offset,1);
B_cwt
C_wave_cwt
 nameTitle=name;
D_need_save
% csvwrite(['.\CSVWrite\',nameTitle],[ t(1:1:end),sfH(1:1:end) ])
clear
end
