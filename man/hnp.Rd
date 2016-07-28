\name{hnp}
\alias{hnp}
\encoding{UTF-8}

\title{Half-Normal Plots with Simulation Envelopes}
\description{Produces a (half-)normal plot from a fitted model object for a range of different models. Extendable to non-implemented model classes.}
\usage{
hnp(object, sim = 99, conf = 0.95, resid.type, maxit,
    halfnormal = T, scale = F, plot.sim = T, verb.sim = F,
    warn = F, how.many.out = F, print.on = F, paint.out = F,
    col.paint.out, newclass = F, diagfun, simfun, fitfun, ...)}
\arguments{
  \item{object }{fitted model object or numeric vector.}
  \item{sim }{number of simulations used to compute envelope. Default is 99.}
  \item{conf }{confidence level of the simulated envelope. Default is 0.95.}
  \item{resid.type }{type of residuals to be used; must be one of "deviance", "pearson", "response", "working", "simple", "student", or "standard". Not all model type and residual type combinations are allowed. Defaults are "student" for \code{\link{aov}} and \code{\link{lm}} objects, "deviance" for \code{\link{glm}}, \code{\link{glm.nb}}, \code{lmer}, \code{glmer} and \code{aodml} objects, "simple" for \code{gamlss} objects, "response" for \code{glmmadmb} and \code{vglm} objects, "pearson" for \code{zeroinfl} and \code{hurdle} objects.}
  \item{maxit }{maximum number of iterations of the estimation algorithm. Defaults are 25 for \code{\link{glm}}, \code{\link{glm.nb}}, \code{gamlss} and \code{vglm} objects, 300 for \code{glmmadmb}, \code{lmer} and \code{glmer} objects, 3000 for \code{aodml} objects, 10000 for \code{zeroinfl} and \code{hurdle} objects.}
  \item{halfnormal }{logical. If \code{TRUE}, a half-normal plot is produced. If \code{FALSE}, a normal plot is produced. Default is \code{TRUE}.}
  \item{scale }{logical. If \code{TRUE} and if \code{object} is a numeric vector, simulates from a normal distribution with mean and variance estimated from \code{object}. If \code{FALSE}, uses a standard normal distribution to simulate from. Default is \code{FALSE}.}
  \item{plot.sim }{logical. Should the (half-)normal plot be plotted? Default is \code{TRUE}.}
  \item{verb.sim }{logical. If \code{TRUE}, prints each step of the simulation procedure. Default is \code{FALSE}.}
  \item{warn }{logical. If \code{TRUE}, shows warning messages in the simulation process. Default is \code{FALSE}.}
  \item{how.many.out }{logical. If \code{TRUE}, the number of points out of the envelope is printed. Default is \code{FALSE}.}
  \item{print.on }{logical. If \code{TRUE}, the number of points out of the envelope is printed on the plot. Default is \code{FALSE}.}
  \item{paint.out }{logical. If \code{TRUE}, points out of the simulation envelope are plotted in a different color. Default is \code{FALSE}.}
  \item{col.paint.out }{If \code{paint.out=TRUE}, sets the color of points out of the envelope. Default is \code{"red"}.}
  \item{newclass }{logical. If \code{TRUE}, use \code{diagfun}, \code{simfun}, and \code{fitfun} to extract diagnostics (typically residuals), generate simulated data using fitted model parameters, and fit the desired model. Default is \code{FALSE}.}
  \item{diagfun }{user-defined function used to obtain the diagnostic measures from the fitted model object (only used when \code{newclass=TRUE}). Default is \code{\link{resid}}.}
  \item{simfun }{user-defined function used to simulate a random sample from the model estimated parameters (only used when \code{newclass=TRUE}).}
  \item{fitfun }{user-defined function used to re-fit the model to simulated data (only used when \code{newclass=TRUE}).}
  \item{\dots }{extra graphical arguments passed to \code{\link{plot.hnp}}.}
}
\details{
A relatively easy way to assess goodness-of-fit of a fitted model is to use (half-)normal plots of a model diagnostic, e.g., different types of residuals, Cook's distance, leverage. These plots are obtained by plotting the ordered absolute values of a model diagnostic versus the expected order statistic of a half-normal distribution, \deqn{\Phi^{-1}(\frac{i+n-1/8}{2*n+1/2})} (for a half-normal plot) or the normal distribution, \deqn{\Phi^{-1}(\frac{i+3/8}{n+1/4})} (for a normal plot).

Atkinson (1985) proposed the addition of a simulated envelope, which is such that under the correct model the plot for the observed data is likely to fall within the envelope. The objective is not to provide a region of acceptance, but some sort of guidance to what kind of shape to expect.

Obtaining the simulated envelope is simple and consists of (1) fitting a model; (2) extracting model diagnostics and calculating sorted absolute values; (3) simulating 99 (or more) response variables using the same model matrix, error distribution and fitted parameters; (4) fitting the same model to each simulated response variable and obtaining the same model diagnostics, again sorted absolute values; (5) computing the desired percentiles (e.g., 2.5 and 97.5) at each value of the expected order statistic to form the envelope.

This function handles different model classes and more will be implemented as time goes by. So far, the following models are included:


\tabular{ll}{
\strong{Continuous data}:\cr\cr
Normal:\tab functions \code{\link{lm}}, \code{\link{aov}} and \code{\link{glm}} with \code{family=gaussian}\cr
\cr
Gamma:\tab function \code{\link{glm}} with \code{family=Gamma}\cr
\cr
Inverse gaussian:\tab function \code{\link{glm}} with \code{family=inverse.gaussian}\cr
\cr
\bold{Proportion data}:\cr\cr
Binomial:\tab function \code{\link{glm}} with \code{family=binomial}\cr
\cr
Quasi-binomial:\tab function \code{\link{glm}} with \code{family=quasibinomial}\cr
\cr
Beta-binomial:\tab package \code{VGAM} - function \code{vglm}, with \code{family=betabinomial};\cr
\tab package \code{aods3} - function \code{aodml}, with \code{family="bb"};\cr
\tab package \code{gamlss} - function \code{gamlss}, with \code{family=BB};\cr
\tab package \code{glmmADMB} - function \code{glmmadmb}, with \code{family="betabinomial"}\cr
\cr
Zero-inflated binomial:\tab package \code{VGAM} - function \code{vglm}, with \code{family=zibinomial};\cr
\tab package \code{gamlss} - function \code{gamlss}, with \code{family=ZIBI};\cr
\tab package \code{glmmADMB} - function \code{glmmadmb}, with \code{family="binomial"}\cr \tab and \code{zeroInfl=TRUE}\cr
\cr
Zero-inflated beta-binomial: \tab package \code{gamlss} - function \code{gamlss}, with \code{family=ZIBB};\cr
\tab package \code{glmmADMB} - function \code{glmmadmb}, with \code{family="betabinomial"}\cr \tab and \code{zeroInfl=TRUE}\cr
\cr
Multinomial: \tab package \code{nnet} - function \code{\link{multinom}}\cr\cr

\strong{Count data}:\cr\cr
Poisson: \tab function \code{\link{glm}} with \code{family=poisson}\cr
\cr
Quasi-Poisson: \tab function \code{\link{glm}} with \code{family=quasipoisson}\cr
\cr
Negative binomial: \tab package \code{MASS} - function \code{\link{glm.nb}};\cr
\tab package \code{aods3} - function \code{aodml}, with \code{family="nb"}\cr \tab and \code{phi.scale="inverse"}\cr
\cr
Zero-inflated Poisson:\tab package \code{pscl} - function \code{zeroinfl}, with \code{dist="poisson"}\cr
\cr
Zero-inflated negative binomial: \tab package \code{pscl} - function \code{zeroinfl}, with \code{dist="negbin"}\cr
\cr
Hurdle Poisson:\tab package \code{pscl} - function \code{hurdle}, with \code{dist="poisson"}\cr
\cr
Hurdle negative binomial:\tab package \code{pscl} - function \code{hurdle}, with \code{dist="negbin"}\cr
\cr
\strong{Mixed models}:\cr\cr

Linear mixed models: \tab package \code{lme4}, function \code{lmer}\cr
\cr
Generalized linear mixed models: \tab package \code{lme4}, function \code{glmer} with \code{family=poisson} or \code{binomial}\cr
\cr
}


Users can also use a numeric vector as \code{object} and \code{hnp} will generate the (half-)normal plot with a simulated envelope using the standard normal distribution (\code{scale=F}) or \eqn{N(\mu, \sigma^2)}{N(mu,sigma^2)} (\code{scale=T}).

Implementing a new model class is done by providing three functions to \code{hnp}: \code{diagfun} - to obtain model diagnostics, \code{simfun} - to simulate random variables and \code{fitfun} - to refit the model to simulated variables. The way these functions must be written is shown in the Examples section.
}

