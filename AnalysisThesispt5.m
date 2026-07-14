%% Analysis file for ALICE

clear; clc;

%% Analysis parameters with changed path names for ALICE
baseDir     = '/home/s2229889/emogen/'; % main project folder
codeDir     = fullfile(baseDir, 'code');
derivDir    = fullfile(baseDir, 'derivatives');
preprocDir  = fullfile(derivDir, 'preprocessing');

WithinDir   = fullfile(derivDir, 'within');
mvpaDir     = fullfile(derivDir, 'mvpa');
logDir      = fullfile(baseDir, 'log');
%cfg.dataDir     = ['/home/s2229889/MRI thesis/data/'];

% Create dirs ?
dirsToMake = {derivDir, preprocDir, WithinDir, mvpaDir, logDir};
for d = 1:numel(dirsToMake)
    if ~exist(dirsToMake{d}, 'dir'); mkdir(dirsToMake{d}); end
end

spmDir       = '/home/s2229889/MATLAB/spm12';
%spm25Dir    = '/home/s2229889/MATLAB/spm';
tdtFolder    = '/home/s2229889/MATLAB/TDT/';

addpath (baseDir);
addpath (codeDir)
addpath (spmDir);
%addpath(cfg.spm25Dir);
addpath (genpath(tdtFolder));

%% Start

spm fmri 

%% Participants

subsToDo = [4,7,8,9,10,11,12,15,16,17,18,19,20,21,22,23,25];

%% ROIs
% ROIs Happy Within
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;

for subject = subsToDo
    roi_HW (cfg);
end

clear cfg

% ROIs Fear Within
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;

for subject = subsToDo
    roi_FW (cfg);
end

clear cfg

% ROIs Happy Cross
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;

for subject = subsToDo
    roi_HC (cfg);
end

clear cfg

% ROIs Fear Cross
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;

for subject = subsToDo
    roi_FC (cfg);
end

clear cfg

%% ReadDA stuff that I don't have for the analysis file
% ReadDA Happy Within ROIs vs Happy Cross data
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.roiMNIDir = fullfile(cfg.dataDir, 'ROI');

for subject = subsToDo
    readDA_HW_vs_HC (cfg);
end

clear cfg

% ReadDA Happy Cross ROIS vs Happy Within data
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.roiMNIDir = fullfile(cfg.dataDir, 'ROI');

for subject = subsToDo
    readDA_HC_vs_HW (cfg);
end

clear cfg

% ReadDA Fear Within ROIS vs Fear Cross Data
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.roiMNIDir = fullfile(cfg.dataDir, 'ROI');

for subject = subsToDo
    readDA_FW_vs_FC (cfg);
end

clear cfg

% ReadDA Fear Cross ROIS vs Fear Within data
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.roiMNIDir = fullfile(cfg.dataDir, 'ROI');

for subject = subsToDo
    readDA_FC_vs_FW (cfg);
end

clear cfg
