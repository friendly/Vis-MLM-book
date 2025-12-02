# allow glue::glue in fig-cap
# from: https://bsky.app/profile/eliocamp.mastodon.social.ap.brid.gy/post/3m6nkerlrul52

knitr::opts_hooks$set(fig.cap = function(options) {
  
  if (!is.null(options$fig.cap)) {
    options$fig.cap <- glue::glue(options$fig.cap)
  }
  return(options)
})