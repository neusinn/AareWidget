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
	var message = "";
	
    
    function convert(data) {
   		if (aareData == null) {
        	aareData = new AareData();
		}	
		aareData.temperature = data.get("temperature").toFloat().format("%0.1f");
		aareData.flow = data.get("flow").toFloat().format("%0i");
		aareData.height = data.get("height").toFloat().toFloat().format("%0i");
		aareData.date = data.get("date");
		
		return aareData;
    }
    
    function onReceive(data) {
    	System.println("AareSchwummModel.onReceive()");
     	if (data instanceof Dictionary) {
     		aareData = convert(data);
        }
        else if (data instanceof Lang.String) {
            System.println("Unexpeced data format: " + data);
            message = data;
        } else {
         	System.println("Unexpeced data type: " + data);
        	message = "Arghh!";
        }
        
        System.println("Do UI update");
        WatchUi.requestUpdate();
    }
    
    function getAareData() {
    	return aareData;
    }    
    
}