clear all; close all; clc
%% Setup
myev3 = legoev3('usb'); %create the object with usb connection
mymotor1 = motor(myev3, 'A'); % Base
mymotor2 = motor(myev3, 'B'); % Ombro
mymotor3 = motor(myev3, 'C'); % Punho
mymotor4 = motor(myev3, 'D'); % Garra

% start motors
start(mymotor1);
start(mymotor2);
start(mymotor3);
start(mymotor4);

for i=1:1
    j1 = readRotation(mymotor1) % Read rotation counter in degrees
    j2 = readRotation(mymotor2) % Read rotation counter in degrees
    j3 = readRotation(mymotor3) % Read rotation counter in degrees
    j4 = readRotation(mymotor4) % Read rotation counter in degrees
end