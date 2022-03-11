# Analysis of CRM task
Analysis of speech in noise perception task (CRM, an adaptive matrix-type task where listeners select two key words out of closed sets embedded in noise).
It computes the SRT based on the last 4 reversals.


This script computes the SRT from the output of a speech in noise task developed and available on Gorilla  (open material: https://app.gorilla.sc/openmaterials/171870) and published in  Bianco et al 2021 ('Reward enhances online participants’ engagement with a demanding auditory task'. Trends in Hearing
https://doi.org/10.1177/23312165211025941). 
In this task the overall level of the mixture (target speaker þ babble background) was kept fixed, with only the ratio between the target and masker changing on each trial.
The signal-to-noise ratio (SNR) between the babble and the target speaker was initially set to 20dB and was adjusted using a one-up one-down adaptive procedure, tracking the 50% correct threshold (Levitt, 1971). 
Initial steps were of 9dB SNR, decreasing by 2dB following the first two reversals and then fixed at a step size of 3 dB SNR for all subsequent trials. 
The procedure terminated after 7 reversals or after a total of 25 trials (the latter was never reached). 
The SRT for one run was calculated as the mean of the SNRs in the last four reversals.

