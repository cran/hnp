\name{orange}
\alias{orange}
\encoding{UTF-8}

\docType{data}
\title{Orange tissue-culture experiment data}
\description{Number of embryos of orange variety \emph{Caipira} produced with different sugar types.}
\usage{data("orange")}
\format{
  A data frame with 150 observations on the following 4 variables.
  \describe{
    \item{\code{block}}{a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5}}
    \item{\code{sugar}}{a factor with levels \code{Maltose} \code{Glucose} \code{Lactose} \code{Galactose} \code{Sucrose} \code{Glycerol}}
    \item{\code{dose}}{a numeric vector}
    \item{\code{embryos}}{a numeric vector}
  }
}
\details{To study the effect of six sugars (maltose, glucose, galactose, lactose, sucrose and glycerol) on the stimulation of somatic embryos from callus cultures, the number of embryos after approximately four weeks was observed. The experiment was set up in a completely randomized block design with five blocks and the six sugars at dose levels of 18, 37, 75, 110 and 150 mM for the first five and 6, 12, 24, 36 and 50 mM for glycerol, see Tomaz (2001). The main interest was in the dose-response relationship.}
\source{
Tomaz ML, Mendes BMJ, Filho FAM, Demetrio CGB, Jansakul N, Rodriguez APM (1997). Somatic embryogenesis in \emph{Citrus} spp.: Carbohydrate stimulation and histodifferentiation. In Vitro Cellular & Developmental Biology - Plant, 37, 446–452.
}

\examples{
data(orange)

require(gamlss)
fit_nbI <- gamlss(embryos ~ block + poly(dose, 2) * sugar, 
                  family=NBII(), data=orange)
                  
d.fun <- function(obj) resid(obj)

s.fun <- function(n, obj) {
  mu <- obj$mu.fv
  sigma <- obj$sigma.fv
  rNBII(n, mu, sigma)
}

f.fun <- function(y.) {
  gamlss(y. ~ block + poly(dose, 2) * sugar, family=NBII(), data=orange)
}

\dontrun{
hnp(fit_nbI, newclass=TRUE, diagfun=d.fun, simfun=s.fun, fitfun=f.fun)
}

fit_pred <- gamlss(embryos ~ poly(dose, 2) * sugar, family=NBII(), data=orange)
orange.pred <- rbind(expand.grid(sugar=levels(orange$sugar)[-6], dose=18:150),
                     expand.grid(sugar="Glycerol", dose=6:50))
orange.pred$pred <- predict(fit_pred, newdata=orange.pred, type="response")
require(latticeExtra)
trellis.par.set(strip.background=list(col="lightgrey"))
xyplot(embryos ~ dose | sugar, scales=list(relation="free"), layout=c(3,2),
       data=orange, col=1, xlab="Dose levels", ylab="Number of embryos") +
  as.layer(xyplot(pred ~ dose | sugar, type="l", col=1, data=orange.pred))
}
\keyword{datasets}
