using Toybox.Communications;
using Toybox.WatchUi;

class WebRequestDelegate extends WatchUi.BehaviorDelegate {
    
    var notify;
    var model;
    var url;
    
        // Set up the callback to the view
    function initialize(handler, model) {
    	System.println("WebRequestDelegate.initialize(), url=" + url);
    	self.model = model;
    	self.url = model.URL;
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
    }
    
    // Handle menu button press
    function onMenu() {
    	System.println("WebRequestDelegate.onMenu()");
        makeAPIRequests(url);
        return true;
    }

    function onSelect() {
    	System.println("WebRequestDelegate.onSelect()");
        makeAPIRequests(url);
        return true;
    }
    
    function makeAPIRequests(url) {
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
			notify.invoke(model.convert(data));
           	
        } else { 
         	notify.invoke("Failed to load\nResponseCode: " + responseCode.toString());
        	System.println("Request failed\nWith ResponseCode: \n" + responseCode);
        }
    }
    

}