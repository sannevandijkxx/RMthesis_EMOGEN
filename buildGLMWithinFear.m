function buildGLMWithinFear(cfg, subject)
% Define directories and file paths
addpath(genpath(cfg.spmDir));
participantDir = [cfg.preprocDir, '/emogen', num2str(subject, '%03i'), '/'];
outputDir = [participantDir, 'GLM/WithinFear/'];

% Read PsychoPy data
filename = dir([participantDir, '*.csv']);
PsychoPyLog = readtable([participantDir, filename.name]);

% Build Onset Matrix = zeros(cfg.runs, 6, 3)
onsetMatrix = zeros(3,2,2); % runs * reps * conditions
counter = ones(3,2);

for trial = 1:height(PsychoPyLog)
    blockStart = PsychoPyLog.("BlockStart_abs_")(trial); % Here it should be adapted to what you find in Alice
    gender   = PsychoPyLog.gender{trial};
    emotion  = PsychoPyLog.emotion{trial};
    target   = PsychoPyLog.task_cue{trial};
    onset    = PsychoPyLog.("ImageOnset_rel_")(trial) + PsychoPyLog.("StartTimeTrial_abs_")(trial) - blockStart;
    duration = PsychoPyLog.("ImageEnd_rel_")(trial) - PsychoPyLog.("ImageOnset_rel_")(trial);
    block = PsychoPyLog.Block(trial) + 1;

    %% Response processing (for trial inclusion only)

    % Participant's selected response (1-3)
    choice = PsychoPyLog.Button_Pressed(trial); % Index of participant response

    % Correct response for this trial (1-3)
    correct_idx = PsychoPyLog.Button_Pressed(trial);  % Index of correct answers as defined

    % Response labels
    options = {...
        PsychoPyLog.("responseOptions_0_"){trial},...
        PsychoPyLog.("responseOptions_1_"){trial},...
        PsychoPyLog.("responseOptions_2_"){trial} ...
        };

    % Converting indices to response labels
    choice_label = upper(options{choice});      % Participant-selected option category
    correct_label = upper(options{correct_idx}); % Correct category label

    % Accuracy check using string comparison
    is_correct = strcmp(choice_label, correct_label); % Boolean check, TRUE if participant response matches correct answer

    % Trial exclusion rule
    if is_correct      % Excludes incorrect trials

        % Determine condition index

        if strcmp (target,'EMOTION')

            if strcmp(emotion, 'FEAR')
                condition = 1;
            elseif strcmp(emotion, 'NEUTRAL')
                condition = 2;
            else
                continue
            end

            % Store onset matrix
            onsetMatrix(block, counter(block,condition), condition) = onset;
            counter(block,condition) = counter(block,condition) + 1;
        end
    end
end

    % Condition names
    conditionName = {'Fear', 'Neutral'};
    EPIs = dir(fullfile(participantDir, 'au*.nii')); %Load EPI images
    cfg.runs = length(EPIs);
    movementRegressors = dir(fullfile(participantDir, 'rp*.txt')); %Load all movement regressors
    if isempty(movementRegressors)
        error('No movement regressors found. Please check the participant directory and file names.');
    end

    clear matlabbatch;

    matlabbatch{1}.spm.stats.fmri_spec.dir = {outputDir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.7; % TR = 700ms
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

    % Load movement parameters as regressors
    % "scans =..." means loading all EPI volumes for that run
    for run = 1:cfg.runs
        filename = EPIs(run).name;
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).scans =  cellstr(spm_select('expand', fullfile(participantDir, filename)));

        for condition = 1:2
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(condition).name = conditionName{condition};
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(condition).onset = nonzeros(onsetMatrix(run,:,condition));
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(condition).duration = 2;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(condition).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(condition).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(run).cond(condition).orth = 1;
        end

        % Load movement parameters as regressors
        if isempty(movementRegressors)
            error('No movement regressors found. Please check the participant directory and file names.');
        end

        matlabbatch{1}.spm.stats.fmri_spec.sess(run).multi_reg = {fullfile(participantDir, movementRegressors(run).name)};% 6 motion parameters
        matlabbatch{1}.spm.stats.fmri_spec.sess(run).hpf = 128; % removes slow drift in signal
    end

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    % Model estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(outputDir, 'SPM.mat')};
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    % Define contrasts
    matlabbatch{3}.spm.stats.con.spmmat = {fullfile(outputDir, 'SPM.mat')};
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Fear > Neutral';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';

    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Neutral > Fear';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';
    matlabbatch{3}.spm.stats.con.delete = 1; % Deletes previous contrasts

    % Run the batch
    spm_jobman('run', matlabbatch);
end