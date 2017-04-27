clc; clear all; close all; clf;
cputime=0;
tic;
%%%%%%%%%%%%
ln=1;
%%%%%%%%%%%%
i=sqrt(-1);
s=-1;
alpha=0;
alph=alpha/(4.343); %Ref page#55 eqn 2.5.3
g=0.003; %fiber non linearity in /W/m
N=1; %soliton order
to=125e-12; %initial pulse width in second
pi=3.1415926535;
Po=0.00064; %input pwr in watts
Ao=sqrt(Po); %Amplitude
Ld=(N^2)/(g*Po);%dispersion length for corresponding soliton order
b2=-(to)^2/Ld; %2nd order disp. (s2/m)
tau =- 4096e-12:1e-12: 4095e-12;%  dt=t/to
 dt=1e-12/to;
 h1=1000;% step size
for ii=0.1:0.1:1.0
z=ii*Ld;
 u=N*sech(tau/to);%fundamental soliton pulse
    figure(1)
   plot(abs(u),'r');
grid on;
hold on;
h=h1/Ld;%soliton conditions
Z=z/Ld;%soliton conditions
l=max(size(u));  
%%%%%%%%%%%%%%%%%%%%%%%
fwhm1=find(abs(u)>abs(max(u)/2));
fwhm1=length(fwhm1);
spectrum=fft(fftshift(u)); %Pulse spectrum
dw=(1/l)/dt*2*pi;
w=(-1*l/2:1:l/2-1)*dw;
 w=fftshift(w);
d=0;
for jj=h:h:Z
spectrum=spectrum.*exp(-alph*(h/2)+i*s/2*w.^2*(h/2)) ; 
f=ifft(spectrum);
f=f.*exp(i*(N^2)*((abs(f)).^2)*(h));
% f=fftshift(f);
spectrum=fft(f);
spectrum=spectrum.*exp(-alph*(h/2)+i*s/2*w.^2*(h/2)) ; 
d=d+1;
end
f=ifft(spectrum);
f=fftshift(f);
op_pulse(ln,:)=abs(f);%saving output pulse at all intervals
fwhm=find(abs(f)>abs(max(f)/2));
fwhm=length(fwhm);
ratio=fwhm/fwhm1 %PBR at every value
pbratio(ln)=ratio;%saving PBR at every step size
dd=atand((abs(imag(f)))/(abs(real(f))));
phadisp(ln)=dd;%saving pulse phase
ln=ln+1;
end
toc;
cputime=toc;
% figure(2);
% mesh(op_pulse(1:1:ln-1,:));
% figure(3)
% plot(pbratio(1:1:ln-1),'k');
% xlabel('Number of steps');
% ylabel('Pulse broadening ratio');
% grid on;
% hold on;
% figure(4)
% plot(phadisp(1:1:ln-1),'k');
% xlabel('distance travelled');
% ylabel('phase change');
% grid on;
% hold on;
% disp('CPU time:'), disp(cputime);
%%
x1 = -60e-6;  
x2 = 60e-6;                         % Coordenada Final
num_samples = 101;                  % Numero de muestras (par)
dx = (x2-x1)/num_samples;           % Espaciado de las muestras en x
dy = 1e-6;                          % Incremento en y
x = linspace (x1, x2-dx, num_samples);     % Dominio espacial
W0 = 8e-6;                          % Radio de la cintura del pulso
n_index = ones(1,num_samples);      % Indice de refraccion del medio
nmax = 1;                           % Indice de refraccion maximo
nmin = 1;                           % Indice de refraccion minimo
n_bar = (nmax+nmin)/2;              % Indice Promedio
lambda = 0.8e-6;                    % Longitud de onda
k0 = 2*pi/lambda;                   % Numero de onda

% ---------- Generacion del pulso -----------------
modo = exp (-(x/W0).^2);          % Pulso Gaussiano

k = k0.*n_index;                     % Vector de onda
k_bar = k.*n_bar;                    % Numero de onda de referencia

% ------ Generamos la reticula para graficar ------ 
[xx,yy] = meshgrid ([x1:dx:x2-dx],[dy:dy:1000e-6]);
zz = zeros(size(xx));
h = dy;
ro = dy/(dx^2);
A = j./(2.*k_bar);
B = j.*(k.^2-k_bar.^2)./(2.*k_bar);
a = -ro.*A;    
b = 2*(1+ro.*A)-h.*B;
c = a;
d = zeros(1,num_samples);
matrix = zeros(num_samples);
% --------- Generacion de la matriz tridiagonal ---------
for m = 1:1:num_samples,
    if ((m>1) && (m<num_samples))
        matrix(m,m-1) = a(m);
        matrix(m,m) = b(m);
        matrix(m,m+1) = c(m);
    else
        matrix(1,1) = b(1);
        matrix(1,2) = c(1);
        matrix(num_samples,num_samples-1) = a(num_samples);
        matrix(num_samples,num_samples) = b(num_samples);
    end
