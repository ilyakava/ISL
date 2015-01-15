########################### Exercise question 6c
# continuing from the conceptual discussion
# here is a sample I found of what gene measurement data might look like

# creates an observations x features matrix
data.maker <- function(n.obs, n.feat, n.classes) {
  labs = c()
  for(ci in c(1:n.classes)) {
    labs = c(labs, rep(ci, n.obs))
  }
  out = data.frame(lab = labs)
  
  for(fi in c(1:n.feat)) {
    whole.col = c()
    for(ci in c(1:n.classes)) {
      whole.col = c(whole.col, rnorm(n.obs, ci^3, fi / 2))
    }
    out = cbind(out, whole.col)
  }
  out
}

set.seed <- 1
datas.w.lab.neat <- data.maker(50, 1000, 2)
# we now shuffle this data since the C/T groups (rows) were collected in random order
datas.w.lab <- datas.w.lab.neat[sample.int(nrow(datas.w.lab.neat)), ]

datas <- datas.w.lab[, -1]
labs <- datas.w.lab[, 1] # our record of the T/C class
# now lets add the linear trend to the matrix for using machine B more
# lets say that the difference between the machines is that machine B was
# more sensitive on all gene measurements
which.samples.b.was.used <- lapply(c(1:nrow(datas)), function(s) { runif(1, s, nrow(datas)) > 80 })
summary(unlist(which.samples.b.was.used)) # retried above line until 50/50 split, which will be our A/B machine record

datas.confounding.1 <- matrix(unlist(datas), nrow = nrow(datas), ncol = ncol(datas))
datas.m.without.machine.confounding <- datas.confounding.1
for(i in seq_along(which.samples.b.was.used)) {
  if (which.samples.b.was.used[[i]] == T) {
    datas.confounding.1[i, ] <- 2 * datas[, i]
  } else {
    datas.confounding.1[i, ] <- datas[, i]
  }
}
X <- datas.confounding.1
# in X each row is a single sample
pca <- prcomp(X, scale = T)

# one note to make here is that there is only 6% of variance explained by the 1st component...
pca$sdev[1]^2 / sum(pca$sdev^2) # 6%
# perhaps there is a different kind of confounding going on in the researcher's case

pca.pre <- prcomp(datas.m.without.machine.confounding, scale = T)
# pca$rotation is the 100 linear combinations of 1000 genes/features
# each column is the loading for each of 1000 features to project any
# sample onto the first principal component

# pca$x is the 100 samples projected onto the 100 linear combinations of genes:
# i.e. X %*% pca$rotation so rows of pca$x are the projected samples
# each row is a single sample's coeficients for the 100 principal components,
# so each column contains the values of a single principal component along all samples

# method from chap 10 lab to get colors
get.col <- function(v) {
  cols = rainbow(length(unique(v)))
  return(cols[as.numeric(as.factor(v))])
}

# now lets see what effect this first kind of confounding has
par(mfrow = c(1,2))
plot(pca$x[,c(1,2)], col=get.col(labs), pch=19, xlab="Z1",ylab="Z2",
     main = "1st vs 2nd Principal Component", sub = "Confounded by A/B machines")
plot(pca.pre$x[,c(1,2)], col=get.col(labs), pch=19, xlab="Z1",ylab="Z2",
     main = "1st vs 2nd Principal Component", sub = "Without machine A/B confounding")

# lets see what the researcher was hoping to achieve:

# need first column of pca$x and first column of pca$rotation multiplied to form a 100x1000 matrix (like X)
first.loading <- matrix(unlist(pca$rotation[, 1]), nrow = 1, ncol = ncol(X)) # 1x1000
first.principal.comp <- matrix(unlist(pca$x[, 1]), ncol = 1, nrow = nrow(X)) # 100x1
X.proj.first.princip.comp <- first.principal.comp %*% first.loading
researcher.matrix <- X - X.proj.first.princip.comp

# perform t-test on each gene/feature
# genes should be columns, samples should be rows
p.values.for.matrix <- function(matrix, labels) {
  p.values <- numeric(length = ncol(matrix))
  for (i in seq_along(p.values)) {
    all.samples.gene <- matrix[, i]
    group.C <- all.samples.gene[labels == 1]
    group.T <- all.samples.gene[labels == 2]
    p.values[i] <- t.test(group.C, group.T)$p.value
  }
  p.values
}

p.values.researcher <- p.values.for.matrix(researcher.matrix, labs)
p.values.unconfounded <- p.values.for.matrix(datas.m.without.machine.confounding, labs)

# we can evaluate this by comparing the p-values of the confounded and unconfounded data
compare <- data.frame(res = p.values.researcher, unconfounded = p.values.unconfounded)
compare.sorted <- compare[order(compare$res), ]
plot(compare.sorted)
# we see nothing informative (we also see nothing when comparing to the coef of the principal
# component loading vector of the unconfounded matrix)

# problem of multiple comparisons


########################### Exercise question 8
us.a <- USArrests
pca <- prcomp(us.a, scale = T)
par(mfrow = c(1,2))
# skree plots
# a) from sdev
pve <- pca$sdev^2 / sum(pca$sdev^2)
principal.component <- c(1:length(pves))
plot(principal.component, pve, type = 'b')
# b) loadings to

# equation 10.8:
pve.eq.10.8 <- function(m, loading, data) {
  p = ncol(data) # num dimensions per observation
  n = nrow(data) # num observations
  sum.loaded.squares = 0 # numerator
  for(i in c(1:n)) {
    sum.projected.data = 0
    for(j in c(1:p)) {
      sum.projected.data = sum.projected.data + loading[j, m] * data[i, j]
    }
    sum.loaded.squares = sum.loaded.squares + sum.projected.data^2
  }
  sum.squares = 0 # denominator, sums of row sums
  for(i in c(1:n)) { # row sum
    sum.squares = sum.squares + sum(data[i, ]^2)
  }
  sum.loaded.squares / sum.squares
}

# use equation 4 times
pve2.scaled <- numeric(length = nrow(pca$rotation))
for(m in seq_along(pca$rotation[1])) {
  pve2.scaled[m] <- pve.eq.10.8(m, pca$rotation, scale(us.a))
}
plot(principal.component, pve2.scaled, type = 'b')

########################### Exercise question 10
# a) create data
set.seed <- 1

datas.w.lab <- data.maker(20, 50, 2)
# b) plot classes
datas <- datas.w.lab[, -1]
labs <- datas.w.lab[, 1]
pca <- prcomp(datas, scale = T)

par(mfrow=c(1,1))
plot(pca$x[,1:2], col=get.col(labs), pch=19,
     xlab="Z1",ylab="Z2", main = "1st vs 2nd Principal Component")
