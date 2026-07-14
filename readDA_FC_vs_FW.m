function [mean_decoding_accuracies] = readDA_FC_vs_FW(cfg)

%% Define decoding analyses (must match your MVPA folder names)
decodingNames = {'WithinFear'};

%% Define ROIs to loop over
roiFilenames = {'LeftFFA2.nii', 'LeftSecVisual3.nii', 'LeftSecVisual4.nii'};
nROIs = length(roiFilenames);

%% Initialise output structure (per ROI, per decoding analysis)
for r = 1:nROIs
    [~, roiName] = fileparts(roiFilenames{r});
    for d = 1:length(decodingNames)
        mean_decoding_accuracies.(roiName).(decodingNames{d}) = [];
    end
end

%% Loop over subjects
for subject = cfg.subsToDo
    subjStr = num2str(subject,'%03i');

    for r = 1:nROIs
        roiFilename = roiFilenames{r};
        [~, roiName] = fileparts(roiFilename);

        %% Load ROI mask (moved inside loop so each ROI is loaded)
        roi_file = fullfile(cfg.roiMNIDir, roiFilename);
        roi_map  = spm_vol(roi_file);

        %% Reslice ROI once per subject/ROI
        ref_stat_file = fullfile( ...
            cfg.dataDir, ...
            ['emogen' subjStr], ...
            'MVPA', ...
            decodingNames{1}, ...
            'wres_accuracy_minus_chance.nii');

        %% Reslice ROI to match decoding map
        spm_reslice( ...
            {ref_stat_file, roi_map.fname}, ...
            struct('which',1,'mean',0));
        %% Read resliced ROI

        resliced_roi = spm_read_vols( ...
            spm_vol(fullfile( ...
            cfg.roiMNIDir, ...
            ['r' roiFilename])));

        %% Binary ROI

        roi_mask_bin = resliced_roi > 0;

        for d = 1:length(decodingNames)
            decodingName = decodingNames{d};

            %% Define results directory
            resultsDir = fullfile( ...
                cfg.dataDir, ...
                ['emogen' subjStr], ...
                'MVPA', ...
                decodingName);

            %% Load decoding map

            stat_file = fullfile( ...
                resultsDir, ...
                'wres_accuracy_minus_chance.nii');

            stat_map = spm_vol(stat_file);
            stat_img = spm_read_vols(stat_map);

            %% Extract ROI values

            roi_values = stat_img(roi_mask_bin);

            %% Compute mean accuracy

            mean_acc = mean(roi_values,'omitnan');

            %% Store result

       mean_decoding_accuracies.(roiName).(decodingName)(end+1) = mean_acc;

        end

    end
end

%% Display results

fprintf('\nMean decoding accuracies per subject:\n')

for r = 1:nROIs
    [~, roiName] = fileparts(roiFilenames{r});
    fprintf('\nROI: %s\n', roiName);
    for d = 1:length(decodingNames)
        name = decodingNames{d};
        fprintf('%s:\n', name);
        disp(mean_decoding_accuracies.(roiName).(name));
    end
end

end