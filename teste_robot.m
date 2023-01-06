clear all; close all; clc
%% Setup
myev3 = legoev3('usb'); %create the object with usb connection
mymotor1 = motor(myev3, 'A'); % Base
mymotor2 = motor(myev3, 'B'); % Ombro
mymotor3 = motor(myev3, 'C'); % Punho
mymotor4 = motor(myev3, 'D'); % Garra

% reset motors
mymotor1.resetRotation;
mymotor2.resetRotation;
mymotor3.resetRotation;
mymotor4.resetRotation;

% start motors
start(mymotor1);
start(mymotor2);
start(mymotor3);
start(mymotor4);

%% Joints
% Create a serial link object for the arm
L1 = Revolute('d',0.13,'alpha',-pi/2); 
L2 = Revolute('a', -0.19);
L3 = Revolute('alpha',-pi/2); 
robot = SerialLink([L1 L2 L3], 'name', 'EV3 Robot');
%'qlim',[deg2rad(-350) deg2rad(5)]
m_endeffector = SE3(-0.02,0,0.12);
robot.tool = m_endeffector;
%% Home Coordinates
base = readRotation(mymotor1); % Read rotation counter in degrees
elbow = readRotation(mymotor2); % Read rotation counter in degrees
wrist = readRotation(mymotor3); % Read rotation counter in degrees
% base = -441;
% elbow = -107;
% wrist = 389;
T1 = robot.fkine(deg2rad(double([base,elbow,wrist])));
%% Position Coordinates
base  = -300;
elbow =  0;
wrist =  0;
T2 = robot.fkine(deg2rad(double([base,elbow,wrist])));
%% Movement to Position
timeStep = [0:0.05:10]';
Ts_1 = ctraj(T1, T2, length(timeStep));
qc1 = robot.ikunc(Ts_1)
% plot(robot,qc1)
%% Movimento do robot
lastMotor1 = 0;
lastMotor2 = 0;
lastMotor3 = 0;

for i=1:200
%     % Elbow
%     trajElbow = qc1(i,2);
%     elbowAngle = rad2deg(trajElbow);
%     speedMotor2 = (elbowAngle - lastMotor2)/0.05; % Calculate the real speed in d/s
%     mymotor2.Speed = speedMotor2;
%     % Wrist
%     trajWrist = qc1(i,3);
%     wristAngle = rad2deg(trajWrist);
%     speedMotor3 = (wristAngle - lastMotor3)/0.05; % Calculate the real speed in d/s
%     mymotor3.Speed = speedMotor3;
%     lastMotor3 = wristAngle; % record last position
    
    % Base
    trajBase = qc1(i,1);
    baseAngle = rad2deg(trajBase);
    speedMotor1 = (baseAngle - lastMotor1)/0.05; % Calculate the real speed in d/s
    mymotor1.Speed = speedMotor1;
    
    % update last value
   lastMotor1 = baseAngle; % record last position
%     lastMotor2 = elbowAngle ; % record last position
end

% Create a table with the data and variable names
elbow = table(lastMotor2,'VariableNames', {'Base'} );
% Write data to text file
writetable(elbow, 'MyFile.txt')


% Reset values
lastMotor1 = 0;
lastMotor2 = 0;
lastMotor3 = 0;

%% Movement to Home
% timeStep = [0:0.05:10]';
% Ts_2 = ctraj(T2, T1, length(timeStep));
% qc2 = robot.ikunc(Ts_2);
% plot(robot,qc2)
% 
% for i=1:200
%     
% %     % Motor 2
% %     trajElbow = qc2(i,2);
% %     elbowAngle = rad2deg(trajElbow);
% %     speedMotor2 = (trajElbow - lastMotor2)/0.05; % Calculate the real speed in d/s
% %     myMotor2.Speed = speedMotor2;
% %     lastMotor2 = elbowAngle ; % record last position
% %     
% %     
% %     % Motor 3
% %     trajWrist = qc2(i,3);
% %     wristAngle = rad2deg(trajWrist);
% %     speedMotor3 = (trajWrist - lastMotor3)/0.05; % Calculate the real speed in d/s
% %     myMotor3.Speed = speedMotor3;
% %     lastMotor3 = wristAngle; % record last position
% %     
%     % Motor 1
%     trajBase = qc2(i,1);
%     baseAngle = rad2deg(trajBase);
%     speedMotor1 = (trajBase - lastMotor1)/0.05; % Calculate the real speed in d/s
%     mymotor1.Speed = speedMotor1;
%     lastMotor1 = baseAngle; % record last position
% end

stop(mymotor1);
stop(mymotor2);
stop(mymotor3);
