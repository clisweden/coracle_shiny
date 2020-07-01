#Tutorial for CORACLE

To activate CORACLE, please press the ?START? button on the upper left. It may take several minutes for CORACLE to load the data the first time you use it. If the data loading is completed, when the ?START? button is mouse-over, the mouse pointer will change from an arrow to a hand shape.

[Part 1 - Search Functions](#part-1)
  1. Introduction 
  2. Publication Dates
  3. Publication Types
  4. Journals
  5. Countries
  6. Languages
  7. MeSH/Keywords
  8. Customized PMID

Part 2 - Output Functions
  STATISTICS tab
  9. STATISTICS - Summary
  10. Publication Trend
  11. MeSH Trend
  12. Country Trend
  13. Language Trend
  14. Journal Trend
  15. Popular Publications

  CITATION MAP tab
  16. CITATION MAP ? Summary
  17. Hubs in Citation Map
  18. Central Publications
  19. Degree Distribution
  20. Visualization of Citation Map

  SIMILARITY CITATION NETWORK tab
  21. Summary
  22. Distribution of Shared Citations
  23. Degree Distribution
  24. Hubs
  25. Visualization of Network

  MeSH MAP tab
  26. MeSH Map - Summary
  27. Hubs in MeSH MAP
  28. Distribution of Shared Publications
  29. Visualization of MeSH Map

  Data Table

Part 3 - How to run CORACLE locally from your computer

Part 4 - Examples
  30. COVID-19 emerging research topics
  31. Tracking ACE2 in COVID-19


##Part 1 ? Search Functions
To activate CORACLE, please press the ?START? button on the upper left. It may take several minutes for CORACLE to load the data the first time you use it. Please note that you will be automatically disconnected after 5 minutes of inactivity. To re-connect, press the black re-load button that appears in the bottom left corner, and press ?START? again to reinitiate your search. Currently, CORACLE is supported on Safari and Explorer browsers only due to limitations in the R Shiny environment. For questions about other browsers, please visit the R Shiny web site (https://shiny.rstudio.com/) for updated information.  

  1. Introduction
CORACLE is a daily-updated and interactive R Shiny app, with its background literature data collected and analyzed from PubMed and LitCovid databases, by Python and R programs. The first version of CORACLE is based on the daily updated publication list from LitCovid and their citations in PubMed, and provides in its most rudimentary forms: 1) fast highlight of emerging research topics, including identification of popular articles, keywords, and journals; 2) personalized extraction of the literature of interest by multilevel filters and customized PMID (PubMed Identifier) lists, combined with citation relationship; 3) prioritize highly related publications by direct citation map and indirect similarity citation network; 4) understand the relationships among research areas (keywords). We provide both web-based version as an easy-access, user-friendly interface, and a downloadable desktop solutions for the more experienced R user. The latter will offer a faster search functionality. If you find our tools useful, please acknowledge us by citing PMID: XXXXXXX. 

The Search-function available in the left panel (black background) consists of five major filter blocks; publication type, country, language, MeSH (Medical Subject Headings) term, and customized PMID list. The functionality of these, and how to set up the each respective search is outlined in detail below. These five filters can be used jointly to set up personalized searches by inputting multiple values in each filter, either as a intersection filter (AND) or union filter (OR) at the bottom left. The default relationships are AND for the search terms publication dates, type, country, language, and MeSH, and OR for customized PMID list/input. Please note that the output results will be updated first after clicking the "START/UPDATE" button on the top of the filter block. 

  2. Range of Publication Dates
This filter consists of a slider, which delimits the range for the official date of publications in the PubMed database to be included in your compilation. The default setting for the range of Publication Dates is from Jan 18, 2020 (the earliest date of literature in the LitCovid database) to the latest date of CORACLE.
 
  3. Publication Types
This filter offers the option of fine-tuning the type of publication to be included in the search by selecting several of the 25 publication types, which are standard in PubMed. The default of Publication types is "journal articles", "letter", and "case reports". 

  4. Journals
This filter function provides the option of selecting a subset of journals from the >2500 journal names which have published COVID-19 related papers. Users can input their specific journal names of interest by free-text with union relationships. The indicator of journal names will be displayed in a drop-down menu when inputting the journal names. Users need to press ?enter? (the Enter key on the keyboard) between each journal name input. Only journals in the database could be inputted. The default option is the union of all journals.

  5. Countries
This filter offers the option of selecting publications from specific countries, here referring to the country of affiliation for the authors. As for the filter Publication Types, multiple countries can be selected with the relationship of union (OR). The top five countries are United States, United Kingdom, Netherlands, China, and Switzerland. There are also 153 International and 417 not available country information studies as of June 1st, 2020. The default of the country filter is the union of all countries, international and not available studies.

  6. Languages
