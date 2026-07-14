function roi_FC(cfg)
%% Add paths
addpath(genpath("/home/s2229889/MATLAB/spm12"))
addpath(genpath("/home/s2229889/MATLAB/TDT"))
addpath(genpath("/home/s2229889/MATLAB/Nifti"))
addpath(genpath("/home/s2229889/emogen/derivatives/preprocessing/GroupLevel/CrossFear/"))

%% Define the atlas file path
atlasFile = fullfile(cfg.spmDir, 'tpm', 'labels_Neuromorphometrics.nii');
% Load the atlas
atlas = load_nii(atlasFile);
% Get the dimensions of the atlas image
[dimx, dimy, dimz] = size(atlas.img);

% Loads the Neuromorphometrics atlas, a standard brain parcellation that ships with SPM.
% a 3D volume where each voxel contains a number (label) identifying which brain region it belongs to.

%% Define the output directory for ROIs
roiMNIDir = fullfile(cfg.dataDir, 'ROI');
% Check if the directory exists, if not, create it
if ~exist(roiMNIDir, 'dir')
    mkdir(roiMNIDir);
end

%% Reslice the thresholded map into atlas space
sourceFile = fullfile('/home/s2229889/emogen/derivatives/preprocessing/GroupLevel/WithinHappy/', 'thresholded_SPM_WH.nii');

matlabbatch{1}.spm.spatial.coreg.write.ref = {atlasFile};
matlabbatch{1}.spm.spatial.coreg.write.source = {sourceFile};
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 0;   % nearest neighbour
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';

spm_jobman('run', matlabbatch);
clear matlabbatch

%% Load Decodingmap
[srcPath, srcName, srcExt] = fileparts(sourceFile);
resliced = fullfile(srcPath, ['r' srcName srcExt]);
decodingMap = load_nii(resliced);

%% Left Fusiform Face Area -> -24, -46, -18
LeftFFA2 = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if LeftFFA2.img(x, y, z) == 122
                if decodingMap.img(x,y,z) > 0
                    LeftFFA2.img(x, y, z) = 1;
                end
            else
                LeftFFA2.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'LeftFFA2.nii');
save_nii(LeftFFA2, filename);
clear x
clear y
clear z

%% Left Secondary Visual -> -28, -80, -4
LeftSecVisual3 = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if LeftSecVisual3.img(x, y, z) == 45
                if decodingMap.img(x,y,z) > 0
                    LeftSecVisual3.img(x, y, z) = 1;
                end
            else
                LeftSecVisual3.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'LeftSecVisual3.nii');
save_nii(LeftSecVisual3, filename);
clear x
clear y
clear z

%% Left Secondary Visual -> -6, -84, -6
LeftSecVisual4 = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if LeftSecVisual4.img(x, y, z) == 64
                if decodingMap.img(x,y,z) > 0
                    LeftSecVisual4.img(x, y, z) = 1;
                end
            else
                LeftSecVisual4.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'LeftSecVisual4.nii');
save_nii(LeftSecVisual4, filename);
clear x
clear y
clear z
end

% Saves the resulting binary mask as a .nii (NIfTI) file
% This makes it ready to use in SPM