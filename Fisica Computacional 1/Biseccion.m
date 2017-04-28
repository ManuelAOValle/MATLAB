function [ x ] = Biseccion(f,n,a,b,e)
%Metodo de Biseccion
%f: funcion 
%n: numero de iteracion
%a y b: intervalo [a,b]
%e: error permitido
a(1) = a;
b(1) = b;
for i = 1:n
    m(i) = (a(i) + b(i))/2;
    x = a(i);
    Fa = eval(f);
    x = m(i);
    Fb = eval(f);
    if(Fa*Fb) < 0
        a(i+1) = a(i);
        b(i+1) = m(i);
    else
        a(i+1) = m(i);
        b(i+1) = b(i);
    end

    X(i,1) = i;
    X(i,2) = a(i);
    X(i,3) = b(i);
    X(i,4) = m(i);

    if i > 1
        Ea = abs((m(i) - m(i-1))/m(i))*100;
        X(i,5) = Ea;
        if Ea < e
            break;
        end
    end
    
end
end