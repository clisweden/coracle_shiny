# HEADER ------------------------------------------------------------------
header <- dashboardHeader(
  title = div(img(
    src = "logob.png",
    height = 30,
    width = 30
  ),
  "CORACLE"),
  titleWidth = 300,
  tags$li(
    a(
      strong("Data Tables"),
      height = 40,
      href = "https://github.com/clisweden/coracle_data",
      title = "",
      target = "_blank"
    ),
    class = "dropdown"
  ),
  tags$li(
    a(
      strong("Tutorials"),
      height = 40,
      href = "https://github.com/clisweden/coracle_tutorials",
      title = "",
      target = "_blank"
    ),
    class = "dropdown"
  ),
  tags$li(
    a(
      strong("Desktop Code"),
      height = 40,
      href = "https://github.com/clisweden/coracle_shiny",
      title = "",
      target = "_blank"
    ),
    class = "dropdown"
  )
)


sidebar <- dashboardSidebar(
  tags$br(),
  width = 300,
  
  div(
    id = "sidebar_button",
    bsButton(
      inputId = "confirm",
      label = "START CORACLE",
      icon = icon("play-circle"),
      style = "danger"
    )
  ),
  
  sliderInput(
    "dateRange",
    label = "Range of Publication Dates",
    min = min(pmid.info$date),
    max = max(pmid.info$date),
    value = c(min(pmid.info$date),
              max(pmid.info$date))
  ),
  pickerInput(
    inputId = "pub.type",
    label = "Publication Type",
    choices = raw.pub.type.all,
    selected = c("Journal Article", "Case Reports", "Letter"),
    multiple = TRUE,
    options = pickerOptions(
      actionsBox = TRUE,
      size = 'auto',
      selectedTextFormat = "count > 3"
    )
  ),
  
  selectInput(
    inputId = "journal",
    selected = NULL,
    multiple = T,
    label = "Journal",
    choices = raw.journal.all
  ),
  
  pickerInput(
    inputId = "country",
    label = "Country",
    choices = raw.country.all,
    selected = raw.country.all,
    multiple = TRUE,
    options = pickerOptions(
      actionsBox = TRUE,
      size = 'auto',
      selectedTextFormat = "count > 3"
    )
  ),
  #tags$br(),
  
  pickerInput(
    inputId = "lanuage",
    selected = c("English"),
    multiple = T,
    label = "Language",
    choices = raw.language.all,
    options = pickerOptions(
      actionsBox = TRUE,
      size = 'auto',
      selectedTextFormat = "count > 3"
    )
  ),
  #tags$hr(),
  
  
  selectInput(
    inputId = "mesh.or",
    #selected = c("ace 2","293t-ace2","ace2","ace2 blocker","ace2 expression","ace2 negative","ace2 receptor","ace2 receptors","ace2, angiotensin converting enzyme 2","ace2, angiotensin-converting enzyme 2","angiotensin converting enzyme 2 (ace2","angiotensin converting enzyme 2(ace2","angiotensin-converting enzyme 2 (ace2","angiotensin-converting enzyme 2, ace2","angiotensin-converting enzyme-2 (ace2","expression of ace2","hace2","human angiotensin-converting enzyme 2 (ace2","humen ace2","recombinant human ace2"),
    selected = NULL,
    multiple = T,
    label = "Enter MeSH(s) [OR]",
    choices = raw.mesh.all
  ),
  
  selectInput(
    inputId = "mesh.and",
    selected = NULL,
    multiple = T,
    label = "Enter MeSH(s) [AND]",
    choices = raw.mesh.all
  ),
  
  radioGroupButtons(
    inputId = "pmid.rule",
    label = "Customized PMID Rules",
    choices = list("OR" = "OR", "AND" = "AND"),
    selected = "OR",
    checkIcon = list(yes = icon("ok",
                                lib = "glyphicon"))
  ),
  #tags$hr(),
  selectInput(
    inputId = "query.pmid",
    selected = NULL,
    multiple = T,
    label = "Enter PMID(s)",
    choices = sort(as.character(pmid.info$pmid))
  ),
  
  uiOutput('file1_ui'),
  actionButton('reset', 'Reset PMID File Input')
  
)



