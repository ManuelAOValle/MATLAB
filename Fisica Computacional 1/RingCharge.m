x=-5:.5:5;
z=-5:.25:5;
[X,Z]= meshgrid(x,z);
b=2;
rho_1=1;
phi=[0:pi/100:2*pi];
delphi=b.*(phi(2)-phi(1));
Ey=zeros(length(z),length(x));
Ex=zeros(length(z),length(x));
Ez=zeros(length(z),length(x));
for m= 1:length(x);
    for n= 1:length(z);
        for o= 1:length(phi);
            xr=b.*cos(phi(o));
            yr=b.*sin(phi(o));
            Rp=[0 X(n,m) Z(n,m)] - [xr yr 0];
            Rp2= dot(Rp,Rp);
            Rhat= Rp/sqrt(Rp2);
            Ey(n,m)=Ey(n,m)+ Rhat(1)./Rp2;
            Ex(n,m)=Ex(n,m)+ Rhat(2)./Rp2;
            Ez(n,m)=Ez(n,m)+ Rhat(3)./Rp2;
        end
    end;
end
Ex= rho_1*delphi.*Ex./(4*pi*8.85e-12);
Ey= rho_1*delphi.*Ey./(4*pi*8.85e-12);
Ez= rho_1*delphi.*Ez./(4*pi*8.85e-12);

figure
quiver(Ex,Ez,'red')
hold on 
plot(linspace(7,15,200),21*ones(1,200),'c*')
set(gca,'Color',[0.1 0.1 0.1]);
title 'Campo Vectorial de un Anillo de Carga'
