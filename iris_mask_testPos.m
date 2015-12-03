function correct_rate = iris_mask_testPos(nn, testImage, groundtruth, countOpt, threshold, Pos, option)
testImage = double(testImage)/255;
groundtruth = double(groundtruth)./255;

x = splitPos(testImage,Pos,option);
% [x, mu, sigma] = zscore(x);
% groundtruth = normalize(groundtruth, mu, sigma);

n = nn.n;
m = size(x, 1);
x = [ones(m,1) x];
nn.a{1} = x;

for i = 2 : n-1
    
    % Calculate the unit's outputs (including the bias term)
    nn.a{i} = sigm(nn.a{i - 1} * nn.W{i - 1}');
    %dropout
    if(nn.dropoutFraction > 0)
        if(nn.testing)
            nn.a{i} = nn.a{i}.*(1 - nn.dropoutFraction);
        else
            nn.dropOutMask{i} = (rand(size(nn.a{i}))>nn.dropoutFraction);
            nn.a{i} = nn.a{i}.*nn.dropOutMask{i};
        end
    end
    
    %calculate running exponential activations for use with sparsity
    if(nn.nonSparsityPenalty>0)
        nn.p{i} = 0.99 * nn.p{i} + 0.01 * mean(nn.a{i}, 1);
    end
    %Add the bias term
    nn.a{i} = [ones(m,1) nn.a{i}];
    nn.a{n} = sigm(nn.a{n - 1} * nn.W{n - 1}');
    
end

% hypothese = patchMerge(nn.a{1,5}',nn.size(1,1));
% test = hypothese > threshold;
% test = ~(xor(test,(groundtruth(1:60,1:360)./255)));
% correct_rate = size(find(test),1) / (60*360);

if countOpt == 8
    load countMatrix\countPos
elseif countOpt == 16
    load countMatrix\count16
elseif countOpt ==32
    load countMatrix\count32
end
hypothese = patchMergePos(nn.a{1,5}',nn.size(1,1));

switch Pos
    case 1
        hypothese2 = hypothese./countMatrix;
        test = hypothese2 > threshold;
        test = ~(xor(test,groundtruth(1:30,1:180)));
    case 2
        hypothese2 = hypothese./countMatrix;
        test = hypothese2 > threshold;
        test = ~(xor(test,groundtruth(1:30,181:360)));
    case 3
        hypothese2 = hypothese./countMatrix;
        test = hypothese2 > threshold;
        test = ~(xor(test,groundtruth(31:60,1:180)));
    case 4
        hypothese2 = hypothese./countMatrix;
        test = hypothese2 > threshold;
        test = ~(xor(test,groundtruth(31:60,181:360)));
end

correct_rate = size(find(test),1) / (30*180);

subplot(4,1,1),imshow(groundtruth(1:30,181:360),[]);
subplot(4,1,2),imshow(testImage(1:30,181:360));
subplot(4,1,3),imshow(hypothese2,[]);
subplot(4,1,4),imshow(hypothese2>threshold);
end