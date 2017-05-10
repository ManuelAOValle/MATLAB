clc
close all
clear all
%[7,8,4,1,9,6,2,3,5;3,2,1,5,8,4,6,9,7;9,5,6,3,2,7,4,1,8;2,9,7,4,5,1,3,8,6;8,4,5,9,6,3,1,7,2;6,1,3,8,7,2,9,5,4;1,7,9,6,4,5,8,2,3;4,3,2,7,1,8,5,6,9;5,6,8,2,3,9,7,4,1]
%------------Parametros Iniciales------------
N=16;                            %Numero de candidatos
Gen1=3000;                       %Numero de generaciones
Gen2=Gen1+2000;                  %Numero de generaciones
Mut=0.01;                        %probabilidad de mutacion
val=15;
ex=0;
g=0;
%------------Parametros Iterativos-------------
minimo=zeros(1,Gen2);             %Se les asigna un valor inicial   
maximo=zeros(1,Gen2);             %a los parametros que cambian
candidatos=zeros(9,9,N);         %de tama?o con cada iteracion,
unix=zeros(1,9);                 %para que tengan un tama?o fijo  
uniy=zeros(1,9);                 %desde el principio y se ahorre 
unic=zeros(1,9);                 %tiempo de computo. 
fitness=zeros(1,N);
%------------Sudoku Inicial a resolver--------
ssudoku=input('Cargar sudoku'': ' );
tic
faltantes=length(ssudoku(ssudoku==0));
v=find(ssudoku>0);               %indices de valores fijos                 
%------------Poblacion Inicial----------------
for ii=1:N
    cand=randi(9,9);
    cand(v)=ssudoku(v);
    candidatos(:,:,ii)=cand;
end
%----------Evaluacion de funcion Fitness------
for generacion=1:Gen2
for f=1:N
M=candidatos(:,:,f);  
for x=1:9                          %filas
    unix(x)=9-length(unique(M(x,:)));
end    
for y=1:9                          %columnas
        uniy(y)=9-length(unique(M(:,y)));     
end
    for i=1:3                      %cuadrantes
        for j=1:3
            unic(i,j)=9-length(unique(M(3*i-2:3*i,3*j-2:3*j)));         
        end
    end
    fitness(f)=sum(unix)+sum(uniy)+sum(sum(unic));    
end
%--------Condicion de salida-----------------
if fitness(fitness==0)==0 
    break 
end
%--------Condicion de reproduccion----------
minfit=sort(fitness);  
if minfit(1:3)>val
    g=g+1;
    if g>=Gen1
        break
    end
%------------Seleccion de Padres(1)------------
ind=find(fitness<=minfit(N/2));
indp=find(fitness>=minfit(N/2));
ind=ind(1:N/2);
perdedores=candidatos(:,:,indp);
papas=candidatos(:,:,ind);
for p=1:N/2
    prob=rand;
    if prob>.95 
        papas(:,:,p)=perdedores(:,:,p);
    end
end
%------------Generacion de nuevos candidatos(1)----------------
candidatos(:,:,1:N/2)=papas;
for can=N/2+1:3*N/4
    candidatos(1:2:9,:,can)=papas(1:2:9,:,2*can-(N+1));
    candidatos(2:2:8,:,can)=papas(2:2:8,:,2*can-N);
end
for can=3*N/4+1:N
    candidatos(:,1:2:9,can)=papas(:,1:2:9,2*can-3*N/2);
    candidatos(:,2:2:8,can)=papas(:,2:2:8,2*can-(3*N/2+1));
end
%------------Seleccion de Padres(2)------------
else 
    if ex==0
% exc=find(fitness<=minfit(16));
% exc=exc(1:16);
% candidatos=candidatos(:,:,exc);
% N=16;
 ex=1;
% exc=sort(exc);
% ind=1:8;
% indp=9:16;
mensaje=['Comienza etapa 2 en generacion: ', num2str(generacion)];
disp(mensaje)
    else
ind=sort(find(fitness<=minfit(N/2)));
ind=ind(1:N/2);
indp=sort(find(fitness>=minfit(N/2)));
indp=indp(1:N/2);
    end
perdedores=candidatos(:,:,indp);
papas=candidatos(:,:,ind);
for p=1:N/2
    prob=rand;
    if prob>.95 
        papas(:,:,p)=perdedores(:,:,p);
    end
end
%------------Generacion de nuevos candidatos(2)----------------
candidatos(:,:,1:N/2)=papas;
for can=N/2+1:3*N/4
     p1=papas(:,:,2*can-(N+1));
     p2=papas(:,:,2*can-(N));
    for i=1:9
        for j=1:9
            if p1(i,j)==p2(i,j)
                candidatos(i,j,can)=p1(i,j);
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
for mut=1:round(81*N*Mut)
   casilla=randi(81*N);
   candidatos(casilla)=randi(9);
end
for candidato=1:N
    cand=candidatos(:,:,candidato);
    cand(v)=ssudoku(v);
    candidatos(:,:,candidato)=cand;
end
%-------------Estadisticas--------------------
minimo(generacion)=minfit(1);
maximo(generacion)=minfit(end);
count=round(Gen2/20);
if mod(generacion,count)==0
    porcentaje=generacion*5/count;
    tiempo=toc;
    mensaje=[num2str(porcentaje),'% en ',num2str(tiempo),' segundos con un fitness minimo de:', num2str(minfit(1))];
    disp(mensaje)
end
end
%--------Despliegue de Resultados-----------------------
tiempo=(toc);
plot(minimo(1:generacion));
title('Minimo Fitness a traves de Iteraciones')
xlabel('Iteraciones')
ylabel('Fitness')
hold on
val=ones(1,generacion)*val;
plot(val,'g')
hold off
umin=unique(minimo(1:generacion));
imax=unique(maximo(1:generacion));
if fitness(fitness==0)==0
sol=find(fitness==0);
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
drawSudoku(ssudoku) %mostramos el Sudoku ingresado
drawSudoku(candidatos(:,:,sol(1))) %Mostramos el Sudoku Final
else
    mensaje=('    ');
    mensaje1=('No se ha podido encontrar la solucion');
    mensaje2=['se llego a un minimo de fitness ', num2str(minfit(1))];
    disp(mensaje)
    disp(mensaje1)
    disp(mensaje2)
end
faltantes=length(ssudoku(ssudoku==0))
find(fitness==0)