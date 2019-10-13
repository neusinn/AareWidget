using Toybox.Communications;

(:glance)
class AareData {
	
	var date;
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
}

(:glance)
class AareSchwummModel {

	// Aareschwumm JSON API
	// See: https://aare.schwumm.ch/api/
	const URL = "https://aare.schwumm.ch/api/current?timeformat=local";
	
	var notify = null;
	var message = "";
	var aareData = null;
	
	function initialize(handler) {
		System.println("AareSchwummModel.initalize()");
		notify = handler;
		
		makeAPIRequest();
	}
	
    function convert(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}	
		aareData.temperature = data.get("temperature").toFloat();
		aareData.flow = data.get("flow").toFloat();
		aareData.height = data.get("height").toFloat();
		aareData.date = data.get("date");
		
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
       		message = "Not available.";
      		notify.invoke(message);
       		}
       		
       	} else {
      		System.println("Communication\nnot\npossible");
      		message = "Communication\nnot possible.";
      		notify.invoke(message);
      	}          	
    }

	function onResponse(responseCode, data) {
		System.println("AareSchwummModel.onResponse(), Code:" + responseCode + ", data:" + data);
        if (responseCode == 200) {
        	aareData = convert(data);
			notify.invoke(aareData);
           	
        } else { 
        	message = "Failed to load: " + responseCode;
        	System.println("AareSchwummModel - Failed to load: " + message);
         	notify.invoke(message);
        }
    }
    
    function getAareData() {
    	return aareData;
    }  

       
}