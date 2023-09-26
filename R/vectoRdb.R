#' cos.sim
#' Find the cosine similarity as defined in http://en.wikipedia.org/wiki/Cosine_similarity
#'
#' @param x first vector
#' @param y second vector
#' @return the cosine similarity between the two vectors
cos.sim <- function(x, y) {
  sum(x*y)/sqrt(sum(x^2)*sum(y^2))
}

#' VectorDB
#' S3 class VectorDB constructor
#'
#' @return an empty VectorDB object
#' @examples
#' x <- VectorDB()
#' @export
VectorDB <- function() {
  structure(list(), class="VectorDB")
}

#' @export
is.VectorDB <- function(x) {
  inherits(x, "VectorDB")
}

#' insert
#' Insert a vector into a VectorDB object
#'
#' @param x VectorDB object
#' @param ... other arguments
#' @export
insert <- function(x, ...) UseMethod("insert")

#' @rdname insert
#' @param k key (name)
#' @param v vector
#' @return the VectorDB object `x` with the new element `k-->v` concatenated in the end
#' @examples
#' x <- VectorDB()
#' for(i in letters[1:10]) { x <- insert(x, i, sample(1:4, 5, replace=TRUE)) }
#' @export
insert.VectorDB <- function(x, k, v) {
  x[[k]] <- v
  x
}

#' search
#' Search a vector into a VectorDB object, using cosine similarity
#'
#' @param x VectorDB object
#' @param ... other arguments
#' @export
search <- function(x, ...) UseMethod("search")

#' @rdname search
#' @param v vector
#' @param n limit to this number of results
#' @param sim_threshold do not report results below this similarity threshold
#' @return a vector of keys with at most `n` similar elements found in the database
#' @examples
#' x <- VectorDB()
#' for(i in letters[1:10]) { x <- insert(x, i, sample(1:4, 5, replace=TRUE)) }
#' best_matches <- search(x, c(4, 4, 1, 1, 1), n=2)
#' @export
search.VectorDB <- function(x, v, n=length(x), sim_threshold=0) {
  sim <- sapply(x, cos.sim, v)
  sim <- sim[sim >= sim_threshold]
  n <- min(length(x), n)
  names(sim[rev(order(sim))[1:n]])
}

#' retrieve
#' Retrieve an entry from a VectorDB object using the key
#'
#' @param x VectorDB object
#' @param ... other arguments
#' @export
retrieve <- function(x, ...) UseMethod("retrieve")

#' @rdname search
#' @param k key to retrieve
#' @return the vector associated with the key `k`
#' @examples
#' x <- VectorDB()
#' for(i in letters[1:10]) { x <- insert(x, i, sample(1:4, 5, replace=TRUE)) }
#' best_matches <- search(x, c(4, 4, 1, 1, 1), n=2)
#' lapply(setNames(best_matches, best_matches), retrieve, x=x)
#' @export
retrieve.VectorDB <- function(x, k) {
  x[[k]]
}

