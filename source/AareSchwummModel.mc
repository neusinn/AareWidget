using Toybox.Communications as Comm;

class AareData {	
	var date;
	var temperature;
	var flow;
	var height;
}

class AareSchwummModel {

	// Aareschwumm JSON API
	// See: http://aare.schwumm.ch/api/
	const URL = "http://aare.schwumm.ch/api/current";
	var aareData = null;
    
    function convert(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}	
		aareData.temperature = data.get("temperature").toFloat().format("%0.1f");
		aareData.flow = data.get("flow").toFloat().format("%0i");
		aareData.height = data.get("height").toFloat().toFloat().format("%0i");
		
		return aareData;
    }
    
    function getAareData() {
    	return aareData;
    }
}