clc
clear
%������ģ���˻�
%��������������ģ���˻�logistic����    �����������ֱ���hdiff.m(ˮλ�ݶȺ���)����logitsalt.m����ȷ�ʺ�����
%�������������ֱ�ģ��
possibility=0.5;   %����
threshold=0.5;%��ֵ
T=200;%��ʷ���г���
flow1=3500;     %  70%����
flow2=2500;     %  90%����
data=xlsread('2011to2013.xls');
%��������ǲ����˶ೱϫ�źŵ����� �ӵ����п�ʼ
data1=data(8786-T:13129,:);   %ѵ������  (3692:12465)    (1:8760)  (1000:11713)  
%8586:13129-----��֤ѵ��2012/9/1-2013/2/28  11514:end ----2013��
%8586:end---2012 9 1��2013���

% data=xlsread('newtrain.xlsx');
% data1=data(600:end,:);      %ѵ������  (3692:12465)    (1:8760)   1000:11713
data1(:,1)=data1(:,1)+data1(:,2);
data1(:,2)=data1(:,3);
data1(:,3)=data1(:,4);
% data1(:,4)=[];
data1(:,4)=data1(:,5);
data1(:,5)=data1(:,6);
data1(:,6)=data1(:,7);
data1(:,7)=data1(:,8);
data1(:,8)=data1(:,9);
data1(:,9)=data1(:,10);
data1(:,10)=data1(:,11);
data1(:,11)=[];

q1=data1(:,1); %��ʱ����
X1=q1(T+1:end);

%�����ȥһ�ܵ�ƽ���������ٷ��� �� 2500����  ��2500~3500  ��3500����
for i=1:length(X1)
    average(i)=sum(q1(T-168+i:i+T-1))/168;  %��ȥһ��������ƽ��
end

x1=find(average<=flow2);          %2500����
x2=find(average<=flow1&average>flow2);      %2500~3500
x3=find(average>flow1);        %3500����

dd=data1(T+1:end,:);

%������
% V=[0.5,30,0.1,20,0.1,20,0.1,20,0.1,20,0.1,20,0.1,20,0.1,20];
% [ y3,a300,a301,a310,a311 ]= logitsalt( data1,x3,V);


lb=[0,1, 0,1, 0,1, 0,1,0, 1, 0,1, 0,1, 0,1]; % ����ȡֵ�½�
ub=[1,60,1,40,1,40,1,40,1,40,1,40,1,40,1,40]; % ����ȡֵ�Ͻ�
% ��ȴ�����
MarkovLength=200; % ��ɷ�������
DecayScale=0.9 ; % ˥������
StepFactor=0.2; % Metropolis��������
sp=0.2;  %������������
Temperature0=90; % ��ʼ�¶�
Temperatureend=0.1; % �����¶�
Boltzmann_con=1; % Boltzmann����
% AcceptPoints=0.0; % Metropolis�������ܽ��ܵ�
% �����ʼ������
range=ub-lb;
Par_ini=rand(size(lb)).*range+lb
Par_cur=Par_ini; % ��Par_cur��ʾ��ǰ��
Par_best_cur=Par_cur; % ��Par_best_cur��ʾ��ǰ���Ž�
Par_best=rand(size(lb)).*range+lb; % ��Par_best��ʾ��ȴ�е���ý�
% ÿ����һ���˻�(����)һ�Σ�ֱ�������������Ϊֹ
t=Temperature0;
itr_num=0; % ��¼��������
k=1;
while t>Temperatureend
    itr_num=itr_num+1;
    AcceptPoints=0.0; %ÿ��Metropolis�����н��ܵ�
    t=DecayScale*t; % �¶ȸ��£�����)
    for i=1:MarkovLength
        % �ڴ˵�ǰ�����㸽�����ѡ��һ��
        p=0;
        while p==0
            %Par_new=Par_cur+StepFactor.*range.*(rand(size(lb))-0.5);
            u=rand(size(lb));
            eta=sign(u-0.5).*t.*((1+1./t).^abs(2*u-1)-1);
            delta=sp*eta;
            Par_new=Par_cur+delta;
            % ��ֹԽ��
            if sum(Par_new>ub)+sum(Par_new<lb)==0
                p=1;
            end
        end
        % ���鵱ǰ���Ƿ�Ϊȫ�����Ž�  logitsalt( data1,x3,V)  
        if (logitsalt(data1,x3,Par_new)<logitsalt(data1,x3,Par_best))
            % ������һ�����Ž�
            Par_best_cur=Par_best;
            % ��Ϊ�µ����Ž�
            Par_best=Par_new;
        end
        % Metropolis����
        if (logitsalt(data1,x3,Par_new)-logitsalt(data1,x3,Par_cur)>0)
            % �����½�
            Par_cur=Par_new;
            AcceptPoints=AcceptPoints+1;
        else
            changer=-1*(logitsalt(data1,x3,Par_new)-logitsalt(data1,x3,Par_cur))/(Boltzmann_con*t);
            p1=exp(changer);
            if p1>rand
                Par_cur=Par_new;
                AcceptPoints=AcceptPoints+1;
            end
        end
    end
    accp=AcceptPoints/MarkovLength;
    sp=I(accp)*sp;
    k=k+1;
end
%% �����ʾ
disp(['��Сֵ��:',num2str(Par_best)]);
Objval_best= logitsalt(data1,x3,Par_best);
disp(['��СֵΪ:',num2str(Objval_best)]);
