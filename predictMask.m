function Mask = predictMask(nn,img)
[row, col] = size(img);

x = split(img,nn.size(1,1));
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

Mask = patchMerge2(nn.a{1,5}',row,col,nn.size(1,1));
countMatrix = zeros(row,col);
for i=1:row-7
    for j=1:col-7
        countMatrix(i:i+7,j:j+7) = countMatrix(i:i+7,j:j+7) + 1;
    end
end
Mask = Mask ./ countMatrix;

end