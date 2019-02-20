/**
 * custom-stop-signal-plugin for jsPsych
 * by Luc Vermeylen
 *
 * based on:
 * jspsych-image-keyboard-response
 * by Josh de Leeuw
 *
 * plugin for displaying two stimuli ('stimulus1' and 'stimulus2') with a certain
 * inter-stimulus-interval ('ISI') and getting one keyboard response to the whole trial
 * with a certain total trial duration ('trial_duration')
 *
 *
 **/


jsPsych.plugins["custom-stop-signal-plugin"] = (function() {

  var plugin = {};

  jsPsych.pluginAPI.registerPreload('custom-stop-signal-plugin', 'stimulus', 'image');

  plugin.info = {
    name: 'custom-stop-signal-plugin',
    description: '',
    parameters: {
      fixation: {
        type:  jsPsych.plugins.parameterType.IMAGE,
        pretty_name: 'Fixation Sign',
        default: undefined,
        description: 'The fixation to be displayed'
      },
      fixation_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Fixation duration',
        default: null,
        description: 'Duration of the fixation.'
      },
      stimulus1: {
        type: jsPsych.plugins.parameterType.IMAGE,
        pretty_name: 'First stimulus',
        default: undefined,
        description: 'The first image to be displayed'
      },
      stimulus2: {
        type: jsPsych.plugins.parameterType.IMAGE,
        pretty_name: 'Second stimulus',
        default: undefined,
        description: 'The second image to be displayed'
      },
      choices: {
        type: jsPsych.plugins.parameterType.KEYCODE,
        array: true,
        pretty_name: 'Choices',
        default: jsPsych.ALL_KEYS,
        description: 'The keys the subject is allowed to press to respond to the stimulus.'
      },
      prompt: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Prompt',
        default: null,
        description: 'Any content here will be displayed below the stimulus.'
      },
      ISI: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Stimulus duration',
        default: null,
        description: 'Inter-Stimulus-Interval (delay of the second stimulus).'
      },
      trial_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Trial duration',
        default: null,
        description: 'How long to show trial before it ends.'
      },
      response_ends_trial: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Response ends trial',
        default: true,
        description: 'If true, trial will end when subject makes a response.'
      },
    }
  }

  plugin.trial = function(display_element, trial) {

    // define the first and second image (note that u need to specify the id attribute as jspsych-image-keyboard-response-stimulus!)
    var fix = '<img src="'+trial.fixation+'"id="jspsych-image-keyboard-response-stimulus"></img>';
    var new_html = '<img src="'+trial.stimulus1+'" id="jspsych-image-keyboard-response-stimulus"></img>';
    var new_html_2 = '<img src="'+trial.stimulus2+'" id="jspsych-image-keyboard-response-stimulus"></img>';

    // add prompt
    if (trial.prompt !== null){
      new_html += trial.prompt;
    }

    // draw the first images
    display_element.innerHTML = fix;

    // store response
    var response = {
      rt: null,
      key: null
    };

    // function to end trial when it is time
    var end_trial = function() {

      // kill any remaining setTimeout handlers
      jsPsych.pluginAPI.clearAllTimeouts();

      // kill keyboard listeners
      if (typeof keyboardListener !== 'undefined') {
        jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
      }

      // gather the data to store for the trial
      var trial_data = {
        "raw_rt": response.rt,
        "rt": response.rt - trial.fixation_duration,
        "first_stimulus": trial.stimulus1,
        "second_stimulus": trial.stimulus2,
        "onset_of_first_stimulus": trial.fixation_duration,
        "onset_of_second_stimulus": trial.ISI + trial.fixation_duration,
        "key_press": response.key
      };

      // clear the display
      display_element.innerHTML = '';

      // move on to the next trial
      jsPsych.finishTrial(trial_data);
    };

    // function to handle responses by the subject
    var after_response = function(info) {

      // after a valid response, the stimulus will have the CSS class 'responded'
      // which can be used to provide visual feedback that a response was recorded
      display_element.querySelector('#jspsych-image-keyboard-response-stimulus').className += ' responded';

      // only record the first response
      if (response.key == null) {
        response = info;
      }

      if (trial.response_ends_trial) {
        end_trial();
      }
    };

    // start the response listener
    if (trial.choices != jsPsych.NO_KEYS) {
      var keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
        callback_function: after_response,
        valid_responses: trial.choices,
        rt_method: 'date',
        persist: false,
        allow_held_key: false
      });
    }

    if (trial.fixation_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        display_element.innerHTML = new_html;
      }, trial.fixation_duration)
    }

    // hide first stimulus if ISI is set and this is a stop trial (if stim1 and stim2 differ)
    if (trial.stimulus1 != trial.stimulus2){
      if (trial.ISI !== null) {
        jsPsych.pluginAPI.setTimeout(function() {
          display_element.innerHTML = new_html_2;
        }, trial.ISI + trial.fixation_duration);
      }
    }


    // end trial if trial_duration is set
    if (trial.trial_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        end_trial();
      }, trial.trial_duration + trial.fixation_duration);
    }

  };

  return plugin;
})();
