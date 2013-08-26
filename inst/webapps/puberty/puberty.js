/*
Web application written by Jeroen Ooms, Utrecht University, 2008.
Any questions/comments: jeroenooms[at]gmail[dot]com
*/

window.onload = function (e) {
	
    init();
    
    document.getElementById('gender').onchange = function (e) {
        changeTable();
		clearAll();
    }
    
    document.getElementById('number').onchange = function (e) {
        changeTable();
		clearAll();
    }
    
    document.getElementById('plot').onclick = function (e) {
        plot();
    }
    
    document.getElementById('clear').onclick = function (e) {
        window.location.href = "index.html";
    }
	
    document.getElementById('ref1').onclick = function (e) {
        if(this.checked) this.value = "T"; 
		else this.value = "F";
		plot();
    }

    document.getElementById('ref2').onclick = function (e) {
        if(this.checked) this.value = "T"; 
		else this.value = "F";
		plot();
    }

    document.getElementById('ref3').onclick = function (e) {
        if(this.checked) this.value = "T"; 
		else this.value = "F";
		plot();
    }	
}


var myAge;
var myGen;
var myPhb;
var myTv;
var myBre;
var myPhg;
var myMen;

function init(){
		changeTable();
}

function changeTable(){

		var gender = document.getElementById("gender").value;
		var number = document.getElementById("number").value;
		
		if(gender=="M"){
		
			myAge=new Array(number); 
			myGen=new Array(number);
			myPhb=new Array(number);
			myTv=new Array(number);
		
			myTable = document.createElement('table');
			myThead = document.createElement('thead');
			
			myTable.cellPadding = 0;
			myTable.cellSpacing = 0;
			
			myTR = document.createElement('tr');
			
			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("#"));
			myTR.appendChild(myTH);
			
			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Age"));
			myTR.appendChild(myTH);			
			
			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Gen"));
			myTR.appendChild(myTH);

			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Phb"));
			myTR.appendChild(myTH);

			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Tv"));
			myTR.appendChild(myTH);

			myThead.appendChild(myTR);
			myTable.appendChild(myThead);
			
			myTbody = document.createElement('tbody');

			for(var i=0; i < number; i++){
				
				myTR = document.createElement('tr');
				
				myTD = document.createElement('td');
				myTD.appendChild(document.createTextNode((i+1)+"."));
				myTR.appendChild(myTD);
				
				myAge[i] = document.createElement('INPUT');
				myAge[i].setAttribute('type','text');
				myAge[i].onblur = function() {testAge(this);}
				myTD = document.createElement('td');
				myTD.appendChild(myAge[i]);
				myTR.appendChild(myTD);
				
				myGen[i] = document.createElement('SELECT');
				myValues=new Array("NA",1,2,3,4,5);
				for(var j=0; j < myValues.length; j++){	
					myOption = document.createElement('OPTION');
					myOption.setAttribute('value',myValues[j]);
					myOption.appendChild(document.createTextNode(myValues[j]));
					myGen[i].appendChild(myOption);
				}
				myTD = document.createElement('td');
				myTD.appendChild(myGen[i]);
				myTR.appendChild(myTD);

				myPhb[i] = document.createElement('SELECT');
				myValues=new Array("NA",1,2,3,4,5);
				for(var j=0; j < myValues.length; j++){	
					myOption = document.createElement('OPTION');
					myOption.setAttribute('value',myValues[j]);
					myOption.appendChild(document.createTextNode(myValues[j]));
					myPhb[i].appendChild(myOption);
				}
				myTD = document.createElement('td');
				myTD.appendChild(myPhb[i]);
				myTR.appendChild(myTD);
				
				myTv[i] = document.createElement('SELECT');
				myValues=new Array("NA",2,3,4,8,12,16,20,25);
				for(var j=0; j < myValues.length; j++){	
					myOption = document.createElement('OPTION');
					myOption.setAttribute('value',myValues[j]);
					myOption.appendChild(document.createTextNode(myValues[j]));
					myTv[i].appendChild(myOption);
				}
				myTD = document.createElement('td');
				myTD.appendChild(myTv[i]);
				myTR.appendChild(myTD);
				
				myTbody.appendChild(myTR);
			}
			
		
			myTable.appendChild(myTbody);
		
			document.getElementById("dataTable").innerHTML = "";
			document.getElementById("dataTable").appendChild(myTable);
		}
		
		if(gender=="F"){
		
			myAge=new Array(number); 
			myBre=new Array(number);
			myPhg=new Array(number);
			myMen=new Array(number);
			
			myTable = document.createElement('table');
			myThead = document.createElement('thead');
			
            myTable.cellPadding = 0;
            myTable.cellSpacing = 0;
			
			myTR = document.createElement('tr');
			
			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("#"));
			myTR.appendChild(myTH);
			
			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Age"));
			myTR.appendChild(myTH);			
			
			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Bre"));
			myTR.appendChild(myTH);

			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Phg"));
			myTR.appendChild(myTH);

			myTH = document.createElement('th');
			myTH.appendChild(document.createTextNode("Men"));
			myTR.appendChild(myTH);

			myThead.appendChild(myTR);
			myTable.appendChild(myThead);	

			myTbody = document.createElement('tbody');			
		
			for(var i=0; i < number; i++){
				
				myTR = document.createElement('tr');
				
				myTD = document.createElement('td');
				myTD.appendChild(document.createTextNode((i+1)+"."));
				myTR.appendChild(myTD);
				
				myAge[i] = document.createElement('INPUT');
				myAge[i].setAttribute('type','text');
				myAge[i].onblur = function() {testAge(this);}
				myTD = document.createElement('td');
				myTD.appendChild(myAge[i]);
				myTR.appendChild(myTD);
				
				myBre[i] = document.createElement('SELECT');
				myValues=new Array("NA",1,2,3,4,5);
				for(var j=0; j < myValues.length; j++){	
					myOption = document.createElement('OPTION');
					myOption.setAttribute('value',myValues[j]);
					myOption.appendChild(document.createTextNode(myValues[j]));
					myBre[i].appendChild(myOption);
				}
				myTD = document.createElement('td');
				myTD.appendChild(myBre[i]);
				myTR.appendChild(myTD);

				myPhg[i] = document.createElement('SELECT');
				myValues=new Array("NA",1,2,3,4,5);
				for(var j=0; j < myValues.length; j++){	
					myOption = document.createElement('OPTION');
					myOption.setAttribute('value',myValues[j]);
					myOption.appendChild(document.createTextNode(myValues[j]));
					myPhg[i].appendChild(myOption);
				}
				myTD = document.createElement('td');
				myTD.appendChild(myPhg[i]);
				myTR.appendChild(myTD);
				
				myMen[i] = document.createElement('SELECT');
				myValues=new Array("NA",1,2);
				for(var j=0; j < myValues.length; j++){	
					myOption = document.createElement('OPTION');
					myOption.setAttribute('value',myValues[j]);
					myOption.appendChild(document.createTextNode(myValues[j]));
					myMen[i].appendChild(myOption);
				}
				myTD = document.createElement('td');
				myTD.appendChild(myMen[i]);
				myTR.appendChild(myTD);
				
				myThead.appendChild(myTR);
			}	
			myTable.appendChild(myThead);
			document.getElementById("dataTable").innerHTML = "";
			document.getElementById("dataTable").appendChild(myTable);
		}
}