The fifth filter refers to publication language, 17 languages included as of June 1st, 2020. English is the default language, currently representing 95.3% of publications, so it?s the default value.

  7. MeSH/Keywords
The MeSH/Keywords filter consists of two sub-filters with the default relationships set as intersection (AND) between them. In the first sub-filter entitled ?Enter MeSH(s) [OR]?, multiple MeSH terms could be inputted with the relationship set to union (OR), while the second sub-filter entitled ?Enter MeSH(s) [AND]?, additional MeSH terms can be inputted with the relationship of intersection (AND). The final output from the simultaneous (AND) and (OR) MeSH/Keywords filtering facilitates a more advanced keywords search. For example, if users would like to search publications related to ACE2 in children only, search terms such as "COVID-19", "ACE2", and "SARS? could be added in ?Enter MeSH(s) [OR]?, and ?child? in ?Enter MeSH(s) [AND]?. The default of ?Enter MeSH(s) [OR]? is all keywords, and ?Enter MeSH(s) [AND]? is null, so the overall default of ?MeSH/Keywords? is all keywords.

  8. Customized PMID
The last filtering option concerns customized PMIDs, and consists of two sub-filters;  ?Enter PMID(s)? facilitates a free-text input option for individual PMIDs, whereas "Enter PMID list? offers a means to import a text file with PMIDs of interest. There is a "Customized PMID rules" of OR (union) and AND (intersection) to define the relationships between this PMID part with other filters (defaults to OR). The relationship between two sub-filters is OR. The input of "Enter PMID(s)" is the same as "Journals" with text input and "Enter" between each input PMID for multiple input. The input of ?Enter PMID list? is a ?CSV" file with the first column as PMID and first item as header. The input file could be the output from PubMed or CORACLE. The button of "Reset PMID File Input" will remove previously inputted file. The defaults of both sub-filters are null and with the default ?Customized PMID rules? as OR (union).

After all filters have been set, users need to push the ?START/UPDATE? button on the top of the filter block to activate the new selections and initiate the search. Then the output results will be updated.


Part 2 ? Output Functions

  STATISTICS tab
The STATISTICS tab summarizes the results and trends of the publications selected in through the global filtering options in Part 1 in seven different display modes.

  9. STATISTICS ? Summary
In the top banner of the STATISTICS tab, four value boxes display the following numericals of the publications filtered/searched:
i. Date of the latest CORACLE up-date (daily updates are automatic, so for publication purposes it is advised to make note of the search date)
ii. Number of filtered/selected publications vs.(/) total publications in CORACLE
iii. Number of MeSH/Keywords included by the filtered publications vs. (/) total MeSH in CORACLE
iv. Number of citation pairs available through the filtered publications vs. (/) total citation pairs in CORACLE
If the number of filtered publications is zero, there will be no other outputs.

  10. Publication Trend
The Publication Trend output consists of two scatter plots with the x-axis representing the range of filtered dates of publication, the y-axis indicates the number of daily new publications in the ?Daily New Publications? window, whereas the total (cumulated) number of publications in the ?Cumulated Publication? window.

  11. MeSH Trend
The results of the MeSH Keywords Trend are displayed as two separate plots. Firstly, a word cloud plot of the top 300 MeSH keywords. By their rank range, users could select the displayed MeSH keywords by a two-sided slider bar adjustable for minimum and maximum desired ranks. The lower the rank, the more number of filtered publications annotated to that MeSH. The font size of the word cloud can also be reset. The second MeSH trend plot is a line plot with the x-axis displaying the date of publication, and the y-axis displaying the total number of publications for each MeSH keyword. The colors of the lines represent different MeSH keywords. The trend of the ten most abundant keywords in the search will be shown as the default, and the user can select the MeSH ranks to be displayed. For example, if the start rank is 1, then the top 10 MeSH trend will be shown, while if the start rank is 5, the trends of MeSH terms with rank 5 to 14 will be shown.

  12. Country Trend
A world map is shown with country color-coding corresponding to the number of filtered publications originating from the respective country. The number of publications for each color annotations will be displayed in the legend.

  13. Language Trend
The Language Trend output is a line plot with the x-axis showing the date of publication, and the y-axis displaying the total (cumulated) number of publications for each language. The colors of the lines represent different languages, as indicated in the legend.

  14. Journal Trend
