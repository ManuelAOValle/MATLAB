clc; 
clear;
 fprintf('\t\tINTEGRACION DE ROMBERG :P\n')
 funcion=input('ingrese la funcion \n f(x)=','s');
 a= input('Ingrese el límite inferior de la integral: \n');
 b= input('Ingrese el límite superior de la integral: \n');
 n= input('Ingrese el número de intervalos\n');
 h=(b-a);
 M=1;
 J=0;
 R=zeros(n,n);
 x=a; f1=eval(funcion);
 x=b;
 f2=eval(funcion);
 R(1,1)=h*(f1+f2)/2;
 while (J<(n-1))
 J=J+1;
 h=h/2;
 s=0;
 for p=1:M
 x=a+h*(2*p-1);
 f3=eval(funcion);
 s=s+f3;
 end
 R(J+1,1)=(1/2)*(R(J,1))+h*s;
 M=2*M;
 for k =1:J
 R(J+1,k+1)=R(J+1,k)+(R(J+1,k)-R(J,k))/(4^k-1);
 end
 end
 R
 fprintf('La aproximacion buscada es: %10.15f\n\n', R(J+1,J+1)) 