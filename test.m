import rvctools

L1 = rvctools.Revolute('d', 0.13, 'alpha', -rvctools.pi/2);
L2 = rvctools.Revolute('a', -0.19);
L3 = rvctools.Revolute('alpha', -rvctools.pi/2);
robot = rvctools.SerialLink([L1, L2, L3], 'name', 'EV3 Robot');
robot.qlim = rvctools.deg2rad([-300, 0; -180, 180; -180, 180]);
m_endeffector = rvctools.SE3(-0.02, 0, 0.12);
robot.tool = m_endeffector

startPos = rvctools.rotx(0, 0, 0);
endPos = rvctools.rotx(-230, 0, 0);

joint_angles_end = robot.ikine(endPos);

trajectory = rvctools.jtraj(robot.getpos(), joint_angles_end, 100);

for angles in trajectory:
    robot.move(angles);
end