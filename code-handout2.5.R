
# open .Rproj file and make sure we have all the files:

# Volver a cargar todo:
### Presentation of the survey data
download.file(url="https://ndownloader.figshare.com/files/2292169",
              destfile = "data/portal_data_joined.csv")

encuesta <- read.csv("data/portal_data_joined.csv")
head(encuesta)


## Respuesta al ejercicio:

## 1.
encuesta_200 <- encuesta[200, ]
## 2.
# Saving `n_rows` to improve readability and reduce duplication
n_rows <- nrow(encuesta)
encuesta_last <- encuesta[n_rows, ]
## 3.
encuesta_middle <- encuesta[n_rows / 2, ]
## 4.
encuesta_head <- encuesta[-(7:n_rows), ]

# Factores

sex <- factor(c("male", "female", "female", "male"))

#R will assign 1 to the level "female" and 2 to the 
#level "male" (because f comes before m, even though 
# the first element in this vector is "male"). 

levels(sex)
nlevels(sex)

sex # current order
#> [1] male   female female male  
#> Levels: female male
sex <- factor(sex, levels = c("male", "female"))
sex # after re-ordering
#> [1] male   female female male  
#> Levels: male female


#Converting factors

as.character(sex)

year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)               # Wrong! And there is no warning...
as.numeric(as.character(year_fct)) # Works...
as.numeric(levels(year_fct))[year_fct]    # The recommended way.

# Notice that in the levels() approach, three important steps occur:
  
#We obtain all the factor levels using levels(year_fct)
#We convert these levels to numeric values using 
#as.numeric(levels(year_fct))
#We then access these numeric values using the underlying 
# integers of the vector year_fct inside the square brackets

# Renaming factors

## bar plot of the number of females and males captured during the experiment:
plot(encuesta$sex)
sex <- encuesta$sex
head(sex)
#> [1] M M        
#> Levels:  F M
levels(sex)
#> [1] ""  "F" "M"
levels(sex)[1] <- "Sin especificar"
levels(sex)
#> [1] "undetermined" "F"            "M"
head(sex)
#> [1] M            M            undetermined undetermined undetermined
#> [6] undetermined
#> Levels: undetermined F M
# Challenge

# En lugar de “F” y “M” cambie por “Femenino” and “Masculino” respectively.
#Now that we have renamed the factor level to “undetermined”, 
#can you recreate the barplot such that “undetermined” 
#is last (after “male”)?

#Using stringsAsFactors=FALSE
#By default, when building or importing a data frame, 
#the columns that contain characters (i.e. text) are 
#coerced (= converted) into factors. Depending on what 
#you want to do with the data, you may want to keep these 
#columns as character. To do so, read.csv() and read.table() 
#have an argument called stringsAsFactors which can be set to FALSE.

# it is preferable to set stringsAsFactors = FALSE when importing data 

## Compare the difference between our data read as `factor` vs `character`.
encuesta <- read.csv("data/portal_data_joined.csv", stringsAsFactors = TRUE)
str(encuesta)
encuesta <- read.csv("data/portal_data_joined.csv", stringsAsFactors = FALSE)
str(encuesta)
## Convert the column "plot_type" into a factor
encuesta$plot_type <- factor(encuesta$plot_type)

# Challenge

# We have seen how data frames are created when using read.csv(), 
# but they can also be created by hand with the data.frame() function. 
# There are a few mistakes in this hand-crafted data.frame. 
# Can you spot and fix them? Don’t hesitate to experiment!
  
animal_data <- data.frame(
    animal = c(dog, cat, sea cucumber, sea urchin),
    feel = c("furry", "squishy", "spiny"),
    weight = c(45, 8 1.1, 0.8)
)


# Formatting Dates
str(encuesta)

library(lubridate)
# ymd() takes a vector representing year, month, and day, 
# and converts it to a Date vector. Date is a class of data 
# recognized by R as being a date and can be manipulated as such. 
# The argument that the function requires is flexible, but, a
# s a best practice, is a character vector formatted as “YYYY-MM-DD”.

# Let’s create a date object and inspect the structure:
  
mi_fecha <- ymd("2015-01-01")
str(mi_fecha)

# sep indicates the character to use to separate each component
mi_fecha <- ymd(paste("2015", "1", "1", sep = "-")) 
str(mi_fecha)

paste(encuesta$year, encuesta$month, encuesta$day, sep = "-")

ymd(paste(encuesta$year, encuesta$month, encuesta$day, sep = "-"))
#> Warning: 129 failed to parse.

# The resulting Date vector can be added to encuesta as a new column 
# called date:
  
encuesta$date <- ymd(paste(encuesta$year, encuesta$month, encuesta$day, sep = "-"))
#> Warning: 129 failed to parse.
str(encuesta) # notice the new column, with 'date' as the class
#Let’s make sure everything worked correctly. One way to inspect 
#the new column is to use summary():
  
summary(encuesta$date)
#>         Min.      1st Qu.       Median         Mean      3rd Qu. 
#> "1977-07-16" "1984-03-12" "1990-07-22" "1990-12-15" "1997-07-29" 
#>         Max.         NA's 
#> "2002-12-31"        "129"

missing_dates <- encuesta[is.na(encuesta$date), c("year", "month", "day")]

head(missing_dates)
#>      year month day
#> 3144 2000     9  31
#> 3817 2000     4  31
#> 3818 2000     4  31
#> 3819 2000     4  31
#> 3820 2000     4  31
#> 3856 2000     9  31

## good quality control when entering data!

