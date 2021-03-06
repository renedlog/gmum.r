#' ---
#' title: "Predicting closest centroid in GNG"
#' author: ""
#' date: ""
#' output:
#'  html_document:
#'    self_contained: false
#' ---

library(gmum.r)
library(ggplot2)

# Load our library dataset
data(cec.mouse1.spherical)

# Train GNG model and find centroids of the resulting graph
g <- GNG(cec.mouse1.spherical, max.nodes=40)

# Convert to igraph and plot resulting graph
plot(convertToIGraph(g))

# GNG aims at making it easy to work with its graph.
# Here we will predict closest centroid 
mouse.centr <- calculateCentroids(g)

# Now we can plot results to see decision boundary for assigning node to centroid
m = as.data.frame(cec.mouse1.spherical)
colnames(m) = c("x", "y")

x_col <- cec.mouse1.spherical[,1]
y_col <- cec.mouse1.spherical[,2]

x_max <- max(x_col)
x_min <- min(x_col) 
y_max <- max(y_col)
y_min <- min(y_col)

x_axis <- seq(from=x_min, to=x_max, length.out=30)
y_axis <- seq(from=y_min, to=y_max, length.out=30)
grid <- data.frame(x_axis,y_axis)
grid <- expand.grid(x=x_axis,y=y_axis)



target <- findClosests(g, node.ids=mouse.centr, x=grid)
grid["target"] <- target


pl <- ggplot()+ 
  geom_tile(data=grid, aes(x=x,y=y, fill=factor(target))) + theme(legend.position="none") +
  geom_point(data=m, aes(x,y), color='white') + scale_size_continuous(range = c(3, 6))
plot(pl)

