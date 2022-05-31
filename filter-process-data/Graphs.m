clc
clear all
D = 'C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Aerosols Chamber\PMT\Ensayo';
F=input('Fecha de pruebas: ');
A = input('Nombre de la carpeta: ');  % El nombre que se ingrese debe ser entre comillas

t=linspace(0,90,50000);              % Tiempo de muestreo
n = input('Número de pruebas hechas: '); % Número de archivos
CH1_filt=cell([n,20]);  % Se inician en 0 para agilizar el código
CH2_filt=cell([n,20]);

for k=1:n
    addpath(fullfile(D,F,A,sprintf('Category%d',k)));

    for i=1:20
        myfilename = sprintf('_%d.xls',i);
        datos = importdata(myfilename);  
        [CH1_filt{k,i},CH2_filt{k,i}]=fftfilter(datos.data(:,2),datos.data(:,3));   %Se filtran las señales importadas: CH1 (señal transmitida), CH2 (señal reflejada)
                                                                                    % En cada fila se guarda cada archivo de prueba: fila 1: Category1     
    end
end
ch1_join=cell([1,n]);
ch2_join=cell([1,n]);
for k=1:n
    ch1_join{1,k}=reshape(cell2mat(CH1_filt(k,1:end)),[],1);    % Se crea una celda donde cada elemento contiene ...
                                                                % la señal de una prueba completa
    ch2_join{1,k}=reshape(cell2mat(CH2_filt(k,1:end)),[],1);
end

% Se guarda la señal de ruido de fondo
if strcmp(A,'Ruido de fondo')||strcmp(A,'Ruido de fondo_con nylon')
    disp('Guardando señal de ruido')
    ch1=mean(cat(3,ch1_join{:}),3); % Se saca el promedio de las señales de ruido de todas las pruebas
    ch2=mean(cat(3,ch2_join{:}),3);
    save('CH1_'+(string(A)),'ch1'); % Se guardan la señal promedio filtrada
    save('CH2_'+(string(A)),'ch2');
end

% Se resta la señal de ruido de fondo para el cálculo del delta*
if strcmp(A,'aerosoles_seco')||strcmp(A,'humedad')
    disp('Restando ruido')
    importfile('CH1_Ruido de fondo.mat')
    importfile('CH2_Ruido de fondo.mat')
    for k=1:n
        ch1_join{1,k}=ch1_join{1,k}-ruido_ch1;
        ch2_join{1,k}=ch2_join{1,k}-ruido_ch2;
    end
end
    
figure(1)
tiledlayout(2,4)
for k=1:n
    nexttile
    plot(t,abs(ch1_join{1,k}))
    hold on
    plot(t,abs(ch2_join{1,k}))
    legend({'Reflected','Transmitted'},'Location','east')
    title(sprintf('Prueba %d',k))
    xlim([0 90])
    xlabel('[s]')
    ylabel('[V]')
end
pause(5)
exportgraphics(gcf,'señales_'+string(A)+'.eps');
pause(10)
movefile('señales_'+string(A)+'.eps',fullfile(D,F,A));

%% Cálculo de eta y delta*=reflejada(CH1)/transmitida(CH2)
if strcmp(A,'aerosoles_seco')||strcmp(A,'humedad')
    delta=cell([1,n]);
else
    eta=cell([1,n]);
end
eta_values=zeros(1,n);

%Calcula eta
for k=1:n
    tiny= abs((ch2_join{1,k})*1e03)<1;    % Se evitan divisiones cercanas a 0
    ch1_join{1,k}(tiny)=[];
    ch2_join{1,k}(tiny)=[];
    
    if strcmp(A,'aerosoles_seco')||strcmp(A,'humedad')
    	delta{1,k}=ch1_join{1,k}./ch2_join{1,k};   % Señal Reflejada(CH1)/transmitida(CH2)
        neg= delta{1,k}<0;
        delta{1,k}(neg)=[];
        eta_values(1,k)=mean(delta{1,k})
    else
        eta{1,k}=ch1_join{1,k}./ch2_join{1,k};   % Señal Reflejada(CH1)/transmitida(CH2)
        neg= eta{1,k}<0;
        eta{1,k}(neg)=[];
        eta_values(1,k)=mean(eta{1,k})
    end      
end
if strcmp(A,'aerosoles_seco')||strcmp(A,'humedad')
    save('delta_'+string(A),'delta');
    a=delta;
else
    save('eta_'+string(A),'eta');
    a=eta;
end

figure(2)
de=tiledlayout(2,4);
for k=1:n
    t2=linspace(0,90,length(a{1,k}));
    means=eta_values(1,k)*ones([1,length(t2)]);
    
    nexttile
    plot(t2,a{1,k})
    hold on
    plot(t2,means)
    legend('delta '+string(A),'delta promedio')
    title(sprintf('Prueba %d',k))
    xlim([0 90])
    xlabel('[s]')
end
title(de,'delta húmedo')
disp('Saving plot');
exportgraphics(gcf,'eta'+string(A)+'.eps');
pause(10)
movefile('eta'+string(A)+'.eps',fullfile(D,F,A));


