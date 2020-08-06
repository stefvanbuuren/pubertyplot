# stadia plot - functions
#
# Stef van Buuren, TNO Quality of Life
# Version: Oct 23, 2008
# (c) 2008 TNO

pubdatafile <- system.file("rawdata/pub.ref.1997.txt", package="pubertyplot")

plot.stadia <- function(data=pub.data, persons=unique(data$id), plotline=c(T,F,F), type=c(T,F,F), colors=c("blue","green","red"),
		overlay=F, ovsex="M", ref = pub.ref.lines, title="Tanner pubertal stages - Patient ", padid = T){
	
	if(overlay) {  # plot everything on one graph
		plot.stadia.general(" ", opt=c(T,T,F,F,F), title=title)
		plot.stadia.lines(plotline, colors, ovsex, ref)
		plot.stadia.general(opt=c(F,F,T,T,T))
	}
	for (i in 1:length(persons)) {
		pnr <- persons[i]
		select <- data$id==pnr
		if (any(select,na.rm=T)){    # skip persons that do not exist in the data
			sex <- data[select,"sex"][1]
			ages <- data[select,"age"]
			if (sex=="M") pubs <- data[select,c("gen","phb","tv")]
			else pubs <- data[select,c("bre","phg","men")]
			
			if (!overlay) {
				plot.stadia.general(toString(pnr), opt=c(T,T,F,F,F),title=title, padid=T)
				plot.stadia.lines(plotline, colors, sex, ref)
				plot.stadia.general(opt=c(F,F,T,T,T))
			}
			plot.stadia.data(ages, pubs, sex, type, colors, ref=ref)
		}
	}
}



plot.stadia.general <- function(i = " ", opt=c(T,T,T,T,T), title=" ", padid=T){
	# opt 1 : plot frame and title
	# opt 2 : plot the extreme regions
	# opt 3 : plot TNO logo
	# opt 4 : plot axes
	# opt 5 : add reference to margin
	xgrid <- seq(8,21,0.25)
	if (opt[1]) {
		if (padid) title <- paste(title,i)
		plot(c(xgrid[1],xgrid[length(xgrid)]),c(-3,3),type="n",xlab="Age",ylab="SDS",lab=c(10,12,5), las=1,cex=1,tck=-0.01,axes=F)
		title(main=title,cex=0.8)
	}
	if (opt[2]) {
		polygon(x=c(rep(par("usr")[1],2),rep(par("usr")[2],2)),y=c(qnorm(0.05),qnorm(0.025),qnorm(0.025),qnorm(0.05)),col=rgb(1,0.8,0.8),border=F)
		polygon(x=c(rep(par("usr")[1],2),rep(par("usr")[2],2)),y=c(qnorm(0.025),qnorm(0.005),qnorm(0.005),qnorm(0.025)),col=rgb(1,0.6,0.6),border=F)
		polygon(x=c(rep(par("usr")[1],2),rep(par("usr")[2],2)),y=c(qnorm(0.005),rep(par("usr")[3],2),qnorm(0.005)),col=rgb(1,.4,0.4),border=F)
		
		polygon(x=c(rep(par("usr")[1],2),rep(par("usr")[2],2)),y=c(qnorm(0.95),qnorm(0.975),qnorm(0.975),qnorm(0.95)),col=rgb(0.8,0.8,1),border=F)
		polygon(x=c(rep(par("usr")[1],2),rep(par("usr")[2],2)),y=c(qnorm(0.975),qnorm(0.995),qnorm(0.995),qnorm(0.975)),col=rgb(0.6,0.6,1),border=F)
		polygon(x=c(rep(par("usr")[1],2),rep(par("usr")[2],2)),y=c(qnorm(0.995),rep(par("usr")[4],2),qnorm(0.995)),col=rgb(0.4,0.4,1),border=F)
		
		text(x=c(9,9,9,21,21,21),y=c(-1.8,-2.27,-2.9,1.8,2.27,2.9),
				labels=c("10% late","5% late","1% late","10% early","5% early","1% early"),adj=1)
		
		abline(0,0,lty=2)
	}
	
	if (opt[3]) tnologo(at=c(20.5,-3.2), size=0.8, aspect=(7/14)*(11.7/8.3), bcol=rgb(1,0.4,0.4))
	if (opt[4]) {box(); axis(1); axis(2, las=1); axis(3, labels=F); axis(4,las=1, labels=F)}
	if (opt[5]) mtext("Dutch 1997 references",1,line=3.3,at=8,cex=0.7,adj=0)
}

