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

%% GroupLevelAnalysis Cross Fear vs Happy
clear cfg
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.preprocDir = preprocDir;
cfg.contrastName = 'crossFvsH';
cfg.resultsDir = [preprocDir, '/GroupLevel/crossFvsH'];
resultsDir = cfg.resultsDir;
groupLevelAnalysis(cfg)

%% ReadDA ROIs Fvs H op Within F vs H
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.roiMNIDir = fullfile(cfg.dataDir, 'ROI');

for subject = subsToDo
    readDAFvsH_Within (cfg);
end

clear cfg

%% ReadDA ROIs Fvs H op Cross F vs H
cfg.dataDir = preprocDir;
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.roiMNIDir = fullfile(cfg.dataDir, 'ROI');

for subject = subsToDo
    readDAFvsH_Cross (cfg);
end

clear cfg
