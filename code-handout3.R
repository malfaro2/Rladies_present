## Code handout 2

# Objetivos de aprendizaje:

## Paquetes dplyr y tidyr
## Seleccionar ciertas columnas en un data.frame SELECT
## Seleccionar ciertas filas en un data.frame FILTER
## Relacionar el output de dplyr con el de otras funciones PIPE
## Agregar nuevas columnas MUTATE
## Usar el método de partir-aplicar-combinar (split-apply-combine)
## Usar SUMMARIZE, GROUP BY, COUNT para resumir datos
## Describir el concepto de tablas anchas y largas.
## Describir qué es un par de valores llave (key-value pairs)
## Darle una nueva forma a los datos  SPREAD, GATHER
## Exportar un data frame a un archivo .csv.

# The tidyverse package tries to address 3 common issues that arise 
# when doing data analysis with some of the functions that come with R:
  
# The results from a base R function sometimes depend on the type of data.
# Using R expressions in a non standard way, which can be confusing 
# for new learners.
# Hidden arguments, having default operations that new learners 
# are not aware of.

## load the tidyverse packages, incl. dplyr
library("tidyverse")

# https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# https://www.rstudio.com/resources/cheatsheets/
  
surveys <- read_csv("data/portal_data_joined.csv")

## inspect the data
str(surveys)

## preview the data
View(surveys)

# This is referred to as a “tibble”. Tibbles tweak some of the 
# behaviors of the data frame objects we introduced in the previous 
# episode. The data structure is very similar to a data frame. 
# For our purposes the only differences are that:
  
# In addition to displaying the data type of each column under its name, 
# it only prints the first few rows of data and only as many columns as 
# fit on one screen.
# Columns of class character are NEVER converted into factors.

# We’re going to learn some of the most common dplyr functions:
  
#select(): subset columns
#filter(): subset rows on conditions
#mutate(): create new columns by using information from other columns
#group_by() and summarize(): create summary statisitcs on grouped data
#arrange(): sort results
#count(): count discrete values

# Selecting columns and filtering rows

select(surveys, plot_id, species_id, weight)

select(surveys, -record_id, -species_id)

filter(surveys, year == 1995)

# Pipes

# Antes:
surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)
surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)

# you can type the pipe with Ctrl + Shift + M 
# if you have a PC or Cmd + Shift + M if you have a Mac.

surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)


## ## Pipes Challenge:
## Usando tuberías, seleccione los datos para incluir los animales 
## recolectados antes de 1995, y retenga las columnas `year`,` sex` 
## y `weight`

surveys %>%
  filter(year < 1995) %>%
  select(year, sex, weight)

## Mutate

surveys %>%
  mutate(weight_kg = weight / 1000)

surveys %>%
  mutate(weight_kg = weight / 1000,
         weight_kg2 = weight_kg * 2)

surveys %>%
  mutate(weight_kg = weight / 1000) %>%
  head()

surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight / 1000) %>%
  head()

# Mutate Challenge:
## Cree un nuevo marco de datos a partir de los datos de las 'surveys` 
## que cumplan con lo siguiente criterio: contiene solo la columna 
## species_id` y una columna que contiene valores que son la mitad 
## de los valores de `hindfoot_length` (por ejemplo, un nueva columna 
## `hindfoot_half`). En esta columna `hindfoot_half`, no hay valores 
## de NA y todos los valores son <30.

# Hint: think about how the commands should be ordered to produce 
# this data frame!

surveys_hindfoot_half <- surveys %>%
  filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_half = hindfoot_length / 2) %>%
  filter(hindfoot_half < 30) %>%
  select(species_id, hindfoot_half)


# Split-apply-combine data analysis and the summarize() function

surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))

surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight))

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight)) %>%
  print(n = 15)

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight))

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(min_weight)

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(desc(mean_weight))

# Counting

surveys %>%
  count(sex) 

surveys %>%
  group_by(sex) %>%
  summarise(count = n())

surveys %>%
  count(sex, sort = TRUE) 

surveys %>%
  count(sex, species) 

surveys %>%
  count(sex, species) %>%
  arrange(species, desc(n))

## ## Count Challenges:
## ##  1. ¿Cuántos animales fueron capturados en cada `plot_type`?

surveys %>%
  count(plot_type) 

## ##  2. Use `group_by()` y `summarize()` para encontrar 
# la media, el mínimo y el máximo min, and max de hindfoot length 
# para cada especie (usando `species_id`). Tambien agregue el número
## de observaciones (hint: vea `?n`)

surveys %>%
  filter(!is.na(hindfoot_length)) %>%
  group_by(species_id) %>%
  summarize(
    mean_hindfoot_length = mean(hindfoot_length),
    min_hindfoot_length = min(hindfoot_length),
    max_hindfoot_length = max(hindfoot_length),
    n = n()
  )

# Reshaping with gather and spread

# Spreading
#spread() takes three principal arguments:
   
#  the data
#  the key column variable whose values will become new column names.
#  the value column variable whose values will fill the new column variables.

surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(genus, plot_id) %>%
  summarize(mean_weight = mean(weight))

str(surveys_gw)

surveys_spread <- surveys_gw %>%
  spread(key = genus, value = mean_weight)

str(surveys_spread)

## Ver figura que explica spread:

# https://datacarpentry.org/R-ecology-lesson/img/spread_data_R.png


surveys_gw %>%
  spread(genus, mean_weight, fill = 0) %>%
  head()


# Gathering

# gather() takes four principal arguments:
  
# the data
# the key column variable we wish to create from column names.
# the values column variable we wish to create and fill with 
# values associated with the key.
# the names of the columns we use to fill the key variable (or to drop).

surveys_gather <- surveys_spread %>%
  gather(key = genus, value = mean_weight, -plot_id)

str(surveys_gather)

# https://datacarpentry.org/R-ecology-lesson/img/gather_data_R.png


surveys_spread %>%
  gather(key = genus, value = mean_weight, Baiomys:Spermophilus) %>%
  head()

## ## Reshaping challenges

# 1. Cree un data.frame ancho (wide) con `año` como columnas,
# ` plot_id`` como filas, y donde los valores son el número 
# de géneros por parcela. Deberá resumir antes de volver a 
# configurar, y usar la función `n_distinct` para obtener 
# el número de géneros únicos dentro de una porción de datos. 
# ¡Es una función poderosa! Vea `? N_distinct` para más.

rich_time <- surveys %>%
  group_by(plot_id, year) %>%
  summarize(n_genera = n_distinct(genus)) %>%
  spread(year, n_genera)

head(rich_time)


# 2. Ahora toma ese data.frame y hágalo largo otra vez, para que 
# cada fila sea una combinación única `plot_id`` año`

# Exporting data

surveys_complete <- surveys %>%
  filter(!is.na(weight),           # remove missing weight
         !is.na(hindfoot_length),  # remove missing hindfoot_length
         !is.na(sex))                # remove missing sex

## Extract the most common species_id
species_counts <- surveys_complete %>%
  count(species_id) %>% 
  filter(n >= 50)

## Only keep the most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)

write_csv(surveys_complete, path = "data_output/surveys_complete.csv")

