# STOP-IT

Here we provide open-source software that can be used to execute a stop-signal task and analyze the resulting data, in an easy-to-use way that complies with the recommendations described in "Capturing the ability to inhibit actions and impulsive behaviors: A consensus guide to the stop-signal task".

### Execute the stop-signal task
To run the stop-signal task, download the jsPsych folder, and simply open the experiment.html file in Firefox or Chrome browser. This will start the program. 

### Analyse the data of the stop-signal task

To analyse the data produced by the jsPsych program:

- Step 1: Install R (https://www.r-project.org)
- Step 2: Open the R console and type "install.packages('shiny’)”. You may have to restart R at this point. 
- Step 3: Type in the R console "shiny::runGitHub('STOP-IT', 'fredvbrug', launch.browser = TRUE, subdir = 'jsPsych_version')"

Note that Steps 1 and 2 can be skipped if you have already installed R and the shiny. 
