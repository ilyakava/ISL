################################# LAB 3.6.2 Simple Linear Regression
require(MASS)
require(ISLR)
# library() and require() are the same, but require throws errors (like bang in ruby)
boston <- Boston

response <- boston$medv
predictor <- boston$lstat

lm.fit <- lm(medv~lstat, boston)
names(lm.fit)
# can then access the quantities from lm.fit using $ or coef() or similar
coef(lm.fit)
confint(lm.fit)

# produce confidence intervals and prediction intervals for the
# prediction of medv for a given value of lstat
predict(lm.fit, data.frame(lstat = (c(5,10,15))), interval = "confidence")
predict(lm.fit, data.frame(lstat = (c(5,10,15))), interval = "prediction")

plot(lstat, medv, col = "blue", pch = 4)
abline(lm.fit, lwd = 3, col = "red")
# explore all the plotting symbols:
plot(1:20, 1:20, pch=1:20)

# 4 diagnostic plots are produced when applying plot() directly to the output of lm()
# we use par() to first split the screen up for displaying these plots
par(mfrow = c(2,2))
plot(lm.fit)

# compute the residuals from the fit
plot(predict(lm.fit), residuals(lm.fit))
# or the studentized residuals
plot(predict(lm.fit), rstudent(lm.fit))
# indeed there is some evidence of non-linearity here, lets compute leverage statistics
plot(hatvalues(lm.fit))
# identify index of the largest element, works on vectors
which.max(hatvalues(lm.fit))

#################################### 3.6.3 Multiple linear Regression
lm.fit <- lm(medv ~ lstat + age, data = boston)
summary(lm.fit)
# it would be cumbersome to type out all of the 13 variables in the dataset as predictors, instead:
lm.fit <- lm(medv ~ ., data = boston)
# compute variance inflation factors
require(car)
vif(lm.fit)
?summary.lm

# note that age has a high p-value, ie Pr(>|t|),
summary(lm.fit)
# lets exclude age:
lm.fit1 <- lm(medv ~ . - age, data = boston)
# alternatively we could have excluded it from the original copy:
lm.fit1 <- update(lm.fit, ~ . - age)

# we can add two predictors and an interaction term for them simultaneously
lm.fit <- lm(medv ~ lstat * age, data = boston)
# or separately
lm.fit <- lm(medv ~ lstat + age + lstat:age, data = boston)

# we can make one of the predictors non-linear
lm.fit2 <- lm(medv ~ lstat + I(lstat ^ 2))
# we see the p-values drop to near zero with the quadratic term
summary(lm.fit2)
# lets use anova() to further quantify the extent to which the fit improved
lm.fit <- lm(medv ~ lstat)
anova(lm.fit, lm.fit2)
# we see that the p-value is nearly zero, and that the F statistic is 135
# we can also see that there is little pattern in the residuals
par(mfrow = c(2,2))
plot(lm.fit2)

# maybe we want to try higher order polynomials
lm.fit5 = lm(medv ~ poly(lstat, 5))
summary(lm.fit5)
# this looks better! why not even try a log
summary(lm(medv ~ log(rm), data = boston))

carseats <- Carseats
lm.fit <- lm(Sales ~ . + Income:Advertising + Price:Age, data = carseats)
summary(lm.fit)
# lets see how R has dealt with the qualitative variables
contrasts(carseats$ShelveLoc)
# we can see that it created both a ShelveLocGood and ShelveLocMed variable
# the positive coefficient for ShelveLocGood tells us that a good shelving location
# has a positive effect on sales

############################# Exercise question 8
require(ISLR)
require(Auto)
auto <- Auto
lm.fit <- lm(mpg ~ horsepower, auto)

