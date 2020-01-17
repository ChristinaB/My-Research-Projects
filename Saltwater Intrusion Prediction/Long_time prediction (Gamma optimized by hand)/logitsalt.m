function [ y,a00,a01,a10,a11 ] = logitsalt( data1,x,V)
% y�ǳɹ��ʣ�
% a00��Ԥ���ʵ�ʶ�������ȡˮ��a01��ʵ�ʲ�����ȡˮ��Ԥ���ɿ���ȡˮ��a10��ʵ�ʿ���ȡˮ�ģ���Ԥ����˲�����ȡˮ��a11ʵ�ʺ�Ԥ�ⶼ����ȡˮ
% data1�����ݼ��� T����ʷ����ʱ�䣬x�ǰ��չ�ȥһ�������ķ���   
% V=[c3N1,c3M1,c3d1N,c3d1M,c3d2N,c3d2M,c3d3N,c3d3M,c3d4N,c3d4M,c3d5N,c3d5M,c3d6N,c3d6M,c3d7N,c3d7M];
% V�ķ�Χ���£�
% V(1): 0-1; 
% V(2): 1-50
% V(3): 0-1
% V(4)��1-40
% V(5),V(7),V(9),...V(15)ͬV(3)    V(6),V(8),...V(16)ͬV(4)
possibility=0.5;   %����
threshold=0.5;%��ֵ
T=200; 
dd=data1(T+1:end,:);
c3x1=dd(x,1);
c3y=dd(x,3);

%���ζ�ֵ��ֵ��������0.5ʱ����ȡˮ��С�ڻ��������ȡˮ��
for i=1:length(c3y)
    if c3y(i)>threshold    %����ȡˮ
        c3y(i)=0;
    elseif c3y(i)<=threshold   %��ȡˮ
        c3y(i)=1; 
    end
end

% ��ʷ��������
for i=1:T
    midc3x3(i,:)=data1(T+x-i,1)';
end
j1=1;
t=1:T;
c3w=(V(1).^V(2))./gamma(V(2)).*(j1.*t).^(V(2)-1).*exp(-V(1)*j1.*t);  %gamma����Ȩ�ع�ʽ
c3W=sum(c3w);
c3weight1=c3w/c3W;  %��һ��
c3weight1=c3weight1';
for j=1:length(c3x1)
    c3x3(j)=midc3x3(:,j)'*c3weight1;   %ԭʼ���ݳ��ϵ����ݳ��ȵ�Ȩ��
end
c3x3=c3x3';  %���ռ�����õ���ʷ�������أ����������������c3x3����̫˳������Ϊ��������ǻ������˻��㷨��������ģ�������֮ǰ�ı������ƣ���Ĳ�˳�۵�����Ҳ�����ԭ��

%������ˮλ���أ����ǰѵ�һ��ˮλ���ݾ�����ֵõ����鳱ϫ�źţ���Ҫ�ļ��鳱ϫ�ź��Ǹ��������������ĳ��������7�飨����Ҫ���ؿ���ֻ�������������飩
%�ೱϫ�źŵ�һ��
n1=4;  % ��ϫ�źŵĵ�һ��λ��ԭʼ���ݵĵ����У���ͬ
% c3d1N=0.5;
% c3d1M=8;
c3d1N=V(3);
c3d1M=V(4);
c3x4d1=hdiff(data1,T,x,n1,c3d1N,c3d1M);
%�ೱϫ�źŵڶ���
n2=5;
% c3d2N=0.5;
% c3d2M=5;
c3d2N=V(5);
c3d2M=V(6);
c3x4d2=hdiff(data1,T,x,n2,c3d2N ,c3d2M);
%�ೱϫ�źŵ�����
 n3=6;
% c3d3N=0.5;
% c3d3M=5;
c3d3N=V(7);
c3d3M=V(8);
c3x4d3=hdiff(data1,T,x,n3,c3d3N,c3d3M);
%�ೱϫ�źŵ�����
 n4=7;
% c3d4N=0.5;
% c3d4M=5;
c3d4N=V(9);
c3d4M=V(10);
c3x4d4=hdiff(data1,T,x,n4,c3d4N ,c3d4M );
%�ೱϫ�źŵ�����
n5=8;
c3d5N=V(11);
c3d5M=V(12);
c3x4d5=hdiff(data1,T,x,n5,c3d5N ,c3d5M );
%�ೱϫ�źŵ�����
n6=9;
c3d6N=V(13);
c3d6M=V(14);
c3x4d6=hdiff(data1,T,x,n6,c3d6N ,c3d6M );
%�ೱϫ�źŵ�����
n7=10;
c3d7N=V(15);
c3d7M=V(16);
c3x4d7=hdiff(data1,T,x,n7,c3d7N ,c3d7M);

c3X=[c3x3,c3x4d1,c3x4d2,c3x4d3,c3x4d4,c3x4d5,c3x4d6,c3x4d7];

c3theta = glmfit(c3X, [c3y ones(length(c3y),1)], 'binomial', 'link', 'logit');
 c3p=1./(1+exp(-[ones(length(c3y),1),c3X]*c3theta));
 
 c3P=c3p;
 
 for i=1:length(c3P)      %�˴������ݸ�������2ֵ���������>=0.5,����Ϊ1��������Ϊ0
    if c3P(i)>=possibility
       c3P(i)=1;
    elseif c3P(i)<possibility
       c3P(i)=0;
    end
end
c3pp=c3y;
c3delta=c3P-c3pp;
[c3M,c3N]=find(c3delta);
c3successfulrate=(length(c3P)-length(c3M))/length(c3P);
y=c3successfulrate;

a00=length(find(c3y==0&c3P==0));  %����ͷע��
a01=length(find(c3y==0&c3P==1));
a10=length(find(c3y==1&c3P==0));
a11=length(find(c3y==1&c3P==1));


end

