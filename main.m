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
% negative speed / base
while readTouch(mytouch2) == 0
    mymotor1.Speed = 20; % activate the motor with the calculated speed
    if readRotation(mymotor1) > 20
         mymotor1.Speed = 10; % activate the motor with the calculated speed
    end
end
pause(1);
% positive speed / elbow
while readTouch(mytouch3) == 0
    mymotor2.Speed = 10; % activate the motor with the calculated speed
end
pause(1);
% negative speed / wrist
while readTouch(mytouch1) == 0
    readRotation(mymotor3)
    mymotor3.Speed = -20; % activate the motor with the calculated speed
    if readRotation(mymotor3) > 20
         mymotor3.Speed = -10; % activate the motor with the calculated speed
    end
end
readTouch(mytouch1)
pause(1);

%% Reset Robot
mymotor1.resetRotation;
mymotor2.resetRotation;
mymotor3.resetRotation;
mymotor4.resetRotation;

%% Robot Movements
% Elbow
while 1
    %{ 
        Go to -350 motor degrees = 90 degrees cartesian
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
% Base
while 1 
    %{ 
        Go to -350 motor degrees = 90 degrees cartesian
        Since the movement is negative, the motor speed is negative as well
        Stop the motor when the position has been reached.
        Start it again so it can be used in the next movement.
    %}
    if readRotation(mymotor1) > -350
        mymotor1.Speed = -20; % activate the motor with the calculated speed
    else
        mymotor1.Speed = 0; % activate the motor with the calculated speed
        break;
    end
end
pause(2);
%% Claw Open
openClaw = 10;
closeClaw = -10;
mymotor4.Speed = openClaw; % activate the motor with the calculated speed
pause(0.2);
mymotor4.Speed = 0;

%% Elbow Down
% positive speed / elbow
while readTouch(mytouch3) == 0
    mymotor2.Speed = 10; % activate the motor with the calculated speed
end

%% Claw Close
pause(2);
mymotor4.Speed = closeClaw;
pause(0.2);
mymotor4.Speed = 0;

%% Store Object

