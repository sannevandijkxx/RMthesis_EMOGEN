Dear reader,

In this Github, you can find all the scripts and code I used to do my analysis for my Research Master thesis.

MATLAB FILES:
AnalysisThesis parts 1-8 are different parts of the masterscript that calls on the function scripts.

There are 5 BuildGLM scripts:
- BuildGLMWithinHappy, BuildGLMWithinFear, and BuildGLMCrossFvsH were used to compare fear and happiness with neutral.
- BuildGLMWithinFvsH and BuildGlmCrossFrvsHP were used to compare happiness and fear.

There are 6 Decoding scripts:
- DecodeWithinFear, DecodeWithinHappy, DecodeCrossFear, and DecodeCrossHappy were used to compare fear and happiness with neutral.
- DecodeWithinFvsH and DecodeCrossFvsH were used to compare happiness and fear.

There are 4 ROI files, one for each condition: Within and Cross fear versus neutral, and Within and Cross happy versus neutral

Similarly, there are 4 readDA files: 
- each one tests the ROIs from the within condition on the decoding of the cross condition
- This is done for both fear and happiness

normalise.m normalizes the data and groupLevelAnalysis performs a group-level SPM analysis of MVPA classification accuracy.

RStudio files
- FvsN and HvsN Frequency: Frequentist t-test for happy and fear versus neutral
- FvsN and HvsN Bayesian: Bayesian t-tests for happy and fear versus neutral
- FvsH Frequentist: Frequentist t-tests for happy versus fear
- FvsH Bayesian: Bayesian t-tests for happy versus fear

# RMthesis_EMOGEN
