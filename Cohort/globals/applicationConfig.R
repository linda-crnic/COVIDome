library(config)
library(cyphr)
library(sodium)
library(base64enc)

# suppress warnings  
storeWarn <- getOption("warn")
options(warn = -1)

# get App metadata
appConfig <- config::get(file = "config/config.yml","appConfig") 

dataConnectionConfig <- config::get(file = "config/config.yml", "dataconnection")

key <- cyphr::key_sodium(base64enc::base64decode(dataConnectionConfig$db_key))

conn_args <- jsonlite::fromJSON(
  cyphr::decrypt_string(base64enc::base64decode(dataConnectionConfig$db_connection_string), key)
)

conn_args$driver <- dataConnectionConfig$driver
if (!is.null(dataConnectionConfig$TDS_Version)) {
  conn_args$TDS_Version <- dataConnectionConfig$TDS_Version
}

rm(dataConnectionConfig, key)

isProductionApp <- ifelse(appConfig$Environment=="Production",TRUE,FALSE)

isDeployed <-  Sys.getenv('SHINY_PORT') != ""

ApplicationURL <- ifelse(appConfig$Environment=="Production",appConfig$applicationURL,'')

sideBarMenuItems <- read_tsv('./config/sidebarmenuitems.tsv',col_types = cols()) %>% filter(IsHidden == 0) %>% select(-c(IsHidden))

namespaces <- as.list(sideBarMenuItems$tabName) 

tabs <- as.list(sideBarMenuItems$tabName)    

dropdownlinks <- read_tsv("./config/dropdownlinks.tsv",col_types = cols())

tutorials <- read_tsv("./config/tutorials.tsv",col_types = cols())

plotlyCustomIcons <- readRDS('config/plotlycustomicons.rds')

statTests <- CUSOMShinyHelpers::getStatTestByKeyGroup.methods

adjustmentMethods <- c("none","Bonferroni","Benjamini-Hochberg (FDR)")

pValueThreshold <- 0.05