The journal trend output is a line plot with the x-axis showing the date of publication, and the y-axis showing the total (cumulated) number of publications for each journal. The colors of the lines represent different journals. The top 15 journals with the highest number of filtered publications will be shown.

  15. Popular Publications
All filtered publications, which are cited at least by one other article, will be displayed under the "Data Table of Highly Cited/Most Recent Publications" block. There are 7 columns: PMID, title, citations, journal, language, country, and date in PubMed. Rows could be reordered by any sequence of these headings, with the default order as descending number of citations. A search box for free-text search is available. The table will be divided into multi-pages with 10 rows on each page. Each page could be downloaded as CSV or EXCEL file.


CITATION MAP tab
The CITATION MAP tab outputs selected publications, as defined by the user in the search panel to the left (black), and associated citations. The CITATION MAP tab includes nodes of filtered publications and their citations with directed edges linking citations to their target publications. There are five output areas under the CITATION MAP tab: the basic summary, Central Publications, Degree Distribution, Hubs in Citation Map, and Visualization of Citation Map with links to inputted target PMIDs of interest.

  16. CITATION MAP ? Summary
On the top left of the CITATION MAP tab, there are two value boxes: a yellow box displaying the number of publications in the citation map (nodes), and a green box displaying the number of citation pairs (directed edges). Click of the ?START/UPDATE? button on the left black filter in search functions (Part 1) is required to fully update the results of ?CITATION MAP? tab.

  17. Hubs in Citation Map
The panel Hubs in Citation Map displays publications that are highly connected in terms of the citation connectivity. It includes 7 columns: PMID, In, Out and Total degree, Title, LitCovid (value is true if the publication is included in LitCovid), and Global Filter (value is true if the publication is selected by the user in the search panel to the left [black]), with the default order as descending Total degree of connectivity.

  18. Central Publications
The Central Publications output consists of a scatter plot, with the x-axis showing the In-degree distribution (number of references, log10 scale) and the y-axis showing the Out-degree distribution (number of citations by other publications, log10 scale). Each scatter point is a publication. When the in- and out-degree values are moused-over, the PMID, and title of the publication will be shown. Publications with higher out-degree score are highly cited papers, whereas publications with higher in-degree scores generally indicate more of a review-type paper. 

  19. Degree Distribution
The degree distribution is a common topological analysis in network biology. This CORACLE output consists of a scatter plot of publications (blue point) with the x-axis showing the total degree distribution (sum of in-and out-degree) of the network of the articles selected in the left (black) panel, and the y-axis displaying the corresponding probability distribution of the total degree distribution (log10 scale). The linear regression between x and y is displayed in orange. A power-law distribution indicates a scale-free feature of the network. 

  20. Visualization of Citation Map
The bottom panel of the CITATION MAP tab facilitates visualization of the citation network, with publications represented by nodes and each reference being represented by an edge. Input the PMIDs of interest in the box and press the "Visualize" button. Please note that only the top 1000 edges will be shown. If you wish to visualize the full citation map, please press the Download Full Map text in blue to download the full citation map, and draw it by your local software of choice, such as Cytoscape or R. Please note that the default input of the text input box "Input target PMID for Visualization" is the 3 most highly connected nodes. Users could input customized newline-separated lists of PMID (i.e., press "Enter" (the Enter key on the keyboard) between each input), and push the ?Visualize? button anew to display the updated network on the right. Please note that if this text input box is empty, the user needs to push the "START/UPDATE" button in the global filter block. User-inputted target PMIDs are indicated as red nodes. Green node color indicates publications included in the LitCovid database or COVID-19 related literature, and grey node color indicates other publications cited by the COVID-19 literature. A mouse-click on a node in the network will display the title of the publication, and a mouse-click of the title will provide a link to the article in the PubMed database. 


