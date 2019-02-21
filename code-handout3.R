## Code handout 2

# Objetivos de aprendizaje:

# Describe the purpose of the dplyr and tidyr packages.
# Select certain columns in a data frame with the dplyr function select.
# Select certain rows in a data frame according to filtering conditions with the dplyr function filter .
# Link the output of one dplyr function to the input of another function with the ‘pipe’ operator %>%.
# Add new columns to a data frame that are functions of existing columns with mutate.
# Use the split-apply-combine concept for data analysis.
# Use summarize, group_by, and count to split a data frame into groups of observations, apply summary statistics for each group, and then combine the results.
# Describe the concept of a wide and a long table format and for which purpose those formats are useful.
# Describe what key-value pairs are.
# Reshape a data frame from long to wide format and back with the spread and gather commands from the tidyr package.
# Export a data frame to a .csv file.





## ## Pipes Challenge:
## ##  Using pipes, subset the data to include animals collected
## ##  before 1995, and retain the columns `year`, `sex`, and `weight.`
## ## Mutate Challenge:
## ##  Create a new data frame from the `surveys` data that meets the following
## ##  criteria: contains only the `species_id` column and a column that
## ##  contains values that are half the `hindfoot_length` values (e.g. a
## ##  new column `hindfoot_half`). In this `hindfoot_half` column, there are
## ##  no NA values and all values are < 30.
## 
## ##  Hint: think about how the commands should be ordered to produce this data frame!
## ## Count Challenges:
## ##  1. How many animals were caught in each `plot_type` surveyed?
## 
## ##  2. Use `group_by()` and `summarize()` to find the mean, min, and max
## ## hindfoot length for each species (using `species_id`). Also add the number of
## ## observations (hint: see `?n`).
## 
## ##  3. What was the heaviest animal measured in each year? Return the
## ##  columns `year`, `genus`, `species_id`, and `weight`.
## ## Reshaping challenges
## 
## ## 1. Make a wide data frame with `year` as columns, `plot_id`` as rows, and where the values are the number of genera per plot. You will need to summarize before reshaping, and use the function `n_distinct` to get the number of unique genera within a chunk of data. It's a powerful function! See `?n_distinct` for more.
## 
## ## 2. Now take that data frame, and make it long again, so each row is a unique `plot_id` `year` combination
## 
## ## 3. The `surveys` data set is not truly wide or long because there are two columns of measurement - `hindfoot_length` and `weight`.  This makes it difficult to do things like look at the relationship between mean values of each measurement per year in different plot types. Let's walk through a common solution for this type of problem. First, use `gather` to create a truly long dataset where we have a key column called `measurement` and a `value` column that takes on the value of either `hindfoot_length` or `weight`. Hint: You'll need to specify which columns are being gathered.
## 
## ## 4. With this new truly long data set, calculate the average of each `measurement` in each `year` for each different `plot_type`. Then `spread` them into a wide data set with a column for `hindfoot_length` and `weight`. Hint: Remember, you only need to specify the key and value columns for `spread`.
## 
## ### Create the dataset for exporting:
## ##  Start by removing observations for which the `species_id`, `weight`,
## ##  `hindfoot_length`, or `sex` data are missing:
## surveys_complete <- surveys %>%
##     filter(species_id != "",        # remove missing species_id
##            !is.na(weight),                 # remove missing weight
##            !is.na(hindfoot_length),        # remove missing hindfoot_length
##            sex != "")                      # remove missing sex
## 
## ##  Now remove rare species in two steps. First, make a list of species which
## ##  appear at least 50 times in our dataset:
## species_counts <- surveys_complete %>%
##     count(species_id) %>%
##     filter(n >= 50) %>%
##     select(species_id)
## 
## ##  Second, keep only those species:
## surveys_complete <- surveys_complete %>%
##     filter(species_id %in% species_counts$species_id)


