using Toybox.Communications;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;

(:glance)
class AareData {
	
	var timestamp = 0;
	var temperature = 0;
	var flow = 0;
	var height = 0;
	var forecast2h = 0;
	var city = "bern";


	// assign a specific color depending on the temperature range
	function colorOfTemperature() {
		var t = temperature;
		var color = Graphics.COLOR_WHITE;

		if (t == null) { 
			return color; 
		}
		if ( t < 16 ) { color = Graphics.COLOR_BLUE;
		} else if (t >= 16 and t < 17) { color = 0x00AAFF;
		} else if (t >= 17 and t < 18) { color = Graphics.COLOR_GREEN;
		} else if (t >= 18 and t < 19) { color = 0x00FF00;		
		} else if (t >= 19 and t < 20) { color = Graphics.COLOR_YELLOW;
		} else if (t >= 20 and t < 22) { color = Graphics.COLOR_ORANGE;
		} else { color = Graphics.COLOR_RED; 
		}

		return color;
	} 
	

	function timeStr() {	
		var date = Gregorian.info(new Time.Moment(timestamp), Time.FORMAT_SHORT);
		return Lang.format("$1$:$2$", [ date.hour, date.min.format("%02d")]);
	}
	

	function dateStr() {
		var date = Gregorian.info(new Time.Moment(timestamp), Time.FORMAT_SHORT);
		return Lang.format("$1$.$2$.$3$ $4$:$5$", [ date.day, date.month.format("%02d"), date.year, date.hour, date.min.format("%02d") ]);
	}  
	

	function isActual() {
		// timestamp is not older than 2 hours.
		return Time.now().subtract(new Time.Moment(timestamp)).lessThan(new Time.Duration(2 * 3600));
	}
	

	function isToday() {
		// timestamp is from today.
		return Time.today().subtract(new Time.Moment(timestamp)).lessThan(new Time.Duration(24 * 3600));
	}
	

	function messureDate() {
		var date = Gregorian.info(new Time.Moment(timestamp), Time.FORMAT_SHORT);
		var dateFormated = "";
		
		if (isActual()) {
			dateFormated = Lang.format("$1$:$2$", [ date.hour, date.min.format("%02d")]);
		} else if (isToday()) {
			dateFormated = Lang.format("$1$:$2$", [ date.hour, date.min.format("%02d")]);
		} else {
			dateFormated =  Lang.format("$1$.$2$.$3$ $4$:$5$", [ date.day, date.month.format("%02d"), date.year, date.hour, date.min.format("%02d") ]);
		}	

		return dateFormated;
	} 
	

	function flowStr() {
		if (flow==null) { 
			return ""; // missing data
		}
		if (flow < 50)  { return WatchUi.loadResource(Rez.Strings.flow_very_little);}
		if (flow < 100) { return WatchUi.loadResource(Rez.Strings.flow_little);}
		if (flow < 150) { return WatchUi.loadResource(Rez.Strings.flow_not_much);}
		if (flow < 200) { return WatchUi.loadResource(Rez.Strings.flow_rater_much);}
		if (flow < 250) { return WatchUi.loadResource(Rez.Strings.flow_much);}
		if (flow < 300) { return WatchUi.loadResource(Rez.Strings.flow_very_much);}
		if (flow < 430) { return WatchUi.loadResource(Rez.Strings.flow_extremly);}
		return WatchUi.loadResource(Rez.Strings.flow_flood); //Schadensgrenze überstiegen
	}

	function cityStr() {
		var cityStr;

		switch (city) {
			case "bern"       : cityStr = WatchUi.loadResource(Rez.Strings.propCityBern); break;
			case "biel"       : cityStr = WatchUi.loadResource(Rez.Strings.propCityBiel); break;
			case "brienz"     : cityStr = WatchUi.loadResource(Rez.Strings.propCityBrienz); break;
			case "thun"       : cityStr = WatchUi.loadResource(Rez.Strings.propCityThun); break;
			case "interlaken" : cityStr = WatchUi.loadResource(Rez.Strings.propCityInterlaken); break;
			case "brugg"      : cityStr = WatchUi.loadResource(Rez.Strings.propCityBrugg); break;
			case "olten"      : cityStr = WatchUi.loadResource(Rez.Strings.propCityOlten); break;
			case "hagneck"    : cityStr = WatchUi.loadResource(Rez.Strings.propCityHagneck); break;
		
			default: cityStr = WatchUi.loadResource(Rez.Strings.propCityBern);
		}

		return cityStr;
	} 
}



(:glance)
class AareSchwummModel {

	// Aareschwumm JSON API (deprecated)
	// See: https://aare.schwumm.ch/api/ 
	// Example: {"date":1579456200,"temperature":6.2,"flow":49.86,"height":501.57,"temperature_text":"cold","source":"BAFU","timeformat":"unix"}
	// const URL = "https://aare.schwumm.ch/api/current?timeformat=unix";
	
