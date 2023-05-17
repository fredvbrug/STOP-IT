library(shiny)

ui <- fluidPage(
  titlePanel("SSRT estimator"),
  fluidRow(

    column(3,
           h1("Input"),

           # Input: specify if we should include fullscreen trials only
           h4("Step 1: Trial inclusion criteria"),
           radioButtons("scr", "Fullscreen trials only?",
                        choices = c(Yes = "yes",
                                    No = "no"),
                        selected = "yes"),

           # Include clarifying text ----
           helpText("By default, the experiment is run in fullscreen mode.
                    This can be changed by the experimenter or participant (during the experiment).
                    You can choose to include only fullscreen trials.
                    Trials on which the focus was not on the screen are automatically excluded."),

           br(),
           h4("Step 2: Upload the data"),
           fileInput("csvs", label=NULL, multiple = TRUE),

           # Include clarifying text ----
           helpText("Use the browse function to upload all the data files.
                    You can upload all requested files at once
                    (when running the Shiny app via a browser)."),


           br(),
           h4("Step 3: Process the data"),
           actionButton("process", "Click here to process data"),

           conditionalPanel("input.process",
                            br(),
                            br(),
                            h4("Optional"),
                            downloadButton('downloadBeest', "Data for parametric tests"), # download button

                            helpText("You can use this option to put the raw data
                                     in the appropriate format for further parametric testing.")
           )
    ),

    column(7,
           conditionalPanel("input.process",
                            h1("Output"),
                            plotOutput(outputId = "main_plot", height = "300px"),
                            h4("Summary"),
                            downloadButton('downloadSummary', "Download table"), # download button
                            tableOutput('summary'),
                            br(),
                            h4("Individual data"),
                            downloadButton('downloadIndividuals', "Download table"), # download button
                            tableOutput('table'))
    )
  )
)



server <- function(input, output) {
  data<-eventReactive(input$process,({
    do.call("rbind", (lapply(input$csvs$datapath, function(i){
      read.csv(i, header=TRUE, na.strings=c("null"), colClasses=c("correct"="factor"))})))
  }))


  processed<-reactive({
    nsubjects <- unique(data()$participantID)
    for (i in nsubjects){
      # select the relevant experimental data for the participant
      dataset<-reactive({subset(data(), data()$participantID == i & data()$block_i > 0)})

      # exclude trials when participant is not focusing
      if (input$scr == 'yes'){
        dataset.focus <-reactive({subset(dataset(), dataset()$focus == 'focus'
                                         & dataset()$Fullscreen == 'yes')})}
      else{
        dataset.focus <-reactive({subset(dataset(), dataset()$focus == 'focus')})
      }

      # stop-signal trials
      stopsignal<-reactive({subset(dataset.focus(), dataset.focus()$signal == 'yes')})
      Nstop <- nrow(stopsignal())

      tmp <- ifelse(stopsignal()$response == "undefined", 0, 1)
      presp <- mean(tmp)
      ssd <- round(mean(stopsignal()$SSD))

      stopsignal.resp.trials <- reactive({subset(stopsignal(), stopsignal()$response != "undefined")})
      usRTtmp <- stopsignal.resp.trials()$rt 
      usRTtmp[is.na(usRTtmp)] <- -250      
      usRT <- round(mean(usRTtmp))

      # go trials
      go<-reactive({subset(dataset.focus(), dataset.focus()$signal == 'no')})
      Ngo <- nrow(go())

      go.resp.trials <- reactive({subset(go(), go()$response != "undefined")})
      goRTtmp <- go.resp.trials()$rt 
      goRTtmp[is.na(goRTtmp)] <- -250  
      goRT_all <- round(mean(goRTtmp))
      goRT_sd <- round(sd(goRTtmp))

      goRT.max <- max(go.resp.trials()$rt)
      goRT.adj <- ifelse(go()$response == "undefined", goRT.max, go()$rt)
      nth <- as.vector(round(quantile(goRT.adj, probs = presp, type = 6)))

      go.correct.trials <- reactive({subset(go(), go()$correct %in% c("true", "TRUE"))})
      goRT_correct <- round(mean(go.correct.trials()$rt))

      go_omission <- 1 - (nrow(go.resp.trials())/Ngo)
      go_error <-  1 - (nrow(go.correct.trials())/nrow(go.resp.trials()))

      premature.trials <- reactive({subset(go(), go()$rt < 0)})
      go_premature <- (nrow(premature.trials())/Ngo)
      
      # calculate SSRT
      ssrt <- nth - ssd

      # combine everything
      dp.subject <- data.frame(presp, ssd, ssrt, usRT, goRT_all, goRT_correct, goRT_sd,
                               go_omission, go_error, go_premature, Nstop, Ngo, subject=i)
      if (exists("dp.all")==FALSE){
        dp.all <- dp.subject
      }else{
        dp.all <- rbind(dp.all,dp.subject)
      }
    }
    dp.all
  })

  # table with the processed data for all subjects
  output$table <- renderTable({
    processed()
  })

  # generate a summary of the dataset
  datasum <-reactive({
    dataset <- reactive({data.frame(processed(), row.names = NULL)})
    dataSummary <- function(data){
      dataSummary.output <- cbind(mean = round(mean(data),2),
                                  min = round(min(data),2),
                                  q25= round(quantile(data, 0.25),2),
                                  median = round(median(data),2),
                                  q75 = round(quantile(data, 0.75),2),
                                  max = round(max(data),2))
      return(dataSummary.output)
    }
    s.table <- rbind (dataSummary(dataset()$presp),
                      dataSummary(dataset()$ssd),
                      dataSummary(dataset()$ssrt),
                      dataSummary(dataset()$usRT),
                      dataSummary(dataset()$goRT_all),
                      dataSummary(dataset()$goRT_correct),
                      dataSummary(dataset()$goRT_sd),
                      dataSummary(dataset()$go_omission),
                      dataSummary(dataset()$go_error),
                      dataSummary(dataset()$Nstop),
                      dataSummary(dataset()$Ngo)
    )
    dvs <- c('presp', 'ssd', 'ssrt', 'usRT', 'goRT.all', 'goRT.correct', 'goRT.intra.sd',
             'go.omission', 'go.choice.error', 'Nstop', 'Ngo')
    s.table <- cbind (variable = dvs, s.table)
    s.table
  })

  output$summary <- renderTable({
    datasum()
  })

  # figure with the distribution of SSRTs
  output$main_plot <- renderPlot({
    tmp <- reactive({data.frame(processed(), row.names = NULL)})
    hist(tmp()$ssrt, xlab="Stop-signal reaction times (SSRT)", main='SSRT distribution')
  })

  # ---- files for downloads
  # individual data
  #downloadHandler() takes two arguments: filename and content.
  output$downloadIndividuals <- downloadHandler(
    filename = "stop_individual_data.csv",
    content = function(file) {write.table(processed(), file, sep = ",", row.names = FALSE)}
  )

  # summary data
  #downloadHandler() takes two arguments: filename and content.
  output$downloadSummary <- downloadHandler(
    filename = "stop_summary_data.csv",
    content = function(file) {write.table(datasum(), file, sep = ",", row.names = FALSE)}
  )

  # also put the data in BEESTs-appropriate format
  dataBeest <-reactive({
  if (input$scr == 'yes'){
    data.focus <-reactive({subset(data(), data()$focus == 'focus' && data()$fullscreen == 'yes')})}
  else{
    data.focus <-reactive({subset(data(), data()$focus == 'focus')})
  }

  subj_idx <- data()$participantID
  ss_presented	<- ifelse(data()$signal == 'yes', 1, 0)
  tmp	<- ifelse(data()$correct == 'true', 1, 0)
  inhibited <- ifelse(data()$signal == 'no', -999, tmp)
  tmp <- data()$SSD
  ssd	<- ifelse(data()$signal == 'no', -999, tmp)
  tmp <- data()$rt
  rt	<- ifelse(data()$rt == 'NA', -999, tmp)

  beest.df <- data.frame(subj_idx, ss_presented, inhibited, ssd, rt)
  beest.df
  })

  output$Beest <- renderTable({
    dataBeest()
  })

  output$downloadBeest <- downloadHandler(
    filename = "stop_beest_data.csv",
    content = function(file) {write.table(dataBeest(), file, sep = ",", row.names = FALSE)}
  )

}


shinyApp(ui = ui, server = server)