plot.stadia.lines <- function(plotlines, colors, sex, ref){
	# adds the Dutch reference lines for males and females to the plot (Genital, Pubic, Testis, Breast, Pubic, Menarche)
	
	xgrid <- seq(8,21,0.25)
	
	if (sex=="M"){
		if (plotlines[3]) {
			col <- colors[3]
			matlines(xgrid,ref$tv[,2:9],lwd=1,lty=1,col=col)
			text(x=c(9,9,9,9,9),y=c(-0.65,0.75,1.5,2.2,2.6),labels=c("2ml","3ml","4ml","8ml","12ml"),cex=0.8,adj=0,col=col)
			text(x=c(20,20,20,19),y=c(-1.1,-0.65,-0.18,1),labels=c("12ml","16ml","20ml","25ml"),cex=0.8,adj=0,col=col)
			text(21,1,labels="Testis",col=col,adj=1)
		}
		
		if (plotlines[1]) {
			col = colors[1]
			matlines(xgrid,ref$gen[,2:6],lwd=1,lty=1,col=col)
			text(x=c(8,8,8),y=c(-0.3,1.3,2.35),labels=c("G1","G2","G3"),cex=0.8,adj=0,col=c(col,col,col))
			text(x=c(15.5,20,20,20),y=c(-3,-2.7,-1.6,0.25),labels=c("G1","G3","G4","G5"),cex=0.8,adj=0,col=col)
			text(21,1.5,labels="Genital",col=col,adj=1)
		}
		
		if (plotlines[2]) {
			col <- colors[2]
			matlines(xgrid,ref$phb[,2:6],lwd=1,lty=1,col=col)
			text(x=c(8,8,9.6,11.1),y=c(0.2,2.1,3,3),labels=c("P1","P2","P3","P5"),cex=0.8,adj=0,col=col)
			text(x=c(16.5,18.8,20),y=c(-3,-3,-2.24),labels=c("P1","P3","P4"),cex=0.8,adj=0,col=col)
			text(21,1.25,labels="Pubic hair",col=col,adj=1)
		}
		
	}
	
	if (sex=="F"){
		if (plotlines[1]) {
			col = colors[1]
			matlines(x=xgrid,y=ref$bre[,2:6],lwd=1,lty=1,col=col)
			text(x=c(8,8,8),y=c(-0.2,2.0,3),labels=c("B1","B2","B3"),cex=0.8,adj=0,col=col)
			text(x=c(20,20,20),y=c(-2.7,-1.5,0.2),labels=c("B3","B4","B5"),cex=0.8,adj=0,col=col)
			text(21,1.5,labels="Breast",col=col,adj=1)
		}
		
		if (plotlines[2]) {
			col <- colors[2]
			matlines(x=xgrid,y=ref$phg[,2:6],lwd=1,lty=1,col=col)
			text(x=c(8,8,8.6,9.5,10.1),y=c(0.2,2.45,3,3,3),labels=c("P1","P2","P3","P4","P5"),cex=0.8,adj=0,col=col)
			text(x=c(15.3,16.5,18.5,20,20),y=c(-3,-3,-3,-2.1,-0.2),labels=c("P1","P2","P3","P4","P5"),cex=0.8,adj=0,col=col)
			text(21,1.25,labels="Pubic hair",col=col,adj=1)
		}
		
		if (plotlines[3]) {
			col <- colors[3]
			matlines(x=xgrid,y=ref$men[,2:3],lwd=1,lty=1,col=col)
			text(21,1,labels="Menarche",col=col,adj=1)
		}
	}
}