SIMILARITY CITATION NETWORK tab
The SIMILARITY CITATION NETWORK tab outputs networks of the publications (selected in the left-hand search panel (black), and related publications with similar citations (at least 3 shared reference). The similarity citation network includes nodes of selected publications linked by their related publications, as calculated by the number of undirected edges. The edge weight is the number of shared citations between two node publications. There are five output areas in the SIMILARITY CITATION NETWORK tab: the basic summary, Distribution of Shared Citations, Degree Distribution, Hubs in Similarity Citation Network, and Visualization of Similarity Citation Network, the latter linking to inputted PMIDs of interest.

  21. SIMILARITY CITATION NETWORK - Summary
The top left panel of the SIMILARITY CITATION NETWORK tab contains two value boxes: a yellow box displaying the number of publications in the similarity citation network (nodes), and a green box displaying the number of publication pairs with more than 3 shared citations (undirected edges). 

  22. Hubs in Similarity Citation Network
The Hubs in Similarity Citation Network panel displays a list of publications ranked according to their degree of interconnectedness with other publications. Publications with a high degree of connectedness, i.e., a hub, are often seminal or breakthrough original research papers, or review paper. The Hubs in Similarity Citation Network table consists of 5 columns; PMID, Degree, Title, LitCovid (value is "true" if the publication is included in LitCovid), and Global Filter (value is true if the publication is selected in the search block to the left [black]), with the default order as descending Degree.

  23. Distribution of Shared Citations
The Distribution of Shared Citations panel is a bar plot with the x-axis displaying the number of shared citations between two publications (termed a publication pair), representing the weight of edges, and the y-axis displaying the number of publication pairs for each weight. The higher the edge weight, the stronger two publications are related. 

  24. Degree Distribution
Similar to the Degree Distribution panel in the CITATION MAP tab, the Degree Distribution panel in the SIMILARITY CITATION NETWORK tab consists of a scatter plot of publications (blue point) with the x-axis showing the degree distribution (total connections), and the y-axis displaying the corresponding probability distribution of the total degree distribution. The difference is that here the total connection refers to number of linking publications with undirected edgess, whereas in the CITATION MAP Degree Distribution, the total connections refer to the sum of direct citations (in-degree) and cited by other works (out-degree). The correlation between x and y is displayed in orange. A power-law relationship indicates a scale-free feature of the network.

  25. Visualization of Similarity Citation Network
The bottom panel of the SIMILARITY CITATION NETWORK tab facilitates visualization of the citation network, with publications represented by nodes and each edge representing at least 3 shared reference between the publication pairs. Mouse-over the edge will display the number of shared publications between the pair. Input the PMIDs of interest in the box and press the "Visualize" button. Please note that only the top 1000 edges will be shown. If you wish to visualize the full citation map, please press the Download Full Map text in blue to download the full citation map, and draw it by your local software of choice, such as Cytoscape or R. Please note that the default input of the text input box "Input target PMID for Visualization" is the 3 most highly connected nodes. Users could input customized newline-separated lists of PMID (i.e., press "Enter" (the Enter key on the keyboard) between each input), and push the ?Visualize? button anew to display the updated network on the right. Please note that if this text input box is empty, the user needs to push the "START/UPDATE" button in the global filter block. User-inputted target PMIDs are indicated as red nodes. Green node color indicates publications included in the LitCovid database or COVID-19 related literature, and grey node color indicates other publications cited by the COVID-19 literature. A mouse-click on a node in the network will display the title of the publication, and a mouse-click of the title will provide a link to the article in the PubMed database.


  MeSH MAP tab
The MeSH MAP tab outputs network analyses of keyword annotations for the selected publications, annotated according to the Medical Subject Headings (MeSH) terms utilized in PubMed. By default, the MeSH terms annotated to the publications selected in the search panel to the left (black) are included, undirected edges. The edge weight is the number of shared publications between two MeSH terms with at least three shared publications. There are four output areas under the MeSH MAP tab: the basic summary, Hubs in MeSH MAP, Distribution of Shared Publications, and Visualization of MeSH Map.

  26. MeSH MAP ? Summary
On the top left of the MeSH MAP tab, two value boxes are displayed: a yellow box showing the number of MeSH terms annotated by the selected publications (nodes), and a green box showing the number of MeSH term pairs with more than 3 shared publications in the full CORACLE database of COVID-19 related publications (undirected edges). 

  27. Hubs in MeSH Map
The panel Hubs in MeSH Map displays MeSH terms that are highly connected in terms of the the number of publications they are annotated to in the selected publications. The table includes 3 columns, MeSH, Degree, and Selected (value is true if the MeSH is annotated by the publications selected in the search block to the left[black]), with the default order as descending Degree.

  28. Distribution of Shared Publications
The Distribution of Shared Publications panel " is a bar plot with the x-axis displaying the number of shared publications for each pair of MeSH terms, representing the wiehgt of the edges, and the y-axis displaying the number of MeSH pairs for each weight. The higher the edge weight, the stronger two MeSH term keywords are related in the COVID-19 literature.

  29. Visualization of MeSH Map
The bottom panel of the MeSH MAP tab facilitates visualization of the MeSH term similarity network, with MeSH term represented by nodes and each edge representing at least 3 shared publications for the respective MeSH pair. The name of the MeSH term is displayed by each node when zoomed in. Mouse-over the edge will display the number of shared publications between the pair. Input the MeSH terms of interest in the box and press the "Visualize" button. Please note that only the top 1000 edges will be shown. If you wish to visualize the full MeSH map, please press the Download Full Map text in blue to download the full citation map, and draw it by your local software of choice, such as Cytoscape or R. Please note that the default input of the text input box "Input target MeSH term for Visualization" is the 3 most highly connected nodes. Users could input customized newline-separated lists of MeSH (i.e., press "Enter" (the Enter key on the keyboard) between each input), and push the ?Visualize? button anew to display the updated network on the right. Please note that if this text input box is empty, the user needs to push the "START/UPDATE" button in the global filter block. User-inputted target MeSHs are indicated as red nodes. Green node color indicates MeSH terms included in the LitCovid database or COVID-19 related literature, and grey node color indicates other publications cited by the COVID-19 literature. 

Data Table
The top banner displays a Data Table, which is be linked to a GitHub repository for daily updated data tables. For more details, please read the ReadMe file.

 Part 3 - How to run CORACLE locally from your computer
CORACLE is available both as a web based application (https://datahub.shinyapps.io/CORACLE/) as well as a downloadable application to be run locally on your personal computer from GitHub (see instructions below). Running CORACLE locally may improve performance time, particularly when the internet access is limiting, as well as avoid interruptions caused by the automatic disconnect from the R Shiny that occurs after 5 minutes of inactivity.

The full code for CORACLE is made available for download at https://github.com/clisweden/coracle_shiny
Users need to install Rstudio (free desktop version available at https://rstudio.com/products/rstudio/download/), as well as all required packages as outlined in the file dependencies.R. In Rstudio, the user could open the file server.R or ui.R, then press the "run App" button to run the CORACLE shiny  app locally on your desktop. 

Part 4 - Examples
  Tracking ACE2 in COVID-19
ACE2 is one of the emerging research topics in COVID-19. Users could the first setup the date range from the earliest to the latest and input ace2 in the "Enter MeSH(s) [OR]" input, and select all related MeSHs by text matching (As in the following table). Besides, users could download a PMID list from PubMed and input into the ?Enter PMID list? with the default ?Customized PMID rules" of OR (union). The example file of ACE2 related PMID list is at https://raw.githubusercontent.com/clisweden/coracle_data/master/acelist20200506.csv. After pushing the "START/UPDATE? button, all ACE2 related publications, their citations, related publications with similar citations, MeSH will be displayed.

MeSH Terms
ace 
ace 2 
ace inh/arbs 
ace inhibitor 
ace inhibitors 
ace inhibitors/angiotensin receptor blockers (aceis/arbs 
ace-2 
ace-2 receptor 
ace-2 receptors 
ace-2-r 
ace-2, angiotensin-converting enzyme 2 
ace-angiotensin-converting enzyme 
ace-i, angiotensin-converting enzyme inhibitor 
ace-inhibition 
ace-inhibitors 
ace2 
ace2 blocker 
ace2 expression 
ace2 gene 
ace2 negative 
ace2 receptor 
ace2 receptor. 
ace2 receptors 
ace2 transcriptome 
ace2 variants 
ace2-b0at1 
ace2, acute kidney injury 
ace2, angiotensin converting enzyme 2 
ace2, angiotensin converting enzyme-2 
ace2, angiotensin receptor 2 
ace2, angiotensin-converting enzyme 2 
ace2, cardiovascular disease, covid-19 
ace2. 
acei 
acei or arb 
acei, angiotensin converting enzyme inhibitor 
acei/arb 
acei/arbs 
aceis, angiotensin converting enzyme inhibitors 
aceis/arbs 
acetaminophen 
acetazolamide 
acetylsalicylic acid 
angiotensin converting enzyme 2 (ace2 
angiotensin converting enzyme ii (ace2 
angiotensin-converting enzyme 2 (ace-2 
angiotensin-converting enzyme 2 (ace2 
angiotensin-converting enzyme 2, ace2 
angiotensin-converting enzyme inhibitor (acei 
angiotensin-converting enzyme inhibitors (aceis 
angiotensin-converting enzyme inhibitors, acei 
angiotensin-converting enzyme-2 (ace2 
coronavirus, sars-cov-2, covid-19, ace 2, neurotoxicity, brain, seizures. 
covid-19, smoking, ace2, sars-cov2, copd 
expression of ace2 
hace-2 
hace2 transgenic mice 
hace2-ki/nifdc 
histone deacetylases 
home spaces 
hormonal contraceptives 
human ace2 transgenic mouse 
human angiotensin-converting enzyme 2 (ace2 
humen ace2 
rhace2 




9


