function [] = dropOnBox2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch1,mytouch2,mytouch3)
    % positive speed / base
    while readTouch(mytouch2) == 0
        mymotor1.Speed = 20; % activate the motor with positive speed
        if readRotation(mymotor1) > 20
             mymotor1.Speed = 10; % slow down
        end
    end
    mymotor1.Speed = 0; % stop motor
    pause(2);
    % Wrist
    while 1 
        if readRotation(mymotor3) < 300 % go to the position for box 2
            mymotor3.Speed = 20; % activate the motor with positive speed
        else
            mymotor3.Speed = 0; % stop motor
            break;
        end
    end
    %% Claw Open
    openClaw = 10;
    closeClaw = -10;
    mymotor4.Speed = openClaw; % activate the motor with the calculated speed
    pause(0.2);
    mymotor4.Speed = 0; % stop motor
    pause(1);
    %% Claw Close
    pause(2);
    mymotor4.Speed = closeClaw; % activate the motor with the calculated speed
    pause(0.2);
    mymotor4.Speed = 0;  % stop motor
    pause(1);
end

