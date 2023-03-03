% ˵����
% 1.��matlab�����һ�������ʦ�Ǽ���γ̴�ɶȵ����⣬�����ο���
% 2.��������ѧԺ��ѧ��Ӧ����ѧרҵʦ����֤�Ŀγ�Ŀ���ɶȼ���͸�Ŀ��Ĵ�ɶ�ɢ��ͼ���ơ�
% 3.��demo�е�100��ѧ������Ϣ�ͳɼ����ݶ�Ϊ������ɣ�demo�γ��а���4���γ�Ŀ���4�������
% 4.���ñ�������㲻ͬ�γ̵Ĵ�ɶȣ�������4���γ�Ŀ�ꡢ������4���������ֻ���޸ĳ����е�1��2���ġ��γ�Ŀ���������Ratio_Matrix�����������ϸ��γ�Ŀ��ռ�ķ�ֵ�����Լ��滻��demo���̿��˳ɼ�.xls������demo����γ�Ŀ��ɼ�.xls��������Excel���
% 5.Excel������滻�ĳɼ�Ҫ��demo�ɼ���ʽ����һ�£���������Ҫ����ֵ���͡�
% ��д�ˣ�������
% ʱ�䣺2023��3��1��

%% 1.�����ѧ����пγ�Ŀ��������� �����滻��
clear
Ratio_Matrix=[
    10	0	0	35
    10	5	0	15
    0	0	5	5
    0	10	5	0]/100;%�б�ʾ4���γ�Ŀ�꣬�б�ʾ4�������ǰ3����ƽʱ�������4��Ϊ�������
[num,num2]=size(Ratio_Matrix);

%% 2.���ع��̳ɼ��;���ɼ� �����滻��
str1=importdata(num2str('demo���̿��˳ɼ�.xls'));
guocheng=str1.data.Sheet1(:,3:end);% ������̳ɼ����ǰٷ��Ʒ�����
str2=importdata(num2str('demo����γ�Ŀ��ɼ�.xls'));
juanmian_original=str2.data.Sheet1(:,3:end);% ������ÿ��ѧ�����γ�Ŀ�����ʵ�÷֣���ĳһ�γ�Ŀ�깲20�֣���18�֡������ۺϳɼ���Combined_Score���ļ��㡣
juanmian_100=round(juanmian_original./[46,48,6,0,100].*100);% �����Ͽγ�Ŀ��1ռ46�֡��γ�Ŀ��2ռ48�֡��γ�Ŀ��3ռ6�֡��γ�Ŀ��4��ռ�֣��ϼ�100�֡����ڸ��γ�Ŀ���ɶȼ��㡣
                                                            % juanmian_100��ʾת���ɰٷ��Ƶĸ��γ�Ŀ�����ʵ�÷֣����������18�֣���ת��18/20*100=90�֡�
all=[guocheng,juanmian_100];
%% 3.����ѧ�����ۺϳɼ�
fprintf('ƽʱ����ռ�ȣ�%d%%, ����ռ�ȣ�%d%% \n',floor(sum(sum(Ratio_Matrix(:,1:end-1)))*100),floor(sum(Ratio_Matrix(:,end))*100));
[n1,n2]=size(guocheng);
pingshi=zeros(n1,1);
[l1,l2]=size(Ratio_Matrix(:,1:end-1));
for i=1:(l1*l2) %Ratio_Matrix��ǰ���й���12��ƽʱ�ɼ��ı�����ֵ���,guocheng(:,i)�������Ӧ�����ƽʱ�ɼ���
    pingshi=pingshi+guocheng(:,i)*Ratio_Matrix(i);
end
pingshi=round(pingshi);%ƽʱ�ɼ���������ȡ����
Combined_Score=round(pingshi+juanmian_original(:,end)*sum(Ratio_Matrix(:,4)));% juanmian_original(:,end)�Ǿ����ܳɼ���Ratio_Matrix(:,4)��ʾ���湲ռ�ı�����������55%��
n=length(Combined_Score);
a1=sum(Combined_Score>89);          %90~
a2=sum(Combined_Score>79)-a1 ;      %80~89
a3=sum(Combined_Score>69)-a1-a2 ;   %70~79
a4=sum(Combined_Score>59)-a1-a2-a3 ;%60~69
a5=sum(Combined_Score<60) ;         %0~59
fprintf('---------�������εĳɼ��ֲ���\n')
fprintf('[90,100]������: %d���ٷֱȣ�%4.2f%%\n',a1,a1/n*100)
fprintf('[80,90)������: %d���ٷֱȣ�%4.2f%%\n',a2,a2/n*100)
fprintf('[70,80)������: %d���ٷֱȣ�%4.2f%%\n',a3,a3/n*100)
fprintf('[60,70)������: %d���ٷֱȣ�%4.2f%%\n',a4,a4/n*100)
fprintf('[0,60)������: %d���ٷֱȣ�%4.2f%%\n',a5,a5/n*100)
fprintf('������: %d\n',a1+a2+a3+a4+a5)
fprintf('ƽ����: %4.2f\n',sum(Combined_Score)/n)
fprintf('��߷�: %d����ͷ�: %d\n',max(Combined_Score),min(Combined_Score))

