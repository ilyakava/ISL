Chapter 10 Conceptual Exercise Solutions
---

10.6. Genes in tissue samples

a. The first principle component's corresponding loading vector is an eigenvector of the data's covariance matrix. It also has a corresponding eigenvalue which signifies the variance in the principle component. The proportion of variance explained is just the ratio of the 1st eigenvalue of the data's covariance matrix to the sum of all of the eigenvalues of the covariance matrix.

b. Some preparation before answering the question: From equation 10.2, we know:

$$
z_{i1} =
\phi_{11}x_{i1} + \phi_{21}x_{i2} +\cdot\cdot\cdot+ \phi_{p1}x_{ip}
=\sum_{k = 1}^{p}\phi_{k1}x_{ik}
$$

Which is the same as:

$$
z_{ij}
=\sum_{k = 1}^{p}\phi_{kj}x_{ik}
$$

In matrix notation this is:

$$
\begin{bmatrix}| &  & | \\Z_1 & \cdots & Z_p\\ | && |  \end{bmatrix}
=
\begin{bmatrix}| &  & | \\X_1 & \cdots & X_p\\ | && |  \end{bmatrix}
\begin{bmatrix}\phi_{11} & \cdots & \phi_{1k} \\\vdots & \ddots & \vdots\\ \phi_{p1} & \cdots & \phi_{pk}  \end{bmatrix}
$$

In the last matrix, k = p since the principal component loading matrix is square. Rearranging a little bit we get:

$$
\begin{aligned}
Z&=X\phi
\\Z\phi^T&=X\phi\phi^T
\\Z\phi^T&=X\ (since\ \phi\ is\ orthonormal)
\end{aligned}
$$

$$
\begin{bmatrix}| &  & | \\X_1 & \cdots & X_p\\ | && |  \end{bmatrix}
=
\begin{bmatrix}| &  & | \\Z_1 & \cdots & Z_p\\ | && |  \end{bmatrix}
\begin{bmatrix}\phi_{11} & \cdots & \phi_{p1} \\\vdots & \ddots & \vdots\\ \phi_{1k} & \cdots & \phi_{pk}  \end{bmatrix}
$$

Stated as a sum, let's call this equation *q1*:

$$
x_{ij}
=\sum_{k = 1}^{p}z_{ik}\phi_{jk}
$$

The question says that the researcher wants to replace each (i,j)th element of X with: $x_{ij} - z_{i1}\phi_{j1}$

This means that, from equation *q1*, each element in X is no longer $\sum_{k = 1}^{p}z_{ik}\phi_{jk}$ but is instead: $\sum_{k = 2}^{p}z_{ik}\phi_{jk}$. The only difference is now, the projection of X onto the first principal component is left out.

The question mentions that the first principle component had a strong linear trend from earlier samples to later ones, and insinuates that this could be due to the researcher decreasing his use of machine A and increasing his use of machine B over time. By subtracting it, perhaps the researcher hopes to correct for using two different machines.

Ultimately though, he hopes to distinguish between the Control and Treatment groups for the tissue samples with a t-test for each of the 1,000 genes in the matrix - i.e. he wants to distinguish between the mean values of each gene between the C and T groups. This is an odd approach, since, as we will see in applied exercise 10.8b, plotting the top principal components against each other should reveal clustering between two different classes having different means.

This is because the first n components of PCA represent a hyperplane that gets as close as possible to the data. And to find a plane closest to the points, we're asking that the projection of the points onto the plane are spread out as much as possible, since we are looking for the top n directions that maximize the variance of our data. This view of clustering is shown in Figure 10.2, and is also shown with R code in exercise 10.8.