summary(lm.fit)
# a
### i. The tiny p-values for the coefficient indicate that there is a
# relationship between our predictor and response variables, the non-zero
# coefficients also are a good sign of a relationship, and the F-statistic,
# like if there was a relationship, is much greater than 1
### ii. The two measures of accuracy for relations are the RSE (residual standard error) and R^2,
# The RSE estimates the standard deviation of the response from the population regression line,
# and it is less than 20% of the mean, indicating roughly that much of a percentage error. The R^2
# statistic tells us the percentage of variability in the response that is explained by the
# predictors. in this case it is 60%
### iii. The slightly negative coefficient shows that the relationship between the predictor
# and the response is slightly negative
### iv. For simple linear regression, a 95% confidence interval (probability that a range will contain
# the true unknown value of a parameter) can be constructed from twice the standard error
# for a coefficient, the prediction interval is a little wider because it also takes into
# account the irreducible error when calculating the relationship between the true and the
# estimated model
predict(lm.fit, data.frame(horsepower = (c(98))), interval = "confidence")
# in our case the confidence interval is (23.97308, 24.96108)
predict(lm.fit, data.frame(horsepower = (c(98))), interval = "prediction")
# and the prediction interval is (14.8094, 34.12476)

# b)
# plotting the response and the predictor, and the regression line:
plot(auto$horsepower, auto$mpg, col = "blue", pch = 4)
abline(lm.fit, lwd = 3, col = "red")
# c)
# lets produce the diagnostic plots:
par(mfrow = c(2,2))
plot(lm.fit)
# There is a little bit of a U shape in the residuals vs fitted graph, indicating that
# there might be some non-linearity in the relationship

################################################### Exercise question 9
# a) lets make all of the possible bivariate combinations of predictors in the dataset
require(ISLR)
auto <- Auto
length(names(auto))
pairs(auto[, 1:9])
# b) lets make a matrix of correlations between the variables, excluding the name
cor(auto[, 1:8], auto[, 1:8])
# c) lets do a multiple linear regression on all the variables, excluding the name
lm.fit <- lm(mpg ~ . - name, auto)
summary(lm.fit)
### i. We see that the intercept coefficient is non-zero, and has a low p-value, invalidating
# the null hypothesis. We also see several other p-values that are pretty low. The F-statistic
# is relatively high, and the RSE is only 15% of the mean mpg

lm.fit2 <- lm(mpg ~ weight + year + origin, auto)
summary(lm.fit2)
### ii. as we pick more statistically significant parameters to fit on the model, the F-statistic doubles,
# the RSE and the R^2 practically stay the same, and the relevant p-values stay low
### iii. The coefficient for the year suggests that as cars get newer, their mpg increases
plot(lm.fit2)
# d) There is a very neat but shallow U shape in the residuals graph
# In the residuals versus leverage plot, we can see that a number of points do have
# a substantial amount of leverage, we can take a closer look with:
plot(hatvalues(lm.fit2))

# To detect outliers affecting R^2 or RSE's plot the studentized residuals, and pick out
# points with residuals that are greater than 3, we can see that there a number of these
par(mfrow = c(1,1))
plot(predict(lm.fit2), rstudent(lm.fit2))

################################### Exercise 10
# a)
carseats <- Carseats
lm.fit.a <- lm(Sales ~ Population + Urban + US, carseats)
# b)
summary(lm.fit.a)
# The qualitative variable US is positively related to sales of carseats in a statistically
# significant way. The R^2 is pretty low in this case, indicating that a large percentage of
# the data is unexplained by the 3 predictors.
# c) Y = ß0 + ß1*Population + ß2*UrbanYes + ß3*USYes
# d) We can reject the null hypothesis overall because of the low p-value for the intercept
# and we can see that the USYes variable is also statistically significant.
# e)
lm.fit.e <- lm(Sales ~ US, carseats)
summary(lm.fit.e)
# the F statistic improves, but the RSE and the R^2 stay the same
# g) the confidence interval for the coefficients will tell us how close Y-hat is to f(X)
confint(lm.fit.e)
# this interval tells us that the average uncertainty surrounding the average Sales over
# US or non-US areas
# just for fun, lets plot the confidence intervals for the prediction of Sales for the two
# variants of US, first we can plot the data
plot(carseats$US, carseats$Sales)
abline(lm.fit.e, lwd = 3)
# then, lets generate the confidence intervals for the two variants of US, and plot the lines
predictions <- predict(lm.fit.e, data.frame(US = c("No", "Yes")), interval = "confidence")
lm.lwr <- lm(predictions[, 2] ~ c("No", "Yes"))
lm.upr <- lm(predictions[, 3] ~ c("No", "Yes"))
abline(lm.lwr, col = "red")
abline(lm.upr, col = "blue")

