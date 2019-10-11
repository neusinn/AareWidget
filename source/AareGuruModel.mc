using Toybox.Communications as Comm;

class AareGuruData {	
	var aare;
	var aarePast;
	var weather;
}

class AareGuruModel {
	// Aareguru JSON API
	// See: https://aareguru.existenz.ch/
	const URL = "http://aareguru.existenz.ch/v2018/current?city=Bern";
	var aareData = null;

  	function initialize()	{
  	    System.println("AareGuruModel.initialize()");
        makeAPIRequests(URL);    				 
    }
    
    function makeAPIRequests(url) {
		//Check if Communications is allowed for Widget usage
		if (Toybox has :Communications) {
			aareData = null; 
			
			var params = null;
       		var options = {
         		:method => Communications.HTTP_REQUEST_METHOD_GET,
         		:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
         		};
         	try {
         	    System.println("Request: " + url);	
       			Comm.makeWebRequest(url, params, options, method(:onResponse));
       		} catch (e instanceof Lang.Exception) {
       			System.println("Exception during WebRequest:" + e.getErrorMessage());
       		}
       		
       	} else {
      		System.println("Communication\nnot\npossible");
      	} 
    }

	function onResponse(responseCode, data) {
        if (responseCode == 200) {
			System.println("Response: " + data);
			convert(data);
           	
        } else { 
        	System.println("Request failed\nWith responseCode: \n" + responseCode);
        }
    }
    
    function convert(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}	
		aareData.temperature = data.get("temperature").toFloat().format("%0.1f");
		aareData.flow = data.get("flow").toFloat().format("%0i");
		aareData.height = data.get("height").toFloat().toFloat().format("%0i");
    }
 
 }