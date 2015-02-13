download.file("http://r-bio.github.io/data/holothuriidae-specimens.csv", "data/holothuriidae-specimens.csv")

download.file("http://r-bio.github.io/data/holothuriidae-nomina-valid.csv", "data/holothuriidae-nomina-valid.csv")

hol <- read.csv(file="data/holothuriidae-specimens.csv", stringsAsFactors=FALSE)

nom <- read.csv(file="data/holothuriidae-nomina-valid.csv", stringsAsFactors=FALSE)


## How many specimens are included in the data frame hol?

head(hol)

length(hol$dwc.family)

length(hol$dwc.occurrenceID)


#2984 specimens

##  The column dwc.institutionCode in the hol data frame lists the museum where the specimens are housed:
##How many institutions house specimens?
##Draw a bar plot that shows the contribution of each institution


table(hol$dwc.institutionCode)
## 4 institutions (CAS, FLMNH, MCZ, YPM)

barplot(table(hol$dwc.institutionCode))

##The column dwc.year indicates when the specimen was collected:
##When was the oldest specimen included in this data frame collected ? (hint: It was not in year 1)

summary(hol$dwc.year)

min(hol$dwc.year, na.rm=TRUE)

which(hol$dwc.year==91)

min(hol$dwc.year[-2272], na.rm=TRUE)
## answer 1991?

which(hol$dwc.year==91)

min(hol$dwc.year[-c(2272, 93, 272, 2182,2226,2815,2879)], na.rm=TRUE)

## or maybe 1902 actually

##What proportion of the specimens in this data frame were collected between the years 2006 and 2014 (included)?

table(hol$dwc.year)

length(hol$dwc.year[-seq(0,2005)])  ##979

length(hol$dwc.year)    ##2984

979/2984   ###.3280831    ##There must be a better way to do this

prop <- hol$dwc.year

prop > 2005

mean(prop > 2005)   ##didn't work, got NA



##The function nzchar() on a vector returns TRUE for the positions of the vectors that are not empty, and FALSE otherwise. For instance, nzchar(c("a", "b", "", "", "e")) would return the vector c(TRUE, TRUE, FALSE, FALSE, TRUE). The column dwc.class is supposed to contain the Class information for the specimens (here they should all be "Holothuroidea"). However, it is missing for some. Use the function nzchar to answer:
 ## How many specimens do not have the information for class listed?
##For the specimens where the information is missing, replace it with the information for their (again, they should all be "Holothuroidea").

nzchar(hol$dwc.class)

summary(nzchar(hol$dwc.class))

sum(nzchar(hol$dwc.class))

## 50 are empty

hol$dwc.class[] <- "Holothuroidea"

nzchar(hol$dwc.class)

summary(nzchar(hol$dwc.class))

sum(nzchar(hol$dwc.class))

##Using the nom data frame, and the columns Subgenus.current and Genus.current, 
##which of the genera listed has/have subgenera?

nzchar(nom$Genus.current)
nzchar(nom$Subgenus.current)

nom$Genus.current[nzchar(nom$Subgenus.current)]

##We want to combine the information included in the nom and the hol spreadsheets,
##to identify the specimens in the data frame that use species names that are not valid. 
##We'll do this using the function merge().
##By default merge() only returns the rows for which there is an exact match in both datasets. 
##Here, because nom only includes the names of the valid species, 
##the results would not include any of the specimen information that do not have valid names. 
##Read the help of the merge() function to learn more about it.

##With the function paste(), create a new column (called genus_species) that 
##contains the genus (column dwc.genus) and species names (column dwc.specificEpithet) for the hol data frame.

genus_species <- paste(hol$dwc.genus, hol$dwc.specificEpithet)

hol <- cbind(hol, genus_species=genus_species)

##Do the same thing with the nom data frame (using the columns Genus.current and species.current).

genus_species_current <- paste(nom$Genus.current, nom$species.current)

nom <- cbind(nom, genus_species=genus_species_current)

##Use merge() to combine hol and nom (hint: you will need to use the all.x argument,
##read the help to figure it out, and check that the resulting data frame has the same number of rows as hol).

?merge()

hol_nom_merge <- merge(hol, nom, all.x=TRUE)

nrow(hol)
nrow(hol_nom_merge)

##Create a data frame that contains the information for the specimens identified 
##with an invalid species name (content of the column Status is not NA)? 
##(hint: specimens identified only with a genus name shouldn't be included in this count.)

Rm_NA <- hol_nom_merge[!is.na(hol_nom_merge$Status), ]

invalid_species <- Rm_NA[Rm_NA$Valid == "no", ]


##Select only the columns: idigbio.uuid, dwc.genus, dwc.specificEpithet, dwc.institutionCode, 
##dwc.catalogNumber from this data frame and export the data as a CSV file (using the function write.csv)
##named holothuriidae-invalid.csv

invalid_species2 <- invalid_species[ ,c("idigbio.uuid", "dwc.genus", "dwc.specificEpithet", "dwc.institutionCode", "dwc.catalogNumber")]

write.csv(invalid_species2, file="data/holothuriidae-invalid.csv")
