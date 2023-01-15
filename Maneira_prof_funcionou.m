clear all; close all; clc

%% Setup
myev3 = legoev3('usb'); %create the object with usb connection
mymotor1 = motor(myev3, 'A'); % Base
@ -6,116 +7,124 @@ mymotor2 = motor(myev3, 'B'); % Ombro
mymotor3 = motor(myev3, 'C'); % Punho
mymotor4 = motor(myev3, 'D'); % Garra

% reset motors
mymotor1.resetRotation;
mymotor2.resetRotation;
mymotor3.resetRotation;
mymotor4.resetRotation;

% start motors
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
L1 = Revolute('d',0.13,'alpha',-pi/2); 
L2 = Revolute('a', -0.19);
L3 = Revolute('alpha',-pi/2); 
L1 = Revolute('d',0.13,'alpha',-pi/2,'qlim', deg2rad([-180 10])); 
L2 = Revolute('a', -0.19,'qlim', deg2rad([-180 0]));
L3 = Revolute('alpha',-pi/2,'qlim', deg2rad([-180 0])); 
robot = SerialLink([L1 L2 L3], 'name', 'EV3 Robot');
%'qlim',[deg2rad(-350) deg2rad(5)]

%% End Effector
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
%% Movement to Final Position
timeStep = [0:0.004:20]';
qc1 = jtraj([0,0,0], [deg2rad(-90),deg2rad(0),deg2rad(0)], length(timeStep));
%qc2 = jtraj([deg2rad(-90),deg2rad(0),deg2rad(0)], [0,0,0], length(timeStep));
%disp(rad2deg(qc2))
% plot(robot,qc1);
% plot(robot,qc2);
%% Declaring variables
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
%% Robot movement
% Base
  % Motor da base
    % -180 -> -300 (angulo que representa 180 graus no cartesiano)
    % inputAngle ->  x
% inputAngle = -((-170 * -300 ) / -180)/-40;
pause(1);
for i=1:5000    
    trajBase = qc1(i,1); % read the position in radians
    baseAngle =  rad2deg(trajBase); % convert to degrees
    speedMotor1 = (baseAngle - lastMotor1)/0.004; % calculate the real speed in d/s
    mymotor1.Speed = speedMotor1; % activate the motor with the calculated speed
    % update previous value
    lastMotor1 = baseAngle; % record last position
end
pause(1);
%  for i=1:5000    
%     trajBase = qc2(i,1); % read the position in radians
%     baseAngle =  rad2deg(trajBase); % convert to degrees
%     speedMotor1 = (baseAngle - lastMotor1)/0.004; % calculate the real speed in d/s
%     mymotor1.Speed = speedMotor1; % activate the motor with the calculated speed
%     % update previous value
%     lastMotor1 = baseAngle; % record last position
% end 
%  
%  for i=1:20    
%     mymotor2.Speed = -80;% activate the motor with the calculated speed
%     if readRotation(mymotor2) <= -30
%           mymotor2.Speed = -30; 
%     end
%  end
 
%  % Base
% for i=1:40   
%     trajBase = qc2(i,1); % read the position in radians
%     baseAngle = rad2deg(trajBase); % convert to degrees
%     speedMotor1 = (baseAngle - lastMotor1)/0.5; % calculate the real speed in d/s
%     mymotor1.Speed = speedMotor1; % activate the motor with the calculated speed
%     % update previous value
%     lastMotor1 = readRotation(mymotor1); % record last position
%     disp(readRotation(mymotor1))
%  end 
%  for i=1:20    
%     mymotor2.Speed = 80;% activate the motor with the calculated speed
%     if readRotation(mymotor2) <= 30
%           mymotor2.Speed = 30; 
%     end
%  end
%     trajWrist = qc1(i,3); % read the position in radians
%     wristAngle = rad2deg(trajWrist); % convert to degrees
%     speedMotor3 = (wristAngle - lastMotor3)/0.05; % calculate the real speed in d/s
%     mymotor3.Speed = speedMotor3; % activate the motor with the calculated speed
%    % update previous value
%     lastMotor3 =  mymotor3.readRotation; % record last position

% Create a table with the data and variable names
elbow = table(lastMotor2,'VariableNames', {'Base'} );
% Write data to text file
writetable(elbow, 'MyFile.txt')

% for i=1:200    
%     trajBase = qc2(i,2); % read the position in radians
%     baseAngle = rad2deg(trajBase); % convert to degrees
%     speedMotor1 = (baseAngle - lastMotor1)/0.05; % calculate the real speed in d/s
%     mymotor1.Speed = speedMotor1; % activate the motor with the calculated speed
%     % update previous value
%     lastMotor1 = baseAngle; % record last position
%     
%     trajElbow = qc2(i,2); % read the position in radians
%     elbowAngle = rad2deg(trajElbow); % convert to degrees
%     speedMotor2 = (elbowAngle - lastMotor2)/0.05; % calculate the real speed in d/s
%     mymotor2.Speed = speedMotor2; % activate the motor with the calculated speed
%    % update previous value
%     lastMotor2 = elbowAngle; % record last position
% end

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
% % Elbow
% for i=1:200 
%     trajElbow = qc1(i,2); % read the position in radians
%     elbowAngle = rad2deg(trajElbow); % convert to degrees
%     speedMotor2 = (elbowAngle - lastMotor2)/0.05; % calculate the real speed in d/s
%     mymotor2.Speed = speedMotor2; % activate the motor with the calculated speed
%     % update previous value
%     lastMotor2 = elbowAngle; % record last position
% end

stop(mymotor1);
stop(mymotor2);
stop(mymotor3);
% % Stop the robot / End execution
% stop(mymotor1);
% stop(mymotor2);
% stop(mymotor3);
