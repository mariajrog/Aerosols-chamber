%% CONFIGFGEN Code for communicating with an instrument.
%
%   This is the machine generated representation of an instrument control
%   session. The instrument control session comprises all the steps you are
%   likely to take when communicating with your instrument. These steps are:
%   
%       1. Instrument Connection
%       2. Instrument Configuration and Control
%       3. Disconnect and Clean Up
% 
%   To run the instrument control session, type the name of the file,
%   configFgen, at the MATLAB command prompt.
% 
%   The file, CONFIGFGEN.M must be on your MATLAB PATH. For additional information 
%   on setting your MATLAB PATH, type 'help addpath' at the MATLAB command 
%   prompt.
% 
%   Example:
%       configfgen;
% 
%   See also SERIAL, GPIB, TCPIP, UDP, VISA, BLUETOOTH, I2C, SPI.
% 
%   Creation time: 01-Nov-2019 15:15:06

% This script was tested with a TBS 1102B-EDU. To connect another device
% change the id in obj1 = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0368::C032873::0::INSTR', 'Tag', '');

%% Instrument Connection

% Find a VISA-USB object.
obj1 = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0368::C032873::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = visa('NI', 'USB0::0x0699::0x0368::C032873::0::INSTR');
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
fprintf(obj1, ':FREQUENCY 500');

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

% The following code has been automatically generated to ensure that any
% object manipulated in TMTOOL has been properly disposed when executed
% as part of a function or script.

% Clean up all objects.
delete(obj1);
clear obj1;

