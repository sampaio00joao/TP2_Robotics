function [] = position2(mymotor1,mymotor2,mymotor3,mymotor4,mytouch3)
% Elbow
    while 1
        %{ 
            Since the movement is negative, the motor speed is negative as well
            Stop the motor when the position has been reached.
            Start it again so it can be used in the next movement.
        %}
        if readRotation(mymotor2) > -185
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
            Go to -250 motor degrees = 45 degrees cartesian
               
            Since the movement is negative, the motor speed is negative as well
            Stop the motor when the position has been reached.
            Start it again so it can be used in the next movement.
        %}
        if readRotation(mymotor1) > -240
            mymotor1.Speed = -20; % activate the motor with the calculated speed
        else
            mymotor1.Speed = 0; % activate the motor with the calculated speed
            break;
        end
    end
    pause(2);
    % Wrist
    while 1 
        %{ 
            Since the movement is negative, the motor speed is negative as well
            Stop the motor when the position has been reached.
            Start it again so it can be used in the next movement.
        %}
        if readRotation(mymotor3) < 80
            mymotor3.Speed = 20; % activate the motor with the calculated speed
        else
            mymotor3.Speed = 0; % activate the motor with the calculated speed
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
    %% Elbow Down
    % positive speed / elbow
    while readTouch(mytouch3) == 0
        mymotor2.Speed = 10; % activate the motor with the calculated speed
    end
    mymotor2.Speed = 0; % activate the motor with the calculated speed
    
    %% Claw Close
    pause(2);
    mymotor4.Speed = closeClaw;
    pause(0.2);
    mymotor4.Speed = 0;
end

