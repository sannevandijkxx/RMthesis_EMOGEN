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

spmDir    = '/home/s2229889/MATLAB/spm12';
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

%% Normalisation Within Happy (accuracy maps to MNI)
cfg.spmDir = spmDir;
cfg.preprocDir = preprocDir;

cfg.spmDir = fileparts(which('spm'));
mvpa = 'MVPA/WithinHappy';

for subject = subsToDo
    subID = sprintf('emogen%03d',subject);

    mvpaDir = fullfile(preprocDir, subID, mvpa);

    files = dir(fullfile(mvpaDir, '**', 'res_accuracy_minus_chance.nii'));

    fprintf('\nFound %d accuracy maps for subject %s\n', ...
        length(files), subID);

    for i = 1:length(files)
        DAmapfile = fullfile(files(i).folder, files(i).name);
        fprintf('Normalising:\n%s\n', DAmapfile);
        normalise(cfg, subject, DAmapfile)
    end
end

fprintf('\nNORMALISATIONFINISHED\n');
   
clear cfg

%% Normalisation Within Fear (accuracy maps to MNI)
cfg.spmDir = spmDir;
cfg.preprocDir = preprocDir;

cfg.spmDir = fileparts(which('spm'));
mvpa = 'MVPA/WithinFear';

for subject = subsToDo
    subID = sprintf('emogen%03d',subject);

    mvpaDir = fullfile(preprocDir, subID, mvpa);

    files = dir(fullfile(mvpaDir,'**', 'res_accuracy_minus_chance.nii'));

    fprintf('\nFound %d accuracy maps for subject %s\n', ...
        length(files), subID);

    for i = 1:length(files)
        DAmapfile = fullfile(files(i).folder, files(i).name);
        fprintf('Normalising:\n%s\n', DAmapfile);
        normalise(cfg, subject, DAmapfile)
    end
end

fprintf('\nNORMALISATIONFINISHED\n');
   
clear cfg

%% GroupLevelAnalysis Happy
clear cfg
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.preprocDir = preprocDir;
cfg.contrastName = 'WithinHappy';
cfg.resultsDir = [preprocDir, '/GroupLevel/WithinHappy'];
resultsDir = cfg.resultsDir;
groupLevelAnalysis(cfg)

%% GroupLevelAnalysis Fear
clear cfg
cfg.spmDir = spmDir;
cfg.subsToDo = subsToDo;
cfg.preprocDir = preprocDir;
cfg.contrastName = 'WithinFear';
cfg.resultsDir = [preprocDir, '/GroupLevel/WithinFear'];
resultsDir = cfg.resultsDir;
groupLevelAnalysis(cfg)