### Data Visualization with ggplot2
## install.packages("hexbin")
## library(hexbin)
## surveys_plot +
##  geom_hex()
## ### Challenge with hexbin
## ##
## ## To use the hexagonal binning with **`ggplot2`**, first install the `hexbin`
## ## package from CRAN:
## 
## install.packages("hexbin")
## library(hexbin)
## 
## ## Then use the `geom_hex()` function:
## 
## surveys_plot +
##     geom_hex()
## 
## ## What are the relative strengths and weaknesses of a hexagonal bin
## ## plot compared to a scatter plot?
## ## Challenge with boxplots:
## ##  Start with the boxplot we created:
## ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
##   geom_boxplot(alpha = 0) +
##   geom_jitter(alpha = 0.3, color = "tomato")
## 
## ##  1. Replace the box plot with a violin plot; see `geom_violin()`.
## 
## ##  2. Represent weight on the log10 scale; see `scale_y_log10()`.
## 
## ##  3. Create boxplot for `hindfoot_length` overlaid on a jitter layer.
## 
## ##  4. Add color to the data points on your boxplot according to the
## ##  plot from which the sample was taken (`plot_id`).
## ##  *Hint:* Check the class for `plot_id`. Consider changing the class
## ##  of `plot_id` from integer to factor. Why does this change how R
## ##  makes the graph?
## 
## ### Plotting time series challenge:
## ##
## ##  Use what you just learned to create a plot that depicts how the
## ##  average weight of each species changes through the years.
## 
## install.packages("gridExtra")
## ### Final plotting challenge:
## ##  With all of this information in hand, please take another five
## ##  minutes to either improve one of the plots generated in this
## ##  exercise or create a beautiful graph of your own. Use the RStudio
## ##  ggplot2 cheat sheet for inspiration:
## ##  https://www.rstudio.com/wp-content/uploads/2015/08/ggplot2-cheatsheet.pdf


## SQL databases and R
## install.packages(c("dbplyr", "RSQLite"))
library(dplyr)
library(dbplyr)
mammals <- DBI::dbConnect(RSQLite::SQLite(), "data/portal_mammals.sqlite")
src_dbi(mammals)
tbl(mammals, sql("SELECT year, species_id, plot_id FROM surveys"))
surveys <- tbl(mammals, "surveys")
surveys %>%
  select(year, species_id, plot_id)
## with dplyr syntax
species <- tbl(mammals, "species")

left_join(surveys, species) %>%
  filter(taxa == "Rodent") %>%
  group_by(taxa, year) %>%
  tally %>%
  collect()

## with SQL syntax
query <- paste("
               SELECT a.year, b.taxa,count(*) as count
               FROM surveys a
               JOIN species b
               ON a.species_id = b.species_id
               AND b.taxa = 'Rodent'
               GROUP BY a.year, b.taxa",
               sep = "" )

tbl(mammals, sql(query))


### Challenge
## Write a query that returns the number of rodents observed in each
## plot in each year.

##  Hint: Connect to the species table and write a query that joins
##  the species and survey tables together to exclude all
##  non-rodents. The query should return counts of rodents by year.

## Optional: Write a query in SQL that will produce the same
## result. You can join multiple tables together using the following
## syntax where foreign key refers to your unique id (e.g.,
## `species_id`):

## SELECT table.col, table.col
## FROM table1 JOIN table2
## ON table1.key = table2.key
## JOIN table3 ON table2.key = table3.key

## species <- tbl(mammals, "species")
## genus_counts <- left_join(surveys, plots) %>%
##   left_join(species) %>%
##   group_by(plot_type, genus) %>%
##   tally %>%
##   collect()
### Challenge

## Write a query that returns the total number of rodents in each
## genus caught in the different plot types.

##  Hint: Write a query that joins the species, plot, and survey
##  tables together.  The query should return counts of genus by plot
##  type.
download.file("https://ndownloader.figshare.com/files/3299483",
              "data/species.csv")
download.file("https://ndownloader.figshare.com/files/10717177",
              "data/surveys.csv")
download.file("https://ndownloader.figshare.com/files/3299474",
              "data/plots.csv")
library(tidyverse)
species <- read_csv("data/species.csv")
surveys <- read_csv("data/surveys.csv")
plots <- read_csv("data/plots.csv")
my_db_file <- "data_output/portal-database-output.sqlite"
my_db <- src_sqlite(my_db_file, create = TRUE)
my_db
### Challenge

## Add the remaining species table to the my_db database and run some
## of your queries from earlier in the lesson to verify that you
## have faithfully recreated the mammals database.


