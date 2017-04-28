disp('Regla del trapecio');
n=input('Introduce la funcion: ');
x0=input('Introduce el limite inferior: ');
x1=input('Introduce el limite superior: ');
h=x1-x0;
f=inline(n);
trap=(f(x1)+f(x0))*(h/2);
disp('El resultado es:');
disp(trap);