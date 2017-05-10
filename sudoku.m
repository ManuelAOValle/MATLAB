clc
clear
%----------SOLVER DE ROMPECABEZAS SUDOKU---------
%ESTE PROGRAMA ES UN ALGORITMO DISEÑADO PARA LA RESOLUCION DE
%ROMPECABEZAS DE SUDOKU POR MEDIO DE ALGORITMOS GENÉTICOS.
%A CONTINUACION SE PRESENTAN VARIOS SUDOKUS INCOMPLETOS HACER PRUEBAS. 

%O CASILLAS VACIAS:
%[7,8,4,1,9,6,2,3,5;3,2,1,5,8,4,6,9,7;9,5,6,3,2,7,4,1,8;2,9,7,4,5,1,3,8,6;8,4,5,9,6,3,1,7,2;6,1,3,8,7,2,9,5,4;1,7,9,6,4,5,8,2,3;4,3,2,7,1,8,5,6,9;5,6,8,2,3,9,7,4,1]

%3 CASILLAS VACIAS:
%[7,0,4,1,9,6,0,3,5;3,2,0,5,8,4,6,9,7;9,5,6,3,2,7,4,1,8;2,9,7,4,5,1,3,8,6;8,4,5,9,6,3,1,7,2;6,1,3,8,7,2,9,5,4;1,7,9,6,4,5,8,2,3;4,3,2,7,1,8,5,6,9;5,6,8,2,3,9,7,4,1]

%10 CASILLAS VACIAS:
%[7,0,4,1,9,6,2,3,5;3,2,1,5,8,4,6,9,0;9,5,6,3,2,7,4,1,8;2,9,0,4,5,0,3,0,6;8,4,5,9,6,3,1,0,2;6,1,3,8,7,2,9,5,4;0,7,9,0,4,5,8,2,3;4,3,2,7,1,0,5,6,9;5,6,8,0,3,9,7,4,1]

%15 CASILLAS VACIAS:
%[7,0,4,1,9,6,0,3,5;3,2,1,5,8,4,6,9,0;9,5,6,3,2,0,4,1,8;2,9,0,4,5,0,3,0,6;8,4,5,0,6,3,1,0,2;6,1,3,8,7,2,9,5,4;0,7,9,0,4,5,8,2,3;4,3,2,7,1,0,5,0,9;5,6,8,0,3,0,7,4,1]

%20 CASILLAS VACIAS:
%[7,0,4,1,0,6,0,3,5;3,2,1,5,8,4,6,9,0;9,5,0,3,2,0,4,1,8;2,9,0,4,5,0,3,0,6;8,4,5,0,6,3,1,0,2;6,1,3,8,7,0,9,5,4;0,7,9,0,0,5,8,2,3;0,3,2,7,1,0,5,0,9;5,6,8,0,3,0,7,4,1]

%------------Parametros Iniciales----------------
N=16;                            %Numero de candidatos
Gen1=3000;                       %Numero de generaciones
Gen2=Gen1+2000;                  %Numero de generaciones
Mut=0.01;                        %probabilidad de mutacion
val=15;
ex=0;
g=0;
%------------Parametros Iterativos---------------
minimo=zeros(1,Gen2);            %Se les asigna un valor inicial   
maximo=zeros(1,Gen2);            %a los parametros que cambian
candidatos=zeros(9,9,N);         %de tamaño con cada iteracion,
unix=zeros(1,9);                 %para que tengan un tamaño fijo  
uniy=zeros(1,9);                 %desde el principio y se ahorre 
unic=zeros(1,9);                 %tiempo de computo. 
fitness=zeros(1,N);
%------------Sudoku Inicial a resolver----------
ssudoku=input('Cargar sudoku'': ' );   %comienza a contar el tiempo
tic                                    %despues de cargar el Sudoku. 
faltantes=length(ssudoku(ssudoku==0)); %# casillas faltantes.
v=find(ssudoku>0);                     %Indices de valores fijos.                
%------------Poblacion Inicial------------------
for ii=1:N
    cand=randi(9,9);
    cand(v)=ssudoku(v);                %reinserta los numeros fijos
    candidatos(:,:,ii)=cand;
end
%----------Evaluacion de funcion Fitness--------
for generacion=1:Gen2
for f=1:N
M=candidatos(:,:,f);  
for x=1:9                               %evaluacion de filas
    unix(x)=9-length(unique(M(x,:)));
end    
for y=1:9                               %evaluacion de columnas
        uniy(y)=9-length(unique(M(:,y)));     
end
    for i=1:3                           %evaluacion de cuadrantes
        for j=1:3
            unic(i,j)=9-length(unique(M(3*i-2:3*i,3*j-2:3*j)));         
        end
    end
    fitness(f)=sum(unix)+sum(uniy)+sum(sum(unic));    
end
%--------Condicion de salida-------------------
if fitness(fitness==0)==0 
    break 
