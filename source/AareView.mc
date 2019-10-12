using Toybox.WatchUi as Ui;
using Toybox.System;

class AareView extends Ui.View {

	hidden var model;
	hidden var mMessage = "";

    function initialize(model) {
     	System.println("AareGlanceView.Initialize()");
     	self.model = model;
        Ui.View.initialize();
    }


    // Load your resources here
    function onLayout(dc) {
    	System.println("AareView.onLayout()");
    	//mMessage = "Press menu or\nselect button";
        //setLayout(Rez.Layouts.MainLayout(dc)); //?
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
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        var aareData = model.getAareData();
        if (aareData != null) {
        	mMessage = Lang.format("temp  : $1$ °C\nheight: $2$ m\nflow  : $3$ m/s", [aareData.temperature, aareData.height, aareData.flow]);
        } else {
        	mMessage = "Loading...";
        }
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLUE);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("AareView.onHide()");
    }

}
