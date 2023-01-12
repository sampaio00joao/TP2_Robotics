function [] = homeSequence(mymotor1,mymotor2,mymotor3,mytouch1,mytouch2,mytouch3)
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
% negative speed / wrist
while readTouch(mytouch1) == 0
    readRotation(mymotor3)
    mymotor3.Speed = -20; % activate the motor with the calculated speed
    if readRotation(mymotor3) > 20
         mymotor3.Speed = -10; % activate the motor with the calculated speed
    end
end
mymotor3.Speed = 0; % stop motor
pause(1);
end