%% 4.���ĳһ�ɼ��ε�ѧ����Ϣ
fprintf('---------90�����ϵ�ѧ�ź�������\n')
good=find(Combined_Score>89)';
good1=str1.data.Sheet1(good,1);
good2=str1.textdata.Sheet1(good+1,2);
for i=1:length(good1)
    fprintf('%d, %s, �ۺϵ÷֣�%d [ƽʱ����%d�֣�����ɼ�%d��]\n', good1(i),good2{i},Combined_Score(good(i)),pingshi(good(i)),juanmian_original(good(i),end))
end
fprintf('---------60�����µ�ѧ�ţ�\n')
bad=find(Combined_Score<60)';
bad1=str1.data.Sheet1(bad,1);
bad2=str1.textdata.Sheet1(bad+1,2);
for i=1:length(bad1)
    fprintf('%d, %s, �ۺϵ÷֣�%d [ƽʱ����%d�֣�����ɼ�%d��]\n', bad1(i),bad2{i},Combined_Score(bad(i)),pingshi(bad(i)),juanmian_original(bad(i),end))
end

%% 5.����γ̸���Ŀ���ɶȺ��ܴ�ɶ�
for k=1:num
Target=zeros(n,1);
index_col=find(Ratio_Matrix(k,:)~=0);
for i=1:length(index_col)
Target=Target+all(:,sub2ind(size(Ratio_Matrix), k,index_col(i)))*Ratio_Matrix(k,index_col(i));
end
aaa=['Achievement_Target' num2str(k) '=Target/(sum(Ratio_Matrix(' num2str(k) ',:))*100);'];
eval(aaa);
end
for i=1:num
    fprintf(['�γ�Ŀ��',num2str(i)])
    fprintf('�Ĵ�ɶ�Ϊ: %4.2f \n', mean(eval(['Achievement_Target',num2str(i)])));
end
Target1234=[mean(Achievement_Target1),mean(Achievement_Target2),mean(Achievement_Target3),mean(Achievement_Target4)];
fprintf('---------�γ�Ŀ���ܴ�ɶ�Ϊ: %4.2f \n', mean(Target1234));

%% 6.���ƿγ̸���Ŀ���ɶ���״ͼ
fx=bar(1:num,Target1234);
set(gca,'XTickLabel',{'�γ�Ŀ�� 1','�γ�Ŀ�� 2','�γ�Ŀ�� 3','�γ�Ŀ�� 4'})
set(fx,'FaceColor',[61,133,198]/255);
ylim([0 1])
set(gca,'Ygrid','on')
for i = 1:length(Target1234)
    text(i,Target1234(i)+0.03,num2str(roundn(Target1234(i),-2)),'VerticalAlignment','middle','HorizontalAlignment','center','FontSize',10);
end
title({['�γ�Ŀ�����۴��ֵ']; [   ]})

%% 7.��������ѧ���Ŀγ̸���Ŀ���ɶ�ɢ��ͼ
for i=1:num
    figure
    plot(1:length(Achievement_Target1),eval(['Achievement_Target',num2str(i)]),'bo','MarkerFaceColor',[61,133,198]/255)
    axis([0 length(Achievement_Target1) 0 1]);
    grid on
    hold on
    plot([0 length(Achievement_Target1)], [0.7 0.7], 'r-')
    title({['�γ�Ŀ��' ,num2str(i), '��ɷֲ�ͼ������������']; [   ]})
end

% %% 8.��������ѧ���Ŀγ���Ŀ���ɶ�ɢ��ͼ ����ѡ��
% % figure
% % plot(1:length(Achievement_Target1),(Achievement_Target1+Achievement_Target2+Achievement_Target3+Achievement_Target4)/4,'bo','MarkerFaceColor',[61,133,198]/255)
% % axis([0 length(Achievement_Target1) 0 1]);
% % grid on
% % hold on
% % plot([0 length(Achievement_Target1)], [0.7 0.7], 'r-')
% % title({['����γ�Ŀ���ɷֲ�ͼ������������']; [   ]})