function [ y ] = hdiff(data1,T,x,n,N,M)
%ˮλ�ݶȺ���
%�����õ�����һ������y�����ͷ�����ೱϫ�ź�֮һ��   
%������ data1�����ݼ� T����ʷ����ʱ�䳤�� x�Ƿ��� n�����ݼ�������  N��gamma��������  M��gamma��������
dd=data1(T+1:end,:);
c3x2=dd(x,n);
for i=1:T
    midc3x4(i,:)=data1(T+x-i,n)';   %��ȥ����  ����t-1,t-2,t-3,......,t-T��˳������
end
[c3x4m,c3x4n]=size(midc3x4);

for i=1:c3x4n
    for j=2:c3x4m-1
        if (midc3x4(j,i)>midc3x4(j-1,i)&midc3x4(j,i)>midc3x4(j+1,i))||(midc3x4(j,i)<midc3x4(j-1,i)&midc3x4(j,i)<midc3x4(j+1,i))  %�жϷ�͹�
            c3feng(j,i)=midc3x4(j,i);  %���������ԭ����
        else
            c3feng(j,i)=0;    %�������������Ϊ0�� �������������㴦��
        end
    end
end

c3place=zeros(c3x4m,c3x4n);
for i=1:c3x4n
    c3placeN(i)=length(find(c3feng(:,i)~=0));
     c3place(1:c3placeN(i),i)=find(c3feng(:,i)~=0);
end
c3dimension=min(c3placeN);  %ȡmin��Ϊ��ͳһ���ݾ����ά��
c3place=c3place(1:c3dimension,:);


c3N2=N;         
c3M2=M;         
c3j2=1;
t2=1:c3dimension;
c3w2=(c3N2.^c3M2)./gamma(c3M2).*(c3j2.*t2).^(c3M2-1).*exp(-c3N2*c3j2.*t2);   %gamma����
c3W2=sum(c3w2);
c3weight2=c3w2/c3W2; %��һ��
c3weight2=c3weight2';

for i=1:c3x4n
    for j=1:size(c3place,1)-1
        c3x4MID(j,i)=(c3feng(c3place(j,i),i)-c3feng(c3place(j+1,i),i))/(c3place(j+1,i)-c3place(j,i));   %����-�ȣ�/ʱ���  or  ����-�壩/ʱ���
    end
end

for i=1:c3x4n
    c3add(i)=(c3x2(i)-c3feng(c3place(1,i),i))/c3place(1,i);  %���ǣ���ǰˮλ-����ķ壨or�ȣ���/ʱ���
end
c3x4MID=[c3add;c3x4MID]; %�ϲ�

for i=1:c3x4n
    c3x4(i)=c3x4MID(:,i)'*c3weight2;  %����Ȩ��
end
c3x4=c3x4';
y=c3x4;
end

