%̨������ʱ��logistic regression
clc
clear
%�������������ֱ�ģ��
possibility=0.5;   %����
threshold=0.5;%��ֵ
c1alpha=0.2;
T=200;%��ʷ���г���
data=xlsread('1.xlsx');
data1=data((300:1000),:);   %ѵ������  (3692:12465)    (1:8760)
data1(:,1)=data1(:,1)+data1(:,2);
data1(:,2)=data1(:,3);
data1(:,3)=data1(:,4);
data1(:,4)=[];
dd=data1(T+1:end,:);
% figure(1)
% plot(dd(:,1))
% figure(2)
% plot(dd(:,2))
x1=1:length(dd);
c1x1=log(dd(x1,1));  %tʱ��
%c1x1=c1x1*mg1;
c1x2=dd(x1,2);    
%c1x2=c1x2*mg2;
c1y=dd(x1,3);
for i=1:length(c1y)
    if c1y(i)>threshold    %����ȡˮ
        c1y(i)=0;
    elseif c1y(i)<=threshold   %��ȡˮ
        c1y(i)=1; 
    end
end

for i=1:T
    midc1x3(i,:)=data1(T+x1-i,1)';
end

%Ȩ��  
c1N1=0.3;    %��һ��         
c1M1=40;    %��һ��
c1j1=1;    
t=1:T;
c1w=(c1N1^c1M1)/gamma(c1M1).*(c1j1.*t).^(c1M1-1).*exp(-c1N1*c1j1.*t);  %gamma����
c1W=sum(c1w);
c1weight1=c1w/c1W;
c1weight1=c1weight1';
for j=1:length(c1x1)
         c1x3(j)=midc1x3(:,j)'*c1weight1;
end
c1x3=log(c1x3');  %��ʷ��������


%��������ʷˮλ�ݶ�����
for i=1:T
    midc1x4(i,:)=data1(T+x1-i,2)';   %��ȥˮλ  ����t-1,t-2,t-3,......,t-T��˳������
end
[c1x4m,c1x4n]=size(midc1x4);

for i=1:c1x4n
    for j=2:c1x4m-1
        if (midc1x4(j,i)>midc1x4(j-1,i)&midc1x4(j,i)>midc1x4(j+1,i))||(midc1x4(j,i)<midc1x4(j-1,i)&midc1x4(j,i)<midc1x4(j+1,i))  %�жϷ����
            c1feng(j,i)=midc1x4(j,i);
        else
            c1feng(j,i)=0;
        end
    end
end

 %ȷ����͹ȵľ���λ��
c1place=zeros(c1x4m,c1x4n);
for i=1:c1x4n
    c1placeN(i)=length(find(c1feng(:,i)~=0));  
     c1place(1:c1placeN(i),i)=find(c1feng(:,i)~=0);
end
c1dimension=min(c1placeN);
c1place=c1place(1:c1dimension,:);


c1N2=0.11;    %�ڶ���           % 4��ϵ���ֱ�Ϊ 0.3 40  0.1  1.7 ��ȷ�� 0.9053     0.11  1.9      
c1M2=1.9;    %�ڶ���
c1j2=1;
t2=1:c1dimension;
c1w2=(c1N2^c1M2)/gamma(c1M2).*(c1j2.*t2).^(c1M2-1).*exp(-c1N2*c1j2.*t2);
c1W2=sum(c1w2);
c1weight2=c1w2/c1W2;
c1weight2=c1weight2';

for i=1:c1x4n
    for j=1:size(c1place,1)-1
        c1x4MID(j,i)=(c1feng(c1place(j,i),i)-c1feng(c1place(j+1,i),i))/(c1place(j+1,i)-c1place(j,i));  %����-�ȣ�/ʱ���  or  ����-�壩/ʱ���
    end
end

for i=1:c1x4n
    c1add(i)=(c1x2(i)-c1feng(c1place(1,i),i))/c1place(1,i);     %���ǣ���ǰˮλ-����ķ壨or�ȣ���/ʱ���
end
c1x4MID=[c1add;c1x4MID]; %�ϲ�

for i=1:c1x4n
    c1x4(i)=c1x4MID(:,i)'*c1weight2;
end
c1x4=c1x4';

%���Ǽ򵥵��ݶȰ汾��������h��t+1��-h(t),ֱ�Ӻ�����Σ������½�����Ϊ������Щ������
% c1weight2=zeros(T,1);
% for i=1:length(c1weight2)
%     c1weight2(i)=c1alpha*(1-c1alpha)^(i-1);
% end
% c1weight2=c1weight2/sum(c1weight2);
% for k=1:length(c1x1)    % ˮλ�ݶȵļ�Ȩƽ��
%     A(:,k)=diff(midc1x4(:,k));   %�ݶ�
%      c1x4(k)=A(:,k)'*c1weight2(1:end-1);
% end
% c1x4=c1x4';
%c1x4=c1x4*mg4;


c1X=[c1x3,c1x4];
c1theta = glmfit(c1X, [c1y ones(length(c1y),1)], 'binomial', 'link', 'logit');
 c1p=1./(1+exp(-[ones(length(c1y),1),c1X]*c1theta));
 
 c1P=c1p;  %Ϊ�˲��ƻ�ԭ���c1p������c1P����������������
 
 for i=1:length(c1P)      %�˴������ݸ�������2ֵ���������>=0.5,����Ϊ1��������Ϊ0
    if c1P(i)>=possibility
       c1P(i)=1;
    elseif c1P(i)<possibility
       c1P(i)=0;
    end
end
c1pp=c1y;
c1delta=c1P-c1pp;
[c1M,c1N]=find(c1delta);
c1successfulrate=(length(c1P)-length(c1M))/length(c1P)

a00=length(find(c1y==0&c1P==0)); 
a01=length(find(c1y==0&c1P==1));
a10=length(find(c1y==1&c1P==0));
a11=length(find(c1y==1&c1P==1));
%a01��ʵ�ʲ�����ȡˮ��Ԥ���ɿ���ȡˮ��a10��ʵ�ʿ���ȡˮ�ģ���Ԥ����˲�����ȡˮ��a11ʵ�ʺ�Ԥ�ⶼ����ȡˮ
%detail���ۺ�
detail=[a00,a01;
  a10,a11  ]

% % %������
% faultc1=[c1x2(c1M),c1x3(c1M),c1x4(c1M),c1y(c1M),c1p(c1M)];

 
figure(1)
subplot(2,1,1)
plot(1:T,c1weight1,'b-','LineWidth',1.5)
legend('the weight of flow')
title('below 2500')
subplot(2,1,2)
plot(1:c1dimension,c1weight2,'r-','LineWidth',1.5)
legend('the weight of sea level')
title('below 2500')

