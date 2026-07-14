function roi_FW(cfg)
%% Add paths
addpath(genpath("/home/s2229889/MATLAB/spm12"))
addpath(genpath("/home/s2229889/MATLAB/TDT"))
addpath(genpath("/home/s2229889/MATLAB/Nifti"))
addpath(genpath("/home/s2229889/emogen/derivatives/preprocessing/GroupLevel/WithinFear/"))

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

% Creates a folder called ROI/ inside your data directory if it doesn't already exist.

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

%% Right Anterior PFC -> 8, 46, 4
RightAntPFC = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if RightAntPFC.img(x, y, z) == 113
                if decodingMap.img(x,y,z) > 0
                    RightAntPFC.img(x, y, z) = 1;
                end
            else
                RightAntPFC.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'RightAntPFC.nii');
save_nii(RightAntPFC, filename);
clear x
clear y
clear z

%% Right Premotor and Supplementarymotor -> 36, -12, 52
Presuppmot = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if Presuppmot.img(x, y, z) == 100
                if decodingMap.img(x,y,z) > 0
                    Presuppmot.img(x, y, z) = 1;
                end
            else
                Presuppmot.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'Presuppmot.nii');
save_nii(Presuppmot, filename);
clear x
clear y
clear z

%% Left Visual Association -> -48, -76, 14
LeftVisualAssoc2 = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if LeftVisualAssoc2.img(x, y, z) == 145
                if decodingMap.img(x,y,z) > 0
                    LeftVisualAssoc2.img(x, y, z) = 1;
                end
            else
                LeftVisualAssoc2.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'LeftVisualAssoc2.nii');
save_nii(LeftVisualAssoc2, filename);
clear x
clear y
clear z

%% Left Supramarginal Gyrus Association -> -60, -24, 36
LeftSupramGy = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if LeftSupramGy.img(x, y, z) == 195
                if decodingMap.img(x,y,z) > 0
                    LeftSupramGy.img(x, y, z) = 1;
                end
            else
                LeftSupramGy.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'LeftSupramGy.nii');
save_nii(LeftSupramGy, filename);
clear x
clear y
clear z

%% Left Fusiform Face Area -> -24, -46, -18
LeftFFA1 = atlas;
for x = 1 : dimx
    for y = 1 : dimy
        for z = 1 : dimz
            if LeftFFA1.img(x, y, z) == 123
                if decodingMap.img(x,y,z) > 0
                    LeftFFA1.img(x, y, z) = 1;
                end
            else
                LeftFFA1.img(x, y, z) = 0;
            end
        end
    end
end

% Save the mask
filename = fullfile(roiMNIDir, 'LeftFFA1.nii');
save_nii(LeftFFA1, filename);
clear x
clear y
clear z
end

% Saves the resulting binary mask as a .nii (NIfTI) file
% This makes it ready to use in SPM