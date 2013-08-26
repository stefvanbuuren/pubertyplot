
upload_tryCatch_pro <- function(){
	setContentType("text/html");
	printSuccess <- function() {
		
		library(foreign);
		
		filename <- FILES$datafile$name;
		
		destination <- file.path('/tmp',FILES$datafile$name)
		file.copy(FILES$datafile$tmp_name,destination,overwrite=TRUE)
		
		if(length(grep(".sav",filename))>0){
			mydata <- read.spss(destination, reencode="utf8", use.value.labels=FALSE, to.data.frame=TRUE);
		} else if(length(grep(".csv",filename))>0){
			mydata <- read.csv(destination);
		} else { mydata <- read.table(destination,header=T, sep='\t'); }
		
		names(mydata) <- tolower(names(mydata)); # headers to lower case
		mydata$age <- as.numeric(gsub(",",".",mydata$age)) #replace comma's by dots
		
		# verify data variables:
		
		if(is.null(mydata$id)) stop("Variabable header 'id' not found in the data! This variable is required!");
		if(is.null(mydata$age)) stop("Variabable header 'age' not found in the data! This variable is required!");
		if(is.null(mydata$sex)) stop("Variabable header 'sex' not found in the data! This variable is required!");
		
		if(sum(is.na(mydata$id))>0) {
			missings <- rownames(mydata)[is.na(mydata$id)]
			stop(paste("Variable 'id' contains missing values! This is not allowed. Rownumbers:",toString(missings)));
		}
		
		if(sum(is.na(mydata$age))>0) {
			missings <- rownames(mydata)[is.na(mydata$age)]
			stop(paste("Variable 'age' contains missing values! This is not allowed. Rownumbers:",toString(missings)));
		}
		
		if(sum(is.na(mydata$sex))>0) {
			missings <- rownames(mydata)[is.na(mydata$sex)]
			stop(paste("Variable 'sex' contains missing values! This is not allowed. Rownumbers:",toString(missings)));
		}
		
		if(sum(!(mydata$sex=="M" | mydata$sex=="F"))>0) {
			wrongvalues <- rownames(mydata)[!(mydata$sex=="M" | mydata$sex=="F")]
			stop(paste("Variable 'sex' contains invalid values! It should only conain F or M. Rownumbers:",toString(wrongvalues)));
		} 
		
		if(sum(mydata$sex=="M")>0){ #there are boys in the datafile    
			
			if(is.null(mydata$tv)) stop("Variabable header 'tv' not found in the data! This variable is required for boys!");
			if(is.null(mydata$gen)) stop("Variabable header 'gen' not found in the data! This variable is required for boys!");
			if(is.null(mydata$phb)) stop("Variabable header 'phb' not found in the data! This variable is required for boys!");    
			
			invalidtv <- !(mydata$tv == 2 | mydata$tv == 3 | mydata$tv == 4 | mydata$tv == 8 | mydata$tv == 12 | mydata$tv == 16 | mydata$tv == 20 | mydata$tv == 25 | is.na(mydata$tv))
			if(sum(invalidtv)>0){
				stop(paste("Variable 'tv' contains invalid values. It should have only values 2,3,4,8,12,16,20,25 or NA. Row numbers:",toString(rownames(mydata)[invalidtv])));   
			}
			
			invalidgen <- !(mydata$gen == 1 | mydata$gen == 2 | mydata$gen == 3 | mydata$gen == 4 | mydata$gen == 5 | is.na(mydata$gen))
			if(sum(invalidgen)>0){
				stop(paste("Variable 'gen' contains invalid values. It should have only values 1,2,3,4,5 or NA. Row numbers:",toString(rownames(mydata)[invalidgen])));   
			}
			
			invalidphb <- !(mydata$phb == 1 | mydata$phb == 2 | mydata$phb == 3 | mydata$phb == 4 | mydata$phb == 5 | is.na(mydata$phb))
			if(sum(invalidphb)>0){
				stop(paste("Variable 'phb' contains invalid values. It should have only values 1,2,3,4,5 or NA. Row numbers:",toString(rownames(mydata)[invalidphb])));   
			}        
		}
		
		if(sum(mydata$sex=="F")>0){ #there are girls in the datafile    
			
			if(is.null(mydata$bre)) stop("Variabable header 'bre' not found in the data! This variable is required for girls!");
			if(is.null(mydata$phg)) stop("Variabable header 'phg' not found in the data! This variable is required for girls!");
			if(is.null(mydata$men)) stop("Variabable header 'men' not found in the data! This variable is required for girls!");    
			
			invalidmen <- !(mydata$men == 1 | mydata$men == 2 | is.na(mydata$men))
			if(sum(invalidmen)>0){
				stop(paste("Variable 'men' contains invalid values. It should have only values 1,2 or NA. Row numbers:",toString(rownames(mydata)[invalidmen])));   
			}
			
			invalidbre <- !(mydata$bre == 1 | mydata$bre == 2 | mydata$bre == 3 | mydata$bre == 4 | mydata$bre == 5 | is.na(mydata$bre))
			if(sum(invalidbre)>0){
				stop(paste("Variable 'bre' contains invalid values. It should have only values 1,2,3,4,5 or NA. Row numbers:",toString(rownames(mydata)[invalidbre])));   
			}
			
			invalidphg <- !(mydata$phg == 1 | mydata$phg == 2 | mydata$phg == 3 | mydata$phg == 4 | mydata$phg == 5 | is.na(mydata$phg))
			if(sum(invalidphg)>0){
				stop(paste("Variable 'phg' contains invalid values. It should have only values 1,2,3,4,5 or NA. Row numbers:",toString(rownames(mydata)[invalidphg])));   
			}        
		}    
		
		persons <- unique(mydata$id);
		
		for(i in 1:length(persons)){
			pnr <- persons[i];
			select <- mydata$id==pnr;
			allsex <- mydata[select,"sex"];    
			if(length(unique(allsex))>1) stop(paste("Person with id",pnr,"has a different sex on varying records. Please fix this."));
		}    
		
		# data seems OK... saving...
		
		dataFileName <- paste(round(runif(1,1,99999)),".RData",sep="");
		dataFileDest <- file.path('/tmp',dataFileName);
		save(mydata, file=dataFileDest);
		
		#start reporting data summary
		
		outstring <- "[\n";
		
		persons <- unique(mydata$id)
		
		for(i in 1:length(persons)){
			pnr <- persons[i];
			select <- mydata$id==pnr;
			personcases <- mydata[select,];
			
			personsex <- personcases$sex[1];
			n_age <- sum(!is.na(personcases$age));
			
			n_tv <- sum(!is.na(personcases$tv));
			n_phb <- sum(!is.na(personcases$phb));
			n_gen <- sum(!is.na(personcases$gen));
			
			n_men <- sum(!is.na(personcases$men));
			n_phg <- sum(!is.na(personcases$phg));
			n_bre <- sum(!is.na(personcases$bre));
			
			ifelse(i>1, thisstring <- ",\n[", thisstring <- "[");
			thisstring <- paste(thisstring,i,",",sep="");        
			thisstring <- paste(thisstring,"\'",pnr,"\',",sep="");   #id name
			thisstring <- paste(thisstring,"\'",personsex,"\',",sep="");
			thisstring <- paste(thisstring,n_age,",",sep="");
			
			thisstring <- paste(thisstring,n_gen,",",sep="");
			thisstring <- paste(thisstring,n_phb,",",sep="");
			thisstring <- paste(thisstring,n_tv,",",sep="");
			
			thisstring <- paste(thisstring,n_bre,",",sep="");
			thisstring <- paste(thisstring,n_phg,",",sep="");
			thisstring <- paste(thisstring,n_men,sep="");
			thisstring <- paste(thisstring,"]",sep="");
			outstring <- paste(outstring,thisstring,sep="");        
		}
		outstring <- paste(outstring,"\n]");
		
		labels <- "['index','id','sex','N','gen','phb','tv','bre','phg','men']"
		
		cat("<html><head></head><body>");
		cat("{success:true, file:\"",dataFileName,"\", labels:",labels,",values:",outstring,"}",sep="");
		cat("</body></html>");
	}
	
	printFailure <- function(e){
		
		#stop("printFailure error");  #returns an http 500;
		
		errorString <- toString(e);
		errorString <- gsub("\"","'",errorString);
		errorString <- gsub("\n"," ",errorString);
		cat("<html><head></head><body>");
		cat("{success:false, error:\"",errorString,"\"}",sep="");
		cat("</body></html>");
	}
	
	### actual function:
	
	tryCatch(printSuccess(), error = function(e){printFailure(e)});
}