	// Optional API
	// BAFU hydrology data of rivers in Switzerland from hydrodaten.admin.ch.
	// See: https://api.existenz.ch/docs/apiv1#/hydro/get_hydro_latest
	// Location Bern_Schönausteg= 2135
	// https://api.existenz.ch/apiv1/hydro/latest?locations=2135&parameters=temperature%2Cflow%2Cheight&format=table&app=AareTemperatur.widget&version=1.0
	
	// API: 
	// API Doc: https://aareguru.existenz.ch/  and https://aareguru.existenz.ch/openapi/
	// API: aareguru.existenz.ch/v2018/current
	// Req: https://aareguru.existenz.ch/v2018/current?city=bern&version=aaretemperatur4garmin&values=aare.timestamp%2Caare.temperature%2Caare.flow%2Caare.forecast2h%2Cweather.today.v.symt%2Cweather.today.n.symt%2Cweather.today.a.symt
	//const URL = "https://aareguru-test.existenz.ch/v2018/current?city=olten&version=aaretemperatur4garmin&values=aare.timestamp%2Caare.temperature%2Caare.flow%2Caare.forecast2h";

	const URL = "https://aareguru.existenz.ch/v2018/current?version=aaretemperatur4garmin&values=aare.timestamp%2Caare.temperature%2Caare.flow%2Caare.forecast2h";
	// Resp: 1624896000\n18.2\n273\n18.4
	// Resp. values: timestamp,temperature,flow,forecast2h
	var cityProperty = "bern";
	var notify = null;
	var message = "";
	var aareData = null;
	

	function initialize(handler) {
		cityProperty = getCityProperty();
		//System.println("City = " + cityProperty);
		notify = handler;
		makeAPIRequest();
	}
	
	// return string of cityProperty. E.g. "bern"
	function getCityProperty() {
		// Read property propCity and convert to string(default = "bern")
		var prop = Application.Properties.getValue("propCity");

		if (prop == 0) { return "bern";
		} else if (prop == 1) { return "biel";
		} else if (prop == 2) { return "thun";
		} else if (prop == 3) { return "brienz";
		} else if (prop == 5) { return "brugg";
		} else if (prop == 6) { return "olten";
		} else if (prop == 7) { return "hagneck";
		} else { return "bern"; 
		}
	}

    function fromJson(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}
		aareData.city = cityProperty;
		aareData.temperature = data.get("temperature").toFloat();
		aareData.flow = data.get("flow").toFloat();
		aareData.height = data.get("height").toFloat();
		aareData.timestamp = data.get("date");
		
		return aareData;
    }
    
    function fromText(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}
		aareData.city = cityProperty;
		// timestamp
		var idx = data.find("\n");
		if (idx != null) {
			aareData.timestamp = data.substring(0, idx).toLong();
			data = data.substring(idx+1, data.length());
		}
		// temperature
		idx = data.find("\n");
		if (idx != null) {
			aareData.temperature = data.substring(0, idx).toFloat();
			data = data.substring(idx+1, data.length());
		}
		// flow
		idx = data.find("\n");
		if (idx != null) {
			aareData.flow = data.substring(0, idx).toFloat();
			data = data.substring(idx+1, data.length());
			
			// forcast2h
			aareData.forecast2h = data.toFloat();		
		} else {
			// In case the station has no forecast data
			aareData.forecast2h = null;
		}
		
		return aareData;
    }
 
    
    function makeAPIRequest() {

		var url = URL + "&city=" + cityProperty;

		//Check if Communications is allowed for Widget usage
		if (Toybox has :Communications) {
			
			var params = null;
       		var options = {
         			:method => Communications.HTTP_REQUEST_METHOD_GET,
         			//:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
         			:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
         		};
         		
         	try {
         	    //System.println("AareSchwummModel Request: " + url);	
       			Communications.makeWebRequest(url, params, options, method(:onResponse));
       			
       		} catch (e) {
       			System.println("Exception during WebRequest:" + e.getErrorMessage());
       			message = "Exception";
      			notify.invoke(message);
       		}
       		
       	} else {
      		message = "no communication";
      		System.println(message);
      		notify.invoke(message);
      	}          	
    }


	function onResponse(responseCode, data) {
		//System.println("AareSchwummModel.onResponse(), Code:" + responseCode + ", data:" + data);
		
		if (responseCode == 200) {
        	//aareData = fromJson(data);
        	aareData = fromText(data);
			notify.invoke(aareData);
		
		} else { 
        	notify.invoke(responseCode);
        }
    }

    
    function getAareData() {
    	return aareData;
    }  

}