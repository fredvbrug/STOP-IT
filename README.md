# STOP-IT

The stop-signal task is an essential tool for studying response inhibition and impulse control. In this task, participants typically perform a go task (e.g. press left when an arrow pointing to the left appears, and right when an arrow pointing to the right appears), but on a minority of the trials, a stop-signal (e.g. crosses replacing the arrow) appears after a variable stop-signal delay (SSD), instructing participants to suppress the imminent go response. The stop-signal task is unique in allowing the estimation of the covert latency of response inhibition (stop-signal reaction time or SSRT).

Here we provide open-source software that can be used to execute a stop-signal task and analyze the resulting data, in an easy-to-use way that complies with the recommendations described in "Capturing the ability to inhibit actions and impulsive behaviors: A consensus guide to the stop-signal task" (Verbruggen et al., 2019).

### Execute the stop-signal task
We provide platform-independent software to correctly execute the stop-signal task. It is programmed using jsPsych (De Leeuw, 2015)

The software is easily amendable, and can be used for offline and online studies. It replaces a previous version (described in Verbruggen, Logan, & Stevens, 2008) which is no longer maintained (and which could only be used on Windows computers). 

To install the stop-signal task, download the jsPsych folder. **We strongly recommend that you read the README-JS file before you start.** To run the stop-signal task, simply open 'experiment.html' in Firefox or Chrome browser, and follow the instructions.

### Analyse the data of the stop-signal task
Once you have collected data using the jsPsych program, you can analyse them using an R Shiny app.
To use this app:

- Step 1: Install R (https://www.r-project.org)
- Step 2: Open the R console and type "install.packages('shiny’)”. You may have to restart R at this point.
- Step 3: Type in the R console "shiny::runGitHub('STOP-IT', 'fredvbrug', launch.browser = TRUE, subdir = 'jsPsych_version')"

Note that Steps 1 and 2 can be skipped if you have already installed R and the shiny package. At the moment, the Shiny app only processes data collected with our jsPsych program.  


### References
de Leeuw, J. R. (2015). jsPsych: A JavaScript library for creating behavioral experiments in a Web browser. Behavior Research Methods, 47(1), 1–12. https://doi.org/10.3758/s13428-014-0458-y

Verbruggen, F., Logan, G. D., & Stevens, M. A. (2008). STOP-IT: Windows executable software for the stop-signal paradigm. Behavior Research Methods, 40(2), 479–483. https://doi.org/10.3758/BRM.40.2.479

Verbruggen, F., et al. (2019). Capturing the ability to inhibit actions and impulsive behaviors: A consensus guide to the stop-signal task.
