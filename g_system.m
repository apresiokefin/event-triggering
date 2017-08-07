function [dx_dt]=g_system(y,x,u)
A=[0 0 -1; 1 0 -3; 0 1 -3];
B=[1 -0.3 0.0]';
dx_dt=A*x+B*u;
end