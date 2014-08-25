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
data.maker <- function(n.obs, n.feat, n.classes) {
  labs = c()
  for(ci in c(1:n.classes)) {
    labs = c(labs, rep(ci, n.obs))
  }
  out = data.frame(lab = labs)

  for(fi in c(1:n.feat)) {
    whole.col = c()
    for(ci in c(1:n.classes)) {
      whole.col = c(whole.col, rnorm(n.obs, ci^2, fi / 2))
    }
    out = cbind(out, whole.col)
  }
  out
}
datas.w.lab <- data.maker(20, 50, 3)
# b) plot classes
datas <- datas.w.lab[, -1]
labs <- datas.w.lab[, 1]
pca <- prcomp(datas, scale = T)

# method from chap 10 lab to get colors
get.col <- function(v) {
  cols = rainbow(length(unique(v)))
  return(cols[as.numeric(as.factor(v))])
}

par(mfrow=c(1,1))
plot(pca$x[,1:2], col=get.col(labs), pch=19,
     xlab="Z1",ylab="Z2", main = "1st vs 2nd Principal Component")