body <- dashboardBody(tabsetPanel(
  tabPanel(
    "STATISTICS",
    icon = icon("poll"),
    fluidRow(
      shinydashboard::box(
        title = "Summary of Selected/Available Items",
        width = 12,
        tags$head(tags$style(HTML(
          ".small-box {height: 80px}"
        ))),
        shinydashboard::valueBox(
          value = tags$p(fdate, style = "font-size: 50%;"),
          subtitle = "Date",
          color = "blue",
          width = 3
        ),
        shinydashboard::valueBoxOutput("pubBox", width = 3),
        shinydashboard::valueBoxOutput("meshBox", width = 3),
        shinydashboard::valueBoxOutput("cpairBox2", width = 3)
      )
    ),
    fluidRow(
      shinydashboard::box(
        title = "Publication Trend",
        status = "danger",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 6,
        tabsetPanel(
          tabPanel(
            "Daily New Publications",
        plotOutput("pub.count.new") %>% withSpinner()),
        tabPanel(
          "Cumulated Publications",
          plotOutput("pub.count.all") %>% withSpinner()
        )
        )
      ),
      shinydashboard::box(
        title = "MeSH Key Words Trend",
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 6,
        tabsetPanel(
          tabPanel(
            "MeSH Wordcloud",
            column(
              width = 8,
              sliderInput(
                "mesh.rank",
                "Select Rank of MeSH",
                min = 1,
                max = 300,
                value = c(1, 100)
              )
            ),
            column(width = 4,
                   numericInput('mesh.size', 'Size of Wordcloud', 1)),
            shinydashboard::box(
              width = 12,
              wordcloud2Output('mesh.wordcloud', height = "325px") %>% withSpinner()
            )
            
          ),
          tabPanel(
            "MeSH Trend",
            numericInput("mesh.rank2",
                         "Select Start Rank of MeSH (10 shown)",
                         value = 1),
            plotlyOutput("mesh.trend.plot") %>% withSpinner()
          )
        )
      )
    ),
    
    fluidRow(
      shinydashboard::box(
        title = "Country & Language Trend",
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 6,
        tabsetPanel(
          tabPanel(
            "Country Trend",
            leafletOutput("country.map") %>% withSpinner()
          ),
          tabPanel(
            "Language Trend",
            plotlyOutput("languagePlot") %>% withSpinner()
          )
        )
      ),
      shinydashboard::box(
        title = "Journal Trend",
        status = "success",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 6,
        plotlyOutput("journalPlot") %>% withSpinner()
      )
    ),
    
    fluidRow(
      shinydashboard::box(
        title = "Data Table of Highly Cited/Most Recent Publications",
        status = "info",
        solidHeader = TRUE,
        collapsible = TRUE,
        width = 12,
        DT::dataTableOutput('table1') %>% withSpinner()
      )
    )
    
  ),
  tabPanel(
    title = "CITATION MAP",
    icon = icon("atom"),
    fluidPage(
      fluidRow(
        shinydashboard::box(
          title = "Summary of Filtered Citation Map",
          width = 3,
          #status = "danger",
          solidHeader = TRUE,
          collapsible = TRUE,
          fluidRow(
            shinydashboard::valueBoxOutput("cnetBox2", width = 12),
            shinydashboard::valueBoxOutput("cnetBox3", width = 12)
          )
        ),
        shinydashboard::box(
          title = "Hubs in Citation Map",
          status = "info",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = 9,
          DT::dataTableOutput('tableCnet') %>% withSpinner()
        )
      ),
      fluidRow(
        shinydashboard::box(
          width = 6,
          status = "success",
          solidHeader = TRUE,
          collapsible = TRUE,
          title = "Central Publications",
          plotlyOutput("cnet.top") %>% withSpinner()
        ),
        shinydashboard::box(
          width = 6,
          status = "warning",
          solidHeader = TRUE,
          collapsible = TRUE,
          title = "Degree Distribution",
          plotlyOutput("cnet.dis") %>% withSpinner()
        )
      ),
      
      tags$br(),
      fluidRow(
        shinydashboard::box(
          width = 2,
          status = "warning",
          solidHeader = TRUE,
          selectInput(
            inputId = "cnet.show",
            selected = NULL,
            multiple = T,
            label = h4("Input target PMID for Visulization"),
            choices = NULL
          ),
          tags$p("!Notice: This can't be null. Push the 'START/UPDATE' button if it's null."),
          div(
            id = "cnetButton",
            bsButton(
              inputId = "cnetButton",
              label = "Visualize",
              icon = icon("eye"),
              style = "danger"
            )
          ),
          tags$br(),
          downloadLink("cnet.download", "        Download Full Map"),
          tags$br(),
          tags$br(),
          div(img(
            src = "legends.png",
            #height = 200,
            width = 100
          ))
        ),
        shinydashboard::box(
          title = "Visualization of Citation Map",
          width = 10,
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          visNetworkOutput("cnet.result", width = "100%", height = "1080px") %>% withSpinner()
        )
      )
    )
  ),
  
  tabPanel(
    title = "SIMILARITY CITATION NETWORK",
    icon = icon("arrows-alt"),
    fluidPage(
      fluidRow(
        shinydashboard::box(
          title = "Summary of Selected Similarity Citation Network",
          width = 3,
          #status = "danger",
          solidHeader = TRUE,
          collapsible = TRUE,
          fluidRow(
            shinydashboard::valueBoxOutput("snetBox2", width = 12),
            shinydashboard::valueBoxOutput("snetBox3", width = 12)
          )
        ),
        shinydashboard::box(
          title = "Hubs in Similarity Citation Network",
          status = "info",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = 9,
          DT::dataTableOutput('tableSnet') %>% withSpinner()
        )
      ),
      fluidRow(
        shinydashboard::box(
          width = 6,
          status = "success",
          solidHeader = TRUE,
          collapsible = TRUE,
          title = "Distribution of Shared Citations (edge weights)",
          plotlyOutput("snet.top") %>% withSpinner()
        ),
        shinydashboard::box(
          width = 6,
          status = "warning",
          solidHeader = TRUE,
          collapsible = TRUE,
          title = "Degree Distribution",
          plotlyOutput("snet.dis") %>% withSpinner()
        )
      ),
      
      tags$br(),
      fluidRow(
        shinydashboard::box(
          width = 2,
          status = "warning",
          solidHeader = TRUE,
          selectInput(
            inputId = "snet.show",
            selected = NULL,
            multiple = T,
            label = h4("Input target PMID for Visulization"),
            choices = NULL
          ),
          tags$p("!Notice: This can't be null. Push the 'START/UPDATE' button if it's null."),
          div(
            id = "snetButton",
            bsButton(
              inputId = "snetButton",
              label = "Visualize",
              icon = icon("eye"),
              style = "danger"
            )
          ),
          tags$br(),
          downloadLink("snet.download", "        Download Full Map"),
          tags$br(),
          tags$br(),
          div(img(
            src = "legends.png",
            #height = 200,
            width = 100
          ))
        ),
        shinydashboard::box(
          title = "Visualization of Similarity Citation Network",
          width = 10,
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          visNetworkOutput("snet.result", width = "100%", height = "1080px") %>% withSpinner()
        )
      )
    )
  ),
  tabPanel(
    title = "MeSH MAP",
    icon = icon("key"),
    fluidPage(
      fluidRow(
        shinydashboard::box(
          title = "Summary of MeSH Map",
          width = 3,
          #status = "danger",
          solidHeader = TRUE,
          collapsible = TRUE,
          fluidRow(
            shinydashboard::valueBoxOutput("mnetBox2", width = 12),
            shinydashboard::valueBoxOutput("mnetBox3", width = 12)
          )
        ),
        shinydashboard::box(
          title = "Hubs in MeSH Map",
          status = "info",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = 9,
          DT::dataTableOutput('tableMnet') %>% withSpinner()
        )
      ),
      fluidRow(
        shinydashboard::box(
          width = 6,
          status = "success",
          solidHeader = TRUE,
          collapsible = TRUE,
          title = "Distribution of Shared Publications (edge weights)",
          plotlyOutput("mnet.top") %>% withSpinner()
        )
      ),
      
      tags$br(),
      fluidRow(
        shinydashboard::box(
          width = 2,
          status = "warning",
          solidHeader = TRUE,
          selectInput(
            inputId = "mnet.show",
            selected = NULL,
            multiple = T,
            label = h4("Input target MeSH"),
            choices = NULL
          ),
          tags$p("!Notice: This can't be null. Push the 'START/UPDATE' button if it's null."),
          div(
            id = "mnetButton",
            bsButton(
              inputId = "mnetButton",
              label = "Visualize",
              icon = icon("eye"),
              style = "danger"
            )
          ),
          tags$br(),
          downloadLink("mnet.download", "        Download Full Map"),
          tags$br(),
          tags$br(),
          div(img(
            src = "legends.png",
            #height = 200,
            width = 100
          ))
        ),
        shinydashboard::box(
          title="Visualization of MeSH Map",
          width = 10,
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          visNetworkOutput("mnet.result", width = "100%", height = "1080px") %>% withSpinner()
        )
      )
    )
  ),
  # tabPanel("DATA TABLE",
  #          icon = icon("file-download")),
  tags$footer(
    "Copyright: To support COVID research, this is a Free Culture License. Contact: chuan-xing.li@ki.se",
    align = "center",
    style = "
    position:absolute;
    bottom:0;
    width:100%;
    height:50px;   /* Height of the footer */
    color: white;
    padding: 10px;
    background-color: black;
    z-index: 1000;"
  )
  ))



ui <-
  dashboardPage(skin = "black", title = "CORACLE", header, sidebar, body)