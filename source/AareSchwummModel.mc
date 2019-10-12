using Toybox.Communications;

(:glance)
class AareData {	
	var date;
	var temperature;
	var flow;
	var height;
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
		aareData.temperature = data.get("temperature").toFloat().format("%0.1f");
		aareData.flow = data.get("flow").toFloat().format("%0i");
		aareData.height = data.get("height").toFloat().format("%0i");
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