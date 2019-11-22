# ANALYZE-IT-JS: Analyze the data of STOP-IT jsPsych using app.R

*app.R*  in the jsPsych folder can be used to analyze the data produced by the jsPsych version of STOP-IT, and is available under a GNU license. The software uses Shiny, *"an open source R package that provides an elegant and powerful web framework for building web applications using R."* For general information about Shiny, see https://www.rstudio.com/products/shiny/

## Installation

For data-protection reasons, the analysis program has to run locally. The installation requires only two simple steps:

- Step 1: Install R (https://www.r-project.org)
- Step 2: Open the R console and type "install.packages('shiny’)”. Restart R.

Note that Steps 1 and 2 can be skipped if R and the shiny package are already installed.

## How to use the app?

- Step 1: Open R, and type in the console: **shiny::runGitHub('STOP-IT', 'fredvbrug', launch.browser = TRUE, subdir = 'jsPsych_version')**. This will open a local version of the app in the default web browser.
- Step 2: Provide the required input.
  - Step 2a: Indicate whether the program should include all trials or only trials in fullscreen mode. By default, the experiment is run in fullscreen mode, but this can be changed by the experimenter or participant (during the experiment). Note that trials on which the participant did not interact with the experiment window (see the README-STOP-IT-JS file) are automatically excluded.
  - Step 2b: Select the data files that should be processed. Multiple data files can be selected at once.
  - Step 2c: Click on the 'process data' button to process the selected data files.

Our analysis software complies with the recommendations described in "Capturing the ability to inhibit actions and impulsive behaviors: A consensus guide to the stop-signal task" (Verbruggen et al., 2019), and stop-signal reaction time (SSRT) is estimated using the integration method (with replacement of go omissions). We refer researchers to this guide for detailed information about the estimation procedure. Note that the program (*app.R*) uses the Type-6 quantile method to determine the nth RT (for more information, see https://stat.ethz.ch/R-manual/R-devel/library/stats/html/quantile.html).

Once the data are processed, users will immediately get an overview. There are three output panels:

- The figure panels plots the SSRT distribution
- The table in the 'Summary' panel provides a general summary of the main dependent variables.
- The table in the 'Individual data' panel shows the main dependent variables for each individual.

In both table panels, there are 11 dependent variables:
- presp = p(respond|signal) = probability of responding on a stop trial. P(respond|signal) is also used to determine SSRT.
- ssd = stop-signal delay = the average delay between the presentation of the go stimulus and the stop-signal (in ms)
- ssrt = stop-signal reaction time = how long does it (on average) take to stop a response (in ms)?
- usRT = RT on unsuccessful stop trials (in ms)
- goRT_all = reaction time (RT) on go trials with a response (in ms). This includes choice errors.
- goRT_correct = reaction time (RT) on go trials with a correct response (in ms). Choice errors are excluded.
- goRT_sd = intra-subject variability in response latencies (including all go trials with a response)
- go_omission = proportion of go trials without a response
- go_error = proportion of incorrect responses on go trials with a response (e.g. the go stimulus required a left response but a right response was executed).
- go_premature = proportion of premature responses on go trials (i.e. responses executed before the presentation of the go stimulus)
- Nstop = number of stop trials included in the analyses
- NGo = number of go trials included in the analyses.

Note: to test the assumption of the independent race model (see Verbruggen et al., 2019), users should compare usRT with goRT_all (i.e. usRT < goRT_all). As explained in the consensus guide, the assumptions of the race model should be checked for each participant (and condition if there is more than one).

Note: 'go_omission' = the ratio of the number of omitted responses to the total number of go trials
[i.e., go_omission = 100 * omitted / (correct + error + omitted)] and 'go_error' = the ratio of
the number of incorrect responses to the number of correct and incorrect responses [i.e., go_error =
100 * incorrect / (correct + incorrect)]. See e.g. Verbruggen & Logan (2009, JEP:HPP) for a discussion.

The data shown in the tables can be downloaded via the corresponding buttons. Finally, there is a third download button, which appears in the 'Optional' panel. Users can use this button to transform the STOP-IT jsPsych output to a format that is appropriate for parametric testing. See http://dora.erbe-matzke.com/software.html for further information.
