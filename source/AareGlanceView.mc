using Toybox.WatchUi as UI;
using Toybox.System;
using Toybox.Graphics as G;

(:glance)
class AareGlanceView extends UI.GlanceView {

	hidden var message = "";
	hidden var aareData = null;
	var sAppTitle;

    function initialize() {
        sAppTitle = UI.loadResource(Rez.Strings.glance_title);
        UI.GlanceView.initialize();
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
    	dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);

        if (aareData != null) {
        	if (aareData.isActual()) {
        		message = Lang.format("$1$ °C", [aareData.temperature.format("%0.1f")]);
        	} else {
        		// no actual data available
        		message = "~ n/a ~";
        	}
        
        } else {
        	// no connection
        	message = "-- x --";
        }

        dc.drawText(0, 6, G.FONT_SYSTEM_XTINY, sAppTitle, G.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 24, G.FONT_SYSTEM_TINY, message, G.TEXT_JUSTIFY_LEFT);
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
         	System.println("Unexpeced data : " + data);
        	message = "Error";
        }
        
        UI.requestUpdate();
    }
}
