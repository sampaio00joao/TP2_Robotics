function [] = dropOnBox(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3)
% Elbow
    while 1
        if readRotation(mymotor2) > -250 % motor angle for box 1
            readRotation(mymotor2)
            mymotor2.Speed = -70; % activate the motor with a negative speed
        else
            mymotor2.Speed = 0;  % stop the motor
            break;
        end
    end
    pause(2);
    % Base
    while 1 
        if readRotation(mymotor1) > -650 % motor angle for box 1
            mymotor1.Speed = -20; % activate the motor with a negative speed
        else
            mymotor1.Speed = 0; % stop the motor
            break;
        end
    end
    pause(2);
    % Wrist
    while 1 
        if readRotation(mymotor3) < 250 % motor angle for box 1
            mymotor3.Speed = 20; % activate the motor with a positive speed
        else
            mymotor3.Speed = 0; % stop the motor
            break;
        end
    end
    pause(2);
    %% Claw Open
    openClaw = 10;
    closeClaw = -10;
    mymotor4.Speed = openClaw; % activate the motor with the calculated speed
    pause(0.2);
    mymotor4.Speed = 0; % stop the motor
    
    %% Claw Close
    pause(2);
    mymotor4.Speed = closeClaw;  % activate the motor with the calculated speed
    pause(0.2);
    mymotor4.Speed = 0; % stop the motor
    
end

