using Toybox.Application;
using Toybox.System;

class AareApp extends Application.AppBase {

    hidden var View;
    hidden var Model;
    hidden var Delegate;
    hidden var GlanceView;

    function initialize() {
      	System.println("AareApp.initalize()");
        AppBase.initialize();
    }
    
    // onStart() is called on application start up
    function onStart(state) {
    	System.println("AareApp.onStart()");
		//Model = new AareGuruModel();	
		Model = new AareSchwummModel();
		Delegate = new WebRequestDelegate(Model.method(:onReceive), Model.URL);
		View = new AareView(Model);
    	GlanceView = new AareGlanceView(Model);
		
		Delegate.makeAPIRequest();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	System.println("AareApp.onStop()");
    }

	// Return the initial glance view of your widget here
    function getGlanceView() {
    	System.println("AareApp.getGlanceView()");
    	return [ GlanceView ];
    }
    
    // Return the initial view of your application here
    function getInitialView() {
    	System.println("AareApp.getInitialView()");
        return [ View, Delegate ];
    }
   

}