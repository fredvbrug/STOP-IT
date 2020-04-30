/* #########################################################################

  Customize the experiment

########################################################################## */

// ----- CUSTOMISE THE STIMULI AND RESPONSES -----
// locate the stimuli that will be used in the experiment
var fix_stim = 'images/fix.png';
var go_stim1 = 'images/go_left.png';
var go_stim2 = 'images/go_right.png';
var stop_stim1 = 'images/stop_left.png';
var stop_stim2 = 'images/stop_right.png';


// define the appropriate response (key) for each stimulus
// (this will also be used to set the allowed response keys)

var cresp_stim1 = 'leftarrow';
var cresp_stim2 = 'rightarrow';


// here you can change the names of the stimuli in the data file

var choice_stim1 = 'left';
var choice_stim2 = 'right';


// ----- CUSTOMISE THE BASIC DESIGN -----

// Define the proportion of stop signals.
// This will be used to determine the number of trials of the basic design (in the main experiment file):
// Ntrials basic design = number of stimuli / proportion of stop signals
// E.g., when nprop = 1/4 (or .25), then the basic design contains 8 trials (2 * 4).
// The following values are allowed: 1/6, 1/5, 1/4, 1/3. 1/4 = default (recommended) value

var nprop = 1/4;

// How many times should we repeat the basic design per block?
// E.g. when NdesignReps = 8 and nprop = 1/4 (see above), the number of trials per block = 64 (8*8)
// Do this for the practice and experimental phases (note: practice can never be higher than exp)

var NdesignReps_practice = 4;
var NdesignReps_exp = 8;

// Number of experimental blocks (excluding the first practice block).
// Note that NexpBl = 0 will still run the practice block

var NexpBL = 4;


// ----- CUSTOMISE THE TIME INTERVALS (in milliseconds)-----

var ITI = 500;    // fixed blank intertrial interval
var FIX = 250;    // fixed fixation presentation
var MAXRT = 1250; // fixed maximum reaction time
var SSD = 200;    // start value for the SSD tracking procedure; will be updated throughout the experiment
var SSDstep = 50; // step size of the SSD tracking procedure; this is also the lowest possible SSD
var iFBT = 750;   // immediate feedback interval (during the practice phase)
var bFBT = 15000; // break interval between blocks


// ----- CUSTOMISE INPUT/OUTPUT VARIABLES -----
// participant ID:
// - ID via participant (e.g. when the participant gets a number via experimenter)
// - ID via the URL of the experiment: 'XXXX.html?subject=15'(subject is the current keyword)
// - determine ID at random with jsPsych.randomization.randomID().

var id = 'random' // use one of these three options: 'participant', 'url', 'random'


// ----- CUSTOMISE SCREEN VARIABLES -----
// Please note that Safari does not support keyboard input when in full mode!!!
// Therefore, this browser will be excluded by default

var fullscreen = true; // Fullscreen mode or not?
var minWidth = 800; // minimum width of the experiment window
var minHeight = 600; // minimum height of the experiment window


// ----- CUSTOMISE END-OF-EXPERIMENT REDIRECTION -----
// !!!!! use https ! (and link to your own experiment with https)
// should we redirect to another URL when the experiment ends? (useful for redirecting to e.g. Prolific or MTurk)

var redirect_onCompletion = false;
var redirect_link = 'https://osf.io'
