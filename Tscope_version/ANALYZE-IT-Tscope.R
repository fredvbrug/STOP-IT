# R script to analyse the data of the original STOP-IT app. 
# In the csv file produced at the end of the script, you can find the following info:
# subject: subject number 
# presp: probability of responding on stop trials
# ssd: stop-signal delay
# SSRTint: SSRT estimated with the integration method
# usRT: RT on unsuccessful stop trials
# goRT_all: RT of go responses (including incorrect go responses)
# raceCheck: comparison of the mean RT on unsuccessful stop trials with the mean RT on go trials (should be larger than zero)
# goPmiss: Go omission 
# goERR: Choice errors on go trials
# goRT_correct: RT of correct go responses
# goRT_correct_sd: standard deviation for RTs of correct go responses


rm(list=ls()) # clear the working directory
library (reshape) # load library
library (Hmisc) # required for %nin%
library (plyr) # required for ddply

# --- STEP: open the data files ---
input <- data.frame()

# the data are in a subfolder labbeled 'data'
# change the next line if the data are stored somewhere else...
oldWD <- setwd("data") 

files <- dir(pattern = "stop-*") #files
for (i in files) {
	tmp <- read.table (i, header = T) #read the file
	
  #extract subject number
  labels <-  unlist(strsplit(files[match(i, files)], "-")) 
  subject_label <- unlist(strsplit(labels[2], "\\."))[1]
  tmp$subject <- as.numeric(subject_label)
  
  #add the content to the data frame
  input <- rbind (input, tmp)
	rm(tmp)
}

setwd(oldWD) # to go back to main folder


# --- STEP: make factors of the signal variable ---
input$signal <- factor(input$signal, levels = 0:1, labels = c('nosignal', 'signal'))

# --- STEP:  do some basic design checks ---
# check design
table(input$subject, input$signal)
table(input$subject, input$stim)

# --- STEP: create some new variables ---
# create new variable for calculation of p(correct)
input$acc <- ifelse(input$correct == 2, 1, 0)
input$miss <- ifelse(input$respons == 0, 1, 0) 
input$resp <- ifelse(input$respons > 0, 1, 0) 

table(input$acc, input$correct)
table(input$respons, input$resp)
table(input$respons, input$miss)

# --- STEP: in the original version, the first trial of a block was excluded ---
# uncomment the next line if you would like to do this again
# input <- subset(input, trial != '0')

# --- STEP:  analyse stop-signal data ---
# function to analyse stop-signal data at once...
funcSignal <- function(data){

    # signal data: prespond, ssd, true SSRT, and signal-respond RT
    signal <- subset(data, signal == 'signal')
    presp <-  mean(signal$resp)
    ssd <- mean(signal$ssd)

    signal.resp <- subset(signal, resp == '1')
    signal.resp.rt <- mean(signal.resp$rt)

    # subset no signal data: with and without missed responses
    # for the missed responses, set RT to max RT of the subject/condition
    nosignal <- subset(data, signal == 'nosignal')
    pmiss <- 1 - mean(nosignal$resp) # determine the actual probability of a missed go response
    nosignal_resp <- subset(nosignal, resp == '1')
    nosignal$rt <- ifelse(nosignal$rt == 0, max(nosignal_resp$rt), nosignal$rt)

    # --- estimate 1 --- all no-signal trials are INcluded when the nth RT is determined
    ## determine nth RT
    nthRT <- quantile(nosignal$rt, probs = presp, type = 6)

    ## SSRT(integration) = nthRT - ssd
    SSRTint <- nthRT - ssd

    #  --- estimate 2 ---  estimate SSRT with the mean method
    # DO NOT USE; included only for comparison purposes
    # mRT <- mean(nosignal_resp$rt)
    # SSRTmean <- mRT - ssd

    # Also calculate no-signal RT for go trials with a response,
    # and the difference with signal-respond RT
    nosignal.resp.rt <- mean(nosignal_resp$rt)
    race.check <- nosignal.resp.rt - signal.resp.rt

    # Return all data
    return(data.frame(presp = round(presp,3), 
                      ssd = round(ssd,0), 
                      # nthRT = round(nthRT,0), 
                      SSRTint = round(SSRTint,0), 
                      # SSRTmean = round(SSRTmean,0),
                      usRT = round(signal.resp.rt,0), 
                      goRT_all = round(nosignal.resp.rt,0), 
                      raceCheck = round(race.check,0), 
                      goPmiss = round(pmiss,3)))
}


signal.cast <- ddply(input, .(subject), funcSignal)

# --- STEP:  some extra no-signal data ---
# subset data
nosignal.input <- subset(input, signal == 'nosignal')

# create molten object 
nosignal.molten <- melt(nosignal.input, id.var = c('subject', 'correct', 'resp'), measure.var = c('acc', 'miss', 'rt'))

# calculate percent correct
# accuracy or p(correct) = correct trials / (correct trials + incorrect trials).
# trials without a response (or anticpatory responses) are omitted. 
acc.cast <- cast (nosignal.molten, subject ~ ., mean, subset = variable == "acc" &  resp == "1") 
names(acc.cast)[2] <- "acc"

# calculate RT for correct responses
rt.cast <- cast (nosignal.molten,  subject ~ ., mean, subset = variable == "rt" &  correct == "2") 
names(rt.cast)[2] <- "rt"

sd.rt.cast <- cast (nosignal.molten,  subject ~ ., sd, subset = variable == "rt" &  correct == "2") 
names(sd.rt.cast)[2] <- "sdrt"

# # --- STEP: combine all data and write to csv file ---
combined <- signal.cast
combined$goERR <- round(1-acc.cast$acc,3)
combined$goRT_correct <- round(rt.cast$rt,0)
combined$goRT_correct_sd <- round(sd.rt.cast$sdrt,0)

write.csv(combined, 'results.csv', row.names = F)