%categories = {'0','1','2','3','4','5','6','7','8','9','A_CAPS','B_CAPS','C_CAPS','D_CAPS','E_CAPS','F_CAPS','G_CAPS','H_CAPS','I_CAPS','J_CAPS','K_CAPS','L_CAPS','M_CAPS','N_CAPS','O_CAPS','P_CAPS','Q_CAPS','R_CAPS','S_CAPS','T_CAPS','U_CAPS','V_CAPS','W_CAPS','X_CAPS','Y_CAPS','Z_CAPS','a_small','b_small','c_small','d_small','e_small','f_small','g_small','h_small','i_small','j_small','k_small','l_small','m_small','n_small','o_small','p_small','q_small','r_small','s_small','t_small','u_small','v_small','w_small','x_small','y_small','z_small'};
files = dir('C:\Users\TB\Documents\MATLAB\project\by_class\');
% Filter to keep the subfolders only
dirFlags = files([files(:).isdir]==1);
% take out those useless . and .. folders
dirFlags = dirFlags(~ismember({dirFlags(:).name},{'.','..'}));
subFolders = {dirFlags.name}; 

rootFolder = 'features';
imds = imageDatastore(fullfile(rootFolder,subFolders),'LabelSource', 'foldernames','FileExtensions','');
[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');
%% layers
% varSize = 128;
% conv1 = convolution2dLayer(5,varSize,'Padding',2,'BiasLearnRateFactor',2);
% conv1.Weights = gpuArray(single(randn([5 5 1 varSize])*0.0001));
% fc1 = fullyConnectedLayer(64,'BiasLearnRateFactor',2);
% fc1.Weights = gpuArray(single(randn([64 576])*0.1));
% fc2 = fullyConnectedLayer(62,'BiasLearnRateFactor',2);
% fc2.Weights = gpuArray(single(randn([62 64])*0.1));
% layers = [
%     imageInputLayer([varSize varSize 1]);
%     conv1;
%     maxPooling2dLayer(3,'Stride',2);
%     reluLayer();
%     convolution2dLayer(5,32,'Padding',2,'BiasLearnRateFactor',2);
%     reluLayer();
%     averagePooling2dLayer(3,'Stride',2);
%     convolution2dLayer(5,64,'Padding',2,'BiasLearnRateFactor',2);
%     reluLayer();
%     averagePooling2dLayer(3,'Stride',2);
%     fc1;
%     reluLayer();
%     fc2;
%     softmaxLayer()
%     classificationLayer()];
layers = [
    imageInputLayer([128 128 1])
    
    convolution2dLayer(10,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(64,'Stride',2)
    
    convolution2dLayer(8,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(16,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(62)
    softmaxLayer
    classificationLayer];
opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.100, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 15, ...
    'MiniBatchSize', 200, ...
    'Verbose', true);

[net, info] = trainNetwork(trainingSet, layers, opts);
charcnn = net;
save charcnn;

%rootFolder = 'features_tst';
%imds_test = imageDatastore(fullfile('Hnd',rootFolder,categories),'LabelSource', 'foldernames','FileExtensions','');
% for s = 1: 100
labels = classify(net, testSet);
acc = sum(labels == testSet.Labels)/numel(testSet.Labels);
%     ii = randi(4000);
%     im = imread(testSet.Files{ii});
%     figure, imshow(im);
%     if labels(ii) == testSet.Labels(ii)
%        colorText = 'g'; 
%     else
%         colorText = 'r';
%     end
%     title(char(labels(ii)),'Color',colorText);
% end