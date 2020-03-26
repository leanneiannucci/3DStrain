
distance(1) = Dist(totalPointsNum(1,:),totalPointsNum(2,:));
 distance(2) = Dist(totalPointsNum(1,:),totalPointsNum(3,:));
 distance(3) = Dist(totalPointsNum(1,:),totalPointsNum(4,:));

test = [0,0,19.05;38.1,0,63.5;0,50.8,31.75;38.1,50.8,6.35];
testDist(1) = Dist(test(1,:),test(2,:));
testDist(2) = Dist(test(1,:),test(3,:));
testDist(3) = Dist(test(1,:),test(4,:));

function distBetweenPoints = Dist(xyz1,xyz2)
distBetweenPoints = sqrt((abs(xyz2(1,1,1)-xyz1(1,1,1)))^2+(abs(xyz2(1,2,1)-xyz1(1,2,1)))^2+(abs(xyz2(1,3,1)-xyz1(1,3,1)))^2);
end
