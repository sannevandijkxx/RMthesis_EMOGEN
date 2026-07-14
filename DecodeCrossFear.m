function DecodeCrossFear (cfg2, subject)
%% decoding emotion - cross task
beta_dir = [cfg2.dataDir, '/emogen', num2str(subject, '%03i'), '/GLM/cross/'];
addpath(genpath('/home/s2229889/MATLAB/TDT/'));
clear cfg
decoding_defaults

% Get regressor names from both GLMs
regressor_names = design_from_spm(beta_dir);

% Define labels
labelnames= {'EmoFear', 'EmoNeutral', 'GenderFear', 'GenderNeutral'}; 
labels = [1 2 1 2];
xclass = [1 1 2 2];

% Define contrast name for output
contrast_name = 'CrossFear';

% update cfg
cfg = decoding_defaults;
cfg.software = 'SPM12';
cfg.analysis = 'searchlight';
cfg.results.dir = fullfile('/home/s2229889/emogen/derivatives/preprocessing', ...
    ['emogen', num2str(subject, '%03i')], 'MVPA', 'CrossFear');
cfg.files.mask = [beta_dir, '/mask.nii']; %Use emotion task

% Describe training data (emotion) and add test data (gender)
% cfg = decoding_describe_data(cfg, labelnames_train, labels, ...
%       regressor_names, beta_dir);
cfg = decoding_describe_data(cfg, labelnames, labels, regressor_names, beta_dir, xclass);

% Searchlight settings
cfg.searchlight.unit = 'mm'; % comment or set to 'voxels' if you want normal voxels
cfg.searchlight.radius = 12; %searchlight radius of 12 units (here: mm)
cfg.searchlight.spherical = 0;
cfg.verbose = 1;
cfg.plot_selected_voxels = 500;
cfg.plot_design = 1; % this is by default set to 1, but if you repeat the same design again and again, it can get annoying...
cfg.decoding.method = 'classification_kernel';
cfg.design.unbalanced_data = 'ok';
cfg.results.overwrite = 1;

% Use train/test design instead of cross-validation
cfg.design = make_design_xclass_cv(cfg);

% run decoding
cfg.results.output = {'accuracy_minus_chance', 'confusion_matrix'};
results = decoding(cfg);
save(fullfile(cfg.results.dir, 'cfg.mat'), 'cfg');
end