function BuildGLMCrossFrvsHp(cfg, subject)
%% Define directories and file paths
addpath(genpath(cfg.spmDir));
participantDir = [cfg.preprocDir, '/emogen', num2str(subject, '%03i'), '/'];
outputDir = [participantDir, '/GLM/crossFvsH/'];

%% ROIs
% Is dit de plek hiervoor?

%% Read PsychoPy data
filename = dir([participantDir, '*.csv']);
PsychoPyLog = readtable([participantDir, filename.name]);

%% Build Onset Matrix = zeros(cfg.runs, 6, 3)
onsetMatrix = zeros(3,2,6); % runs * reps * conditions
counter = ones(3,6);

for trial = 1:height(PsychoPyLog)

    blockStart = PsychoPyLog.("BlockStart_abs_")(trial);
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
        if strcmp(target, 'EMOTION') && strcmp(emotion, 'FEAR')
            condition = 1; % EmoFear
        elseif strcmp(target, 'EMOTION') && strcmp(emotion, 'HAPPY')
            condition = 2; % EmoHappy
        elseif strcmp(target, 'EMOTION') && strcmp(emotion, 'NEUTRAL')
            condition = 3; % EmoNeutral
        elseif strcmp(target, 'GENDER') && strcmp(emotion, 'FEAR')
            condition = 4; % GenderFear
        elseif strcmp(target, 'GENDER') && strcmp(emotion, 'HAPPY')
            condition = 5; % GenderHappy
        elseif strcmp(target, 'GENDER') && strcmp(emotion, 'NEUTRAL')
            condition = 6; % GenderNeutral
        else
            continue
        end

        % Store onset matrix
        onsetMatrix(block, counter(block,condition), condition) = onset;
        counter(block,condition) = counter(block,condition) + 1;
    end
end

%% Condition names
conditionName = {'EmoFear', 'EmoHappy', 'EmoNeutral','GenderFear', 'GenderHappy', 'GenderNeutral'};
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

    for condition = 1:6
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

% Fear > Happy (over beide taken gemiddeld)
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Fear > Happy';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1 0 1 -1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';

% Happy > Fear (over beide taken gemiddeld)
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Happy > Fear';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1 0 -1 1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'repl';

% Fear > Neutral (over beide taken gemiddeld)
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Fear > Neutral';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [1 0 -1 1 0 -1 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'repl';

% Neutral > Fear (over beide taken gemiddeld)
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Neutral > Fear';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 0 1 -1 0 1 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'repl';

% Happy > Neutral (over beide taken gemiddeld)
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Happy > Neutral';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [0 1 -1 0 1 -1 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'repl';

% Neutral > Happy (over beide taken gemiddeld)
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Neutral > Happy';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 -1 1 0 -1 1 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'repl';

% Emotion taak > Gender taak
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'EmoTask > GenderTask';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [1 1 1 -1 -1 -1 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'repl';

% Gender taak > Emotion taak
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'GenderTask > EmoTask';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [-1 -1 -1 1 1 1 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'repl';

matlabbatch{3}.spm.stats.con.delete = 1;

% Run the batch
spm_jobman('run', matlabbatch);
end