function plot(){

	var gender = document.getElementById("gender").value;
	var number = document.getElementById("number").value;
	var name = document.getElementById("name").value;
	
	var reflines = new Array(3);
	reflines[0] = document.getElementById("ref1").value;
	reflines[1] = document.getElementById("ref2").value;
	reflines[2] = document.getElementById("ref3").value;

	for(var i=0; i<number; i++){
		if(myAge[i].value=="") myAge[i].value = "NA";
	}
	
	if(gender=="M"){
	
		var ageString = myAge[0].value;
		var genString = myGen[0].value;
		var phbString = myPhb[0].value;
		var tvString = myTv[0].value;

		
		for(var i=1; i < number; i++){
			ageString = ageString + ":" + myAge[i].value;
			genString = genString + ":" + myGen[i].value;
			phbString = phbString + ":" + myPhb[i].value;
			tvString = tvString + ":" + myTv[i].value;
		}
		
		new Ajax.Request('/pubertyplot', {
			method: 'get',
			parameters: {
				gender: gender, 
				name: name,
				number: number,
				age: ageString,
				gen: genString,
				phb: phbString,
				tv: tvString,
				reflines: reflines.toString()
			},
			onSuccess: function(transport){
				var response = transport.responseText;
				document.getElementById("plotpng").setAttribute('src',"/plotdumpdir/"+ response + ".png");
				
				var downloadPdf = document.createElement("a");
				downloadPdf.appendChild(document.createTextNode("Download in PDF!"));
				downloadPdf.setAttribute("href", "/plotdumpdir/"+ response + ".pdf");
				downloadPdf.setAttribute("target", "_blank");
				
				document.getElementById("pdfarea").innerHTML = "";
				document.getElementById("pdfarea").appendChild(downloadPdf);
				
			},
			onFailure: function(){ alert('Something went wrong... consult apache error log') 
			}
		});
	}
	
	if(gender=="F"){
		var ageString = myAge[0].value;
		var breString = myBre[0].value;
		var phgString = myPhg[0].value;
		var menString = myMen[0].value;	

		for(var i=1; i < number; i++){
			ageString = ageString + ":" + myAge[i].value;
			breString = breString + ":" + myBre[i].value;
			phgString = phgString + ":" + myPhg[i].value;
			menString = menString + ":" + myMen[i].value;
		}	
		
		new Ajax.Request('/pubertyplot', {
			method: 'get',
			parameters: {
				gender: gender, 
				name: name,
				number: number,
				age: ageString,
				bre: breString,
				phg: phgString,
				men: menString,
				reflines: reflines.toString()				
			},
			onSuccess: function(transport){
				var response = transport.responseText;
				document.getElementById("plotpng").setAttribute('src',"/plotdumpdir/"+ response + ".png");
				
				var downloadPdf = document.createElement("a");
				downloadPdf.appendChild(document.createTextNode("Download in PDF!"));
				downloadPdf.setAttribute("href", "/plotdumpdir/"+ response + ".pdf");	
				downloadPdf.setAttribute("target", "_blank");				
				
				document.getElementById("pdfarea").innerHTML = "";
				document.getElementById("pdfarea").appendChild(downloadPdf);
			},
			onFailure: function(){ alert('Something went wrong... consult apache error log') 
			}
		});
	}		
}


function isValidAge(ageBox){

	var age = ageBox.value = ageBox.value.replace(/,/, '.');
	if ((age == parseFloat(age) && age >= 8 && age <= 21)) {return true};
	return false
}

function testAge(ageBox){

	if(!isValidAge(ageBox)) {
		alert("This is not a valid age! Please select an age between 8 and 21, and use a dot for decimals");
		ageBox.value = "";
	}
}

function clearAll(){

	document.getElementById("pdfarea").innerHTML = "<br />";
	
	document.getElementById('ref1').checked = false;
	document.getElementById('ref1').value = "F";
	
	document.getElementById('ref2').checked = false;
	document.getElementById('ref2').value = "F";

	document.getElementById('ref3').checked = false;
	document.getElementById('ref3').value = "F";
	
	document.getElementById("plotpng").setAttribute('src',"empty.png");

}

