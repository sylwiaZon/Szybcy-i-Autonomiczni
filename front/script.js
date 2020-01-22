window.addEventListener("load", function(){
var tarcza = document.getElementById('predkosciomierz');
var s =document.getElementById('s');
var uid;
if(s.value==''){
		s.value=0;
	}
for(i=0;i<250;i+=30){
	var miarka = document.createElement('div');

	miarka.className='miarka';
	x=60+i;
	miarka.style.transform = "rotate("+x+"deg)";
	tarcza.appendChild(miarka);
}
var p50 = document.createElement('div');
p50.className='miarka';
p50.style.transform = "rotate(110deg)";
p50.style.borderBottom="solid 30px red"
tarcza.appendChild(p50);

var send = document.getElementById('send');
send.addEventListener("click",function(){

	var max = document.getElementById('trip-length');
	var stop = document.getElementById('stop');
	var ramp = document.getElementById('ramp');
	var walkway = document.getElementById('walkway');
	var empty = document.getElementById('empty');
	var human = document.getElementById('human');
	var roadworks = document.getElementById('roadworks');
	var roadworksEnd = document.getElementById('roadworks-end');
	var unbuilt = document.getElementById('unbuilt');
	var unbuiltEnd = document.getElementById('unbuilt-end');
	var maxSpeed = document.getElementById('max-speed');
	var maxSpeedStart = document.getElementById('max-speed-start');
	var maxSpeedEnd = document.getElementById('max-speed-end');

	var tab = [];
	
	if(stop.value != ""){
		tab.push([0,parseFloat(stop.value)]);
		//var x= parseFloat(stop.value)+0.1;
		//tab.push([50,x]);	
	};
	if(ramp.value != ""){
		tab.push([10,parseFloat(ramp.value)]);
		//var x= parseFloat(ramp.value)+0.1;
		//tab.push([50,x]);	
	};
	if(walkway.value!=""){
		if(empty.checked){
			tab.push([40,parseFloat(walkway.value)]);
		}
		if(human.checked){

			tab.push([0,parseFloat(walkway.value)]);
		}
		//var x= parseFloat(walkway.value)+0.1;
		//tab.push([50,x]);	
	}
	if(roadworks.value != ""){
		tab.push([40,parseFloat(roadworks.value)]);
		var y;
		if(roadworksEnd.value != ""){
			y = parseFloat(roadworksEnd.value);
		}else{
			y=0.1
		}
		var x= parseFloat(roadworks.value)+y;
		tab.push([50,x]);	
	};
	if(unbuilt.value != ""){
		tab.push([90,parseFloat(unbuilt.value)]);
		if(nbuiltEnd.value!=null){
			tab.push([50,parseFloat(unbuiltEnd.value)]);
		}else{
			var x = parseFloat(unbuilt.value)+1.5;
			tab.push([50,x]);
		}
	}
	if(maxSpeed.value !=""){
		tab.push([+maxSpeed.value,parseFloat(maxSpeedStart.value)])
		tab.push([50,parseFloat(maxSpeedEnd.value)])
	}
	if(max.value!=""){
		tab.push([0,parseFloat(max.value)]);
	}

tab.sort( function(a,b) {
   return b[1]-a[1];
  });
tab.reverse();
	console.log(tab);
	var data = {tab}

	console.log(data);
	
	var Http = new XMLHttpRequest();
	var url='localhost:8085/getRoute';
	Http.open("POST", url,true);
	Http.send(tab);

	Http.onreadystatechange = (e) => {
	  console.log(Http.responseText)
	  uid = JSON.parse(Http.responseText).uid;
	}
	
})


function animation(tab){
	
		var i =0;

		
		var interv = setInterval(function(){
			
			var speed = document.getElementById('speed');
			var inf = document.getElementById("informacja");
			inf.innerHTML ="Jesteś na "+ parseFloat(tab[i][1])/1000 + "km";

			var x = tab[i][0]+60;		
			var indicator = document.getElementById('indicator');
				indicator.className='indicator';
			indicator.style.WebkitTransitionDuration='2s';		//roznica czasu
			indicator.style.WebkitTransform="rotate("+x+"deg)";	//nowa predkosc

			speed.innerHTML = tab[i][0] +"km/h";
			i+=1;
			
		},1000)
		//x = (tab.lenght+1)*1000;
		//setTimeout(function(){clearInterval(interv)},x);
		
}

var get = document.getElementById('get');
get.addEventListener("click",function(){
	
	var Http = new XMLHttpRequest();
	var url='localhost:8085/getRoute?id='+uid;
	Http.open("GET", url);
	Http.send(data);

	Http.onreadystatechange = (e) => {
	  console.log(Http.responseText)

	  //dodaj animacje
	}
	
	//animacja
	var tab2 = [[0,0],[50,100],[80,200],[10,300],[100,400],[100,500],[100,600],[60,700],[40,800],[40,900],[0,1000]];
	tab2.sort( function(a,b) {
   return b[1]-a[1];
  });
	tab2.reverse();
	console.log(tab2);
	animation(tab2);
})
s.addEventListener("keydown", event => {
  if(event.keyCode==13){
  	var speed = document.getElementById('speed');
	var s =document.getElementById('s');
	
	var x = parseInt(s.value)+60;		
	var indicator = document.getElementById('indicator');
		indicator.className='indicator';
	indicator.style.WebkitTransitionDuration='2s';		//roznica czasu
	indicator.style.WebkitTransform="rotate("+x+"deg)";	//nowa predkosc

	speed.innerHTML = s.value +"km/h";
  }
});


})