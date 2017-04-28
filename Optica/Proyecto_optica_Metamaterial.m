clear;close all
%Se define longitud de lado de region 1 (con metamaterial ZIM)
a=4.5e-6;
c=3e8;%Se defien
%De acuerdo al articulo, se define un valor para la frecuencia de
%resonancia para la permitividad y la permeabilidad del material
wp=2*pi*(c/a);
%Se define el factor de amortiguamiento a partir de la frecuencia de
%resonancia (se elige peque?o de acuerdo al articulo)
gamma=(1e-25)*wp;
w=linspace(0.8*wp,1.2*wp,1000);%Se define vector de frecuencias
%Se definen el valor de la permitividad relativa en la regi?n con el ZIM
e1=1-(wp^2)./(w.*(w+i*gamma*w))
%Se definen el area y la altura de la region 1, asi como la longitud de
%onda de la luz en tal region, la cual debe ser grande para obtener el
%efecto de superacoplamiento y no sufrir desfase en la transmision
A=a^2;
d=a;
lambda=0.8*a;
%Se define la magnitud del vector de propagacion
ko=(2*pi)/(lambda);
%Se definen en base al modelo de Drude y el articulo, los coeficientes de
%relexion y transmision de Fresnel para el caso en la frontera de la region
%1 y el conductor magnetico perfecto
R=-(i*ko*e1*A)./(2*d+(i*ko*e1*A));
T=1+R;
wnorm=w/wp;%De define un vector de frecuencias normalizado
%Se grafican los coeficientes de fresnel a lo largo de un rango de
%frecuencias normalizada que incluyen la de resonancia
figure (1)
plot(wnorm,abs(T))
title('Coeficiente de transmision en la frontera 1-2')
xlabel('w/wp')
ylabel('Coeficiente de transmision')
figure (2)
plot(wnorm,abs(R))
title('Coeficiente de reflexion en la frontera 1-2')
xlabel('w/wp')
ylabel('Coeficiente de reflexion')