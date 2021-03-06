#Wczytaj mapę
library(maptools)
woj_map <- readShapePoly("województwa.shp")
woj_map@data <- woj_map@data[ , c(5,6)]
woj_map@data$nazwa <- as.character(woj_map$jpt_nazwa_)
woj_map.gg <- fortify(woj_map, region="nazwa")
#Województwa - powiaty
pow_woj = read.table("kod_woj_clean", header = FALSE, sep = " ", colClasses = c("factor", "factor"))

#Read in data
sickness <- read.csv("zachorowania/Zachorowanianowotwory1999-2015powiaty.csv", header = T, sep=";", colClasses = c("numeric", "factor", "character", "character", "numeric"))
#Read countys coding
countys <- read.csv("powiaty.cleaned2.csv", header = F, sep=",", colClasses = c("factor", "factor"))
#Match codes to countys in one dataset
sickness$voivodeship <- pow_woj$V2[sickness$powiat]
sickness$countys <- countys$V1[sickness$powiat]
#Change the codes to be consisted along all rows
sickness$icd10[sickness$icd10 == "c17"] <- "C17"
sickness$icd10[sickness$icd10 == "c53"] <- "C53"
sickness$icd10[sickness$icd10 == "c83"] <- "C83"
#Change to english
sickness$plec[sickness$plec == "K"] <- "F"
#sickness$icd10 <- as.factor(sickness$icd10)
#To drop the levels that we deleted in previouse step
#sickness$icd10 <- droplevels(sickness$icd10)
#Map codes to placement/type of cancer, so it's easier to tell what is what
placement <- c("C00 Lip", "C01 Base of tongue", 
               "C02 Other and unspecified parts of tongue",
               "C03 Gum", "C04 Floor of mouth", "C05 Palate", 
               "C06 Other and unspecified parts of mouth", "C07 Parotid gland", 
               "C08 Other and unspecified parts of major salivary glands", 
               "C09 Tonsil", "C10 Oropharynx", "C11 Nasopharynx", "C12 Piriform sinus",
               "C13 Hypopharynx", 
               "C14 Other and ill-defined sites in the lip, oral cavity and pharynx", 
               "C15 Oesophagus", "C16 Stomach", "C17 Small intestine", "C18 Colon",
               "C19 Rectosigmoid junction", "C20 Rectum", "C21 Anus and anal canal",
               "C22 Liver and intrahepatic bile ducts", "C23 Gallbladder", 
               "C24 Other and unspecified parts of biliary tract", "C25 Pancreas", 
               "C26 Other and ill-defined digestive organs", 
               "C30 Nasal cavity and middle ear", "C31 Accessory sinuses", 
               "C32 Larynx", "C33 Trachea", "C34 Bronchus and lung", 
               "C37 Thymus", "C38 Heart, mediastinum and pleura", 
               "C39 Other and ill-defined sites in the respiratory system and intrathoracic organs",
               "C40 Bone and articular cartilage of limbs", 
               "C41 Bone and articular cartilage of other and unspecified sites", 
               "C43 Melanoma of skin", "C44 Neoplasms of skin", 
               "C45 Mesothelioma", "C46 Kaposi sarcoma", 
               "C47 Peripheral nerves and autonomic nervous system", 
               "C48 Retroperitoneum and peritoneum", 
               "C49 Other connective and soft tissue", "C50 Breast", "C51 Vulva", 
               "C52 Vagina", "C53 Cervix uteri", "C54 Corpus uteri", 
               "C55 Uterus, part unspecified", "C56 Ovary", 
               "C57 Other and unspecified female genital organs", "C58 Placenta",
               "C60 Penis", "C61 Prostate", "C62 Testis", 
               "C63 Other and unspecified male genital organs", 
               "C64 Kidney, except renal pelvis", "C65 Renal pelvis", "C66 Ureter",
               "C67 Bladder", "C68 Other and unspecified urinary organs",
               "C69 Eye and adnexa", "C70 Meninges", "C71 Brain", 
               "C72 Spinal cord, cranial nerves and other parts of central nervous system",
               "C73 Thyroid gland", "C74 Adrenal gland",
               "C75 Other endocrine glands and related structures", 
               "C76 Other and ill-defined sites", "C77 Lymph nodes", 
               "C78 Respiratory and digestive organs", "C79 Other and unspecified sites", 
               "C80 Without specification of site", "C81 Hodgkin lymphoma", 
               "C82 Follicular lymphoma", "C83 Non-follicular lymphoma", 
               "C84 Mature T/NK-cell lymphomas", 
               "C85 Other and unspecified types of non-Hodgkin lymphoma",
               "C88 Malignant immunoproliferative diseases", 
               "C90 Multiple myeloma and malignant plasma cell neoplasms", 
               "C91 Lymphoid leukaemia", "C92 Myeloid leukaemia", 
               "C93 Monocytic leukaemia", "C94 Other leukaemias of specified cell type",
               "C95 Leukaemia of unspecified cell type", 
               "C96 Other and unspecified malignant neoplasms of lymphoid, haematopoietic and related tissue",
               "C97 Malignant neoplasms of independent (primary) multiple sites", 
               "D00 Oral cavity, oesophagus and stomach", 
               "D01 Other and unspecified digestive organs", 
               "D02 Middle ear and respiratory system", "D03 In situ of different parts",
               "D04 Skin ", "D05 breast", "D06 cervix uteri", 
               "D07 Other and unspecified genital organs", 
               "D09 Other and unspecified sites")