plot.stadia.data <- function(ages, pubs, sex, type, colors, ref){
	xgrid <- seq(8,21,0.25)
	
	if (sex=="M") {
		if (type[1]) {
			col <- colors[1]
			stages <- unlist(pubs[,"gen"])
			refy <- ref$gen[,-1]
			curve <- findXY(refx=xgrid, refy=refy, patx=ages, pats=stages)
			lines(curve,lwd=2,col=col)
			points(x=curve$x[curve$patient],y=curve$y[curve$patient],pch=16,col=col)
		}
		
		if (type[2]) {
			col <- colors[2]
			stages <- unlist(pubs[,"phb"])
			refy <- ref$phb[,-1]
			curve <- findXY(refx=xgrid, refy=refy, patx=ages, pats=stages)
			lines(curve,lwd=2,col=col)
			points(x=curve$x[curve$patient],y=curve$y[curve$patient],pch=16,col=col)
		}
		
		if (type[3]) {
			col <- colors[3]
			stages <- unlist(pubs[,"tv"])
			refy <- ref$tv[,-1]
			curve <- findXY(refx=xgrid, refy=refy, patx=ages, pats=stages)
			lines(curve,lwd=2,col=col)
			points(x=curve$x[curve$patient],y=curve$y[curve$patient],pch=16,col=col)
		}
	}
	
	if (sex=="F") {
		if (type[1]) {
			col <- colors[1]
			stages <- unlist(pubs[,"bre"])
			refy <- ref$bre[,-1]
			curve <- findXY(refx=xgrid, refy=refy, patx=ages, pats=stages)
			lines(curve,lwd=2,col=col)
			points(x=curve$x[curve$patient],y=curve$y[curve$patient],pch=16,col=col)
		}
		
		if (type[2]) {
			col <- colors[2]
			stages <- unlist(pubs[,"phg"])
			refy <- ref$phg[,-1]
			curve <- findXY(refx=xgrid, refy=refy, patx=ages, pats=stages)
			lines(curve,lwd=2,col=col)
			points(x=curve$x[curve$patient],y=curve$y[curve$patient],pch=16,col=col)
		}
		
		if (type[3]) {
			col <- colors[3]
			stages <- unlist(pubs[,"men"])
			refy <- ref$men[,-1]
			curve <- findXY(refx=xgrid, refy=refy, patx=ages, pats=stages)
			lines(curve,lwd=2,col=col)
			points(x=curve$x[curve$patient],y=curve$y[curve$patient],pch=16,col=col)
		}
	}
}


findXY <- function(refx, refy, patx, pats){
	# calculates the coordinates and symbols of the data line to be plotted
	# refx - vector of reference ages
	# refy - matrix of reference values for each stage
	# patx - vector of patient ages
	# pats - vector of patient stages
	
	# returns a array with x, y and symbol
	
	# declare return vectors
	yout <- vector("numeric",0)
	xout <- vector("numeric",0)
	patient <- vector("logical",0)
	stage <- vector("numeric",0)
	
	# identify the segments
	segments <- findSegments(pats)
	
	for (i in 1:nrow(segments)){
		select <- segments[i,]
		theStage <- pats[select][1]
		if (any(select,na.rm=T)){
			# append reference data
			x1 <- patx[select&!is.na(select)]
			x2 <- refx[refx>min(x1,na.rm=T)&refx<max(x1,na.rm=T)]  # x2 is needed for plotting along the curve
			xo <- c(x1,x2)
			flags <- c(rep(T,sum(select,na.rm=T)),rep(F,length(x2)))
			
			# sort in proper order
			ix <- order(xo)
			flags <- flags[ix]
			xo <- xo[ix]
			
			# interpolate the Y values
			y <- approx(x=refx, y=refy[,theStage], xo)$y
			
			# and store
			yout <- c(yout,y)
			xout <- c(xout,xo)
			patient <- c(patient,flags)
			stage <- c(stage,rep(theStage,length(yout)))
		}
	}
	return(list(x=xout,y=yout,stage=stage,patient=patient))
}

