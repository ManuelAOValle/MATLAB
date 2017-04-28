clearvars
punto=0.5;
h1=0.5;
y=@(x) -0.1*(x^4)-0.15*(x^3)-0.5*(x^2)-0.25*x+1.2;
D=@(h) (y(punto+h)-y(punto-h))/(2*h);
h2=h1/2;
Der=(4/3)*D(h2)-(1/3)*D(h1)
Error=-0.9125-Der