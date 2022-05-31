% p

%clear all
close all
clc

%% Temperature plots

% plotTitle = 'Photomultipliers signals'; 
% xLabel = 'Time [s]';     
% ch1_yLabel = 'Voltage CH 1 [V]';  
% ch2_yLabel = 'Voltage CH 2 [V]';
% plotGrid = 'on';                
% delay = 0.1;    
% left_color = [1 0 0];
% right_color = [0 0 1];

%Define Function Variables
time = 0;
y1 = 0;
y2 = 0;
x1 = 0;
x2 = 0;
count = 0;

prompt = 'How many adquisitions do you want? ';
totalAdquisitions = input(prompt);

%% Configure oscilloscope

configFgen

%% Read waveform and save graph

%figPath = 'C:\Users\labfisica\Desktop\Daniela\OsciloscopeRead\Figures';
%figPath = 'C:\Users\labfisica\Documents\Manuela\PMT_waveforms\Figures';

%tablePath = 'C:\Users\labfisica\Desktop\Daniela\OsciloscopeRead\Waveform_data';
%tablePath = 'C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Aerosols Chamber\PMT\Ensayo';
 
D = 'C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Aerosols Chamber\PMT\Ensayo';
F = 'Mayo_25';
if (exist(fullfile(D,F,sprintf('Category%d',k)),'dir'))==7
    existence=1;
    return
else
    existence=0;
end
mkdir(fullfile(D,F,sprintf('Category%d',k)));
tablePath = fullfile(D,F,sprintf('Category%d',k));


for i = 1:totalAdquisitions
    
    time = char(datetime('now'));
    
    captureWaveform
    
    T = table(x1', y1',y2');
    
    T.Properties.VariableNames = {'Time' 'SignalCH1' 'SignalCH2'};
    
    %writetable(T, fullfile(tablePath, sprintf('_%s.xls', strrep(time, ':', '.'))))
    writetable(T, fullfile(tablePath, sprintf('_%d.xls',i)))
    
%     figure(i);
%     
%     fig = gcf;
%     fig.Name = time;
%     fig.Color = 'white';
%     fig.Units = 'normalized';
%     fig.OuterPosition = [0 0 1 1];
%     
%     set(gcf,'defaultAxesColorOrder',[left_color; right_color]);
%     
%     yyaxis left
%     channel1 = plot(x1, y1, '-r', 'LineWidth', 1.5);
%     ylim([min(y1) max(y1)*1.05])
%     xlabel(xLabel, 'FontSize', 15);
%     ylabel(ch1_yLabel, 'FontSize', 15);
%        
%     hold on
    
%     yyaxis right
%     ylabel(ch2_yLabel, 'FontSize', 15);
%     
%     channel2 = plot(x2, y2, '-b'); 
%     ylim([min(y2) max(y2)])
%     %xlabel(xLabel, 'FontSize', 15);
%     
%     ax = gca;
%     ax.FontSize = 12;
%     
%     title(sprintf('%s adquired at %s', plotTitle, time), 'FontSize', 15);
%     grid(plotGrid);
    
%     saveas(gcf, fullfile(figPath, sprintf('%s.png', strrep(time, ':', '..'))), 'png');
%     saveas(gcf, fullfile(figPath, sprintf('%s.svg', strrep(time, ':', '..'))), 'svg');
end

disp('Plot closed and Tektronix object has been deleted');
