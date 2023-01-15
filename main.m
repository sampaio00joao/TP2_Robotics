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

%% Camera
pos = imThreshold();

%% Robot Movements
for i=1:1
    switch pos
        case 1
            position1(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3);
            % Elbow
            while 1
                %{ 
                    Since the movement is negative, the motor speed is negative as well
                    Stop the motor when the position has been reached.
                    Start it again so it can be used in the next movement.
                %}
                if readRotation(mymotor2) > -300
                    readRotation(mymotor2)
                    mymotor2.Speed = -70; % activate the motor with the calculated speed
                else
                    mymotor2.Speed = 0; % activate the motor with the calculated speed
                    break;
                end
            end
            pause(2);
            %homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); 
            pos = 3;

        case 2
            position2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3);
            pause(1);
            % Elbow
            while 1
                %{ 
                    Since the movement is negative, the motor speed is negative as well
                    Stop the motor when the position has been reached.
                    Start it again so it can be used in the next movement.
                %}
                if readRotation(mymotor2) > baseAngle
                    readRotation(mymotor2)
                    mymotor2.Speed = -80; % activate the motor with the calculated speed
                else
                    mymotor2.Speed = 0; % activate the motor with the calculated speed
                    break;
                end
            end
            pause(1);
            dropOnBox2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch1,mytouch2,mytouch3);
            homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); 
        case 3 
            dropOnBox(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3);
            % Wrist
            while readTouch(mytouch1) == 0
                readRotation(mymotor3)
                mymotor3.Speed = -20; % activate the motor with the calculated speed
                if readRotation(mymotor3) > 20
                    mymotor3.Speed = -10; % activate the motor with the calculated speed
                end
            end
            homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); 
    end
end
