library(pubertyplot)
pubdatafile <- file.path("data-raw/data/pub.ref.1997.txt")

# read the pubertal references based on Dutch 1997 study (Fredriks et al, 2000)
z <- read.table(pubdatafile, header=T, sep='\t')
z[,2:ncol(z)] <- z[,2:ncol(z)]/10000
pub.ref <- list(
    gen = z[,c("age","gen.G2","gen.G3","gen.G4","gen.G5")],
    phb = z[,c("age","phb.P2","phb.P3","phb.P4","phb.P5")],
    tv  = z[,c("age","tv.T3","tv.T4","tv.T8","tv.T12","tv.T16","tv.T20","tv.T25")],
    bre = z[,c("age","bre.B2","bre.B3","bre.B4","bre.B5")],
    phg = z[,c("age","phg.P2","phg.P3","phg.P4","phg.P5")],
    men = z[,c("age","men.M2")]
)
dimnames(pub.ref$gen)[[2]] <- c("age","G2","G3","G4","G5")
dimnames(pub.ref$phb)[[2]] <- c("age","P2","P3","P4","P5")
dimnames(pub.ref$tv)[[2]]  <- c("age","T3","T4","T8","T12","T16","T20","T25")
dimnames(pub.ref$bre)[[2]] <- c("age","B2","B3","B4","B5")
dimnames(pub.ref$phg)[[2]] <- c("age","P2","P3","P4","P5")
dimnames(pub.ref$men)[[2]] <- c("age","M2")

# calculate the stadia lines from the reference
pts <- expand.grid(pub.ref$gen[,"age"],1:5); gen <- calculateSDS(pts[,1], pts[,2], type="gen", ref=pub.ref)
pts <- expand.grid(pub.ref$phb[,"age"],1:5); phb <- calculateSDS(pts[,1], pts[,2], type="phb", ref=pub.ref)
pts <- expand.grid(pub.ref$tv[,"age"],1:8);  tv <- calculateSDS(pts[,1],  pts[,2], type="tv",  ref=pub.ref)
pts <- expand.grid(pub.ref$bre[,"age"],1:5); bre <- calculateSDS(pts[,1], pts[,2], type="bre", ref=pub.ref)
pts <- expand.grid(pub.ref$phg[,"age"],1:5); phg <- calculateSDS(pts[,1], pts[,2], type="phg", ref=pub.ref)
pts <- expand.grid(pub.ref$men[,"age"],1:2); men <- calculateSDS(pts[,1], pts[,2], type="men", ref=pub.ref)
pub.ref.lines <- list(
    gen = matrix(c(pub.ref$gen[,"age"], gen), nrow=nrow(pub.ref$gen), ncol = 6, dimnames=list(NULL,c("age","G1","G2","G3","G4","G5"))),
    phb = matrix(c(pub.ref$phb[,"age"], phb), nrow=nrow(pub.ref$phb), ncol = 6, dimnames=list(NULL,c("age","P1","P2","P3","P4","P5"))),
    tv  = matrix(c(pub.ref$tv[,"age"], tv),   nrow=nrow(pub.ref$tv),  ncol = 9, dimnames=list(NULL,c("age","T2","T3","T4","T8","T12","T16","T20","T25"))),
    bre = matrix(c(pub.ref$bre[,"age"], bre), nrow=nrow(pub.ref$bre), ncol = 6, dimnames=list(NULL,c("age","B1","B2","B3","B4","B5"))),
    phg = matrix(c(pub.ref$phg[,"age"], phg), nrow=nrow(pub.ref$phg), ncol = 6, dimnames=list(NULL,c("age","P1","P2","P3","P4","P5"))),
    men = matrix(c(pub.ref$men[,"age"], men), nrow=nrow(pub.ref$men), ncol = 3, dimnames=list(NULL,c("age","M1","M2")))
)

usethis::use_data(pub.ref, overwrite = TRUE)
usethis::use_data(pub.ref.lines, overwrite = TRUE)
