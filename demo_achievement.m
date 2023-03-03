% 说明：
% 1.本程序可一键快速解决老师们计算课程达成度的问题，供参考
% 2.用于邵阳学院理学院数学与应用数学专业师范认证的课程目标达成度计算和各目标的达成度散点图绘制。
% 3.demo中的学生信息和成绩数据为随机生成。根据不同课程，需替换第1、2步中的“课程目标比例矩阵Ratio_Matrix”、“demo过程考核成绩.xls”、“demo卷面课程目标成绩.xls”、“卷面上各课程目标占的分值”。
% 4.Excel表格中替换的成绩要和demo成绩形式保持一致，并且数字要是数值类型。
% 编写人：杨梦云
% 时间：2023年3月1日

%% 1.输入教学大纲中课程目标比例矩阵 【需替换】
clear
Ratio_Matrix=[
    10	0	0	35
    10	5	0	15
    0	0	5	5
    0	10	5	0]/100;%行表示4个课程目标，列表示4个考核项（前3列是平时考核项，第4列为考试项）。
[num,num2]=size(Ratio_Matrix);

%% 2.加载过程成绩和卷面成绩 【需替换】
str1=importdata(num2str('demo过程考核成绩.xls'));
guocheng=str1.data.Sheet1(:,3:end);% 各项过程成绩都是百分制分数。
str2=importdata(num2str('demo卷面课程目标成绩.xls'));
juanmian_original=str2.data.Sheet1(:,3:end);% 卷面上每个学生各课程目标的真实得分，如某一课程目标共20分，得18分。用于综合成绩（Combined_Score）的计算。
juanmian_100=round(juanmian_original./[46,48,6,0,100].*100);% 卷面上课程目标1占46分、课程目标2占48分、课程目标3占6分、课程目标4不占分，合计100分。用于各课程目标达成度计算。
                                                            % juanmian_100表示转换成百分制的各课程目标的真实得分，如上情况得18分，将转成18/20*100=90分。
all=[guocheng,juanmian_100];
%% 3.计算学生的综合成绩
fprintf('平时考核占比：%d%%, 考试占比：%d%% \n',floor(sum(sum(Ratio_Matrix(:,1:end-1)))*100),floor(sum(Ratio_Matrix(:,end))*100));
[n1,n2]=size(guocheng);
pingshi=zeros(n1,1);
[l1,l2]=size(Ratio_Matrix(:,1:end-1));
for i=1:(l1*l2) %Ratio_Matrix的前三列共由12个平时成绩的比例数值组成,guocheng(:,i)是逐个对应具体的平时成绩。
    pingshi=pingshi+guocheng(:,i)*Ratio_Matrix(i);
end
pingshi=round(pingshi);%平时成绩四舍五入取整。
Combined_Score=round(pingshi+juanmian_original(:,end)*sum(Ratio_Matrix(:,4)));% juanmian_original(:,end)是卷面总成绩，Ratio_Matrix(:,4)表示卷面共占的比例，这里是55%。
n=length(Combined_Score);
a1=sum(Combined_Score>89);          %90~
a2=sum(Combined_Score>79)-a1 ;      %80~89
a3=sum(Combined_Score>69)-a1-a2 ;   %70~79
a4=sum(Combined_Score>59)-a1-a2-a3 ;%60~69
a5=sum(Combined_Score<60) ;         %0~59
fprintf('---------各分数段的成绩分布：\n')
fprintf('[90,100]的人数: %d，百分比：%4.2f%%\n',a1,a1/n*100)
fprintf('[80,90)的人数: %d，百分比：%4.2f%%\n',a2,a2/n*100)
fprintf('[70,80)的人数: %d，百分比：%4.2f%%\n',a3,a3/n*100)
fprintf('[60,70)的人数: %d，百分比：%4.2f%%\n',a4,a4/n*100)
fprintf('[0,60)的人数: %d，百分比：%4.2f%%\n',a5,a5/n*100)
fprintf('总人数: %d\n',a1+a2+a3+a4+a5)
fprintf('平均分: %4.2f\n',sum(Combined_Score)/n)
fprintf('最高分: %d，最低分: %d\n',max(Combined_Score),min(Combined_Score))

%% 4.输出某一成绩段的学生信息
fprintf('---------90分以上的学号和姓名：\n')
good=find(Combined_Score>89)';
good1=str1.data.Sheet1(good,1);
good2=str1.textdata.Sheet1(good+1,2);
for i=1:length(good1)
    fprintf('%d, %s, 综合得分：%d [平时折算%d分，卷面成绩%d分]\n', good1(i),good2{i},Combined_Score(good(i)),pingshi(good(i)),juanmian_original(good(i),end))
end
fprintf('---------60分以下的学号：\n')
bad=find(Combined_Score<60)';
bad1=str1.data.Sheet1(bad,1);
bad2=str1.textdata.Sheet1(bad+1,2);
for i=1:length(bad1)
    fprintf('%d, %s, 综合得分：%d [平时折算%d分，卷面成绩%d分]\n', bad1(i),bad2{i},Combined_Score(bad(i)),pingshi(bad(i)),juanmian_original(bad(i),end))
end

%% 5.计算课程各分目标达成度和总达成度
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
    fprintf(['课程目标',num2str(i)])
    fprintf('的达成度为: %4.2f \n', mean(eval(['Achievement_Target',num2str(i)])));
end
Target1234=[mean(Achievement_Target1),mean(Achievement_Target2),mean(Achievement_Target3),mean(Achievement_Target4)];
fprintf('---------课程目标总达成度为: %4.2f \n', mean(Target1234));

%% 6.绘制课程各分目标达成度柱状图
fx=bar(1:num,Target1234);
set(gca,'XTickLabel',{'课程目标 1','课程目标 2','课程目标 3','课程目标 4'})
set(fx,'FaceColor',[61,133,198]/255);
ylim([0 1])
set(gca,'Ygrid','on')
for i = 1:length(Target1234)
    text(i,Target1234(i)+0.03,num2str(roundn(Target1234(i),-2)),'VerticalAlignment','middle','HorizontalAlignment','center','FontSize',10);
end
title({['课程目标评价达成值']; [   ]})

%% 7.绘制所有学生的课程各分目标达成度散点图
for i=1:num
    figure
    plot(1:length(Achievement_Target1),eval(['Achievement_Target',num2str(i)]),'bo','MarkerFaceColor',[61,133,198]/255)
    axis([0 length(Achievement_Target1) 0 1]);
    grid on
    hold on
    plot([0 length(Achievement_Target1)], [0.7 0.7], 'r-')
    title({['课程目标' ,num2str(i), '达成分布图（定量分析）']; [   ]})
end

% %% 8.绘制所有学生的课程总目标达成度散点图 【自选】
% % figure
% % plot(1:length(Achievement_Target1),(Achievement_Target1+Achievement_Target2+Achievement_Target3+Achievement_Target4)/4,'bo','MarkerFaceColor',[61,133,198]/255)
% % axis([0 length(Achievement_Target1) 0 1]);
% % grid on
% % hold on
% % plot([0 length(Achievement_Target1)], [0.7 0.7], 'r-')
% % title({['整体课程目标达成分布图（定量分析）']; [   ]})
