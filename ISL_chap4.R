############################## Lab 4.6.1
library(ISLR)
names(Smarket)
# market data for 5 years
table(Smarket$Year)
dim(Smarket)
summary(Smarket)
pairs(Smarket)
cor(Smarket[, -9])
plot(Smarket$Volume)

# we will specify logistic regression within the generalized linear model package
glm.fit <- glm(Direction ~ . - Today - Year, Smarket, family = binomial)
# even Lag1's p-value is too large to be point to a convincing relationship
summary(glm.fit)

attach(Smarket)
# see what dummy variables R has assigned
contrasts(Direction)

glm.probs <- predict(glm.fit, type = "response")
head(glm.probs)

# lets make these predicted probabilities of the market direction bivariate
# by first making a vector with all "Down"s and then correcting others to "Up"
glm.pred <- rep("Down", 1250)
glm.pred[glm.probs > 0.5] = "Up"
# easy now to generate a confusion matrix
# the sum of the left col == Direction$Down, and sum of right col == Direction$Up
# 507 and 145 days were correctly predicted as Up and Down
# the off-diagonals show the incorrect predictions
table(glm.pred, Direction)
# can easily see the overlap between glm.pred and Direction, the percentage of correct predictions
# ie the percent TRUE in the vector generated inside the parentheses
mean(glm.pred == Direction)
# the training error rate is then 1 - this

# since this is overly optimistic, lets repeat this procedure but hold out some training data
train <- (Year < 2005)
# train is a boolean vector (of TRUEs and FALSEs) depending on the year of the Smarket
table(train)
# and lets store the data but leave out the year 2005
Smarket.2005 <- Smarket[!train, ]
Direction.2005 <- Direction[!train]
# we could either create another data.frame with the other Smarket data, or...
glm.fit <- glm(Direction ~ . - Year - Today, Smarket, subset = train, family = "binomial")
glm.probs <- predict(glm.fit, Smarket.2005, type = "response")
# lets do the same comparison as above
glm.pred <- rep("Down", 252)
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction.2005)
# computing the test error rate
mean(glm.pred != Direction.2005)

######################################################## LDA 4.6.3
library(MASS)
lda.fit <- lda(Direction ~ Lag1 + Lag2, data = Smarket, subset = train)
# π1 = 0.492 (49% of training observations were on down days) and π2 = 0.508 here
# the group means are the average of each predictor within each class (estimate of µk),
# they indicate that there is a tendency for market to go Down when previous day had positive
# returns, and up when previous day had negative returns
# the "coefficients of linear discriminants" gives the linear  combination of the two
# predictors that is used to form the LDA decision rule (-0.642 * Lag1 - 0.514 * Lag2 = Pr[market_increase])
lda.fit
# compute linear discriminants (-0.642 * Lag1 - 0.514 * Lag2) for each observation and plot
plot(lda.fit)
lda.pred <- predict(lda.fit, Smarket.2005)
# second element, "posterior", is a matrix whose kth column constrains the posterior Pr that the
# observation belongs to the kth class
names(lda.pred)
# if we want to predict a market decrease only if the posterior Pr is 90% or more
sum(lda.pred$posterior[, 1] > 0.9)
# we can see that no days meet that threshold
############################################################ KNN
library(class)
# requires 1) matrix containing predictors for the training data, 2) matrix with
# predictors for the data for which we predict 3) vector with class labels for training
# observations, 4) a value for K
# lets column bind Lag1 and Lag2 variables together in two matrices, training and test
train.X <- cbind(Lag1, Lag2)[train, ]
test.X <- cbind(Lag1, Lag2)[!train, ]
train.Direction <- Direction[train]
# lets set a random seed so that ties in our Pr(Class) are broken in a reproducible way
knn.pred <- knn(train.X, test.X, train.Direction, k = 1)
table(knn.pred, Direction.2005)
# (83 + 43) / 252 == 0.5  # the percent of predictions that were correct
# increasing K to 3 yields slightly better performance, but thats as good as it gets

###################################### KNN for insurance
# we standardize our variables to a mean of 0 and a std dev of 0, and exclude the Purchase variable
standardized.X <- scale(Caravan[, -86])
var(Caravan[, 1])
var(standardized.X[, 1])
# now lets split into train and test
test <- 1:1000
train.X <- standardized.X[-test, ]
test.X <- standardized.X[test, ]
train.Y <- Purchase[-test]
test.Y <- Purchase[test]
set.seed(1)
knn.pred <- knn(train.X, test.X, train.Y, k = 1)
# knn error rate
mean(test.Y != knn.pred)
# this might seem like an okay error rate, but considering that only 6% of the customers
# purchased insurance, always predicting "No" would halve the error to 6%
mean(test.Y != "No")
# we may be more interested in the fraction of customers whose purchase was correctly predicted "Yes"
table(knn.pred, test.Y)
