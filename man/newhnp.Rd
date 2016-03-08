\name{newhnp}
\alias{newhnp}
\encoding{UTF-8}
\title{Method for non-implemented model classes}
\description{Uses user defined functions to produce the (half-)normal plot with simulated envelope.}
\usage{
newhnp(object, sim=99, conf=.95, halfnormal=T, plot.sim=T,
       verb.sim=F, how.many.out=F, print.on=F, paint.out=F,
       col.paint.out, diagfun, simfun, fitfun, ...)
}
\arguments{
  \item{object }{fitted model object.}
  \item{sim }{number of simulations. Default is 99.}
  \item{conf }{confidence level of the simulated envelope. Default is 0.95.}
  \item{halfnormal }{logical. If \code{TRUE}, a half-normal plot is produced. If \code{FALSE}, a normal plot is produced. Default is \code{TRUE}.}
  \item{plot.sim }{logical. Should the (half-)normal plot be plotted? Default is \code{TRUE}.}
  \item{verb.sim }{logical. If \code{TRUE}, prints each step of the simulation procedure. Default is \code{FALSE}.}
  \item{how.many.out }{logical. If \code{TRUE}, the number of points out of the envelope is printed. Default is \code{FALSE}.}
  \item{print.on }{logical. If \code{TRUE}, the number of points out of the envelope is printed on the plot. Default is \code{FALSE}.}
  \item{paint.out }{logical. If \code{TRUE}, points out of the simulation envelope are plotted in a different color. Default is \code{FALSE}.}
  \item{col.paint.out }{If \code{paint.out=TRUE}, sets the color of points out of the envelope. Default is \code{"red"}.}
  \item{diagfun }{user-defined function used to obtain the desired diagnostic measures from the fitted model object (only needed when \code{newclass=TRUE}). Default is \code{\link{resid}}.}
  \item{simfun }{user-defined function used to simulate a random sample from the model estimated parameters (only needed when \code{newclass=TRUE}).}
  \item{fitfun }{only needed when \code{newclass=TRUE}. User-defined function used to re-fit the desired model to the simulated data.}
  \item{\dots }{extra graphical arguments passed to \code{\link{plot.hnp}}.}
}
\details{
By providing three user-defined functions, \code{newhnp} produces the half-normal plot with simulated envelope for a model whose class is not yet implemented in the package.

The first function, \code{diagfun}, must extract the desired model diagnostics from a model fit object. The second function, \code{simfun}, must return the response variable (numeric vector or matrix), simulated using the same error distributions and estimated parameters from the fitted model. The third and final function, \code{fitfun}, must return a fitted model object. See the Examples section.
}
\author{
Rafael A. Moral <rafael_moral@yahoo.com.br>, John Hinde and Clarice G. B. \enc{Demétrio}{Demetrio}
}
\examples{
## Implementing new classes
## Users provide three functions - diagfun, simfun and fitfun,
## in the following way:
##
## diagfun <- function(obj) {
##   userfunction(obj, other_argumens)
##     # e.g., resid(obj, type="pearson")
##   }
##
## simfun <- function(n, obj) {
##   userfunction(n, other_arguments) # e.g., rpois(n, fitted(obj))
##   }
##
## fitfun <- function(y.) {
##  userfunction(y. ~ linear_predictor, other_arguments, data=data)
##    # e.g., glm(y. ~ block + factor1 * factor2, family=poisson,
##    #           data=mydata)
##  }
##
## when response is binary:
## fitfun <- function(y.) {
##  userfunction(cbind(y., m-y.) ~ linear_predictor,
##               other_arguments, data=data)
##    #e.g., glm(cbind(y., m-y.) ~ treatment - 1,
##    #          family=binomial, data=data)
##  }

\dontrun{
## Example no. 1: Using Cook's distance as a diagnostic measure
y <- rpois(30, lambda=rep(c(.5, 1.5, 5), each=10))
tr <- gl(3, 10)
fit1 <- glm(y ~ tr, family=poisson)

# diagfun
d.fun <- function(obj) cooks.distance(obj)

# simfun
s.fun <- function(n, obj) {
  lam <- fitted(obj)
  rpois(n, lambda=lam)
}

# fitfun
my.data <- data.frame(y, tr)
f.fun <- function(y.) glm(y. ~ tr, family=poisson, data=my.data)

# hnp call
hnp(fit1, newclass=TRUE, diagfun=d.fun, simfun=s.fun, fitfun=f.fun)

## Example no. 2: Implementing gamma model using package gamlss
# load package
require(gamlss)

# model fitting
y <- rGA(30, mu=rep(c(.5, 1.5, 5), each=10), sigma=.5)
tr <- gl(3, 10)
fit2 <- gamlss(y ~ tr, family=GA)

# diagfun
d.fun <- function(obj) resid(obj) # this is the default if no
                                  # diagfun is provided

# simfun
s.fun <- function(n, obj) {
  mu <- obj$mu.fv
  sig <- obj$sigma.fv
  rGA(n, mu=mu, sigma=sig)
}

# fitfun
my.data <- data.frame(y, tr)
f.fun <- function(y.) gamlss(y. ~ tr, family=GA, data=my.data)

# hnp call
hnp(fit2, newclass=TRUE, diagfun=d.fun, simfun=s.fun,
    fitfun=f.fun, data=data.frame(y, tr))

## Example no. 3: Implementing binomial model in gamlss
# model fitting
y <- rBI(30, bd=50, mu=rep(c(.2, .5, .9), each=10))
m <- 50
tr <- gl(3, 10)
fit3 <- gamlss(cbind(y, m-y) ~ tr, family=BI)

# diagfun
d.fun <- function(obj) resid(obj)

# simfun
s.fun <- function(n, obj) {
  mu <- obj$mu.fv
  bd <- obj$bd
  rBI(n, bd=bd, mu=mu)
}

# fitfun
my.data <- data.frame(y, tr, m)
f.fun <- function(y.) gamlss(cbind(y., m-y.) ~ tr,
                               family=BI, data=my.data)

# hnp call
hnp(fit3, newclass=TRUE, diagfun=d.fun, simfun=s.fun, fitfun=f.fun)
}
}
\keyword{ hnp }