\value{
\code{hnp} returns an object of class \code{"hnp"}, which is a list containing the following components:

\item{x }{quantiles of the (half-)normal distribution}
\item{lower }{lower envelope band}
\item{median }{median envelope band}
\item{upper }{upper envelope band}
\item{residuals }{diagnostic measures in absolute value and in order}
\item{out.index }{vector indicating which points are out of the envelope}
\item{col.paint.out }{color of points which are outside of the envelope (used if \code{paint.out=TRUE})}
\item{how.many.out }{logical. Equals \code{TRUE} if \code{how.many.out=TRUE} in the \code{hnp} call}
\item{total }{length of the diagnostic measure vector}
\item{out }{number of points out of the envelope}
\item{print.on }{logical. Equals \code{TRUE} if \code{print.on=TRUE} in the \code{hnp} call}
\item{paint.out }{logical. Equals \code{TRUE} if \code{paint.out=TRUE} in the \code{hnp} call}
}
\references{
Atkinson, A. C. (1985) Plots, transformations and regression, Clarendon Press, Oxford.

\enc{Demétrio}{Demetrio}, C. G. B. and Hinde, J. (1997) Half-normal plots and overdispersion. GLIM Newsletter 27:19-26.

Hinde, J. and \enc{Demétrio}{Demetrio}, C. G. B. (1998) Overdispersion: models and estimation. Computational Statistics and Data Analysis 27:151-170.

\enc{Demétrio}{Demetrio}, C. G. B., Hinde, J. and Moral, R. A. (2014) Models for overdispersed data in entomology. In Godoy, W. A. C. and Ferreira, C. P. (Eds.) Ecological modelling applied to entomology. Springer.
}
\author{
Rafael A. Moral <rafael_moral@yahoo.com.br>, John Hinde and Clarice G. B. \enc{Demétrio}{Demetrio}
}
\note{See documentation on example data sets for simple analyses and goodness-of-fit checking using \code{hnp}.}

