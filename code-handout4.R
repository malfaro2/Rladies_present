## Code handout 3
## Data Visualization with ggplot2
## Learning Objectives

# Produce scatter plots, boxplots, and time series plots using ggplot.
# Set universal plot settings.
# Describe what faceting is and apply faceting in ggplot.
# Modify the aesthetics of an existing ggplot plot (including axis labels and color).
# Build complex and customized plots from data in a data frame.

library(tidyverse)

surveys_complete <- read_csv("data_output/surveys_complete.csv")

## Plotting with **`ggplot2`**

 # ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +  <GEOM_FUNCTION>()

ggplot(data = surveys_complete)
ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length))


#`geom_point()` for scatter plots, dot plots, etc.
# `geom_boxplot()` for, well, boxplots!
# `geom_line()` for trend lines, time series, etc.  

ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length)) +
geom_point()

# Assign plot to a variable
surveys_plot <- ggplot(data = surveys_complete, 
mapping = aes(x = weight, y = hindfoot_length))
# Draw the plot
surveys_plot + 
geom_point()

# Create a ggplot and draw it
surveys_plot <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))
surveys_plot + 
geom_point()

# - Anything you put in the `ggplot()` function can be seen by any geom layers
# that you add (i.e., these are universal plot settings). This includes the x- and
# y-axis mapping you set up in `aes()`.
#- You can also specify mappings for a given geom independently of the
#mappings defined globally in the `ggplot()` function.
#- The `+` sign used to add new layers must be placed at the end of the line containing
#the *previous* layer. If, instead, the `+` sign is added at the beginning of the line
#containing the new layer, **`ggplot2`** will not add the new layer and will return an 
#error message.

# This is the correct syntax for adding layers
surveys_plot +
geom_point()
# This will not add the new layer and will return an error message
surveys_plot
+ geom_point()

## Challenge (optional)

# Scatter plots can be useful exploratory tools for small datasets. 
# For data sets with large numbers of observations, such as the 
# `surveys_complete` data set, overplotting of points can be a 
# limitation of scatter plots. One strategy for handling such 
# settings is to use hexagonal binning of observations. The
# plot space is tessellated into hexagons. Each hexagon is assigned a color
# based on the number of observations that fall within its boundaries.  To use
# hexagonal binning with **`ggplot2`**, first install the R package `hexbin`
# from CRAN:

install.packages("hexbin")
library(hexbin)

surveys_plot +
geom_hex()

# - What are the relative strengths and weaknesses of a hexagonal bin plot
#   compared to a scatter plot? Examine the above scatter plot and compare it
#  with the hexagonal bin plot that you created.

## Building your plots iteratively

#Building plots with **`ggplot2`** is typically an iterative process. We start by
#defining the dataset we'll use, lay out the axes, and choose a geom:
  
ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length)) +
  geom_point()

ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length)) +
  geom_point(alpha = 0.1)

ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length)) +
  geom_point(alpha = 0.1, color = "blue")

ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(color = species_id))

ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length, 
                                              color = species_id)) +
  geom_point(alpha = 0.1)

ggplot(data = surveys_complete, mapping = aes(x = weight, 
                                              y = hindfoot_length, 
                                              color = species_id)) +
  geom_jitter(alpha = 0.1)

# Challenge

# Use what you just learned to create a scatter plot of `weight` over
# `species_id` with the plot types showing in different colors. Is this a good
# way to show this type of data?

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
    geom_point(aes(color = plot_type))

## Boxplot

# We can use boxplots to visualize the distribution of weight within each species:
  
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot()

#By adding points to boxplot, we can have a better idea of the number of
#measurements and of their distribution:
  
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "tomato")

#Notice how the boxplot layer is behind the jitter layer? What do you need to
#change in the code to put the boxplot in front of the points such that it's not
#hidden?

## Plotting time series data

# Let's calculate number of counts per year for each species. First we need
# to group the data and count records within each group:

yearly_counts <- surveys_complete %>%
count(year, species_id)

#Time series data can be visualized as a line plot with years on the x axis and counts
#on the y axis:

ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
geom_line()

#Unfortunately, this does not work because we plotted data for all the species
#together. We need to tell ggplot to draw a line for each species by modifying
#the aesthetic function to include `group = species_id`:

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = species_id)) +
geom_line()

#We will be able to distinguish species in the plot if we add colors (using `color` also automatically groups the data):

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, color = species_id)) +
geom_line()

## Faceting

#**`ggplot2`** has a special technique called *faceting* that allows the user to split one
#plot into multiple plots based on a factor included in the dataset. We will use it to
#make a time series plot for each species:

ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
geom_line() +
facet_wrap(~ species_id)

#Now we would like to split the line in each plot by the sex of each individual
#measured. To do that we need to make counts in the data frame grouped by `year`,
#`species_id`, and `sex`:

yearly_sex_counts <- surveys_complete %>%
count(year, species_id, sex)

ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
geom_line() +
facet_wrap(~ species_id)

#Usually plots with white background look more readable when printed.  We can set
#the background to white using the function `theme_bw()`. Additionally, you can remove
#the grid:

ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
geom_line() +
facet_wrap(~ species_id) +
theme_bw() +
theme(panel.grid = element_blank())

## **`ggplot2`** themes

#In addition to `theme_bw()`, which changes the plot background to white, **`ggplot2`**
#comes with several other themes which can be useful to quickly change the look
#of your visualization. The complete list of themes is available
#at <http://docs.ggplot2.org/current/ggtheme.html>. `theme_minimal()` and
#`theme_light()` are popular, and `theme_void()` can be useful as a starting
#point to create a new hand-crafted theme.

