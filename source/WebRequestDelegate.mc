using Toybox.Communications;
using Toybox.WatchUi;

class WebRequestDelegate extends WatchUi.BehaviorDelegate {
    
    var notify;
    var url;
    
        // Set up the callback to the view
    function initialize(handler, url) {
    	self.url = url;
    	System.println("WebRequestDelegate.initialize(), url=" + url);
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
    }
    
    function onSelect() {
    	System.println("WebRequestDelegate.onSelect() --> update data.");
        makeAPIRequest();
        return true;
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
         	    System.println("Request: " + url);	
       			Communications.makeWebRequest(url, params, options, method(:onResponse));
       		} catch (e instanceof Lang.Exception) {
       			System.println("Exception during WebRequest:" + e.getErrorMessage());
       		}
       	} else {
      		System.println("Communication\nnot\npossible");
      	}          	
    }

	function onResponse(responseCode, data) {
		System.println("WebRequestDelegate.OnResponse(), Code:" + responseCode + ", data:" + data);
        if (responseCode == 200) {
			notify.invoke(data);
           	
        } else { 
         	notify.invoke("Failed to load: " + responseCode.toString());
        	System.println("Request failed\nWith ResponseCode: \n" + responseCode);
        }
    }


}