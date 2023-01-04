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
%% Joints
% Create a serial link object for the arm
L1 = Revolute('d',0.11,'alpha',pi/2); 
L2 = Revolute('a', -0.18,'alpha',-pi/2);
L3 = Revolute('d',0.18,'alpha',-pi/2); 
robot = SerialLink([L1 L2 L3], 'name', 'EV3 Robot');
%% Position
base = readRotation(mymotor1); % Read rotation counter in degrees
elbow = readRotation(mymotor2); % Read rotation counter in degrees
wrist = readRotation(mymotor3); % Read rotation counter in degrees
% base = -441;
% elbow = -107;
% wrist = 389;
T1 = SE3(base,elbow,wrist);
%% Home Coordinates
base =  -184;
elbow = -152;
wrist = 213;
T2 = SE3(base,elbow,wrist); % home position
%% Movement
timeStep = [0:0.05:10]';
Ts_1 = ctraj(T1, T2, length(timeStep));
qc = robot.ikine(Ts_1)
%% Movimento do robot
lastR1 = 0;
lastR2 = 0;
flagStop = 0;

for i=1:200
%   base = readRotation(mymotor1); % Read rotation counter in degrees
    % motor speed
    traj1 = qc(i,1);
    jointAngle = rad2deg(traj1);
    speed1 = (jointAngle - lastR1)/0.05; % Calculate the real speed in d/s
    mymotor1.Speed = speed1;
    lastR1 = jointAngle; 
    pause(0.05); % Wait for next sampling period
end
stop(mymotor1);
stop(mymotor2);
stop(mymotor3);
