## Code handout 1

# Objetivos de aprendizaje:
# Definir los siguientes términos y cómo se usan en R: 
# object, assign, call, function, arguments, options.
# Asignar valores a objetos en R.
# Aprender a nombrar objetos en R.
# Usar comentarios para el script.
# Resolver problemas de aritmética simples en R.
# Llamar funciones que usan argumentos para cambiar las opciones default.
# Inspeccionar el contenido de vectores. 
# Subset y extraer los valores de vectores. 
# Analizar vectores con datos perdidos.

### Creating objects in R

3 + 5
12 / 7

weight_kg <- 55

# Objects vs. variables
# What are known as objects in R are known as 
# variables in many other programming languages. 
# Depending on the context, object and variable 
# can have drastically different meanings. 
# However, in this lesson, the two words are 
# used synonymously. For more information see: 
# https://cran.r-project.org/doc/manuals/r-release/R-lang.html#Objects

weight_kg <- 55    # doesn't print anything
(weight_kg <- 55)  # but putting parenthesis around the call prints the value of `weight_kg`
weight_kg          # and so does typing the name of the object

2.2 * weight_kg

weight_kg <- 57.5
2.2 * weight_kg

weight_lb <- 2.2 * weight_kg

weight_kg <- 100

### Challenge
##
## What are the values after each statement in the following?
##
## mass <- 47.5            # mass?
## age  <- 122             # age?
## mass <- mass * 2.0      # mass?
## age  <- age - 20        # age?
## mass_index <- mass/age  # mass_index?


## Functions and their arguments

b <- sqrt(a)

round(3.14159)

args(round)

?round

round(3.14159, digits = 2)

round(3.14159, 2)

round(digits = 2, x = 3.14159)

## Vectors and data types

weight_g <- c(50, 60, 65, 82)
weight_g

animals <- c("mouse", "rat", "dog")
animals

length(weight_g)
length(animals)

class(weight_g)
class(animals)

str(weight_g)
str(animals)

weight_g <- c(weight_g, 90) # add to the end of the vector
weight_g <- c(30, weight_g) # add to the beginning of the vector
weight_g

# Vectors are one of the many data structures that 
# R uses. Other important ones are lists (list), 
# matrices (matrix), data frames (data.frame), 
# factors (factor) and arrays (array).


## ## We’ve seen that atomic vectors can be of type character, numeric, integer, and
## ## logical. But what happens if we try to mix these types in a single
## ## vector?
## 
## ## What will happen in each of these examples? (hint: use `class()` to
## ## check the data type of your object)
## num_char <- c(1, 2, 3, "a")
## 
## num_logical <- c(1, 2, 3, TRUE)
## 
## char_logical <- c("a", "b", "c", TRUE)
## 
## tricky <- c(1, 2, 3, "4")
## 
## ## Why do you think it happens?
## 
## ## You've probably noticed that objects of different types get
## ## converted into a single, shared type within a vector. In R, we call
## ## converting objects from one class into another class
## ## _coercion_. These conversions happen according to a hierarchy,
## ## whereby some types get preferentially coerced into other types. Can
## ## you draw a diagram that represents the hierarchy of how these data
## ## types are coerced?
heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)

# 1.
heights_no_na <- heights[!is.na(heights)] 
# or
heights_no_na <- na.omit(heights)
# or
heights_no_na <- heights[complete.cases(heights)]

# 2.
median(heights, na.rm = TRUE)

# 3.
heights_above_67 <- heights_no_na[heights_no_na > 67]
length(heights_above_67)
## ###Challenge
## 1. Using this vector of heights in inches, create a new vector with the NAs removed.
##
##    heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)
##
## 2. Use the function `median()` to calculate the median of the `heights` vector.
##
## 3. Use R to figure out how many people in the set are taller than 67 inches.

## Subsetting vectors

animals <- c("mouse", "rat", "dog", "cat")
animals[2]

animals[c(3, 2)]

more_animals <- animals[c(1, 2, 3, 2, 1, 4)]
more_animals

# Conditional subsetting

weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, TRUE, TRUE, FALSE)]

weight_g > 50    # will return logicals with TRUE for the indices that meet the condition

## so we can use this to select only the values above 50
weight_g[weight_g > 50]

weight_g[weight_g < 30 | weight_g > 50]

weight_g[weight_g >= 30 & weight_g == 21]

animals <- c("mouse", "rat", "dog", "cat")
animals[animals == "cat" | animals == "rat"] # returns both rat and cat

animals %in% c("rat", "cat", "dog", "duck", "goat")

animals[animals %in% c("rat", "cat", "dog", "duck", "goat")]

## Can you figure out why "four" > "five" returns TRUE?

## Missing data

heights <- c(2, 4, 4, NA, 6)
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)


## Extract those elements which are not missing values.
heights[!is.na(heights)]

## Returns the object with incomplete cases removed. The returned object is an atomic vector of type `"numeric"` (or `"double"`).
na.omit(heights)

## Extract those elements which are complete cases. The returned object is an atomic vector of type `"numeric"` (or `"double"`).
heights[complete.cases(heights)]

## Challenge

# Using this vector of heights in inches, 
# create a new vector, heights_no_na, with the 
# NAs removed.

heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 
             59, 64, 69, 63, 63, NA, 72, 65, 64, 
             70, 63, 65)

# Use the function median() to calculate the median 
# of the heights vector.

# Use R to figure out how many people in the set 
# are taller than 67 inches.