names(placement) <- c(sort(unique(sickness$icd10)))
#Work placement into the dataset for consistency
sickness$placement <- placement[sickness$icd10]
#Clean temporary set
#rm(placement)
#aggregate do drop the info about countys as it is useless, because there is more codes
#than countys in Poland and we don't have any info about how it was coded

#sick <- aggregate(sickness$SUM_of_liczba, by=list(year=sickness$rok, gender=sickness$plec, 
#                                                  icd10=sickness$icd10, placement=sickness$placement), FUN=sum)
#sick <- aggregate(sickness$SUM_of_liczba, by=list(year=sickness$rok), FUN=sum)


#actually we somehow can map countys -> https://pl.wikisource.org/wiki/Polskie_powiaty_wed%C5%82ug_kodu_TERYT

#Narrow down the dataset
#sicknessC00 <- sickness[sickness$icd10 == "C01", ]
#sicknessC00 <- aggregate(sickness$SUM_of_liczba, by=list(rok=sickness$rok, 
#                                                         plec=sickness$plec), FUN=sum)

#Plot narrowed dataset
#ggplot(data = sicknessC00) +
#  geom_point(mapping = aes(x = sicknessC00$rok, y = sicknessC00$x, 
#                           color = sicknessC00$plec))

#Ideas how to visualize the data:
#1. If we decode the countys we can draw on map how many cancers we had in given year (we could differentiate by the type, gender)
#2. Graph showing what trends are visible in number of people getting sick through the years (differentiate gender, type)

narrow_dataset <- function(gender, type_of_sickness, voivodeship=NULL, year=NULL){
  narrowed_data <- sickness
  if(gender != "All"){
    narrowed_data <- narrowed_data[narrowed_data$plec == gender, ]
  }
  if(!is.null(voivodeship)){
    narrowed_data <- narrowed_data[narrowed_data$voivodeship == voivodeship, ]
  }
  if(!is.null(year)){
    narrowed_data <- narrowed_data[narrowed_data$rok == year, ]
  }
  narrowed_data <- narrowed_data[narrowed_data$placement == type_of_sickness, ]
  #narrowed_data <- aggregate(narrowed_data$SUM_of_liczba, by=list(rok=narrowed_data$rok, 
  #                                                                plec=narrowed_data$county), FUN=sum)
  return(narrowed_data)  
}