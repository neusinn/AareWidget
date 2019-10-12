using Toybox.WatchUi as Ui;
using Toybox.System;

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
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        var aareData = model.getAareData();
        if (aareData != null) {
        	mMessage = Lang.format("temp  : $1$ °C", [aareData.temperature]);
        } else {
        	mMessage = "No data available...";
        }
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLUE);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("AareGlanceView.onHide()");
    }

/*
    function onReceive(data) {
    	System.println("AareGlanceView.onReceive(), data:" + data);
     	if (data instanceof AareData) {
            mMessage = Lang.format("temp  : $1$ °C", [data.temperature]);
        }
        else if (data instanceof Lang.String) {
            mMessage = data;
        }
        else if (data instanceof Dictionary) {
            mMessage = printDictionalry(data);
        }
        Ui.requestUpdate();
    }
    
    function printDictionalry(dict) {
    	var dictString = "";
    	if (dict instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = dict.keys();
            for( var i = 0; i < keys.size(); i++ ) {
                dictString += Lang.format("$1$: $2$\n", [keys[i], dict[keys[i]]]);
            }
        }
    }
*/
}
