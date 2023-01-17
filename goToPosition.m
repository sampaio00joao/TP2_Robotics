function [] = goToPosition(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3,angleX)
    % Elbow
    while 1
        if readRotation(mymotor2) > -185
            mymotor2.Speed = -70; % activate the motor with the calculated speed  
        else
            mymotor2.Speed = 0; % activate the motor with the calculated speed
            break;
        end
    end
    % Base
    while 1
            if readRotation(mymotor1) > angleX
                mymotor1.Speed = -20; % activate the motor with the calculated speed  
            else
                mymotor1.Speed = 0; % activate the motor with the calculated speed
                break;
            end
    end
    pause(1);
    % Wrist
    while 1 
        if readRotation(mymotor3) < 65 % motor angle for position 2
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
    mymotor4.Speed = 0;
    pause(1);
    % Elbow
    while readTouch(mytouch3) == 0
        mymotor2.Speed = 10; % activate the motor with the calculated speed
    end
    mymotor2.Speed = 0; % stop motor
    pause(1);
    %% Claw Close
    pause(2);
    mymotor4.Speed = closeClaw;
    pause(0.3);
    mymotor4.Speed = 0;
end

