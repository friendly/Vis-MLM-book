library(vegan)

data(varespec)
vare.dist <- vegdist(wisconsin(varespec))

mds.null <- monoMDS(vare.dist, y = cmdscale(vare.dist), trace=0)
mds.alt <- monoMDS(vare.dist, trace = 0)

vare.proc <- procrustes(mds.alt, mds.null)
vare.proc
summary(vare.proc)
plot(vare.proc)
# plot(vare.proc, kind=2)
# residuals(vare.proc)
