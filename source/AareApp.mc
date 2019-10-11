using Toybox.Application;
using Toybox.System;

class AareApp extends Application.AppBase {

    hidden var View;
    hidden var Model;
    hidden var Delegate;

    function initialize() {
      	System.println("AareApp.initalize()");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	System.println("AareApp.onStart()");
    	View = new AareView();
		//Model = new AareGuruModel();
		Model = new AareSchwummModel();
		Delegate = new WebRequestDelegate(View.method(:onReceive), Model);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	System.println("AareApp.onStop()");
    }

    // Return the initial view of your application here
    function getInitialView() {
    	System.println("AareApp.getInitialView()");
        return [ View ,Delegate ];
    }

}