using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Graphics as G;


class AareGlanceView extends Ui.GlanceView {

	hidden var mMessage = "";
	hidden var model;

    function initialize(model) {
     	System.println("AareGlanceView.Initialize()");
     	self.model = model;
        Ui.GlanceView.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	System.println("AareGlanceView.onLayout()");
    	mMessage = "Aaretempertur";
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

        var aareData = model.getAareData();
        if (aareData != null) {
        	mMessage = Lang.format("$1$ °C", [aareData.temperature]);
        } else {
        	mMessage = "Not vailable...";
        }
        dc.setColor(G.COLOR_BLUE, G.COLOR_TRANSPARENT);

        dc.drawText(0, 6, G.FONT_SYSTEM_XTINY, "AARETEMPERATUR", G.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 24, G.FONT_SYSTEM_TINY, mMessage, G.TEXT_JUSTIFY_LEFT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("AareGlanceView.onHide()");
    }

}
