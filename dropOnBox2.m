function [] = dropOnBox2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch1,mytouch2,mytouch3)
    % positive speed / base
    while readTouch(mytouch2) == 0
        mymotor1.Speed = 20; % activate the motor with the calculated speed
        if readRotation(mymotor1) > 20
             mymotor1.Speed = 10; % activate the motor with the calculated speed
        end
    end
    mymotor1.Speed = 0; % stop motor
    pause(1);
    % positive speed / elbow
    while readTouch(mytouch3) == 0
        mymotor2.Speed = 10; % activate the motor with the calculated speed
    end
    mymotor2.Speed = 0; % stop motor
    pause(1);
    pause(2);
    %% Claw Open
    openClaw = 10;
    closeClaw = -10;
    mymotor4.Speed = openClaw; % activate the motor with the calculated speed
    pause(0.2);
    mymotor4.Speed = 0;
    
    %% Claw Close
    pause(2);
    mymotor4.Speed = closeClaw;
    pause(0.2);
    mymotor4.Speed = 0;
end

