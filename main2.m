clear all; close all; clc
%% Setup
myev3 = legoev3('usb'); %create the object with usb connection
% Motors
mymotor1 = motor(myev3, 'D');   % Base
mymotor2 = motor(myev3, 'C');   % Elbow
mymotor3 = motor(myev3, 'B');   % Wrist
mymotor4 = motor(myev3, 'A');   % Claw
% Touch Sensors
mytouch1 = touchSensor(myev3,1); % Wrist  
mytouch2 = touchSensor(myev3,2); % Base
mytouch3 = touchSensor(myev3,3); % Elbow

%% Start motors
start(mymotor1);
start(mymotor2);
start(mymotor3);
start(mymotor4);

%% Home Sequence
homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3);

%% Reset Robot
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

%% Camera
[x , y] = imThreshold_traj();

%% 3 Simple Rule
% 30cm - 90 graus
% X - ?
% valorCm = resposta da conta anterior
valorAngle = (x *90)/30
% -90 - 350
% valorCm - x
% x é a resposta
lastMotor1 = 0;
respAngle = (valorAngle*350)/-90;
respAngle = -respAngle/200

%% Movement to Final Position
timeStep = [0:0.05:10]';
qc1 = jtraj([0,0,0], [deg2rad(-valorAngle),deg2rad(0),deg2rad(5)], length(timeStep));
disp(rad2deg(qc1))

for i=1:200
        trajWrist = qc1(i,3); % read the position in radians
        wristAngle =  rad2deg(trajWrist); % convert to degrees
        if  lastMotor1 > (wristAngle - respAngle)
                        disp('.')
            mymotor1.Speed = -20; % activate the motor with the calculated speed
            
        elseif trajWrist == respAngle
            mymotor1.Speed = 0; % activate the motor with the calculated speed
        end
        lastMotor1 = wristAngle;
end
    
% %% Robot Movements
% for i=1:1
%     switch pos
%         case 1
%             position1(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3);
%             % Elbow
%             while 1
%                 %{ 
%                     Since the movement is negative, the motor speed is negative as well
%                     Stop the motor when the position has been reached.
%                     Start it again so it can be used in the next movement.
%                 %}
%                 if readRotation(mymotor2) > -300
%                     readRotation(mymotor2)
%                     mymotor2.Speed = -70; % activate the motor with the calculated speed
%                 else
%                     mymotor2.Speed = 0; % activate the motor with the calculated speed
%                     break;
%                 end
%             end
%             pause(2);
%             %homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); 
%             pos = 3;
% 
%         case 2
%             position2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3);
%             pause(1);
%             % Elbow
%             while 1
%                 %{ 
%                     Since the movement is negative, the motor speed is negative as well
%                     Stop the motor when the position has been reached.
%                     Start it again so it can be used in the next movement.
%                 %}
%                 if readRotation(mymotor2) > baseAngle
%                     readRotation(mymotor2)
%                     mymotor2.Speed = -80; % activate the motor with the calculated speed
%                 else
%                     mymotor2.Speed = 0; % activate the motor with the calculated speed
%                     break;
%                 end
%             end
%             pause(1);
%             dropOnBox2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch1,mytouch2,mytouch3);
%             homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); 
%         case 3 
%             dropOnBox(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3);
%             % Wrist
%             while readTouch(mytouch1) == 0
%                 readRotation(mymotor3)
%                 mymotor3.Speed = -20; % activate the motor with the calculated speed
%                 if readRotation(mymotor3) > 20
%                     mymotor3.Speed = -10; % activate the motor with the calculated speed
%                 end
%             end
%             homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); 
%     end
% end
