function [pos] = triangulateDLT_LEI_v1(XCoord_L, YCoord_L, XCoord_R, YCoord_R, L, R)

    Q(1,1:3) = [(L(1) - L(9)*XCoord_L), (L(2) - L(10)*XCoord_L), (L(3) - L(11)*XCoord_L)];
    Q(2,1:3) = [(L(5) - L(9)*YCoord_L), (L(6) - L(10)*YCoord_L), (L(7) - L(11)*YCoord_L)];
    Q(3,1:3) = [(R(1) - R(9)*XCoord_R), (R(2) - R(10)*XCoord_R), (R(3) - R(11)*XCoord_R)];
    Q(4,1:3) = [(R(5) - R(9)*YCoord_R), (R(6) - R(10)*YCoord_R), (R(7) - R(11)*YCoord_R)];

    q(1:4,1) = [(XCoord_L - L(4)); (YCoord_L - L(8)); (XCoord_R - R(4)); (YCoord_R - R(8))];
    pos = (inv(Q.'*Q))*Q'*q;

end

