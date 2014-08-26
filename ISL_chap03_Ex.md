Chapter 3 Conceptual Exercise Solutions
---

3.1. The null hypothesis was originally that there is no relation between tv, radio, and newspaper advertising budgets and product sales. It also tells us that in the absence of tv and radio expenditures, sales are non-zero. The tiny p-value for the intercept tells us that we can reject the null hypothesis, i.e. that ß0 == 0. The tiny p-values for tv and radio accordingly tells us that we can reject the hypotheses that ß1 == 0 and ß2 == 0, i.e. that there is no relationship between tv and sales, or radio and sales. Since the p-value for newspaper is substantially more than 5%, we can conclude that there is no relationship between newspaper advertisements and product sales, when tv and radio ads are kept constant.

3.2. KNN regression estimates the f(x0) of a test point by looking at the average y of the K points closest to that test point. In contrast, the KNN classifier estimates the conditional probability of a test point equaling each variation of f(x0) and then assigns f(x0) to the value that is most likely.

3.3. The estimated coefficient for IQ and the interaction between GPA and IQ are near zero.

a. Answer is iii

i. ß3 is positive and the gender dummy variable assigns 1 for females and 0 for males, then this means that the response, salary, is $35,000 dollars higher for females than males.

ii. At the same time, the interaction between gender and GPA is pretty negative, so overall, the ß5 interaction term should outweigh the ß3 term with a decent GPA (should be above 3.5).

iii. This is the correct answer.

iv. This would be the correct answer if it said "females earn more provided that the GPA is low enough." Odd, but think of a point where an identical male and female have the same 3.5 GPA, then think that if both of their GPA's were to increase, then the ß5 would start to outweigh the ß3 boost that females get, and their salary would start to decrease. For males, both ß3 and ß5 are always 0, since their gender is 0.

b. `50 + 20*4.0 + 0.07*110 + 35*1 + 0.01*4.0*110 + -10*4.0*1 = 137.1` in thousands of dollars.

c. We should be looking at the p-values in the model for the ß4 coeficient in order to determine whether or not the interaction effect is significant to the model. The coefficient only tells us how significant the interaction is relevant to the other parameters in the model, while the p-value would tell us how significant the interaction is with all other things kept constant.

3.4. In the case of an accurate fit, ß2 and ß3 would be near zero.

a. Since the cubic regression would be prone to end up overfitting the training data, and thereby reducing some of the random error in the true model, the RSS for the cubic fit would probably be lower.

b. For the case of the testing data, then the RSS should be lower for the linear regression than for the cubic regression, as a result of the overfitting described above.

c. Without knowing the true model, it is possible to justify that the RSS for either the cubic or the linear would be lower.

d. Same as above.

---

Extra: Why do we minimize the square of the error between our fit and the data?

* It is a result of the following hypothesis: The error terms of the true model have a Gaussian distribution.

    *  strong assumption about both the shape of the distribution and that the variance is the same for all points

        *  IID - independently identically distributed

    *  errors are independent at different points

        *  product of errors, when you take the log of the product, it becomes the sum of the errors, and they are all the same, so you multiply by the number of observations

*  We will notice a squared x in the Gaussian distribution.

*  calculate likelihood function, probabilities of a certain error given an error. Maximize that you got the observation.
