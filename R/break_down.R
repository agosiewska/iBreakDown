#' Model Agnostic Sequential Variable Attributions
#'
#' This function finds Variable Attributions via Sequential Variable Conditioning.
#' It calls either \code{\link{local_attributions}} or \code{\link{local_interactions}}.
#'
#' @param x a model to be explained, or an explainer created with function `DALEX::explain()`.
#' @param data validation dataset, will be extracted from `x` if it is an explainer.
#' @param predict_function predict function, will be extracted from `x` if it's an explainer.
#' @param new_observation a new observation with columns that correspond to variables used in the model.
#' @param keep_distributions if `TRUE`, then distribution of partial predictions is stored and can be plotted with the generic `plot()`.
#' @param order if not `NULL`, then it will be a fixed order of variables. It can be a numeric vector or vector with names of variables.
#' @param ... parameters passed to `local_*` functions.
#' @param interactions shall interactions be included?
#' @param label name of the model. By default it is extracted from the 'class' attribute of the model.
#'
#' @return an object of the `break_down` class.
#'
#' @seealso \code{\link{local_attributions}}, \code{\link{local_interactions}}
#'
#' @examples
#' \dontrun{
#' ## Not run:
#' library("DALEX")
#' library("iBreakDown")
#' library("randomForest")
#' set.seed(1313)
#' # example with interaction
#' # classification for HR data
#' model <- randomForest(status ~ . , data = HR)
#' new_observation <- HR_test[1,]
#'
#' explainer_rf <- explain(model,
#'                         data = HR[1:1000,1:5],
#'                         y = HR$status[1:1000])
#'
#' bd_rf <- break_down(explainer_rf,
#'                            new_observation)
#' bd_rf
#' plot(bd_rf)
#' }
#' @export
#' @rdname break_down
break_down <- function(x, ..., interactions = FALSE)
  UseMethod("break_down")

#' @export
#' @rdname break_down
break_down.explainer <- function(x, new_observation,
                                 ...,
                                 interactions = FALSE) {
  model <- x$model
  data <- x$data
  predict_function <- x$predict_function
  label <- x$label

  break_down.default(model, data, predict_function,
                             new_observation = new_observation,
                             label = label,
                             ...,
                             interactions = interactions)
}


#' @export
#' @rdname break_down
break_down.default <- function(x, data, predict_function = predict,
                                       new_observation,
                                       keep_distributions = FALSE,
                                       order = NULL,
                                       label = class(x)[1], ...,
                               interactions = interactions) {
  if (interactions) {
    res <- local_interactions.default(x, data, predict_function = predict_function,
                                      new_observation = new_observation,
                                      keep_distributions = keep_distributions,
                                      order = order,
                                      label = label, ...)
  } else {
    res <- local_attributions.default(x, data, predict_function = predict_function,
                                      new_observation = new_observation,
                                      keep_distributions = keep_distributions,
                                      order = order,
                                      label = label, ...)
  }
  res
}
