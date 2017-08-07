theta_array=linspace(0,1,100);
[p,q]=size(theta_array);

for iter = 1:q    
t=0.0;
t_final=30;
x=[0 0 0]';
y=0.0;yb=0.0;ys=0.0;ysb=0.0;
delta_t=0.01;n=round(t_final/delta_t);
C=[0 0 1];
theta=theta_array(iter); %time delay
h_u=zeros(1,1000);
n_theta=round(theta/delta_t);
kc=1.5;ti=3.0;td=0.5;s=0.0;
sigma=0.1; %event-triggered parameter
dist=0;

for i=1:n
     t_array(i)=t; y_array(i)=y; ys_array(i)=ys;x_array(:,i)=x;
     if (t>1) ys=1.0; else ys=0.0;end
     %if (t>10)&&(t<15) dist=1; else dist=0;end
     s=s+(kc/ti)*(ys-y)*delta_t;
     if (abs((y-ys))>(sigma*ys))
     u=dist+kc*(ys-y)+s+kc*td*((ys-y)-(ysb-yb))/delta_t;
     u_array(i)=u;
     event_array(i)=1;
     else if (i>1) u=u_array(i-1); u_array(i)=u; event_array(i)=0;
         else u=0; u_array(i)=u; event_array(i)=0; end; end;
     ysb=ys; yb=y; 
     for j=1:999
         h_u(j)=h_u(j+1);
     end
     h_u(1000)=u;
     dx_dt=g_system(y,x,h_u(1000-n_theta));
     x=x+dx_dt*delta_t;
     y=C*x;
     t=t+delta_t;
end
%{
figure(1);
subplot(3,1,1)
plot(t_array,ys_array,t_array,y_array);
xlabel('time(s)');ylabel('Output Value');
legend('y_{setpoint}','y')
grid on

subplot(3,1,2)
plot(t_array,u_array);
xlabel('time(s)');ylabel('Input Value');
legend('u')
grid on

subplot(3,1,3)
area(t_array,event_array);
title('Event-triggered')
xlabel('time(s)');
%}

%{
figure(2)
plot(t_array,x_array)
legend('x1','x2','x3')
grid on
%}

[m,n]=size(t_array);
R=sum(event_array)/n;
R_array_theta(iter)=R;
end

figure(1)
set(gca,'FontSize',10);
plot(theta_array,R_array_theta,'LineWidth',2,'Color','g');
grid on;
xlabel('theta'); ylabel('R');title('Event Ratio (R) vs Time Delay (Theta)');
print('theta_vs_R','-dpng');