#The [ggthemes](https://jrnold.github.io/ggthemes/reference/index.html) package
#provides a wide variety of options (including an Excel 2003 theme).
#The [**`ggplot2`** extensions website](https://www.ggplot2-exts.org) provides a list
#of packages that extend the capabilities of **`ggplot2`**, including additional
#themes.

 ### Challenge
# Use what you just learned to create a plot that depicts how the average weight
# of each species changes through the years.

yearly_weight <- surveys_complete %>%
  group_by(year, species_id) %>%
  summarize(avg_weight = mean(weight))
ggplot(data = yearly_weight, mapping = aes(x=year, y=avg_weight)) +
  geom_line() +
  facet_wrap(~ species_id) +
  theme_bw()

#The `facet_wrap` geometry extracts plots into an arbitrary number of dimensions
#to allow them to cleanly fit on one page. On the other hand, the `facet_grid`
#geometry allows you to explicitly specify how you want your plots to be
#arranged via formula notation (`rows ~ columns`; a `.` can be used as
#a placeholder that indicates only one row or column).

#Let's modify the previous plot to compare how the weights of males and females
#have changed through time:
  
# One column, facet by rows
yearly_sex_weight <- surveys_complete %>%
  group_by(year, sex, species_id) %>%
  summarize(avg_weight = mean(weight))
ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, y = avg_weight, color = species_id)) +
  geom_line() +
  facet_grid(sex ~ .)

# One row, facet by column
ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, y = avg_weight, color = species_id)) +
  geom_line() +
  facet_grid(. ~ sex)

## Customization

# https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf

# Now, let's change names of axes to something more informative than 'year'
#and 'n' and add a title to the figure:

ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
geom_line() +
facet_wrap(~ species_id) +
labs(title = "Observed species in time",
x = "Year of observation",
y = "Number of individuals") +
theme_bw()

#The axes have more informative names, but their readability can be improved by
#increasing the font size:

ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
geom_line() +
facet_wrap(~ species_id) +
labs(title = "Observed species in time",
x = "Year of observation",
y = "Number of individuals") +
theme_bw() +
theme(text=element_text(size = 16))

#Note that it is also possible to change the fonts of your plots. If you are on
#Windows, you may have to install
#the [**`extrafont`** package](https://github.com/wch/extrafont), and follow the
#instructions included in the README for this package.

#After our manipulations, you may notice that the values on the x-axis are still not
#properly readable. Let's change the orientation of the labels and adjust them
#vertically and horizontally so they don't overlap. You can use a 90-degree
#angle, or experiment to find the appropriate angle for diagonally oriented
#labels:

ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
geom_line() +
facet_wrap(~ species_id) +
labs(title = "Observed species in time",
x = "Year of observation",
y = "Number of individuals") +
theme_bw() +
theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
axis.text.y = element_text(colour = "grey20", size = 12),
text = element_text(size = 16))

#If you like the changes you created better than the default theme, you can save them as
#an object to be able to easily apply them to other plots you may create:

grey_theme <- theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
axis.text.y = element_text(colour = "grey20", size = 12),
text = element_text(size = 16))
ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
geom_boxplot() +
grey_theme

## Arranging and exporting plots

#Faceting is a great tool for splitting one plot into multiple plots, but sometimes you may want to produce a single figure that contains multiple plots using different variables or even different data frames. The **`gridExtra`** package allows us to combine separate ggplots into a single figure using `grid.arrange()`:

install.packages("gridExtra")
library(gridExtra)

spp_weight_boxplot <- ggplot(data = surveys_complete, 
mapping = aes(x = species_id, y = weight)) +
geom_boxplot() +
xlab("Species") + ylab("Weight (g)") +
scale_y_log10()
spp_count_plot <- ggplot(data = yearly_counts, 
mapping = aes(x = year, y = n, color = species_id)) +
geom_line() + 
xlab("Year") + ylab("Abundance")
grid.arrange(spp_weight_boxplot, spp_count_plot, ncol = 2, widths = c(4, 6))

#In addition to the `ncol` and `nrow` arguments, used to make simple arrangements, there are tools for [constructing more complex layouts](https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html). 

# After creating your plot, you can save it to a file in your favorite format. The Export tab in the **Plot** pane in RStudio will save your plots at low resolution, which will not be accepted by many journals and will not scale well for posters. 

#Instead, use the `ggsave()` function, which allows you easily change the dimension and resolution of your plot by adjusting the appropriate arguments (`width`, `height` and `dpi`). 

#Make sure you have the `fig_output/` folder in your working directory.

my_plot <- ggplot(data = yearly_sex_counts, 
mapping = aes(x = year, y = n, color = sex)) +
geom_line() +
facet_wrap(~ species_id) +
labs(title = "Observed species in time",
x = "Year of observation",
y = "Number of individuals") +
theme_bw() +
theme(axis.text.x = element_text(colour = "grey20", size = 12, angle = 90, hjust = 0.5, vjust = 0.5),
axis.text.y = element_text(colour = "grey20", size = 12),
text=element_text(size = 16))

ggsave("fig_output/yearly_sex_counts.png", my_plot, width = 15, height = 10)
# This also works for grid.arrange() plots
combo_plot <- grid.arrange(spp_weight_boxplot, spp_count_plot, ncol = 2, widths = c(4, 6))
ggsave("fig_output/combo_plot_abun_weight.png", combo_plot, width = 10, dpi = 300)

#Note: The parameters `width` and `height` also determine the font size in the saved plot.
