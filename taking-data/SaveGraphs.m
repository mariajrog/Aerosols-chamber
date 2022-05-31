clear all
archivo='Número de archivo: ';
k=input(archivo);               % Número de archivo
OscilloscopeAdq  % Toma de datos
if existence==1    % Evita sobreescribir los archivos
    disp('Folder already exist');
    return
end

%Se importan los datos
n=totalAdquisitions; %Número de muestras
addpath(tablePath)
for i=1:n
    myfilename = sprintf('_%d.xls',i);
    datos = importdata(myfilename);  % Se crea una celda
    %datos{i}=myfile{1};      % Se saca la estructura 
    tiempo{i}=datos.data(:,1);   % Se importan 3 columnas: Tiempo, CH1 (señal transmitida), CH2 (señal reflejada)
    CH1{i}=datos.data(:,2);
    CH2{i}=datos.data(:,3);
end

%Grafica la señal recibida del osciloscopio filtrada
figure(1)
for i=1:n
    [CH1_filt{i},CH2_filt{i}]=fftfilter(CH1{i},CH2{i});
    plot(tiempo{i},CH1_filt{i})
    hold on
    plot(tiempo{i},CH2_filt{i})
    legend('trans','refle')
end
title('Señal filtrada')
%ylim([-8E-02 8E-02])
xlabel('[s]')
ylabel('[V]')
