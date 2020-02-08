
% Get a list of all files and folders in this folder.
files = dir('C:\Users\TB\Documents\MATLAB\project\by_class\');
% Filter to keep the subfolders only
dirFlags = files([files(:).isdir]==1);
% take out those useless . and .. folders
dirFlags = dirFlags(~ismember({dirFlags(:).name},{'.','..'}));
subFolders = {dirFlags.name}; 
% this will be used to store features 
outFeatures = "features";
%outFeaturesTest = "features_tst";
mkdir('C:\Users\TB\Documents\MATLAB\project',outFeatures);
%mkdir('C:\Users\TB\Documents\MATLAB\project\Hnd',outFeaturesTest); <
%replaced by automated partitioning 
%label = ["0","1","2","3","4","5","6","7","8","9","A_CAPS","B_CAPS","C_CAPS","D_CAPS","E_CAPS","F_CAPS","G_CAPS","H_CAPS","I_CAPS","J_CAPS","K_CAPS","L_CAPS","M_CAPS","N_CAPS","O_CAPS","P_CAPS","Q_CAPS","R_CAPS","S_CAPS","T_CAPS","U_CAPS","V_CAPS","W_CAPS","X_CAPS","Y_CAPS","Z_CAPS","a_small","b_small","c_small","d_small","e_small","f_small","g_small","h_small","i_small","j_small","k_small","l_small","m_small","n_small","o_small","p_small","q_small","r_small","s_small","t_small","u_small","v_small","w_small","x_small","y_small","z_small"];
for k = 1 : length(subFolders)
    category = char(subFolders(k));
    mkdir('C:\Users\TB\Documents\MATLAB\project\features',category);
    %mkdir('C:\Users\TB\Documents\MATLAB\project\Hnd\features_tst',category);
   %this has all the images in one set .eg all images for 0
   imgSet = imageSet(strcat('by_class/' , category,'/train_',category) );
   for n = 1:1000 %taking only the first 10k samples of each char
       
         a = fullfile('C:\Users\TB\Documents\MATLAB\project\features',category,int2str(n));
         imgg = imread(char(imgSet.ImageLocation(n)));
         img = preprocess(imgg);
         imwrite(img,a,'bmp');
         if n > 50 && n < 54
             figure, imshow(img); 
         end

       
   end

  
   fprintf('Sub folder #%d = %s\n', k, subFolders{k});
end