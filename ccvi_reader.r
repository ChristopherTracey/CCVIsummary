library(tidyverse)
library(readxl)
library(here)
require(knitr)


url_CCVIpage <- "http://www.naturalheritage.state.pa.us/climate.aspx"

ccvi_file <- "//wpc.local/WPCPublic/Public_/Conservation Programs/Natural Heritage Program/PNHP_CCVI/ccvi_release_3.02_Master.xlsm"

readxl::excel_sheets(ccvi_file)

ccvi <- readxl::read_xlsx(ccvi_file, "Results Table", range=cell_rows(5:87))

colnames(ccvi)
colnames_new <- read.csv(file="ccvicolnames.csv")
colnames(ccvi) <- colnames_new$nameNew


db_ccvi_code <- c("EV","HV","MV","LV","IE")
db_ccvi_name <- c("Extremely Vulnerable","Highly Vulnerable","Moderately Vulnerable","Not Vulnerable/Presumed Stable","Not Vulnerable/Increase Likely")
db_ccvi_desc <- c("Abundance and/or range extent within geographical area assessed extremely likely to substantially decrease or disappear by 2050.","Abundance and/or range extent within geographical area assessed likely to decrease significantly by 2050.","Abundance and/or range extent within geographical area assessed likely to decrease by 2050.","Available evidence does not suggest that abundance and/or range extent within the geographic area assessed will change (increase/decrease) substantially by 2050. Actual range boundaries may change.","Available evidence suggests that abundance and/or range extent within geographic area assessed is likely to increase by 2050.")
db_ccvi_col <- c("red","orange","yellow","green","gray")

db_ccvi <- data.frame(code=db_ccvi_code, name=db_ccvi_name, description=db_ccvi_desc, color=db_ccvi_col, stringsAsFactors=FALSE)
rm(db_ccvi_code, db_ccvi_name, db_ccvi_desc, db_ccvi_col)

##############################################################################################################
## Write the output document for the site ###############

i=1
#for(i in 1:nrow(ccvi)){

  # function to generate the pdf
  #knit2pdf(here::here("scripts","template_Formatted_NHA_PDF.rnw"), output=paste(pdf_filename, ".tex", sep=""))
  #makePDF <- function(rnw_template, pdf_filename) {
  fname <- stringi::stri_replace_all_fixed(ccvi$SNAME[i], " ", "_")
  knit(here::here("ccvi_summary.rnw"), output=paste(fname, ".tex",sep=""))
  call <- paste0("xelatex -interaction=nonstopmode ", fname , ".tex")
  system(call)
  #system(paste0("biber ",pdf_filename))
  #system(call) # 2nd run to apply citation numbers
  #}
  
#}


#setwd(paste(NHAdest, "DraftSiteAccounts", nha_foldername, sep="/"))
pdf_filename <- paste(nha_foldername,"_",gsub("[^0-9]", "", Sys.time() ),sep="")
makePDF(rnw_template, pdf_filename) # user created function
deletepdfjunk(pdf_filename) # user created function # delete .txt, .log etc if pdf is created successfully.
setwd(here::here()) # return to the main wd
