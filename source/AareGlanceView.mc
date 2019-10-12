using Toybox.WatchUi as UI;
using Toybox.System;
using Toybox.Graphics as G;

(:glance)
class AareGlanceView extends UI.GlanceView {

	hidden var mMessage = "";
	hidden var aareData = null;

    function initialize() {
     	System.println("AareGlanceView.Initialize()");
        UI.GlanceView.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	System.println("AareGlanceView.onLayout()");
    }

    // Called when this View is brought to the foreground. Restore
    // Restore the state of this View and prepare it to be shown. 
    // This includes loading resources into memory.
    function onShow() {
    	System.println("AareGlanceView.onShow()");
    }

    // Update the view
    function onUpdate(dc) {
    	System.println("AareGlanceView.onUpdate()" + dc);
    	
    	dc.setColor(G.COLOR_BLUE, G.COLOR_TRANSPARENT);

        if (aareData != null) {
        	mMessage = Lang.format("$1$ °C", [aareData.temperature]);
        
        } else {
        	mMessage = "Not vailable...";
        }

        dc.drawText(0, 6, G.FONT_SYSTEM_XTINY, "AARETEMPERATUR", G.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 24, G.FONT_SYSTEM_TINY, mMessage, G.TEXT_JUSTIFY_LEFT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("AareGlanceView.onHide()");
    }

    function onReceive(data) {
    	System.println("AareView.onReceive()");
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
