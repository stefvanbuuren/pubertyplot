window.onload = function (e) {
	
}

function pageScroll(pixels) {
	for(var i = 0; i < pixels; i++){
		window.scrollBy(0,5);
	}
}

function startCallback() {
	 // make something useful before submit (onStart)
	 return true;
}

function completeCallback(response) {
	// make something useful after (onComplete)
	document.getElementById('f1_upload_process').style.visibility = 'hidden';
	document.getElementById('f1_upload_form').style.visibility = 'visible';
	
	var myjson = response.evalJSON();
	if(myjson.success) { 
		makeTable(myjson); 
		pageScroll(500);
		document.getElementById('f1_upload_success').style.visibility = 'visible';
	}
	
	if(!myjson.success) { alert("An error occured!\n\n" + myjson.error); }
}

function makeTable(myjson){

	myTable1 = document.createElement('table');
	myTable1.setAttribute("id","myTable1");
	myThead = document.createElement('thead');
	myTR = document.createElement('tr');
	
	for(var i=1; i < myjson.labels.length; i++){
	
		myTH = document.createElement('th');
		myTH.appendChild(document.createTextNode(myjson.labels[i]));
		myTR.appendChild(myTH);
	}
	
	myThead.appendChild(myTR);
	myTable1.appendChild(myThead);
	
	myTable2 = document.createElement('table');
	myTable2.setAttribute("id","myTable2");	
	myTbody = document.createElement('tbody');	

	for(var i=0; i < myjson.values.length; i++){
	
		myTR = document.createElement('tr');
		for(var j=1; j < myjson.labels.length; j++){
		
			myTD = document.createElement('td');
			myTD.appendChild(document.createTextNode(myjson.values[i][j]));
			myTR.appendChild(myTD);		
			
		}
		myTbody.appendChild(myTR);
	}
	myTable2.appendChild(myTbody);
	
	myTableContainer = document.createElement('div');
	myTableContainer.setAttribute("id","myTableContainer");
	myTableContainer.appendChild(myTable2);

	document.getElementById("dataTable").innerHTML = "";
	document.getElementById("goPlaceholder").innerHTML= "";

	myH2 = document.createElement('H2');
	myH2.appendChild(document.createTextNode("Step 2: Verify your data and press 'Go'"));
	
	myP = document.createElement('p');
	myP.setAttribute("id","plotLoader");
	myP.appendChild(document.createElement("br"));
	
	myP.appendChild(document.createTextNode("loading...."));
	
	myImg = document.createElement('img');
	myImg.setAttribute("src","loader.gif");
	myP.appendChild(myImg);
	myP.appendChild(document.createElement("br"));
	

	myInput = document.createElement('input');
	myInput.setAttribute("type","button");
	myInput.setAttribute("value","GO!");
	myInput.setAttribute("id","goButton");
	myInput.file = myjson.file;
	myInput.onclick = function() {getOutput(this.file);}
	
	document.getElementById("dataTable").appendChild(myH2);
	document.getElementById("dataTable").appendChild(myTable1);
	document.getElementById("dataTable").appendChild(myTableContainer);	
	
	document.getElementById("goPlaceholder").appendChild(myP); //loader animation
	document.getElementById("goPlaceholder").appendChild(myInput); //gobutton
	

}

function getOutput(dataFile){

	document.getElementById('plotLoader').style.visibility = 'visible';
	document.getElementById('goButton').style.visibility = 'hidden';

	new Ajax.Request('/pubertyproplot',
	{
    method:'post',
	parameters: {dataFile: dataFile},
    onSuccess: function(transport){
		var myjson2 = transport.responseText.evalJSON();
		if(!myjson2.success) {alert("There was an error:\n\n" + myjson2.error);}
		if(myjson2.success) {
			showIcons(myjson2.file);
			//window.scroll(0,500);
			pageScroll(100);
		}
    },
    onFailure: function(){ alert('Something went wrong...') }
  });
}

function showIcons(filename){

	//alert("filename="+filename);
	
	myH3 = document.createElement('h3');
	myH3.appendChild(document.createTextNode("Output files were successfully generated!"));
	myH3.setAttribute("id","outputsuccess");

	myP = document.createElement('p');
	myP.appendChild(myH3);
	
	document.getElementById("goPlaceholder").innerHTML = "<br />";
	document.getElementById("goPlaceholder").appendChild(myP);
	
	// icons:
	document.getElementById("icons").innerHTML = "";
	
	myH2 = document.createElement('H2');
	myH2.appendChild(document.createTextNode("Step 3: Download Output files"));	
	
	myH3 = document.createElement('H3');
	myH3.appendChild(document.createTextNode("Use Right Mouseclick > \"Save Target As\" to save files to your disk."));	
	
	document.getElementById("icons").appendChild(myH2);
	document.getElementById("icons").appendChild(myH3);
	//csv icon 
	myA = document.createElement('a');
	myA.setAttribute("href","/plotdumpdir/"+filename+".csv");
	myA.setAttribute("target","_blank");
	myImg = document.createElement('img');
	myImg.setAttribute("src","doc_csv_icon.png");
	myA.appendChild(myImg);
	document.getElementById("icons").appendChild(myA);

	//txt icon
	myA = document.createElement('a');
	myA.setAttribute("href","/plotdumpdir/"+filename+".txt");
	myA.setAttribute("target","_blank");
	myImg = document.createElement('img');
	myImg.setAttribute("src","txt_icon.png");
	myA.appendChild(myImg);
	document.getElementById("icons").appendChild(myA);
	
	//pdf icon

	myA = document.createElement('a');
	myA.setAttribute("href","/plotdumpdir/"+filename+".pdf");
	myA.setAttribute("target","_blank");
	myImg = document.createElement('img');
	myImg.setAttribute("src","pdf_icon.jpg");
	myA.appendChild(myImg);
	document.getElementById("icons").appendChild(myA);	
}

function clearAll(){

	document.getElementById("dataTable").innerHTML = "";
	document.getElementById("goPlaceholder").innerHTML= "";
	document.getElementById("icons").innerHTML= "";
	
	document.getElementById('f1_upload_success').style.visibility = 'hidden';	
	document.getElementById('f1_upload_process').style.visibility = 'visible';
	document.getElementById('f1_upload_form').style.visibility = 'hidden';
	  
	return(true);
}

	