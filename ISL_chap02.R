# contour plot
x = seq(1,10)
y <- x
f = outer(x, y, function(x, y) cos(y)/(1 + x^2))
contour(x,y,f)
contour(x,y,f, nlevels=45, add=T)

fa = (f - t(f)) / 2
contour(x,y,fa, nlevels=15)

#################################### Exercise question 7
X1 <- c(0,2,0,0,-1,1)
X2 <- c(3,0,1,1,0,0)
X3 <- c(0,0,3,2,1,2)
Y <- c("Red", "Red", "Red", "Green", "Green","Red")
obs <- data.frame(X1 = X1, X2 = X2, X3 = X3, Y = Y)
test_point <- c(0,0,0,NULL)
# compute euclidean distance between the test point and all the other rows
obs_matrix <- obs[,1:3]
sqrt.sum_squares = function(x) { sqrt(sum(x**2)) }
distances <- apply(obs_matrix, 1, sqrt.sum_squares)
# our prediction with K = 1?
sorted <- obs
sorted[,5] <- distances
names(sorted)[5] <- "DIST"
sorted <- sorted[ order(sorted$DIST), ]
K1 = sorted[1,4]
# our prediction with K = 3?
K3 = sorted[1:3,4]
most_common = sort(table(K3),decreasing=TRUE)[1]
# if the Bayes decision boundary is non-linear, the best value for K would be low
# lower K corresponds to a more flexible model. As K grows, bias grows and variance shrinks


#################################### Exercise question 8
require(ISLR)
college <- College
# X11 popout display of data
fix(college)
# pairs of variables are made into scatter plots
pairs(college[,1:10])
# graphing
# y vs x => independent vs dependent => abscissa vs ordinate
# boxplots: if the variables on the x axis are categorical,
# then boxplots will automatically be produced by plot()

# here, the outstate price is on the Y axis, and yes no values for Private are on the x axis
plot(college$Private, college$Outstate)

# make a new elite category: Yes when at least 50% of their student body is coming
# from the Top10perc of their high school
Elite <- rep("No", nrow(college))
Elite[college$Top10perc > 50] <- "Yes"
Elite <- as.factor(Elite)
college <- data.frame(college, Elite)
plot(college$Elite, college$Outstate)

# divide the screen
par(mfrow = c(2,2))

#################################### Exercise question 9
auto <- Auto
# as.factor() will convert a quantitative variable into a qualitative one
# this is relevant for origin, cylinders, and name in this data-set
auto$cylinders <- as.factor(auto$cylinders)
plot(auto$cylinders, auto$mpg)

auto$origin <- as.factor(auto$origin)
plot(auto$origin, auto$mpg)

#image <- par(mfrow = c(1,2))
#image[1]