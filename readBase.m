


clear all; close all; clc
%% Setup
myev3 = legoev3('usb'); %create the object with usb connection
mymotor1 = motor(myev3, 'D');   % Base
mymotor2 = motor(myev3, 'C');   % Elbow
mymotor3 = motor(myev3, 'B');   % Wrist
mymotor4 = motor(myev3, 'A');   % Claw
mytouch = touchSensor(myev3,3);


% start motors
start(mymotor1);
start(mymotor2);
start(mymotor3);
start(mymotor4);

% motors
% mymotor1.resetRotation;
% mymotor2.resetRotation;
mymotor3.resetRotation;
% mymotor4.resetRotation;

while 1
%         readTouch(mytouch)
%    j1 = readRotation(mymotor1) % Read rotation counter in degrees
%    j2 = readRotation(mymotor2) % Read rotation counter in degrees
   j3 = readRotation(mymotor3) % Read rotation counter in degrees
%    j4 = readRotation(mymotor4) % Read rotation counter in degrees
end