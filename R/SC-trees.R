library(networktree)
data(SocialCog, package="heplots")
data(NeuroCog, package="heplots")

SCtree <- networktree(MgeEmotions + ToM + ExtBias + PersBias ~ Dx, data=SocialCog)
plot(SCtree)

NCtree <- networktree(Speed + Attention + Memory + Verbal + Visual + ProbSolv + SocialCog ~ Age + Sex, data=NeuroCog)
plot(NCtree)

# try qgraph

library("qgraph")
corMat <- cor_auto(NeuroCog) # Correlate data
(Graph_pcor <- qgraph(corMat, graph = "pcor", layout = "spring"))

# If you want to fit a multivariate regression tree that tries to detect changes in the mean/location of the dependent variables, then this can be easily done in a nonparametric way via

library(partykit)
levels(SocialCog$Dx) <- c("Schizo", "SchAff", "Control")
SCtr <- ctree(Dx ~ MgeEmotions + ToM + ExtBias + PersBias, data = SocialCog,
			control = partykit::ctree_control(alpha=0.250))
SCtr
plot(SCtr, tp_args=gpar(fill=c("pink", "lightblue", "lightgray" )), 
           ip_args=gpar(fill=adjustcolor("lightgreen", alpha=0.4)))

#NCtr <- ctree(Speed + Attention + Memory + Verbal + Visual + ProbSolv + SocialCog ~ Age + Sex, data=NeuroCog)
#plot(NCtr)

levels(NeuroCog$Dx) <- c("Schizo", "SchAff", "Control")
NCtr2 <- ctree(Dx ~ Speed + Attention + Memory + Verbal + Visual + ProbSolv + SocialCog , data=NeuroCog)
plot(NCtr2, tp_args=gpar(fill=c("pink", "lightblue", "lightgray" )), 
           ip_args=gpar(fill=adjustcolor("lightgreen", alpha=0.4)))


# The corresponding parametric version based on multivariate lm() is not directly available. But as mob() is extensible you can quickly hack an mlm-based tree:

mlmfit <- function(y, x, start = NULL, weights = NULL,
   offset = NULL, ..., estfun = FALSE, object = FALSE) {
   rval <- if(is.null(x)) lm(y ~ 1, ...) else lm(y ~ 0 + x, ...)
   list(
     coefficients = as.vector(coef(rval)),
     objfun = sum(deviance(rval)),
     estfun = if(estfun) sandwich::estfun(rval) else NULL,
     object = if(object) rval else NULL
   )
}

tr2 <- mob(MgeEmotions + ToM + ExtBias + PersBias ~ Dx,
   data = SocialCog, fit = mlmfit, control = mob_control(ytype = "matrix"))
plot(tr2)

# A similar tree is also available in networktree() albeit the main focus of the
#function is different. It was written to mainly detect changes in the
#correlation among multivariate response only, treating means and variances as
#nuisance parameters. However, by setting the model argument you could also do

#networktree(..., model = "mean")
#
#or you could try to capture changes in all parts
#
#networktree(..., model = c"mean", "variance", "correlation"))
#
#etc. Furthermore, the "method" in networktree() can be set either to "ctree" or "mob".
#
