clc %borrar consola
clear %borrar variables
%[7,8,4,1,9,6,2,3,5;3,2,1,5,8,4,6,9,7;9,5,6,3,2,7,4,1,8;2,9,7,4,5,1,3,8,6;8,4,5,9,6,3,1,7,2;6,1,3,8,7,2,9,5,4;1,7,9,6,4,5,8,2,3;4,3,2,7,1,8,5,6,9;5,6,8,2,3,9,7,4,1]
%  Parameters:
N=32; %Numero de candidatos
Gen=22000; %Numero de generaciones
%    Input un sudoku sin resolver
ssudoku = input( ' Cargar sudoku'': ' );
tic
v=find(ssudoku>0);%encuentra LOS INDICES de la matriz ssudoku que no son cero
                 %y que por lo tanto no pueden cambiar
                 
%Crear una poblaci?n inicial 
for ii=1:N %crea una cantidad N de candidatos
    cand=randi(9,9); %se llenan las casillas vacias del sudoku de manera aleatoria
    cand(v)=ssudoku(v);%se fijan los numeros que vienen originalmente
    candidatos(:,:,ii)=cand; %se guarda al candidato en un arreglo de 9x9xN
end

for generacion=1:Gen %se comienza el loop evolutivo
for f=1:N %para cada candidato se evaluara el fitness
M=candidatos(:,:,f);    
for x=1:9 %filas
    unix(x)=9-length(unique(M(x,:))); %cuenta la cantidad de repeticiones que hay por fila
end    
fitnes(f)=sum(unix); %fitness filas

for y=1:9%columnas
        uniy(y)=9-length(unique(M(:,y)));%cuenta la cantidad de repeticiones que hay por columna     
end
fitnes(f)=fitnes(f)+sum(uniy);   %fitness columnas
    for i=1:3%cuadrantes
        for j=1:3%cuenta la cantidad de repeticiones que hay por cuadrante
            unic(i,j)=9-length(unique(M(3*i-2:3*i,3*j-2:3*j))); %fitness cuadrantes
            
        end
    end
    fitnes(f)=fitnes(f)+sum(sum(unic)); %%se suma todo el fitness   
end
if fitnes(fitnes==0)==0 %si el programa detecta que algun candidato
    %tiene fitness cero
   
    break %se detiene el programa
end
minfit=sort(fitnes); %vemos el minimo fitness
ind=find(fitnes<=minfit(N/2)); %indices de los mejores sudokus candidatos
indp=find(fitnes>=minfit(N/2)); %indices de los peores sudokus candidatos
ind=ind(1:N/2); %determina que los mejores son solo la mitad con menor fitness
perdedores=candidatos(:,:,indp); %los peores son la otra mitad
papas=candidatos(:,:,ind); %quedan como progenitores los mejores
for p=1:N/2 %damos un chance de que los perdedores tambi?n se reproduzcan
    prob=rand; 
    if prob>.95 %solo hay un 5% de probabilidad de que esto pase
        papas(:,:,p)=perdedores(:,:,p);
    end
end
candidatos(:,:,1:N/2)=papas;
for can=N/2+1:3*N/4 %aqui se crean a los hijos mezclando las filas de los papas
    candidatos(1:2:9,:,can)=papas(1:2:9,:,2*can-(N+1));
    candidatos(2:2:8,:,can)=papas(2:2:8,:,2*can-N); %y se guardan como candidatos para
    %la siguiente generaci?n
end
for can=3*N/4+1:N %aqui se crean a los hijos mezclando las columnas de los papas
    candidatos(:,1:2:9,can)=papas(:,1:2:9,2*can-3*N/2);
    candidatos(:,2:2:8,can)=papas(:,2:2:8,2*can-(3*N/2+1));%y se guardan como candidatos para
    %la siguiente generaci?n
end
for mut=1:25 %damos pie a una peque?a mutacion con el fin de que no se estanque
    casilla=randi(81*N);
   candidatos(casilla)=randi(9);
end
for candidato=1:N %respetamos los valores fijos
    cand=candidatos(:,:,candidato);
    cand(v)=ssudoku(v);
    candidatos(:,:,candidato)=cand;
end
minimo(generacion)=minfit(1); %observamos la evolucion del fitness
end
plot(minimo) %Ploteamos el fitness
drawSudoku(ssudoku) %mostramos el Sudoku ingresado
if find(fitnes==0)
    drawSudoku(candidatos(:,:,find(fitnes==0))) %Mostramos el Sudoku Final
else
    input('No se puede resolver')
end
toc %decimos cuanto duro el programa corriendo