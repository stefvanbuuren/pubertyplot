#PLOTTER.RHTML

plotter <- function(){
	
	setContentType('text/html')
			
	gender <- as.character(GET$gender[1]);
	name <- as.character(GET$name[1]);
	number <- as.integer(GET$number[1]);
	
	reflines <- as.character(GET$reflines[1]);
	refVector <- as.logical(strsplit(reflines,",")[[1]]);
	
	id <- rep(1,number);
	sex <- rep(gender,number)
	pub.data <- "empty";
	
	if(gender=="M"){
		
		age <- as.numeric(chartr(",",".",strsplit(as.character(GET$age[1]),":")[[1]]));
		gen <- as.numeric(chartr(",",".",strsplit(as.character(GET$gen[1]),":")[[1]]));
		phb <- as.numeric(chartr(",",".",strsplit(as.character(GET$phb[1]),":")[[1]]));
		tv <- as.numeric(chartr(",",".",strsplit(as.character(GET$tv[1]),":")[[1]]));
		
		# recode tv (in ml) as consecutive integers
		tv[!is.na(tv) & tv==2] <- 1
		tv[!is.na(tv) & tv==3] <- 2
		tv[!is.na(tv) & tv==4] <- 3
		tv[!is.na(tv) & tv==8] <- 4
		tv[!is.na(tv) & tv==12] <- 5
		tv[!is.na(tv) & tv==16] <- 6
		tv[!is.na(tv) & tv==20] <- 7
		tv[!is.na(tv) & tv==25] <- 8
		
		bre <- rep(NA,number);
		phg <- rep(NA,number);
		men <- rep(NA,number);
		
		pub.data <- data.frame(id,age,gen,phb,tv,bre,phg,men,sex);
		
	}
	
	if(gender=="F"){
		
		age <- as.numeric(chartr(",",".",strsplit(as.character(GET$age[1]),":")[[1]]));
		bre <- as.numeric(chartr(",",".",strsplit(as.character(GET$bre[1]),":")[[1]]));
		phg <- as.numeric(chartr(",",".",strsplit(as.character(GET$phg[1]),":")[[1]]));
		men <- as.numeric(chartr(",",".",strsplit(as.character(GET$men[1]),":")[[1]]));
		
		gen <- rep(NA,number);
		phb <- rep(NA,number);
		tv <- rep(NA,number);
		
		pub.data <- data.frame(id,age,gen,phb,tv,bre,phg,men,sex);
		
	}
	
	options(error=dump.frames)
	
	randomnum <- round(runif(1,0,100000));
	file <- paste(plotdumpdir, "/." ,name,".",randomnum,".pdf",sep="")
	pdf(file=file, paper="a4r",width=11.67, height=8.27)
	plot.stadia(data=pub.data,person=1,type=c(T,T,T),plotline=refVector,title=paste("Puberty Plot",name),padid=F)
	dev.off()
	
	file <- paste(plotdumpdir, "/.", name, ".", randomnum,".png",sep="")
	png(file=file, width=700, height=500)
	plot.stadia(data=pub.data,person=1,type=c(T,T,T),plotline=refVector,title=paste("Puberty Plot",name),padid=F)
	dev.off()
	
	cat(paste("",name,randomnum,sep="."))
}


		
		