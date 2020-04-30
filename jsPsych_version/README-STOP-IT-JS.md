# STOP-IT-JS: The jsPsych version

STOP-IT jsPsych can be installed on local computers or on a web server, and is available under a GNU license. The software is based on the jsPsych (De Leeuw, 2015), which is *"a JavaScript library for running behavioral experiments in a web browser. The library provides a flexible framework for building a wide range of laboratory-like experiments."* We refer STOP-IT users to the jsPsych website (https://www.jspsych.org) for more information about jsPsych itself.

(Customised) jsPsych functions are used for randomization, timing, stimulus presentation, and response registration. In addition, standard JavaScript libraries and PHP scripts are used for the staircase tracking procedure and some additional features of the program, such as writing the data to an output file.

## Installation

**To ensure accurate timing, STOP-IT requires a Firefox or Chrome web browser.** To install STOP-IT jsPsych, simply download the jsPsych folder from https://github.com/fredvbrug/STOP-IT. This folder can be placed on a local computer (running Windows, macOS, or linux) or on a web server (e.g. "https://myownwebspace/").  

In the jsPsych folder, researchers can find the 'experiment.html' file, the 'app.R' file (see the README-ANALYSIS file for more information), and several folders:

- './configuration': this folder contains two files that researchers can adjust to change the design and certain parameters of the task (see below)
- './data': the data of all participants will automatically appear in this folder when in 'online' mode (see below)
- ./html': STOP-IT requires Firefox or Chrome (see above). When an unsupported browser is used, the 'not_supported.html' is opened. This might be relevant for online experiments using platforms such as Prolific or Mturk. The message in the html file can be adjusted.
- './images': this folder contains the stimuli used in the stop task. These can be adjusted (see below)
- './js': this folder contains the jsPsych library and other Javacript libraries that are required to run the program. These files should not be changed.
- './php': this folder contains the PHP script that is required to write the data to an output file on a web server. This script should not be changed.

The main advantages of this version of STOP-IT are (a) the version is platform-independent; (b) it can be used for both offline and online studies; and (c) there is no need for additional programming for basic use. Of course, more advanced users can adjust the source files when wanted or needed.

## The default stop-signal task

The primary go task is a simple two-choice task in which participants have to discriminate between a white arrow pointing to the left and a white arrow pointing to the right. On go trials (75% of the trials), participants have to respond as fast and accurate as possible to these arrows. On stop-signal trials (25% of the trials), the arrows turn red (i.e. a visual stop signal) after a variable delay, instructing participants to cancel their response.

### Stimuli and responses
The default go stimuli are two white arrows (RGB: 255, 255, 255), whith a black border (RGB = 0, 0, 0). The fixation sign (a black dot; RGB: 0,0,0) and arrows are presented in the center of the screen on a white background. Stimulus size will correspond to the size of the go stimuli in the './images' folder. Occasionally, a visual stop signal (the arrow turning red; RGB: 255,38,0) is presented shortly after the stimulus onset in the go task, replacing the (white) go stimulus. Again, the size of the default stop signal will depend on the size of the stop signal in the images folder. Researchers can change all stimuli by uploading new images in the './images' folder. Be aware that the file names should correspond to the names described in the 'experiment_variables.js' file (see below).

By default, the response keys are ‘leftarrow’ (for the stimulus associated with the left response) and ‘rightarrow’ (for the stimulus associated with the right response). The experiment is aborted when the ESC key is pressed and the browser window is closed.

### Procedure
The program starts with a welcome message, and the informed consent (which can be adjusted via the configuration folder). Depending on the settings (see below), participant ID is then entered. After this, participants are required to enter their age and gender, and the experiment switches to fullscreen mode. At this point, the task instructions are presented on the screen.

The experiment consists of two phases: a practice phase (one block of 32 trials) and an experimental phase (4 blocks of 64 trials). As we will outline below, some of these default numbers can be changed.

In both phases, each trial starts with the presentation of the fixation sign, which is replaced by the go stimulus after 250 ms. The stimulus remains on the screen until participants respond (using the predefined responses keys), or until 1,250 ms (i.e., the maximal RT) have elapsed. The default inter-stimulus interval is 750 ms and independent of RT. On stop trials, a stop signal is presented after a variable SSD. SSD is initially set to 300 ms and is adjusted continuously with the staircase tracking procedure: when inhibition is successful, SSD increases by 50 ms; when inhibition is unsuccessful, SSD decreases by 50 ms. Response registration continues during stop-signal presentation.

During the practice phase, immediate feedback is presented for 750 ms:

- 'incorrect response' when participants execute the incorrect response on go trials (choice error)
- 'too slow' when participants do not respond on go trials (go omission)
- 'too fast' when participants press a response key before the go stimulus is presented (premature response)
- 'remember: try to stop' when participants execute a response on a stop trial (unsuccessful stop)

Between each block, subjects have to wait for 15 seconds before they can start the next block. During this interval, participants will receive information about their performance in the last block: the mean RT on go trials, the number of go omissions (with a reminder that this value should be 0), and the percentage of correctly cancelled responses on stop trials (with a reminder that this value should be close to .50).


### Output files
The results are written to a data file that is stored in the data folder.
The data file is a csv file (‘SST_data_ID.csv’, where ID corresponds to the participant number), which can be opened in Microsoft Excel or statistical-software packages such as R and SPSS. STOP-IT will never overwrite data files; when a data file already exists (i.e., the participant number was already used), the new data will be appended to the existing file. When data files need to be replaced (e.g., because a participant did not complete the experiment), the user can manually delete the data file with the basic file system utilities.

The data file consists of the following information:
- participantID: participant number
- age: age of the participant
- gender: gender of the participants (default options: female, male, other, prefer not to say)
- block_i: block number. 'block = 0' is always the practice block
- trial_i: trial number (within a block)
- stim: which go stimulus was presented?
- signal: was a stop signal presented or not (yes = stop trial; no = go trial)
- SSD: stop-signal delay (in ms)
- response: which go response was executed on the trial (left or right response. Undefined = no response).
- RT: latency of the go response in ms (null: no response was registered). Negative values indicate that the participant pressed a key during the fixation interval (i.e. before the presentation of the go stimulus).
- Correct: was the trial correct (TRUE) or not (FALSE). A correct go trial requires a correct response; a correct stop trial requires no response.
- Focus: did the participant interact with the experiment, as determined by jsPsych (see https://www.jspsych.org/core_library/jspsych-data/#jspsychdatagetinteractiondata for further information).
- Fullscreen: was the experiment run in fullscreen mode or not?
- time_elapsed: total time elapsed since the start of the experiment (can be useful for debugging purposes)
- browser_name: name of the browser used to run the experiment
- browser_version: version number of the browser used to run the experiment
- os_name: name of the operating system used to run the experiment
- os_version: version of the operating system
- tablet: was the experiment run via a tablet or not ('undefined' = a computer was used)?
- mobile: was the experiment run via a mobile  or not ('undefined' = a computer was used)?
- screen_resolution: resolution of the screen
- window_resolution: resolution of the window (if fullscreen: screen and window resolution will correspond)

When the experiment is hosted on a web server (i.e. online experiments), the data will be automatically written to the data file (stored in the data folder) after every trial. Thus, **data will be available when online experiments are aborted before the end**. For experiments that are hosted on a local computer (i.e. offline experiments), data will be written to the data file at the end of the experiment. Thus, **no data are saved if local experiments are aborted before the end**. When the data are stored, a Download window will open (in the browser) and researchers can select the data folder.

## The Configuration File
The task can be used immediately after installation. However, users can adjust some of the default values of the task. This can be done by opening the 'experiment_variables.js' and 'text_variables.js' files (which can be found in the './configuration' folder) in a text editor (such as Notepad).

**The default values comply with the recommendations described in "Capturing the ability to inhibit actions and impulsive behaviors: A consensus guide to the stop-signal task" (Verbruggen et al., 2019). Please read this guide carefully before adjusting any of the values (the design variables in particular).**


### Experiment variables

Researchers can change the values of certain experimental variables. The structure of file is always the same:
var NAME = VALUE. Researchers can change the VALUE but they should not change 'var NAME' (unless they also change the code in the 'experiment.html') file.

#### Stimuli and responses
- *var fix_stim = 'images/fix.png'*: adjust VALUE if location and name of the fixation image is altered.
- *var go_stim1 = 'images/go_left.png'*: adjust VALUE if location and name of the go stimulus associated with the left response is altered.
- *var go_stim2 = 'images/go_right.png'*: adjust VALUE if location and name of the go stimulus associated with the right response is altered.
- *var stop_stim1 = 'images/stop_left.png'*: adjust VALUE if location and name of the left stop signal stimulus is altered.
- *var stop_stim2 = 'images/stop_right.png'*: adjust VALUE if location and name of the right stop signal stimulus is altered.
- *var cresp_stim1 = 'leftarrow'*: adjust VALUE to change the left response key
- *var cresp_stim2 = 'rightarrow'*: adjust VALUE to change the right response key
- *var choice_stim1 = 'left'*: adjust VALUE to change the label (in the data file) of the go stimulus associated with the left response
- *var choice_stim2 = 'right'*: adjust VALUE to change the label (in the data file) of the go stimulus associated with the right response

The images themselves can be adjusted by replacing the .png files in the image folder. The names of the images and the values defined in this 'experiment_variables.js' file (see below) should correspond.

There are separate image files for the stop signal that will replace the left go stimulus, and the stop signal that will replace the right go stimulus.

##### Design variables
In the first step, researchers can adjust the proportion of stop signals:

- *var nprop = 1/4*: adjust VALUE to change the proportion of stop signals in the experiment. The following values are allowed: 1/6, 1/5, 1/4, 1/3. 1/4 = default (recommended) value.

The proportion of stop signals is used to determine the number of trials in the basic design. More specifically, the number of trials of the basic design = 2 (number of go stimuli) / proportion of stop signals. For example, when *var nprop* = 1/4 (or .25), then the basic design contains 8 trials (2 x 4).

In a second step, researchers can determine how many times the basic design should be repeated per block. This can be done separately for the practice block and the experimental block (although the number of trials in a practice block can never be higher than the number of trials in an experimental block). This value will then be multiplied by the number of trials in the basic design to determine the total number of trials within a block. For example, when *var NdesignReps_exp = 8* and *var nprop = 1/4* (see above), the number of trials per block = 64 (8 x 2 x 4).

- *var NdesignReps_practice = 4*: adjust this VALUE to change the number of trials within a practice block.
- *var NdesignReps_exp = 8*: adjust this VALUE to change the number of trials within an experimental block.

In a third step, researchers can alter the number of experimental blocks.

- *var NexpBL = 4*: adjust this VALUE to change the number of experimental blocks.

##### Time intervals
All time intervals are in ms.

- *var ITI = 500*: adjust this VALUE to change the duration of the blank intertrial interval
- *var FIX = 250*: adjust this VALUE to change the duration of the fixation presentation
- *var MAXRT = 1250*: adjust this VALUE to change the maximum reaction time
- *var SSD = 200*: adjust this VALUE to change the start value for the SSD tracking procedure; this value will be updated throughout the experiment.
- *var SSDstep = 50*: adjust this VALUE to change the step size of the SSD tracking procedure; this is also the lowest possible SSD.
- *var iFBT = 750*: adjust this VALUE to change the duration of the immediate feedback interval (during the practice phase)
- *var bFBT = 15000*: adjust this VALUE to change the duration of the break interval between blocks

##### Participant ID
There are three different ways to determine the participant number for the file names:

- ID via *participant* (e.g. when the participant gets a number via experimenter)
- ID via the *url* of the experiment: 'XXXX.html?subject=15'(subject is the current keyword)
- determine ID at *random* with jsPsych.randomization.randomID().

The value is determined via *var id*:
- *var id = 'random'*: use 'participant', 'url', or 'random'

##### Screen variables

- *var fullscreen = true*: run the experiment in fullscreen mode or not?
- *var minWidth = 800*: adjust this VALUE to change the minimum width of the experiment window
- *var minHeight = 600*: adjust this VALUE to change  minimum height of the experiment window

##### End-of-experiment redirection
Researchers can redirect participants to another URL when the experiment ends (useful for redirecting to e.g. Prolific or MTurk)

- *var redirect_onCompletion = false*: redirect (VALUE = true) or not (VALUE = false)
- *var redirect_link = 'https://osf.io'*: redirect link. **Importantly, always use https for links (including links to your own experiment).**


### Text variables

This file can be used to alter all text presented during the experiment. This includes:

- the instructions (note that the main instructions consist of two pages)
- the text of the informed consent
- the immediate feedback
- the feedback at the end of each block
- the labels on the buttons at the beginning of the experiment
- the welcome and end-of-experiment messages
- the gender options
- warning messages at the beginning of a block
