clear all; close all; clc
%% Variables
breakOut = true; % used to break the loop
userInput = 0; % used to read the user input

%% Connection to the brick and motor and sensor setup
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

% Reset Robot / Reference creation / All motors at 0 degrees 
mymotor1.resetRotation;
mymotor2.resetRotation;
mymotor3.resetRotation;
mymotor4.resetRotation;

%% Camera / Threshold
% Depending on the user input it will activate the fixed position mode or
% the random position mode
prompt = "1. Fixed Position 2. Random position\n";
userInput = input(prompt); % receives data from the user
if userInput == 1 % Fixed Position Mode
    pos = imThreshold(); % receives pos 1 or 2;
elseif userInput == 2 % Random Position Mode
    [pos,x,y] = imThreshold_traj(); % receives pos 3 and x y coordinates;
end

%% Robot Movements
while breakOut == true % runs until a movement has finished
    switch pos
        case 1 % Movement to position 1
            position1(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3); % move to the fixed position 1
            pause(1);
            % Elbow movement to make sure it will stay on top of the object
            while 1
                if readRotation(mymotor2) > -300 % motor angle for position 1
                    readRotation(mymotor2)
                    mymotor2.Speed = -70; % activate the motor with a negative speed
                else
                    mymotor2.Speed = 0;  % stop the motor
                    break;
                end
            end
            pause(2);
            dropOnBox(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3); % drops on box 1 / left
            homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); % goes back to the home position
            breakOut = false; % break the loop
        case 2 % Movement to position 1
            position2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3); % move to the fixed position 1
            pause(1);
            % Elbow movement to make sure it will stay on top of the object
            while 1
                if readRotation(mymotor2) > -250 % motor angle for position 2
                    readRotation(mymotor2)
                    mymotor2.Speed = -90; % activate the motor with a negative speed
                else
                    mymotor2.Speed = 0;  % stop the motor
                    break;
                end
            end
            pause(1);
            dropOnBox2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch1,mytouch2,mytouch3); % drops on box 2 / right
            homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3); % goes back to the home position         
            breakOut = false; % break the loop
        case 3 % Movement to random position
            %% Conversions to motor degrees
            % 30cm - 90 graus
            % x - ?
            % 30cm - 90 graus
            % y - ?
            valueX = (x *90)/30;
            valueY = (y *45)/21;
            % -90 - 350
            % valueX - angleX
            % 80 - 350
            % valueY - angleY
            angleX = -180+((valueX*350)/-90);
            angleY = ((valueY*350)/80);
            % Movement to the calculated position
            goToPosition(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3,angleX);
            dropOnBox(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3); % drops on box 1 / left
            homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3);  % goes back to the home position             
            breakOut = false; % break the loop
    end
end
