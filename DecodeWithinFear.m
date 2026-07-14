function DecodeWithinFear (cfg2, subject)
beta_dir = [cfg2.dataDir, '/emogen', num2str(subject, '%03i'),'/GLM/WithinFear/'];
addpath(genpath('/home/s2229889/MATLAB/TDT/'));
clear cfg
decoding_defaults

regressor_names = design_from_spm(beta_dir);


labelnames = {'Fear', 'Neutral'};
contrast_name = 'WithinFear';
labels = [1 2];

% update cfg
cfg = decoding_defaults;
cfg.software = 'SPM12';
cfg.analysis = 'searchlight';
mkdir(cfg.results.dir);
cfg.results.dir = fullfile('/home/s2229889/emogen/derivatives/preprocessing', ...
    ['emogen', num2str(subject, '%03i')], 'MVPA', 'WithinFear');

cfg.files.mask = [beta_dir, '/mask.nii'];

cfg = decoding_describe_data(cfg, labelnames, labels, regressor_names, beta_dir);
cfg.searchlight.unit = 'mm'; % comment or set to 'voxels' if you want normal voxels
cfg.searchlight.radius = 12; %searchlight radius of 12 units (here: mm)
cfg.searchlight.spherical = 0;
cfg.verbose = 1;
cfg.plot_selected_voxels = 500;
cfg.plot_design = 1; % this is by default set to 1, but if you repeat the same design again and again, it can get annoying...
cfg.decoding.method = 'classification_kernel';
cfg.design.unbalanced_data = 'ok';
cfg.results.overwrite = 1;
cfg.design = make_design_cv(cfg);

% run decoding
cfg.results.output = {'accuracy_minus_chance', 'confusion_matrix'};
results = decoding(cfg);
save(fullfile(cfg.results.dir, 'cfg.mat'), 'cfg');
end