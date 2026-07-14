function matlabbatch = groupLevelAnalysis(cfg) % Input baseDir and subject number

resultsDir = cfg.resultsDir;

spmDir = cfg.spmDir;

%% Build Batch

cfg.filenames = {};

for subject = cfg.subsToDo
    participantDir = fullfile(cfg.preprocDir, ['emogen', num2str(subject, '%03i')], ...
        'MVPA', cfg.contrastName);
    cfg.filenames{end+1,1} = [participantDir, '/wres_accuracy_minus_chance.nii'];
end

clear matlabbatch;

matlabbatch{1}.spm.stats.factorial_design.dir = {resultsDir};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cfg.filenames;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Run
% Hier zit een error, waarom?
 spm_jobman('run',matlabbatch);

 clear matlabbatch;

matlabbatch{1}.spm.stats.fmri_est.spmmat = {fullfile(resultsDir, 'SPM.mat')};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
spm_jobman('run',matlabbatch);

%% Define contrasts

clear matlabbatch;

matlabbatch{1}.spm.stats.con.spmmat = {fullfile(resultsDir, 'SPM.mat')};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Classification';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{1}.spm.stats.con.delete = 1; % Deletes previous contrasts

spm_jobman('run',matlabbatch);
