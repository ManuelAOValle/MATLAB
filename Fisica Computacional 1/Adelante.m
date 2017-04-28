x=linspace(-3*pi,3*pi,1000);
h=x(2)-x(1);
y=sin(x);
A1=[]; ErrorA1=[]; A2=[]; ErrorA2=[]; D1=[]; ErrorD1=[]; 
D2=[]; ErrorD2=[]; C1=[]; ErrorC1=[]; C2=[]; ErrorC2=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adelante con dos puntos
for k=1:999
    A1(end+1)=(y(k+1)-y(k))./h;
    ErrorA1(end+1)=cos(y(k))-A1(end);
end
figure(1);
plot(x(2:end),A1(1:end),'bo'), grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adelante con tres puntos
for k=1:998
    A2(end+1)=(-y(k+2)+4*y(k+1)-3*y(k))/(2*h);
    ErrorA2(end+1)=cos(y(k))-A2(end);
end
figure(2);
plot(x(3:end),A2(1:end),'gx'), grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hacia atrás con dos puntos
for k=2:1000
    D1(end+1)=(y(k)-y(k-1))/h;
    ErrorD1(end+1)=cos(y(k))-D1(end);
end
figure(3);
plot(x(1:end-1),D1(1:end),'r+'), grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hacia atrás con tres puntos
for k=3:1000
    D2(end+1)=(3*y(k)-4*y(k-1)+y(k-2))/(2*h);
    ErrorD2(end+1)=cos(y(k))-D2(end);
end
figure(4);
plot(x(1:end-2),D2(1:end),'cs'), grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Centrada con dos puntos
for k=2:999
    C1(end+1)=(y(k+1)-y(k-1))/(2*h);
    ErrorC1(end+1)=cos(y(k))-C1(end);
end
figure(5);
plot(x(2:end-1),C1(1:end),'md'), grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Centrada con cuatro puntos
for k=3:998
    C2(end+1)=(-y(k+2)+8*y(k+1)-8*y(k-1)+y(k-2))/(12*h);
    ErrorC1(end+1)=cos(y(k))-C2(end);
end
figure(6);
plot(x(3:end-2),C2(1:end),'mv'), grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%