% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/local_attributions.R
\name{local_attributions}
\alias{local_attributions}
\alias{local_attributions.explainer}
\alias{local_attributions.default}
\title{Model Agnostic Sequential Variable attributions}
\usage{
local_attributions(x, ...)

\method{local_attributions}{explainer}(x, new_observation,
  keep_distributions = FALSE, ...)

\method{local_attributions}{default}(x, data, predict_function = predict,
  new_observation, label = class(x)[1], keep_distributions = FALSE,
  order = NULL, ...)
}
\arguments{
\item{x}{a model to be explained, or an explainer created with function `DALEX::explain()`.}

\item{...}{other parameters.}

\item{new_observation}{a new observation with columns that correspond to variables used in the model.}

\item{keep_distributions}{if `TRUE`, then distribution of partial predictions is stored and can be plotted with the generic `plot()`.}

\item{data}{validation dataset, will be extracted from `x` if it is an explainer.}

\item{predict_function}{predict function, will be extracted from `x` if it is an explainer.}

\item{label}{name of the model. By default it's extracted from the 'class' attribute of the model.}

\item{order}{if not `NULL`, then it will be a fixed order of variables. It can be a numeric vector or vector with names of variables.}
}
\value{
an object of the `break_down` class.
}
\description{
This function finds Variable attributions via Sequential Variable Conditioning.
The complexity of this function is O(2*p).
This function works in a similar way to step-up and step-down greedy approximations in function `breakDown::break_down()`.
The main difference is that in the first step the order of variables is determined.
And in the second step the impact is calculated.
}
\examples{
\dontrun{
## Not run:
library("DALEX")
library("iBreakDown")
library("randomForest")
set.seed(1313)
# example with interaction
# classification for HR data
model <- randomForest(status ~ . , data = HR)
new_observation <- HR_test[1,]

explainer_rf <- explain(model,
                        data = HR[1:1000,1:5],
                        y = HR$status[1:1000])

bd_rf <- local_attributions(explainer_rf,
                           new_observation)
bd_rf
plot(bd_rf)
plot(bd_rf, baseline = 0)

# example for regression - apartment prices
# here we do not have intreactions
model <- randomForest(m2.price ~ . , data = apartments)
explainer_rf <- explain(model,
                        data = apartments_test[1:1000,2:6],
                        y = apartments_test$m2.price[1:1000])

bd_rf <- local_attributions(explainer_rf,
                           apartments_test[1,])
bd_rf
plot(bd_rf, digits = 1)

bd_rf <- local_attributions(explainer_rf,
                           apartments_test[1,],
                           keep_distributions = TRUE)
plot(bd_rf, plot_distributions = TRUE)
}
}
\seealso{
\code{\link{break_down}}, \code{\link{local_interactions}}
}