end
%------------Seleccion de Padres(1)------------
minfit=sort(fitness);                %fitnes de chico a grande
ind=find(fitness<=minfit(N/2));      %indices de 'ganadores'
indp=find(fitness>=minfit(N/2));     %indices de 'perdedores'   
ind=ind(1:N/2);
indp=indp(end-N/2:end);
perdedores=candidatos(:,:,indp);
papas=candidatos(:,:,ind);
for p=1:N/2                          %les da una oportunidad
    prob=rand;                       %a los perdedores de ser
    if prob>.95                      %seleccionados
        papas(:,:,p)=perdedores(:,:,p);
    end
end
%--------Condicion de reproduccion-------------
if minfit(1:3)>val                   %es el 'switch' que cambia
    g=g+1;                           %el metodo de reproduccion
    if g>=Gen1                       %break despues de Gen1 generaciones 
        break                        %sin cruzar el valor para el 
    end                              %metodo 2. 
%------------Generacion de nuevos candidatos(1)----------------
candidatos(:,:,1:N/2)=papas;
for can=N/2+1:3*N/4
candidatos(1:2:9,:,can)=papas(1:2:9,:,2*can-(N+1)); %Columnas impares de padre 1. 
candidatos(2:2:8,:,can)=papas(2:2:8,:,2*can-N);     %Columnas pares de padre 2.
end
for can=3*N/4+1:N
candidatos(:,1:2:9,can)=papas(:,1:2:9,2*can-3*N/2);     %Filas impares de padre 2.
candidatos(:,2:2:8,can)=papas(:,2:2:8,2*can-(3*N/2+1)); %Filas impares de padre 1.
end
%----------------Comienzo de Metodo 2--------------------------
else 
    if ex==0
 ex=1;
mensaje=['Comienza etapa 2 en generacion: ', num2str(generacion)];
disp(mensaje)
    end
%------------Generacion de nuevos candidatos(2)----------------
candidatos(:,:,1:N/2)=papas;
for can=N/2+1:3*N/4                               %Evalua el valor de cada
     p1=papas(:,:,2*can-(N+1));                   %casilla de los padres.
     p2=papas(:,:,2*can-(N));                     %Si son iguales, el valor
    for i=1:9                                     %se hereda al hijo. Si son
        for j=1:9                                 %diferentes, se le asgina
            if p1(i,j)==p2(i,j)                   %un randi(9) en la casilla
                candidatos(i,j,can)=p1(i,j);      %correspondiente del hijo. 
                candidatos(i,j,can+N/4)=p1(i,j);
            else
                candidatos(i,j,can)=randi(9);
                candidatos(i,j,can+N/4)=randi(9);
            end
        end
    end
end 
end
%-----------Mutacion de la poblacion-----------------------
for mut=1:round(81*N*Mut)                %81*N es la cantidad total
   casilla=randi(81*N);                  %de casillas por generacion. 
   candidatos(casilla)=randi(9);         %un porcentaje fijo Mut de 
end                                      %esta cantidad se muta. 
for candidato=1:N                        
    cand=candidatos(:,:,candidato);      %se reinsertan los valores
    cand(v)=ssudoku(v);                  %fijos de las casillas
    candidatos(:,:,candidato)=cand;
end
%-------------Estadisticas--------------------
minimo(generacion)=minfit(1);            %Fitness minimo de cada
count=round(Gen2/20);                    %generacion.
if mod(generacion,count)==0              
    porcentaje=generacion*5/count;       %Lleva registro del progreso
    tiempo=toc;                          %del algoritmo a tiempo real. 
    mensaje=[num2str(porcentaje),'% en ',num2str(tiempo),' segundos con un fitness minimo de:', num2str(minfit(1))];
    disp(mensaje)
end
end
%--------Despliegue de Resultados-----------------------
tiempo=(toc);                                      %Se toma el tiempo. 
plot(minimo(1:generacion));                        %Grafica con los fitness
title('Minimo Fitness a traves de Iteraciones')    %minimos de cada generacion. 
xlabel('Iteraciones')                                 
ylabel('Fitness')                                  %Se le agrega una linea
hold on                                            %de referencia marcando
val=ones(1,generacion)*val;                        %el valor que marca el
plot(val,'g')                                      %cambio de metodo
hold off
if fitness(fitness==0)==0                          %Mensaje si se encontró
sol=find(fitness==0);                              %una solución. 
mensaje=('    ');
mensaje1=['Se ha encontrado la solucion en ',num2str(tiempo),' segundos y ' num2str(generacion),' generaciones'];
mensaje2=['El original y su solucion es el candidato ',num2str(sol(1))];
mensaje3=[num2str(ssudoku),zeros(9,9),num2str(candidatos(:,:,sol(1)))];
mensaje4=['Habian ',num2str(faltantes), ' casillas faltantes'];
disp(mensaje)
disp(mensaje1)
disp(mensaje2)
disp(mensaje3)
disp(mensaje4)
else
mensaje=('    ');
mensaje1=('No se ha podido encontrar la solucion');
mensaje2=['se llego a un minimo de fitness ', num2str(minfit(1))];
disp(mensaje)                                    %Mensaje en caso de no
disp(mensaje1)                                   %encontrar una solución 
disp(mensaje2)                                   %antes del limite de
end                                              %generaciones. 