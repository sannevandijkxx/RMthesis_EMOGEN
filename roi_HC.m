function roi_HC(cfg)
%% Add paths
addpath(genpath("/home/s2229889/MATLAB/spm12"))
addpath(genpath("/home/s2229889/MATLAB/TDT"))
addpath(genpath("/home/s2229889/MATLAB/Nifti"))
addpath(genpath("/home/s2229889/emogen/derivatives/preprocessing/GroupLevel/CrossHappy/"))

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

%% Right Secondary Visual -> 24, -82, -8
RightSecVisual2 = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if RightSecVisual2.img(x, y, z) == 50
                if decodingMap.img(x,y,z) > 0
                    RightSecVisual2.img(x, y, z) = 1;
                end
            else
                RightSecVisual2.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'RightSecVisual2.nii');
save_nii(RightSecVisual2, filename);
clear x
clear y
clear z
end

% Saves the resulting binary mask as a .nii (NIfTI) file
% This makes it ready to use in SPM