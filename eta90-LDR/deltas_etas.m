%% Plot etas
D='C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Aerosols Chamber\PMT';

n = input('Número de pruebas hechas calibración: ');

importfile2('eta_0');
importfile2('eta_90');
eta90=cell([1,n]);

figure(7)
refl=tiledlayout(1,3);
for k=1:n
    t1=linspace(0,90,length(eta_0{1,k}));
    t2=linspace(0,90,length(eta_90{1,k}));
    dim=min(length(eta_0{1,k}),length(eta_90{1,k}));
    
    eta90{1,k}=sqrt(eta_0{1,k}(1:dim).*eta_90{1,k}(1:dim)); % Cálculo eta delta 90
        
    tiny= abs((eta90{1,k})*1e02)<1;      % Evita divisiones cercanas a 0
    eta90{1,k}(tiny)=[];
    
    t3=linspace(0,90,length(eta90{1,k}));
    means=mean(eta90{1,k})*ones([1,length(t3)]);
    
    nexttile
    plot(t1,eta_0{1,k})
    hold on
    plot(t2,eta_90{1,k})
    hold on
    plot(t3,eta90{1,k})
    hold on
    plot(t3,means)
    legend('\eta^*(0°)','\eta^*(90°)','\eta_{\Delta90}','Mean \eta_{\Delta90}','NumColumns',2)
%     title(sprintf('Prueba %d',k))
    xlim([0 90])
    xlabel('[s]')
end
title(refl,'Calibration factor');
save('eta90','eta90');

%% Plot delta final
D='C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Aerosols Chamber\PMT';

n2 = input('Número de prubas tomadas de aerosoles: ');

disp('Seleccione:');
disp('1. Aerosoles secos');
disp('2. Aerosoles con humedad:')
cases=input('-> ');

switch cases
    case 1
        importfile2('delta_aerosoles_seco');
        a=delta_aerosoles_seco;
    case 2
        importfile2('delta_humedad');
        a=delta_humedad;
end

len=50000;
for k=1:n
    len=min(len,length(eta90{1,k}));
end

eta90=mean(cat(3,eta90{1,1}(1:len),eta90{1,2}(1:len),eta90{1,3}(1:len)),3);
delta_m=0.0034; R=5.8;

figure(8)
dv=tiledlayout(2,4);
for k=1:n2 
    nexttile
    dim=min(length(eta90),length(a{1,k}));
    delta_v=a{1,k}(1:dim)./ eta90(1:dim);    % Cálculo delta v
    
    prom=mean(delta_v)*ones([dim,1]);
    t=linspace(0,90,dim);
    
    % Cálculo delta de partículas
    
    delta_p=((1+delta_m)*R*mean(delta_v)-(1+mean(delta_v))*delta_m)./ ...
        ((1+delta_m)*R-(1+mean(delta_v)))
    
    plot(t,delta_v)
    hold on
    plot(t,prom)
    title(sprintf('Prueba %d',k))
    legend('\delta_{v}','Mean \delta_{v}')
    xlabel('[s]')
    xlim([0 90])
end
title(dv,'\delta_{v}')
