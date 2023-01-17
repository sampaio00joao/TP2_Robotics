clear all; close all; clc

%% Joints
% Create a serial link object for the arm
L1 = Revolute('d',0.13,'alpha',-pi/2,'qlim', deg2rad([0 180])); 
L2 = Revolute('a', -0.19,'qlim', deg2rad([0 90]));
L3 = Revolute('alpha',-pi/2,'qlim', deg2rad([0 90])); 
robot = SerialLink([L1 L2 L3], 'name', 'EV3 Robot');


%% End Effector
m_endeffector = SE3(-0.02,0,0.12);
robot.tool = m_endeffector;
%% Home Coordinates
base =0; % Read rotation counter in degrees
elbow =0; % Read rotation counter in degrees
wrist = 0; % Read rotation counter in degrees
% base = -441;
% elbow = -107;
% wrist = 389;
%T1 = robot.fkine(deg2rad(double([base,elbow,wrist])));
T1 = transl(0,0,0);
%% Position Coordinates
base  =180;
elbow =  -90;
wrist =  45;
T2 = transl(-0.111,-0.226,0.313);
%T2 = robot.fkine(deg2rad(double([base,elbow,wrist]))); %Tem de ser em cartesianas
%T2 = SE3.rpy([180,90,0]);
%% Movement to Position
timeStep = [0:0.05:5]';
%Ts_1 = ctraj(T1, T2, length(timeStep));
%qc1 = robot.ikunc(Ts_1)
% plot(robot,qc1)
%% Movimento do robot
%% Movement to Final Position
%timeStep = [0:0.05:10]';
%qc1 = jtraj([0,0,0], [deg2rad(180),deg2rad(90),deg2rad(45)], length(timeStep));
qc1 = ctraj(T1,T2, length(timeStep));
%disp(rad2deg(qc2))
tranimate(qc1)
% plot(robot,qc2);