end   
% --------- Ciclo Principal de Propagacion ---------  
for n = 1:1:1000,
    for m = 1:1:num_samples,
        if ((m>1) && (m<num_samples))
            d(m) = (2*(1-ro*A(m))+h*B(m))*modo(m)+ro*A(m)*(modo(m-1)+modo(m+1));
        else
            d(1) = (2*(1-ro*A(1))+h*B(1))*modo(1)+ro*A(1)*(modo(2));
            d(num_samples) = (2*(1-ro*A(num_samples))+h*B(num_samples))*modo(num_samples)+ro*A(num_samples)*(modo(num_samples-1));
        end
    end
    modo = matrix\d.';
    zz(n,:) = [abs(modo.')];        % Generamos la matriz para graficar
end

% -- Graficamos la magnitud de nuestros pulsos propagados --
surf(xx,yy,zz);
shading interp;
colormap jet;
grid on;
title('Magnitud de los Pulsos Gaussianos Propagados');
%%
N = 512000;                 % Number of Fourier mode
dt = .001;                  % Time step
tfinal = 10;                % Final time
M = round(tfinal./dt);      % Total number of time steps
L = 500;                    % Total space length
h = L/N;                    % Space step
n =( -N/2:1:N/2-1)';        % Indices
x = n*h;                    % Grid points
u = exp(-(x/2).^2);         %Intial pulse
k = 2*n*pi/L;               % wavenumber values.
epsilon = 50;               % nonlinear coefficient
for m = 1:1:M               % Start time loop
    plot(x, abs(u), 'o');
    axis([-10 10 0 max(abs(u))]);
    pause(0.05);

    % Here are split step steps.
    u = exp(dt*1i* epsilon *(abs(u).^2)).*u; % Propagate non-linear part of NLSE
    c = fftshift(fft(u));                % Take Fourier transform
    c = exp(-dt*1i*k.^2 ).*c;            % Advance in Fourier space
    u = ifft(fftshift(c));               % Fourier transform back to Physical Space
end
%%
dx=0.1;
xmin = -8;
xmax = +8;
ymin = -2;
ymax = +20;
x=(xmin+dx:dx:xmax)'; 

k = dx^3;
nsteps = 0.5/k; 
mesh2d = [];

u = -12 * sech(x).^2;

for ii = 1:nsteps
k1 = k * kdvequ(u,dx);
k2 = k * kdvequ(u+k1/2,dx);
k3 = k * kdvequ(u+k2/2,dx);
k4 = k * kdvequ(u+k3,dx);
u = u + k1/6 + k2/3 + k3/3 + k4/6;
mesh2d(ii,:) = -u;

if mod(ii,10) == 0
plot(x,-u,'b-','LineWidth',2);
axis([xmin,xmax,ymin,ymax])
drawnow; 
end
end

function dudt=kdvequ(u,dx) 
u = [u(end-1:end); u; u(1:2)];
dudt = 6*(u(3:end-2)).*(u(4:end-1)-u(2:end-3))/(2*dx) - (u(5:end)-2*u(4:end-1)+2*u(2:end-3)-u(1:end-4))/(2*dx^3);
end
%%
A = [1 2 3]'; V = [1 2 0]'; x0 = A*0; phi0 = A*0;
q = 1; I = sqrt(-1); N=length(A);
lambda = (A + I*V/sqrt(2)); Mlambda = lambda*ones(1,N);
denominador = ( Mlambda + Mlambda' );
X=-20:0.1:20; NX = length(X); T=-20:20; NT = length(T);
M=zeros(N,N); b=ones(N,1); u=zeros(NX,NT);
for it=1:NT, t=T(it);
for ix=1:NX, x=X(ix);
%gamma = (exp(-x.^2));
gamma = (sech(x));
M = ( 1./gamma + gamma' )./denominador;
u(ix,it) = sum(M\b);
end
end
u = 1/sqrt(q)*u;
figure(1); mesh(X,T,abs(u)')
figure(2); contour(X,T,abs(u'),30)
figure(3); mesh(X,T,log(abs(u)'))