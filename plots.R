library(plyr)

### "read-data"
agitations <- read.table("agitations.txt", header=TRUE)
dim(agitations)
agitations[0:10,]

### "define-functions"
median.agit.fn <- function(x) { median(x$agitation) }
min.agit.fn <- function(x) { min(x$agitation) }
max.agit.fn <- function(x) { max(x$agitation) }

### "calculate-agitations"
median.agitation <- unlist(dlply(agitations, ~period, median.agit.fn))
min.agitation <- unlist(dlply(agitations, ~period, min.agit.fn))
max.agitation <- unlist(dlply(agitations, ~period, max.agit.fn))

### @end
png("agitation-over-time.png")
### "agitation-plot"
max.max.agit <- max(as.vector(max.agitation))
plot(median.agitation, col="purple", pch=19, ylim=c(0, max.max.agit+1))
points(min.agitation, col="green", pch=19)
points(max.agitation, col="red", pch=19)

### @end
dev.off()

