using Toybox.Communications;
using Toybox.Time;
using Toybox.Time.Gregorian;

(:glance)
class AareData {
	
	var timestamp;
	var temperature;
	var flow;
	var height;


	// assign a specific color depending on the temperature range
	function colorOfTemperature() {
		var t = temperature;
		var color = Graphics.COLOR_WHITE;
		if ( t < 16 ) {
			color = Graphics.COLOR_BLUE;
		} else if (t >= 16 and t < 19) {
			color = Graphics.COLOR_GREEN;
		} else if (t >= 19 and t < 21) {
			color = Graphics.COLOR_YELLOW;
		} else if (t >= 21 and t < 23) {
			color = Graphics.COLOR_ORANGE;
		} else if (t >= 23 ) {
			color = Graphics.COLOR_RED;
		}
		
		return color;
	} 
	
	function timeStr() {	
		var date = Gregorian.info(new Time.Moment(timestamp), Time.FORMAT_SHORT);
		return Lang.format("$1$:$2$", [ date.hour, date.min]);
	}
	
	function dateStr() {
		var date = Gregorian.info(new Time.Moment(timestamp), Time.FORMAT_SHORT);
		return Lang.format("$1$.$2$.$3$ $4$:$5$", [ date.day, date.month, date.year, date.hour, date.min ]);
	}  
	
	function isActual() {
		// timestamp is not older than 2 hours.
		return Time.now().subtract(new Time.Moment(timestamp)).lessThan(new Time.Duration(2 * 3600));
	}
	
	function isToday() {
		// timestamp is from today.
		return Time.today().subtract(new Time.Moment(timestamp)).lessThan(new Time.Duration(24 * 3600));
	}
	
	function dateStrComplex() {
		var date = Gregorian.info(new Time.Moment(timestamp), Time.FORMAT_SHORT);
		var dateFormated;
		
		if (isActual()) {
			dateFormated = Lang.format("$1$:$2$", [ date.hour, date.min]);
		} else if (isToday()) {
			dateFormated =  Lang.format("$1$:$2$ (!)", [ date.hour, date.min]);
		} else {
			dateFormated =  Lang.format("$1$.$2$.$3$ (!) $4$:$5$", [ date.day, date.month, date.year, date.hour, date.min ]);
		}	

		return dateFormated;
	} 
	
	function flowStr() {

		if (flow < 50) { return "sehr wenig";}
		if (flow < 100) { return "wenig";}
		if (flow < 150) { return "eher wenig";}
		if (flow < 200) { return "eher viel";}
		if (flow < 250) { return "viel";}
		if (flow < 300) { return "sehr viel";}
		if (flow < 420) { return "extrem viel";}
		return "Hochwasser"; //Schadensgrenze überstiegen
	}
	    
}

(:glance)
class AareSchwummModel {

	// Aareschwumm JSON API
	// See: https://aare.schwumm.ch/api/
	const URL = "https://aare.schwumm.ch/api/current?timeformat=unix";
	
	var notify = null;
	var message = "";
	var aareData = null;
	
	function initialize(handler) {
		System.println("AareSchwummModel.initalize()");
		notify = handler;
		
		makeAPIRequest();
	}
	
    function fromJson(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}	
		aareData.temperature = data.get("temperature").toFloat();
		aareData.flow = data.get("flow").toFloat();
		aareData.height = data.get("height").toFloat();
		aareData.timestamp = data.get("date");
		
		return aareData;
    }
    
    function makeAPIRequest() {
		//Check if Communications is allowed for Widget usage
		if (Toybox has :Communications) {
			
			var params = null;
       		var options = {
         			:method => Communications.HTTP_REQUEST_METHOD_GET,
         			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
         		};
         		
         	try {
         	    System.println("Request: " + URL);	
       			Communications.makeWebRequest(URL, params, options, method(:onResponse));
       			
       		} catch (e instanceof Lang.Exception) {
       			System.println("Exception during WebRequest:" + e.getErrorMessage());
       			message = "Exception";
      			notify.invoke(message);
       		}
       		
       	} else {
      		message = "Keine communication";
      		System.println(message);
      		notify.invoke(message);
      	}          	
    }

	function onResponse(responseCode, data) {
		System.println("AareSchwummModel.onResponse(), Code:" + responseCode + ", data:" + data);
        if (responseCode == 200) {
        	aareData = fromJson(data);
			notify.invoke(aareData);
           	
        } else { 
        	message = "Service\nnot available";
        	System.println("AareSchwummModel " + message + " Code:" + responseCode);
         	notify.invoke(message);
        }
    }
    
    function getAareData() {
    	return aareData;
    }  

       
}