using Toybox.WatchUi as UI;
using Toybox.System;
using Toybox.Graphics as G;

class AareView extends UI.View {

	hidden var message = "";
	var aareData = null;
	
	hidden var sAppTitle;
	hidden var sWaterLevel;
	hidden var sExCommNotAvailable;
	hidden var sServiceNotAvailable;


    function initialize() {
        sAppTitle = UI.loadResource(Rez.Strings.view_title);
        sWaterLevel = UI.loadResource(Rez.Strings.water_level);
    	sExCommNotAvailable = WatchUi.loadResource(Rez.Strings.exception_communication_not_available);
        sServiceNotAvailable = WatchUi.loadResource(Rez.Strings.exception_service_not_available);      
        UI.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // Restore the state of this View and prepare it to be shown. 
    // This includes loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
	    var width = dc.getWidth();
	    var height = dc.getHeight();

    	dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
	    dc.clear();
		dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        
	    var y = 30;
	    dc.drawText(width/2, y, G.FONT_SYSTEM_XTINY, sAppTitle, G.TEXT_JUSTIFY_CENTER);
	    y = y + G.getFontHeight(G.FONT_SYSTEM_XTINY);
        
        if (aareData != null) {

	        dc.setColor(aareData.colorOfTemperature(), G.COLOR_TRANSPARENT);
	        dc.drawText(width/2 - 10, y, G.FONT_SYSTEM_NUMBER_HOT, aareData.temperature.format("%0.1f"), G.TEXT_JUSTIFY_CENTER);
	        dc.drawText(width - 50, y + 18, G.FONT_SYSTEM_SMALL, "°C", G.TEXT_JUSTIFY_RIGHT);	        

	   		y = y + G.getFontHeight(G.FONT_SYSTEM_NUMBER_HOT);

			// Aare flow
			dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
	        //dc.drawText(width/2, y, G.FONT_SYSTEM_LARGE, aareData.flow.format("%0i")  + "m³/s", G.TEXT_JUSTIFY_CENTER);  
			dc.drawText(width/2, y, G.FONT_SYSTEM_LARGE, aareData.flowStr(), G.TEXT_JUSTIFY_CENTER);
			dc.drawText(width/2, y+ G.getFontHeight(G.FONT_SYSTEM_LARGE), G.FONT_SYSTEM_XTINY, sWaterLevel, G.TEXT_JUSTIFY_CENTER);
				        
			if (! aareData.isActual()) {
				dc.setColor(G.COLOR_ORANGE, G.COLOR_TRANSPARENT);
				dc.drawText(width/2, height - 40, G.FONT_SYSTEM_TINY, aareData.messureDate(), G.TEXT_JUSTIFY_CENTER);  			
			} else {
				if (aareData.forecast2h != 0) {
			    	dc.setColor(aareData.colorOfTemperature(), G.COLOR_TRANSPARENT);
					dc.drawText(width/2, height - 50, G.FONT_SYSTEM_TINY, aareData.forecast2h.format("%0.1f") + "°C in 2h", G.TEXT_JUSTIFY_CENTER);  
				}
			}
			        
        } else {
			dc.drawText(width/2, height/2 , G.FONT_SYSTEM_SMALL, message, G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);
        }
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    function onReceive(data) {
     	if (data instanceof AareData) {
     		aareData = data;

        } else {
        	System.println("View: Unexpeced data : " + data);
        	if (data == Communications.BLE_CONNECTION_UNAVAILABLE) {
            	message = sExCommNotAvailable;
        	} else { 
        		message = sServiceNotAvailable;
        	}
        }
        
        UI.requestUpdate();
    }


}