findSegments <- function(z){
	# determines the segments of z in which z does not change
	y <- z[!is.na(z)]
	nsegments <- sum(diff(y)!=0) + 1
	
	selector <- matrix(F,nrow=nsegments,ncol=length(z))
	k <- 1
	z.old <- z[1]
	for (i in 1:length(z)) {
		if (!is.na(z[i]) && !is.na(z.old) && (z.old!=z[i])) k <- k + 1   # new segment
		if (!is.na(z[i])) {
			selector[k,i] <- T
			z.old <- z[i]
		}
	}
	return(selector)
}



tnologo <- function(col = "darkblue", bcol = "white", at=c(0,0), size=300, aspect=1) {
	# plots the TNO logo using the current coordinate system
	# argument 'at' is the (x,y)-coordinate of the lower left corner of the logo
	# size is horizontal size measured in the units of the x-axis
	# aspect = unit size y-axis / unit size x-axis
	# vertical size in x-units = (300/309) * aspect
	# SvB Oct 2008
	size <- size/309
	offsetx <- at[1]
	scalex <- size
	offsety <- at[2]
	scaley <- size * (275/254.75) * aspect
	x <- c(88.75, 279.25, 211.75, 21.25, NA, 65.25, 105, 156.5, 156.5, 209, 209, 145, 145, 92.5, 92.5, 76, 76, 25, NA, 0, 92.5, 92.5, 63.5, 63.5, 29, 29, 0, NA, 105, 169, 169,
			196.5, 196.5, 132.5, 132.5, 105)
	y <- c(0, 60.5, 275, 214.5, NA, 74, 74, 89.5, 74, 74, 201.5, 185, 201.5, 201.5, 144.5, 144.5, 201.5, 201.5, NA, 86.5, 86.5, 132, 132, 189, 189, 132, 132, NA, 86.5, 106.5,
			86.5, 86.5, 186, 169, 189, 189)
	x <- offsetx + x * scalex
	y <- offsety + (275 - y) * scaley
	unit.circle <- complex(arg = seq( - pi, pi, length = 40))
	select <- c(1:9, 28:40)
	polygon(x=offsetx+c(0,0,309,309)*size,y=offsety+c(0,300,300,0)*size*aspect,col=bcol,border=F)
	polygon(x = x, y = y, col = c(col, bcol, col, col), border = F)
	polygon(x = offsetx + ((254.75 + Re(unit.circle) * 66.25)[select]) * scalex, y = offsety + ((138.25 + Im(unit.circle) * 66.25)[select]) * scaley, col = bcol, border = F)
	polygon(x = offsetx + (254.75 + Re(unit.circle) * 53.75) * scalex, y = offsety + (138.25 + Im(unit.circle) * 53.75) * scaley, col = col, border = F)
}

# testing code
# plot.new();plot.window(xlim=c(0,10),ylim=c(0,10)); tnologo(at=c(5,5),size=5,bcol="green")
# tnologo(at=c(4,4),size=1,bcol="red",col="white"); tnologo(at=c(0,0),size=4,bcol="yellow",col="black")


# define the function for calculating SDS
calculateSDS <- function(age, stage, type, ref=pub.ref){
	# calculates the SDS
	# age - vector of patient ages
	# stage - vector of patient stages
	# type of reference: "gen","phb","tv","bre","phg" or "men"
	
	sds <- vector("numeric",length(age))
	r <- ref[[type]]
	m <- ncol(r)
	q <- matrix(1,nrow=length(age),ncol=m+1)
	q[,m+1] <- 0
	for (j in 2:m) q[,j] <- approx(x=r[,1],y=r[,j],xout=age)$y
	low <- q[matrix(c(1:length(age),stage),ncol=2,byrow=F)]
	high <- q[matrix(c(1:length(age),stage+1),ncol=2,byrow=F)]
	z <- qnorm(1-(low+high)/2)
	return(z)
}