\seealso{
\code{\link{plot.hnp}}, \code{\link{cbb}}, \code{\link{chryso}}, \code{\link{corn}}, \code{\link{fungi}}, \code{\link{oil}}, \code{\link{progeny}}, \code{\link{wolbachia}}
}
\examples{
## Simple Poisson regression
set.seed(100)
counts <- c(rpois(5, 2), rpois(5, 4), rpois(5, 6), rpois(5, 8))
treatment <- gl(4, 5)
fit <- glm(counts ~ treatment, family=poisson)
anova(fit, test="Chisq")

## half-normal plot
hnp(fit)

## or save it in an object and then use the plot method
my.hnp <- hnp(fit, print.on=TRUE, plot=FALSE)
plot(my.hnp)

## changing graphical parameters
plot(my.hnp, lty=2, pch=4, cex=1.2)
plot(my.hnp, lty=c(2,3,2), pch=4, cex=1.2, col=c(2,2,2,1))
plot(my.hnp, main="Half-normal plot", xlab="Half-normal scores",
     ylab="Deviance residuals", legpos="bottomright")

## Using a numeric vector
my.vec <- rnorm(20, 4, 4)
hnp(my.vec) # using N(0,1)
hnp(my.vec, scale=TRUE) # using N(mu, sigma^2)

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
\keyword{ glm }
