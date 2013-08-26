#NOTES

plotterpro <- function(){
	
	setContentType('text/html')
	printSuccess <- function() {
		
		dataFile    <- as.character(POST$dataFile);
		
		name 		 <- "proplot"
		#name        <- as.character(POST$name);				
		
		dataFileDest <- file.path('/tmp',dataFile);
		load(dataFileDest);
		
		pub.data <- mydata;
		
		pub.data[!is.na(pub.data$tv) & pub.data$tv==2,"tv"] <- 1;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==3,"tv"] <- 2;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==4,"tv"] <- 3;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==8,"tv"] <- 4;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==12,"tv"] <- 5;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==16,"tv"] <- 6;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==20,"tv"] <- 7;
		pub.data[!is.na(pub.data$tv) & pub.data$tv==25,"tv"] <- 8;
		
		patients <- unique(pub.data$id);
		
		#create output datafile
		
		if(sum(mydata$sex=="M")>0){
			mydata$SDS_gen <- round(calculateSDS(pub.data$age,pub.data$gen,"gen"),2);
			mydata$SDS_phb <- round(calculateSDS(pub.data$age,pub.data$phb,"phb"),2);
			mydata$SDS_tv  <- round(calculateSDS(pub.data$age,pub.data$tv, "tv" ),2);
		}
		
		if(sum(mydata$sex=="F")>0){
			mydata$SDS_bre <- round(calculateSDS(pub.data$age,pub.data$bre,"bre"),2);
			mydata$SDS_phg <- round(calculateSDS(pub.data$age,pub.data$phg,"phg"),2);
			mydata$SDS_men <- round(calculateSDS(pub.data$age,pub.data$men,"men"),2);
		}
		
		randomnum <- round(runif(1,0,100000));
		file <- paste(plotdumpdir, "/.", name,".", randomnum, ".csv", sep="");
		write.csv(mydata,file,quote=F,na=" ",row.names=F,eol="\r\n");
		
		file <- paste(plotdumpdir, "/.", name,".", randomnum, ".txt",sep="");
		write.table(mydata,file,sep = "\t",quote=F,na=" ",row.names=F,eol="\r\n");
		
		#creating PDF
		#options(error=dump.frames);
		file <- paste(plotdumpdir, "/.", name,".", randomnum, ".pdf",sep="");
		pdf(file=file, paper="a4r",width=11.67, height=8.27);
		plot.stadia(data=pub.data,type=c(T,T,T),plotline=c(F,F,F),padid=T);
		dev.off();
		
		cat("{success:true, file:\"",paste("",name,randomnum,sep="."),"\"}",sep="");
	}
	
	printFailure <- function(e){
		
		errorString <- toString(e);
		errorString <- gsub("\"","'",errorString);
		errorString <- gsub("\n"," ",errorString);
		errorString <- paste("R catched an error!",errorString);
		sink();
		cat("{success:false, error:\"",errorString,"\"}",sep="");
	}
	
	tryCatch(printSuccess(), error = function(e){printFailure(e)});
}




