shinyServer(function(input, output, session) {
  # update confirm button-------
  observeEvent(input$confirm, {
    updateButton(
      session,
      inputId = "confirm",
      label = "UPDATE SELECTION",
      icon = icon("bar-chart-o"),
      style = "success"
    )
  })

  # update reset button for PMID file input-----
  values <- reactiveValues(upload_state = NULL)

  observeEvent(input$file1, {
    values$upload_state <- 'uploaded'
  })

  observeEvent(input$reset, {
    values$upload_state <- 'reset'
  })

  file_input <- reactive({
    if (is.null(values$upload_state)) {
      return(NULL)
    } else if (values$upload_state == 'uploaded') {
      return(input$file1)
    } else if (values$upload_state == 'reset') {
      return(NULL)
    }
  })

  output$file1_ui <- renderUI({
    input$reset ## Create a dependency with the reset button
    fileInput('file1', label = NULL)
  })

  # Data - pmid.selected=getSelectID()------------

  getSelectID <- eventReactive(input$confirm, {
    # confirm buttons needs to be pressed to initiate this code
    isolate({
      selected.pub.type <- input$pub.type
      if (!is.null(input$journal)) {
        selected.journal <- input$journal
      } else {
        selected.journal <- raw.journal.all
      }

      selected.country <- input$country
      selected.language <- input$lanuage
      if (!is.null(input$mesh.or)) {
        selected.mesh.or <- input$mesh.or
      } else {
        selected.mesh.or <- raw.mesh.all
      }

      selected.mesh.and <- input$mesh.and
      selected.mindate <- input$dateRange[1]
      selected.maxdate <- input$dateRange[2]
      query.pmid <- input$query.pmid
      inFile <- file_input()$datapath

      if (!is.null(inFile)) {
        query.pmid2 <- read.csv(file = inFile) %>% .[, 1] %>% unlist(.)
        query.pmid <- base::union(query.pmid, query.pmid2)
      }

      pmid.selected <-
        list(
          pub.type = subset(pmid.pub.type, value %in% selected.pub.type)[, "pmid"],
          journal = subset(pmid.info, journal %in% selected.journal)[, "pmid"],
          country = subset(pmid.info, country %in% selected.country)[, "pmid"],
          language = subset(pmid.info, language %in% selected.language)[, "pmid"],
          mesh.or = subset(pmid.mesh, value %in% selected.mesh.or)[, "pmid"],
          date = subset(
            pmid.info,
            date <= selected.maxdate & date >= selected.mindate
          )[, "pmid"]
        )
      pmid.selected <- Reduce(intersect, pmid.selected)


      if (!is.null(selected.mesh.and) &
          length(pmid.selected) > 1) {
        mesh.and = subset(pmid.mesh,
                          pmid %in% pmid.selected &
                            value %in% selected.mesh.and) %>% .[, 1] %>% table %>% .[. == length(selected.mesh.and)]

        pmid.selected <-
          mesh.and %>% names %>% as.integer %>% intersect(pmid.selected, .)

      }

      if (!is.null(query.pmid)) {
        if (input$pmid.rule == "OR") {
          pmid.selected <- base::union(pmid.selected, query.pmid)
        } else
        {
          if (length(pmid.selected) > 1) {
            pmid.selected <- intersect(pmid.selected, query.pmid)
          }
        }
      }
      pmid.selected

    })
  })
  ## Data - getCount()------
  getCount <- eventReactive(input$confirm, {
    pmid.selected <- getSelectID()
   plot.data = NULL
    if (length(pmid.selected) > 0) {
      plot.data <- subset(pmid.info, pmid %in% pmid.selected)[, c("date","pmid")]  %>% group_by(., date) %>% summarise(n = n())
      plot.data <- data.frame(plot.data, ncum = cumsum(plot.data$n))

    }
    return(plot.data)
  })

  ## output$pub.count.new----
  output$pub.count.new <- renderPlot({

    if (length(getSelectID()) > 0) {
      plot.data <- getCount()
      plot(x=plot.data$date,y=plot.data$n,xlab="Date",ylab="Daily New Publications")
    }
  })

  output$pub.count.all <- renderPlot({
    if (length(getSelectID()) > 0) {
      plot.data <- getCount()
      plot(x=plot.data$date,y=plot.data$ncum,xlab="Date",ylab="Total Publications")
    }
  })
  ##ouput box values----------
  output$pubBox <- renderValueBox({
    t = 0
    if (!is.null(getSelectID())) {
      t = length(getSelectID())
    }
    valueBox(
      #value = paste0(length(getSelectedData()[["pmid.selected"]]), "/", nrow(pmid.info)),
      value = tags$p(paste0(t, "/", nrow(pmid.info)), style = "font-size: 50%;"),
      subtitle = "Publications",
      color = "red"
      #icon = icon("copy","fa-0.5x")
    )
  })

  output$meshBox <- renderValueBox({
    t = 0
    if (!is.null(getSelectID()) & !is.null(getMesh())) {
      t = nrow(getMesh())
    }
    valueBox(
      value = tags$p(paste0(t, "/", length(
        unique(pmid.mesh$value)
      )), style = "font-size: 50%;"),
      subtitle = "MeSH",
      color = "yellow"
      #icon = icon("key","fa-0.5x")
    )
  })

  output$cpairBox2 <- renderValueBox({
    t = 0
    if (!is.null(getCnet()[["cnet.edges"]])) {
      t = nrow(getCnet()[["cnet.edges"]])
    }
    valueBox(
      value = tags$p(paste0(t, "/", nrow(cnet)), style = "font-size: 50%;"),
      subtitle = "Citation Pairs",
      color = "green"
      #icon = icon("atom","fa-0.5x")
    )
  })

  ## output$country.map----------
  output$country.map <- renderLeaflet({
    pmid.selected <- getSelectID()
    plot.data <-
      table(subset(pmid.info, pmid %in% pmid.selected)[, "country"])
    plot.data <-
      plot.data[setdiff(names(plot.data), c("Not available", "International"))]

    if (length(plot.data) > 0) {
      if (length(plot.data) == 1) {
        mybins = c(max(plot.data) - 1, max(plot.data))
      } else {
        mybins <- c(unique(round(quantile(
          plot.data, probs = seq(0, 1, 0.1)
        ))))
        mybins[length(mybins)] = max(plot.data)
      }


      # Prepare the text for tooltips:

      v <- rep(0, length = length(world_spdf@data$NAME))
      tmp = match(names(plot.data), world_spdf@data$NAME)
      v[tmp[which(!is.na(tmp))]] = plot.data[which(!is.na(tmp))]
      v[v == 0] = NA

      mypalette <-
        colorBin(
          palette = colorpal,
          domain = v,
          na.color = "transparent",
          bins = mybins
        )
      mytext <- paste("Country: ",
                      world_spdf@data$NAME,
                      "<br/>",
                      "Publications: ",
                      v,
                      "<br/>",
                      sep = "") %>%
        lapply(htmltools::HTML)
      # Final Map
      m <- leaflet(world_spdf) %>%
        addTiles()  %>%
        setView(lat = 10,
                lng = 0 ,
                zoom = 2) %>%
        addPolygons(
          fillColor = ~ mypalette(v),
          stroke = TRUE,
          fillOpacity = 0.9,
          color = "white",
          weight = 0.3,
          label = mytext,
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "13px",
            direction = "auto"
          )
        ) %>%
        addLegend(
          pal = mypalette,
          values =  ~ v,
          opacity = 0.9,
          title = "Publications",
          position = "bottomleft"
        )
      m
    }

  })
  # Data- mesh.count-------
  getMesh <- eventReactive(input$confirm, {
    # confirm buttons needs to be pressed to initiate this code


    pmid.selected <- getSelectID()
    plot.data = NULL
    if (!is.null(pmid.selected) & length(pmid.selected) > 0) {
      plot.data <- subset(pmid.mesh, pmid %in% pmid.selected)
      plot.data <- table(plot.data$value) %>% as.data.frame()
      colnames(plot.data) <- c("mesh", "count")
      plot.data <- arrange(plot.data, desc(count))
      if (sum(plot.data$mesh == "not available") > 0) {
        plot.data <- plot.data[-which(plot.data$mesh == "not available"), ]
      }

    }
    return(plot.data)

  })
  ## output$mesh.wordcloud------
  output$mesh.wordcloud <- renderWordcloud2({
    # wordcloud2(demoFreqC, size=input$size)
    plot.data <- getMesh()

    if (!is.null(plot.data)) {
      wordcloud2(plot.data[input$mesh.rank[1]:input$mesh.rank[2], ], size = input$mesh.size)
    }
  })


  ##output$mesh.trend.plot--------
  output$mesh.trend.plot <- renderPlotly({
    pmid.selected <- getSelectID()

    if (length(pmid.selected) > 0) {
      termMesh <-
        getMesh()

      if (!is.null(termMesh)) {
        topMesh <-
          termMesh[input$mesh.rank2:min(nrow(termMesh), (input$mesh.rank2 + 9)), 1]
        plot.data <-
          unique(subset(pmid.info, pmid %in% pmid.selected)[, c("pmid", "date")])

        plot.data <-
          merge(
            plot.data,
            subset(pmid.mesh, pmid %in% pmid.selected &
                     value %in% topMesh),
            by.x = "pmid",
            by.y = "pmid"
          )
        plot.data <- split(plot.data, plot.data$value)
        plot.data <- lapply(plot.data, function(k) {
          k <-
            k[, c("pmid", "date")] %>% group_by(., date) %>% summarise(n = n())
          k <- data.frame(k, ncum = cumsum(k$n))
          return(k)
        })
        plot.data <- bind_rows(plot.data, .id = "mesh")
        plot.data$mesh <-
          factor(plot.data$mesh, levels = topMesh)

        plot_ly(plot.data,
                type = 'scatter',
                mode = 'lines',
                colors = plotlypal) %>% add_trace(
                  x = ~ date,
                  y = ~ ncum,
                  color = ~ mesh,
                  mode = 'lines+markers'
                ) %>% layout(
                  xaxis = list(title = "Date", titlefont = plotlyf),
                  yaxis = list(title = "Total Publications", titlefont = plotlyf)
                )
      }
    }
  })
  # output$languagePlot-----
  output$languagePlot <- renderPlotly({
    pmid.selected <- getSelectID()
    if (length(pmid.selected) > 0) {
      plot.data <-
        subset(pmid.info, pmid %in% pmid.selected)[, c("date", "language")]
      plot.data <- split(plot.data, plot.data$language)
      plot.data <- lapply(plot.data, function(k) {
        k <-
          k %>% group_by(., date) %>% summarise(., n = n()) %>% as.data.frame()
        k <- data.frame(k, ncum = cumsum(k$n))
        return(k[, c("date", "ncum")])
      })
      plot.data <- bind_rows(plot.data, .id = "language")

      plot_ly(plot.data,
              type = 'scatter',
              mode = 'lines',
              colors = plotlypal) %>% add_trace(
                x = ~ date,
                y = ~ ncum,
                color = ~ language,
                mode = 'lines+markers'
              ) %>% layout(
                xaxis = list(title = "Date", titlefont = plotlyf),
                yaxis = list(title = "Total Publications", titlefont = plotlyf)
              )
    }


  })
  # output$journalPlot-------
  output$journalPlot <- renderPlotly({
    pmid.selected <- getSelectID()
    if (!is.null(input$journal)) {
      selected.journal <- input$journal
    } else {
      selected.journal <- raw.journal.all
    }
    if (length(pmid.selected) > 0) {
      plot.data <-
        subset(pmid.info, pmid %in% pmid.selected)[, c("date", "journal")]
      plot.data <- split(plot.data, plot.data$journal)
      plot.data <- lapply(plot.data, function(k) {
        k <-
          k %>% group_by(., date) %>% summarise(., n = n()) %>% as.data.frame()
        k <- data.frame(k, ncum = cumsum(k$n))
        return(k[, c("date", "ncum")])
      })
      plot.data <- bind_rows(plot.data, .id = "journal")

      a <-
        plot.data[, c("journal", "ncum")] %>% group_by(., journal) %>% summarise(nmax = max(ncum)) %>%
        arrange(., desc(nmax)) %>% as.data.frame()
      if (nrow(a) >= 15) {
        a <- a[1:15, ]
      } else{
        a <- a[1:length(selected.journal), ]
      }
      a <- as.character(a$journal)
      if (length(selected.journal) > length(a)) {
        a <- a
      } else{
        a <- selected.journal
      }
      plot.data <- subset(plot.data, journal %in% a)
      plot.data$journal <-
        factor(plot.data$journal, levels = a)

      plotly::plot_ly(plot.data,
                      type = 'scatter',
                      mode = 'lines',
                      colors = plotlypal) %>% add_trace(
                        x = ~ date,
                        y = ~ ncum,
                        color = ~ journal,
                        mode = 'lines+markers'
                      ) %>% layout(
                        xaxis = list(
                          side = "top",
                          title = "Date",
                          titlefont = plotlyf
                        ),
                        yaxis = list(title = "Total Publications", titlefont = plotlyf),
                        legend = list(
                          orientation = "h",
                          # show entries horizontally
                          xanchor = "top",
                          # use center of legend as anchor
                          x = 0.5,
                          y = -10
                        )
                      )
    }
  })
  #output$table1-------
  output$table1 = DT::renderDataTable({
    pmid.selected <- getSelectID()
    if (length(pmid.selected) > 0) {
      t = subset(pmid.info, pmid %in% pmid.selected &
                   cited >= 0)[, c("pmid",
                                  "title",
                                  "cited",
                                  "journal",
                                  "language",
                                  "country",
                                  "date")] %>% .[order(.$cited, .$date, decreasing = T), ]
      colnames(t)[1]="PMID"

      DT::datatable(
        t[1:min(nrow(t), 100),],
        extensions = 'Buttons',
        options = list(dom = 'Bfrtip',
                       buttons = c('csv', 'excel')),
        rownames = FALSE
      )
    }
  })
  ## Data -getCnet()"cnet.degree","cnet.edges"-----------
  getCnet <- eventReactive(input$confirm, {
    #isolate({
    res <- vector("list", length = 2)
    names(res) <- c("cnet.degree", "cnet.edges")
    pmid.selected <- getSelectID()
    if (length(pmid.selected) > 0) {
      k <- subset(cnet,
                  source %in% pmid.selected |
                    target %in% pmid.selected) %>% unique
      if (nrow(k) > 1) {
        k.edges <- data.frame(k[, 1:2], arrows = "to", smooth = TRUE)
        colnames(k.edges)[1:2] <- c("from", "to")

        k.out <- as.data.frame(table(k.edges[, 1]))
        colnames(k.out) = c("pmid", "out")
        k.in <- as.data.frame(table(k.edges[, 2]))
        colnames(k.in) = c("pmid", "in")
        k.degree <- base::merge(k.in, k.out, all.x = T, all.y = T)
        k.degree[is.na(k.degree)] = 0
        k.degree$pmid <- as.integer(as.character(k.degree$pmid))

        k.degree$total = rowSums(k.degree[, c("in", "out")])

        net.ids <- k.degree$pmid

        k.degree <-
          merge(k.degree,
                pmid.info.extended[, c("pmid", "title", "LitCovid")],
                all.x = T)
        k.degree$selected <- FALSE
        k.degree$selected[is.element(k.degree$pmid, pmid.selected)] =
          TRUE

        k.degree <-
          k.degree %>% .[order(.$total, decreasing = T),]
        updateSelectInput(
          session,
          "cnet.show",
          selected = k.degree$pmid[1:3],
          choices = k.degree$pmid
        )
        res[["cnet.edges"]] <- k.edges
        res[["cnet.degree"]] <- k.degree


      }
    }
    return(res)
    #})

  })



  ##  output$cnet.top---------
  output$cnet.top <- renderPlotly({
    plot.data = getCnet()[["cnet.degree"]]

    if (!is.null(plot.data)) {
      colnames(plot.data)[2] <- "In"
      plotly::plot_ly(
        plot.data,
        type = 'scatter',
        mode = 'markers',
        x = ~ In,
        y = ~ out,
        text = ~ paste('PMID: ', pmid,
                       '</br> Title: ', title)
      ) %>% layout(
        xaxis = list(
          type = "log",
          title = "In-Degree",
          titlefont = plotlyf
        ),
        yaxis = list(
          type = "log",
          title = "Out-Degree",
          titlefont = plotlyf
        )
      )
    }
  })

  ##   output$cnet.dis---------
  output$cnet.dis <- renderPlotly({
    plot.data = getCnet()[["cnet.degree"]]

    if (!is.null(plot.data)) {
      plot.data <- as.data.frame(table(plot.data$total))
      plot.data$Freq = plot.data$Freq / sum(plot.data$Freq)
      plot.data$Var1 <- as.numeric(as.character(plot.data$Var1))
      fv <-
        plot.data %>% filter(!is.na(Freq)) %>% lm(log10(Freq) ~ Var1, .) %>% fitted.values()
      fv <- 10 ^ fv

      plotly::plot_ly(
        plot.data,
        type = 'scatter',
        mode = 'markers',
        x = ~ Var1,
        y = ~ Freq
      ) %>% add_lines(x = ~ Var1, y = fv) %>% layout(
        xaxis = list(title = "Total-Degree (k)", titlefont = plotlyf),
        yaxis = list(
          type = "log",
          title = "p(k)",
          titlefont = plotlyf
        )
      ) %>% layout(showlegend = F)
    }
  })

  ## ouput$cnet.download----------
  output$cnet.download <- downloadHandler(
    filename = function() {
      paste("CitationMapDownload-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write_csv2(getCnet()[["cnet.edges"]], file)
    }
  )

  # output$tableCnet-------
  output$tableCnet = DT::renderDataTable({
    tableCnet <- getCnet()[["cnet.degree"]]
    
    if (!is.null(tableCnet)) {
      DT::datatable(
        tableCnet[1:min(nrow(tableCnet), 100),] %>% .[order(.$total, .$selected, decreasing = T), ],
        extensions = 'Buttons',
        colnames=c("PMID","In-degree","Out-degree","Total-
                   
                   degree","Title","LitCovid","Global Filter"),
        options = list(
          dom = 'Bfrtip',
          pageLength = 5,
          buttons = c('csv', 'excel')
        ),
        rownames = FALSE
      )
    }
  })

  ## Data-getCnetVis() network-------
  getCnetVis <- eventReactive(input$cnetButton, {
    fig = NULL
    k.degree <- getCnet()[["cnet.degree"]]
    k.edges <- getCnet()[["cnet.edges"]]
    pmid.show <- input$cnet.show %>% as.integer
    if (!is.null(k.edges)) {
      k2 <-
        subset(k.edges, from %in% pmid.show |
                 to %in% pmid.show)
      k2 <- data.frame(k2) %>% .[1:min(1000, nrow(k2)),]
      net.ids <- base::union(k2[, 1], k2[, 2])

      k.nodes <-
        data.frame(id = net.ids,
                   label = net.ids,
                   color = "lightgrey")
      k.nodes$color <- as.character(k.nodes$color)
      k.nodes[which(k.nodes$label %in% getSelectID()), "color"] <-
        "forestgreen"
      k.nodes[which(k.nodes$label %in% pmid.show), "color"] <-
        "red"
      k.nodes <-
        merge(
          k.nodes,
          pmid.info.extended,
          by.x = "id",
          by.y = "pmid",
          all.x = T
        )
      k.nodes$title <-
        paste(
          '<a href="https://www.ncbi.nlm.nih.gov/pubmed/',
          k.nodes$id,
          '" target="_blank">',
          k.nodes$title,
          '</a>',
          sep = ""
        )

      fig <- visNetwork(nodes = k.nodes, edges = k2) %>%
        visOptions(highlightNearest = list(enabled = TRUE, hover = TRUE)) %>%
        visLayout(randomSeed = 123) %>%
        addFontAwesome() %>%
        visIgraphLayout()
    }
    return(fig)
  })

  ##  output$cnet.result--------
  output$cnet.result <- renderVisNetwork({
    getCnetVis()
  })

  ## Data -getSnet()"snet.degree","snet.edges"-----------
  getSnet <- eventReactive(input$confirm, {
    plotlist <- vector("list", length = 3)
    names(plotlist) <- c("snet.degree", "snet.edges", "snet.bar")
    pmid.selected <- getSelectID()
    if (length(pmid.selected) > 0) {
      k <-
        subset(relPMID,
               PMID1 %in% pmid.selected |
                 PMID2 %in% pmid.selected)
      if (nrow(k) > 1) {
        #k.edges <- data.frame(k[, 1:2], arrows = "to", smooth = TRUE)
        k.edges <-
          unique(data.frame(k[, c("PMID1", "PMID2", "N")]))
        colnames(k.edges)[1:3] <- c("from", "to", "weight")

        k.degree <-
          as.data.frame(table(c(k.edges[, 1], k.edges[, 2])))
        colnames(k.degree) = c("pmid", "degree")
        k.degree <-
          merge(k.degree,
                pmid.info.extended[, c("pmid", "title", "LitCovid")],
                all.x = T)
        k.degree$selected <- FALSE
        k.degree$selected[is.element(k.degree$pmid, pmid.selected)] = TRUE

        k.bar <- as.data.frame(table(k.edges$weight))
        plotlist[["snet.bar"]] <- k.bar
        plotlist[["snet.degree"]] <- k.degree
        plotlist[["snet.edges"]] = arrange(k.edges, desc(weight))

        updateSelectInput(
          session,
          "snet.show",
          selected = k.degree$pmid[1:3],
          choices = k.degree$pmid
        )

      }
    }
    return(plotlist)
  })
  ## Data-getSnetVis() network of snet----------
  getSnetVis <- eventReactive(input$snetButton, {
    k.edges <-
      getSnet()[["snet.edges"]]
    pmid.show <- input$snet.show %>% as.integer
    if (!is.null(k.edges) & !is.null(pmid.show)) {
      k2 <-
        subset(k.edges, from %in% pmid.show |
                 to %in% pmid.show)
      k2 <- data.frame(k2) %>% .[1:min(1000, nrow(k2)),]
      net.ids <- base::union(k2[, 1], k2[, 2])

      k.nodes <-
        data.frame(id = net.ids,
                   label = net.ids,
                   color = "lightgrey")
      k.nodes$color <- as.character(k.nodes$color)
      k.nodes[which(k.nodes$label %in% getSelectID()), "color"] <-
        "forestgreen"
      k.nodes[which(k.nodes$label %in% pmid.show), "color"] <-
        "red"
      k.nodes <-
        merge(
          k.nodes,
          pmid.info.extended,
          by.x = "id",
          by.y = "pmid",
          all.x = T
        )
      k.nodes$title <-
        paste(
          '<a href="https://www.ncbi.nlm.nih.gov/pubmed/',
          k.nodes$id,
          '" target="_blank">',
          k.nodes$title,
          '</a>',
          sep = ""
        )
      k2$title <- paste0("Shared Citation:", k2$weight)

      visNetwork(nodes = k.nodes, edges = k2) %>%
        visOptions(highlightNearest = list(enabled = TRUE, hover = TRUE)) %>%
        visLayout(randomSeed = 123) %>%
        addFontAwesome() %>%
        visIgraphLayout()

    }

  })
  ##output$snet.result---------
  output$snet.result <- renderVisNetwork({
    getSnetVis()
  })
  ##output$snet.download----------
  output$snet.download <- downloadHandler(
    filename = function() {
      paste("SimilarityCitationNetDownload-",
            Sys.Date(),
            ".csv",
            sep = "")
    },
    content = function(file) {
      data = getSnet()[["snet.edges"]]
      colnames(data) <- c("PMID1", "PMID2", "Shared_Citation_NO")
      write_csv2(data, file)
    }
  )

  ##output$snet.top------
  output$snet.top <- renderPlotly({
    plot.data = getSnet()[["snet.bar"]]

    if (!is.null(plot.data)) {
      plotly::plot_ly(
        plot.data,
        type = 'bar',
        #        mode = 'markers',
        x = ~ Var1,
        y = ~ Freq,
        text = ~ paste('Shared Citation: ', Var1,
                       '</br> Number of Pairs: ', Freq)
      ) %>% layout(
        xaxis = list(title = "Number of Shared Citation<br>(weight of edges)", titlefont = plotlyf),
        yaxis = list(title = "Number of Pairs (edges)", titlefont = plotlyf)
      )
    }
  })
  ##output$snet.dis-----------
  output$snet.dis <- renderPlotly({
    plot.data = getSnet()[["snet.degree"]]

    if (!is.null(plot.data)) {
      plot.data <- as.data.frame(table(plot.data$degree))
      plot.data$Freq = plot.data$Freq / sum(plot.data$Freq)
      plot.data$Var1 <- as.numeric(as.character(plot.data$Var1))
      fv <-
        plot.data %>% filter(!is.na(Freq)) %>% lm(log10(Freq) ~ Var1, .) %>% fitted.values()
      fv <- 10 ^ fv

      plotly::plot_ly(
        plot.data,
        type = 'scatter',
        mode = 'markers',
        x = ~ Var1,
        y = ~ Freq
      ) %>% add_lines(x = ~ Var1, y = fv) %>% layout(
        xaxis = list(title = "Degree (k)", titlefont = plotlyf),
        yaxis = list(
          type = "log",
          title = "p(k)",
          titlefont = plotlyf
        )
      ) %>% layout(showlegend = F)
    }
  })

  # output$tableSnet-------
  output$tableSnet = DT::renderDataTable({
    tableSnet <- getSnet()[["snet.degree"]]
    
    if (!is.null(tableSnet)) {
      DT::datatable(
        tableSnet[1:min(nrow(tableSnet), 100),] %>% .[order(.$degree, .$selected, decreasing = T), ],
        extensions = 'Buttons',
        colnames= c("PMID","Degree","Title","LitCovid","Global Filter"),
        options = list(
          dom = 'Bfrtip',
          pageLength = 5,
          buttons = c('csv', 'excel')
        ),
        rownames = FALSE
      )
    }
  })



  output$cnetBox2 <- renderValueBox({
    t = 0
    if (!is.null(getCnet()[["cnet.degree"]])) {
      t = nrow(getCnet()[["cnet.degree"]])
    }
    valueBox(
      value = tags$p(paste0("Nodes:", t), style = "font-size: 50%;"),
      subtitle = "Publications",
      color = "yellow"
      #icon = icon("atom","fa-0.5x")
    )
  })

  output$cnetBox3 <- renderValueBox({
    t = 0
    if (!is.null(getCnet()[["cnet.edges"]])) {
      t = nrow(getCnet()[["cnet.edges"]])
    }
    valueBox(
      value = tags$p(paste0("Edges:", t), style = "font-size: 50%;"),
      subtitle = "Citation Pairs",
      color = "green"
      #icon = icon("atom","fa-0.5x")
    )
  })
  output$snetBox2 <- renderValueBox({
    t = 0
    if (!is.null(getSnet()[["snet.degree"]])) {
      t = nrow(getSnet()[["snet.degree"]])
    }
    valueBox(
      value = tags$p(paste0("Nodes:", t), style = "font-size: 50%;"),
      subtitle = "Publications",
      color = "yellow"
      #icon = icon("atom","fa-0.5x")
    )
  })
  output$snetBox3 <- renderValueBox({
    t = 0
    if (!is.null(getSnet()[["snet.edges"]])) {
      t = nrow(getSnet()[["snet.edges"]])
    }
    valueBox(
      value = tags$p(paste0("Edges:", t), style = "font-size: 50%;"),
      subtitle = "Publication Pairs",
      color = "green"
      #icon = icon("atom","fa-0.5x")
    )
  })

  ## Data -getMnet()"mnet.degree","mnet.edges"-----------
  getMnet <- eventReactive(input$confirm, {
    plotlist <- vector("list", length = 3)
    names(plotlist) <- c("mnet.degree", "mnet.edges", "mnet.bar")
    mesh.selected <- getMesh()[, "mesh"]
    if (!is.null(mesh.selected)) {
      k <-
        subset(relMeSH,
               term1 %in% mesh.selected |
                 term2 %in% mesh.selected)
      if (nrow(k) > 1) {
        #k.edges <- data.frame(k[, 1:2], arrows = "to", smooth = TRUE)
        k.edges <- unique(k)
        #unique(data.frame(k[, c("PMID1", "PMID2", "N")]))
        colnames(k.edges)[1:3] <- c("from", "to", "weight")

        k.degree <-
          as.data.frame(table(c(k.edges[, 1], k.edges[, 2])))
        colnames(k.degree) = c("MeSH", "Degree")

        k.degree$selected <- FALSE
        k.degree$selected[is.element(k.degree$MeSH, mesh.selected)] = TRUE

        k.bar <- as.data.frame(table(k.edges$weight))

        plotlist[["mnet.bar"]] <- k.bar
        plotlist[["mnet.degree"]] <- k.degree
        plotlist[["mnet.edges"]] = arrange(k.edges, desc(weight))
        tmp <- k.degree[k.degree$selected==TRUE,]
        tmp <- tmp[order(tmp$Degree,decreasing = T),]

        updateSelectInput(session,
                          "mnet.show",
                          selected = tmp$MeSH[1:3],
                          choices = k.degree$MeSH)
      }
    }

    return(plotlist)
  })



  ## Data-getMnetVis() network of mnet----------
  getMnetVis <- eventReactive(input$mnetButton, {
    mesh.show = input$mnet.show
    k.edges <-
      getMnet()[["mnet.edges"]]

    if (!is.null(k.edges) & !is.null(mesh.show)) {
      k2 <-
        subset(k.edges, from %in% mesh.show |
                 to %in% mesh.show)
      k2 <- data.frame(k2) %>% .[1:min(1000, nrow(k2)),]
      net.ids <- base::union(k2[, 1], k2[, 2])

      k.nodes <-
        data.frame(id = net.ids,
                   label = net.ids,
                   color = "grey")
      k.nodes$color <- as.character(k.nodes$color)
      k.nodes[which(k.nodes$label %in% getMesh()[, 1]), "color"] <-
        "forestgreen"
      k.nodes[which(k.nodes$label %in% mesh.show), "color"] <-
        "red"

      k2$title <- paste0("Shared Citation:", k2$weight)

      visNetwork(nodes = k.nodes, edges = data.frame(k2)[k2$weight >= 3,]) %>%
        visOptions(highlightNearest = list(enabled = TRUE, hover = TRUE)) %>%
        visLayout(randomSeed = 123) %>%
        addFontAwesome() %>%
        visIgraphLayout()

    }

  })

  ##output$mnet.result---------
  output$mnet.result <- renderVisNetwork({
    getMnetVis()
  })
  ##output$mnet.download----------
  output$mnet.download <- downloadHandler(
    filename = function() {
      paste("MeshMapDownload-",
            Sys.Date(),
            ".csv",
            sep = "")
    },
    content = function(file) {
      data = getMnet()[["mnet.edges"]]
      colnames(data) <- c("MeSH1", "MeSH2", "Shared_Citation_NO")
      write_csv2(data, file)
    }
  )

  ##output$mnet.top------
  output$mnet.top <- renderPlotly({
    plot.data = getMnet()[["mnet.bar"]]

    if (!is.null(plot.data)) {
      plotly::plot_ly(
        plot.data,
        type = 'bar',
        #        mode = 'markers',
        x = ~ Var1,
        y = ~ Freq,
        text = ~ paste('Shared Citation: ', Var1,
                       '</br> Number of Pairs: ', Freq)
      ) %>% layout(
        xaxis = list(title = "Number of Shared Publications<br>(weight of edges)", titlefont = plotlyf),
        yaxis = list(title = "Number of Pairs (edges)", titlefont = plotlyf)
      )
    }
  })

  # output$tableMnet-------
  output$tableMnet = DT::renderDataTable({
    tableMnet <- getMnet()[["mnet.degree"]]

    if (!is.null(tableMnet)) {
      DT::datatable(
        tableMnet[1:min(nrow(tableMnet), 100),] %>% .[order(.$Degree, .$selected, decreasing = T), ],
        extensions = 'Buttons',
        colnames=c("MeSH","Degree","Selected"),
        options = list(
          dom = 'Bfrtip',
          pageLength = 5,
          buttons = c('csv', 'excel')
        ),
        rownames = FALSE
      )
    }
  })

  ##output$mnet box--------
  output$mnetBox2 <- renderValueBox({
    t = 0
    if (!is.null(getMnet()[["mnet.degree"]])) {
      t = nrow(getMnet()[["mnet.degree"]])
    }
    valueBox(
      value = tags$p(paste0("Nodes:", t), style = "font-size: 50%;"),
      subtitle = "MeSH Terms",
      color = "yellow"
      #icon = icon("atom","fa-0.5x")
    )
  })
  output$mnetBox3 <- renderValueBox({
    t = 0
    if (!is.null(getMnet()[["mnet.edges"]])) {
      t = nrow(getMnet()[["mnet.edges"]])
    }
    valueBox(
      value = tags$p(paste0("Edges:", t), style = "font-size: 50%;"),
      subtitle = "MeSH Pairs",
      color = "green"
      #icon = icon("atom","fa-0.5x")
    )
  })
})
