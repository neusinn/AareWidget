using Toybox.WatchUi as UI;
using Toybox.System;
using Toybox.Graphics as G;

class AareView extends UI.View {

	hidden var message = "";
	var aareData = null;

    function initialize() {
     	System.println("AareView.Initialize()");
        UI.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	System.println("AareView.onLayout()");
    }

    // Called when this View is brought to the foreground. Restore
    // Restore the state of this View and prepare it to be shown. 
    // This includes loading resources into memory.
    function onShow() {
    	System.println("AareView.onShow()");
    }

    // Update the view
    function onUpdate(dc) {
    	System.println("AareView.onUpdate()" + dc);

	    var width = dc.getWidth();
	    var height = dc.getHeight();
	        	
    	dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
	    dc.clear();
		dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        
        if (aareData != null) {

	        var y = 30;
	        dc.drawText(width/2, y, G.FONT_SYSTEM_XTINY, "AARETEMPERATUR", G.TEXT_JUSTIFY_CENTER);
	        y = y + G.getFontHeight(G.FONT_SYSTEM_XTINY);
	        
	        dc.drawText(width/2 - 10, y, G.FONT_SYSTEM_NUMBER_HOT, aareData.temperature, G.TEXT_JUSTIFY_CENTER);
	        dc.drawText(width - 50, y + 18, G.FONT_SYSTEM_SMALL, "°C", G.TEXT_JUSTIFY_RIGHT);
	   		y = y + G.getFontHeight(G.FONT_SYSTEM_NUMBER_HOT) - 10;

	        dc.drawText(width/2, y, G.FONT_SYSTEM_LARGE, aareData.height + "m    " + aareData.flow  + "m/s", G.TEXT_JUSTIFY_CENTER);  
	        
			dc.drawText(width/2, height - 60, G.FONT_SYSTEM_XTINY, aareData.date, G.TEXT_JUSTIFY_CENTER);  
        
        } else {
			dc.drawText(width/2, height/2 , G.FONT_SYSTEM_SMALL, message, G.TEXT_JUSTIFY_RIGHT | G.TEXT_JUSTIFY_VCENTER);
        }      
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("AareView.onHide()");
    }

    function onReceive(data) {
    	System.println("AareViewl.onReceive()");
     	if (data instanceof AareData) {
     		aareData = data;
        }
        else if (data instanceof Lang.String) {
            System.println("Unexpeced data format: " + data);
            message = data;
        } else {
         	System.println("Unexpeced data type: " + data);
        	message = "Arghh!";
        }
        
        System.println("Do UI update");
        UI.requestUpdate();
    }
}
