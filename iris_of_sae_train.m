function test_example_SAE
load mnist_uint8;
N = [784 200 100 10];
train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
rand('state',0)
sae = saesetup(N(1,1:end-1));
for i=1:size(N,2)-2
    sae.ae{i}.activation_function       = 'sigm';
    sae.ae{i}.learningRate              = 1;
    sae.ae{i}.inputZeroMaskedFraction   = 0.5;
    opts.numepochs =   1;
    opts.batchsize = 100;
end
sae = saetrain(sae, train_x, opts);
% for i=1:size(N,2)-2  %視覺化選項
%     figure,visualize(sae.ae{i}.W{i}(:,2:end)');
% end

% Use the SDAE to initialize a FFNN
disp('NN fine-tune');
nn = nnsetup(N);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
nn.W{1} = sae.ae{1}.W{1};

% Train the FFNN
opts.numepochs =   1;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
assert(er < 0.16, 'Too big error');
