%% μ1，μ2的范围
%   if μ1>1&&μ2>1/2此时中继处缓冲与用户1处缓冲仅有出流量
%   if μ1<0&&μ2<0此时中继处缓冲与用户1处缓冲仅有入流量

%下面为满足条件的范围
%   if (μ1<0||μ1>1)&&0<μ2<1/2此时仅有中继处缓冲有入流量和出流量，即模式1,3可行，满足限制C1，而不满足C2；
%   if (μ2<0||μ2>1/2)&&0<μ1<1此时仅有用户1处缓冲有入流量和出流量，即模式2,4可行，满足限制C2，而不满足C1；
%   if 0<μ1<1&&0<μ2<1/2此时中继处缓冲及用户1处的缓冲都有入流量和出流量，即模式1,2,3,4皆有概率可行，满足限制C1，C2；
%   other 打破了C1，C2的限制


%目的：求-R0/N*sum(d1(i)*O1(i)+d2(i)*O2(i))的最小值
%模式选择准则：首先根据每条链路的信道条件，判断各个Ok(i),k=1,2,3,4,5的值，然后根据给定的μ1，μ2，确定相应的权值系数，
%其中与Ok(i)，k=1,2,3,4,5相对应的系数分别为1-2μ2,1-μ1，2μ2，μ1，0，并使用w(k)表示，根据max{Ok(i)*w(k)}确定相应的模式。
clc;
clear;
R0=1;
low=0;
high=40;
Np=15;
rho_dB=linspace(low,high,Np);%单位dB
distance=1;
gama=2;
N=2e6;

 %% 产生μ值
        miu_1=0.1:0.4:0.9;%共有49个值
        miu_2=0.05:0.2:0.45;%共有49个值
        %两者组合共有25的数据量
        C=zeros(length(miu_1)*length(miu_2),Np);
for i=1:length(miu_1)
    for j=1:length(miu_2)
        miu1=miu_1(i);
        miu2=miu_2(j);
        w=[1-2*miu2,1-miu1,2*miu2,miu1,0];
        %% 算法时间复杂度为O（T）=Np*length(miu_1)*length(miu_2)*N,本例中为11*81*2e4=1782 0000
        for k=1:Np
            rho=10^(rho_dB(k)/10);
            for t=1:N
              %% 信道建模
                h_BR=1/2*distance^(-gama/2)*complex(randn(1,1),randn(1,1));%基站到K-1个中继的信道信息：模式1
                h_B1=1/sqrt(2)*distance^(-gama/2)*complex(randn(1,1),randn(1,1));%基站到用户1的信道信息：模式2
                h_R1=1/sqrt(2)*distance^(-gama/2)*complex(randn(1,1),randn(1,1));%K-1个中继到用户1的信道信息：模式3
                h_R2=1/2*distance^(-gama/2)*complex(randn(1,1),randn(1,1));%K-1个中继到用户2的信道信息：模式3
                h_12=1/sqrt(2)*distance^(-gama/2)*complex(randn(1,1),randn(1,1));%用户1到用户2的信道信息：模式4

              %% 获取各个链路的通断状态
                [O1,O2,O3,O4,O5]=available_model(h_BR,h_B1,h_R1,h_R2,h_12,R0,rho);

              %% 获取所选模式
                O=[O1,O2,O3,O4,O5];
                d=zeros(1,5);
                [value,index]=max(O.*w);
                if value==0
                    index=5;
                end
                d(index)=1;
                %% 获取目标函数值，即吞吐量
                C((i-1)*length(miu_2)+j,k)=C((i-1)*length(miu_2)+j,k)+(d(1)*O1+d(2)*O2);
            end
        end
    end
end

%% 下面需要思考的一个问题是，对于给定的81个组合该怎么绘制其吞吐量随着信噪比的变化的曲线，研究哪一组取值可以另吞吐量尽可能的大？
   % 图形绘制
figure(1)
for i=1:length(miu_1)*length(miu_2)
        semilogy(rho_dB,C(i,:)*R0,'-g','LineWidth',1);hold on;
end
        

xlabel('信噪比（dB）');
ylabel('Channel Capacity bits/s');  
%axis([low,high,5e-5,1]);
%legend('固定功率分配传输模拟','Location','southwest');
hold on;
grid on;  
