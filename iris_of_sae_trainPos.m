function nn = iris_of_sae_trainPos(N, trainNum, Pos, option)
%%

%load Data
load DataName;
if size(xName,1) ~= trainNum
    xName = xName(1:trainNum,:);
    yName = yName(1:trainNum,:);
end


%  Setup and train a stacked denoising autoencoder (SDAE)
rand('state',0)
for j=1:trainNum
    sae = saesetup(N(1,1:end-1));
    if j==1
        for i=1:size(N,2)-2
            sae.ae{i}.activation_function       = 'sigm';
            sae.ae{i}.learningRate              = 0.01;
            sae.ae{i}.inputZeroMaskedFraction   = 0.5;
            opts.numepochs =   50;
            opts.batchsize = 173;           % if input patch size is 64
            %opts.batchsize = 345;           % if input patch size is 256
            %opts.batchsize = 329;           % if input patch size is 1024
        end
    end
    train_x = double(imread([xDir xName{j,:}]))/255;
    train_x = splitPos(train_x,Pos,option);
    train_y = double(imread([yDir yName{j,:}]))/255;
    train_y = splitPos(train_y,Pos,option);
    % normalize
    [train_x, mu, sigma] = zscore(train_x);
    sae = saetrain(sae, train_x, opts);
end
% for i=1:size(N,2)-2  %視覺化選項
%     figure,visualize(sae.ae{i}.W{i}(:,2:end)');
% end

% Use the SDAE to initialize a FFNN
disp('NN fine-tune');

nn = nnsetup(N);
nn.activation_function              = 'sigm';
nn.learningRate                     = 0.01;

for i=1:size(N,2)-2
    nn.W{i} = sae.ae{i}.W{1};
end
% Train the FFNN
opts.numepochs =   50;
%opts.batchsize = 353;           % if input patch size is 64
% opts.batchsize = 345;           % if input patch size is 256
opts.batchsize = 173;           % if input patch size is 1024
for j = 1:trainNum
    train_x = double(imread([xDir xName{j,:}]))/255;
    train_x = splitPos(train_x,Pos,option);
    train_y = double(imread([yDir yName{j,:}]))/255;
    train_y = splitPos(train_y,Pos,option);
    % normalize
    [train_x, mu, sigma] = zscore(train_x);
    nn = nntrain(nn, train_x, train_y, opts);
end
% [er, bad] = nntest(nn, test_x, test_y);
% assert(er < 0.16, 'Too big error');