# we can see what looks like a couple of outliers on the histogram, lets
# see what else we can see by plotting the studentized residuals
plot(predict(lm.fit.e), rstudent(lm.fit.e))
# it actually doesn't look so bad, there are no points that are so far from a
# studentized residual of 3 or -3. (Studentized residuals are calculated by dividing
# each residual by its estimated standard error, the SE is the amount that
# the estimated value differs from the actual value)
############################ Exercise 11
# lets generate a predictor and a response
set.seed(1)
x <- rnorm(10000)
y <- 2 * x + rnorm(10000)
# a) lets perform a SLR without an intercept
lm.fit <- lm(y ~ x + 0)
summary(lm.fit)
# THe SE is small, and the coefficient is much (20x) larger than the SE, pointing to a relationship
# the t value, ie the t-statistic; ß / SE(ß), is pretty high, and the p-value is low, also
# signifying a relationship

# b) performing a regression the other way:
lm.fit2 <- lm(x ~ y + 0)
summary(lm.fit2)
# in this case, the SE is still 5% of the Coefficient, the t-value and the p-value are still low
# the F statistic and R^2 are identical, and the RSE has been halved
# c) The relationship between the fits is the ratio of the slopes ßx/ßy
# from equation 3.38 we see that this is: (sum(x * y) / sum(x * x)) / (sum(y * x) / sum(y * y))
# which equals: sum(y * y) / sum(x * x) == 4.93 or 5
# this is the ratio of the variances of the two distributions.
# x ~ N(0, 1)
# y ~ N(0, 5)
# d) substitute in ß into SE(ß) and then multiply that by ß as well
# e) looking at the equation in 11d, because it is highly symmetric, ie switching out the
# x's for the y's would yield the same exact equation, the t-statistic is identically calculated
# for a y on x or x on y regression
# f) the t-statistic is indeed the same for ß1
lm.fit3 <- lm(y ~ x)
lm.fit4 <- lm(x ~ y)
summary(lm.fit3)
summary(lm.fit4)
######################################## Exercise 12
# a) The coefficient will be the same when the variance of the two are the same
# b) This is the same as question 11
# c)
set.seed(1)
x <- rnorm(100)
y <- rnorm(100)
lm.fit <- lm(y ~ x + 0)
lm.fit1 <- lm(x ~ y + 0)
summary(lm.fit)
summary(lm.fit1)
######################################## Exercise 13
x <- rnorm(100)
# b) random noise with variance of 1/4 (variance will be the coefficient squared)
epx <- .25 * rnorm(100)
# c) a length 100 vector with ß0 = -1 and ß1 = 1/2
y <- -1 + 0.5 * x + epx
# d)
plot(x, y)
# e)
lm.fit <- lm(y ~ x)
summary(lm.fit)
# the model provides very accurate fits for the coefficients, but about half of the
# data is unexplained as seen in the R^2 statistic
# f)
abline(lm.fit)
abline(-1, 0.5, col = "red")
legend("bottomleft", legend = c("estimated", "population"), text.col = 1:2)
poly.fit <- lm(y ~ x + I(x^2))
abline(poly.fit)
summary(poly.fit)
# the R^2 statistic doesn't change and the p-value is huge, not an improvement, plotting
# even reveals that the polynomial coefficient didn't change the shape of the fit
# h) less noise: makes the fit stronger, R^2 and F-statistic gets larger, while RSE shrinks
# i) more noise: when the variance of the noise increases by a factor of 64, almost no
# pattern is discernible, the null hypothesis cannot be proven wrong very confidently
# h) after looking at the same distribution with less noise