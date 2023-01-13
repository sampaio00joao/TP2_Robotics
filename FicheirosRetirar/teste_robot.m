clear all; close all; clc

%% Setup
myev3 = legoev3('usb'); %create the object with usb connection
mymotor1 = motor(myev3, 'A'); % Base
mymotor2 = motor(myev3, 'B'); % Ombro
mymotor3 = motor(myev3, 'C'); % Punho
mymotor4 = motor(myev3, 'D'); % Garra

%% Start motors
start(mymotor1);
start(mymotor2);
start(mymotor3);
start(mymotor4);

%% Reset motors
mymotor1.resetRotation;
mymotor2.resetRotation;
mymotor3.resetRotation;
mymotor4.resetRotation;

%% Joints
% Create a serial link object for the arm
L1 = Revolute('d',0.13,'alpha',-pi/2,'qlim', deg2rad([-180 10])); 
L2 = Revolute('a', -0.19,'qlim', deg2rad([-180 0]));
L3 = Revolute('alpha',-pi/2,'qlim', deg2rad([-180 0])); 
robot = SerialLink([L1 L2 L3], 'name', 'EV3 Robot');

%% End Effector
m_endeffector = SE3(-0.02,0,0.12);
robot.tool = m_endeffector;
%% Movement to Final Position
timeStep = [0:0.005:10]';
qc1 = jtraj([0,0,0], [deg2rad(-45),deg2rad(0),deg2rad(5)], length(timeStep));
qc2 = jtraj([deg2rad(-45),deg2rad(0),deg2rad(5)], [deg2rad(-90),deg2rad(0),deg2rad(10)], length(timeStep));
% go back
% qc3 = jtraj([deg2rad(-90),deg2rad(0),deg2rad(0)], [deg2rad(-45),deg2rad(0),deg2rad(0)], length(timeStep));
% qc4 = jtraj([deg2rad(-45),deg2rad(0),deg2rad(0)], [0,0,0], length(timeStep));
disp(rad2deg(qc1))
disp(rad2deg(qc2));
% plot(robot,qc1);
% plot(robot,qc1);
% plot(robot,qc2);
% plot(robot,qc3);
% plot(robot,qc4);
%% Declaring variables
lastMotor1 = 0;
% lastMotor2 = 0;
lastMotor3 = 0;
%% Robot movement
% Base Front
for i=1:2000    
    trajBase = qc1(i,1); % read the position in radians
    baseAngle =  rad2deg(trajBase); % convert to degrees
    speedMotor1 = (baseAngle - lastMotor1)/0.005; % calculate the real speed in d/s
    mymotor1.Speed = speedMotor1; % activate the motor with the calculated speed
    % update previous value
    lastMotor1 = baseAngle; % record last position
end
% Base Front next
for i=1:2000    
    trajBase = qc2(i,1); % read the position in radians
    baseAngle =  rad2deg(trajBase); % convert to degrees
    speedMotor1 = (baseAngle - lastMotor1)/0.005; % calculate the real speed in d/s
    mymotor1.Speed = speedMotor1; % activate the motor with the calculated speed
    % update previous value
    lastMotor1 = baseAngle; % record last position
end

% Wrist Front
for i=1:2000  
    trajWrist = qc1(i,3); % read the position in radians
    wristAngle =  rad2deg(trajWrist); % convert to degrees
    speedMotor3 = (wristAngle - lastMotor3)/0.005; % calculate the real speed in d/s
    mymotor3.Speed = speedMotor3+2; % activate the motor with the calculated speed
    % update previous value
    lastMotor3 = wristAngle; % record last position
end
% Wrist Front next
for i=1:2000  
    trajWrist = qc2(i,3); % read the position in radians
    wristAngle =  rad2deg(trajWrist); % convert to degrees
    speedMotor3 = (wristAngle - lastMotor3)/0.005; % calculate the real speed in d/s
    mymotor3.Speed = speedMotor3+2; % activate the motor with the calculated speed
    % update previous value
    lastMotor3 = wristAngle; % record last position
end

% % Stop the robot / End execution
% stop(mymotor1);
% stop(mymotor2);
% stop(mymotor3);

