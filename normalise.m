function normalise(cfg, subject, DAmapFile)

%% Paths
   
addpath(genpath("/home/s2229889/MATLAB/spm12"))
addpath(genpath("/home/s2229889/MATLAB/TDT"))
addpath(genpath("/home/s2229889/MATLAB/xiangruili-dicm2nii-3fe1a27"))

T1 = fullfile(cfg.preprocDir, ['emogen' num2str(subject, '%03i')], ...
    'T1.nii');

TPM = fullfile(cfg.spmDir, ...
    'tpm', ...
    'TPM.nii');

%% Safety checks

if ~exist(T1,'file')
    error('T1 not found:\n%s', T1);
end

if ~exist(DAmapFile,'file')
    error('Accuracy map not found:\n%s', DAmapFile);
end

if ~exist(TPM,'file')
    error('TPM not found:\n%s', TPM);
end

%% Clear batch

matlabbatch = [];

%% NORMALISATION

matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {T1};

matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = ...
    {DAmapFile};

%% Estimation options

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = ...
    {TPM};

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = ...
    [0 0.001 0.5 0.05 0.2];

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';

%% Write options

matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = ...
    [-78 -112 -70
      78   76  85];

matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = ...
    [2 2 2];

matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;

matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';

%% Run SPM

spm_jobman('run', matlabbatch);

end