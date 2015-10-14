function [imOut] = splitPos(imIn, pos)
% split by posistion
% pos : UL 1, UR 2, DL 3, DR 4
switch pos
    case 1
        imOut = imIn(1:30,1:180);
    case 2
        imOut = imIn(1:30,181:360);
    case 3
        imOut = imIn(31:60,1:180);
    case 4
        imOut = imIn(31:60,181:360);
end
end

