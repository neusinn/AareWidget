using Toybox.Application;
using Toybox.System;

class AareApp extends Application.AppBase {

    hidden var mView;
    hidden var mModel;
    hidden var mDelegate;
    hidden var mGlanceView;

    function initialize() {
      	System.println("AareApp.initalize()");
        AppBase.initialize();
    }
    
    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

	// Return the initial glance view of your widget here
	(:glance)
    function getGlanceView() {
    	mGlanceView = new AareGlanceView();
    	mModel = new AareSchwummModel(mGlanceView.method(:onReceive));
    	mDelegate = new AareDelegate(mModel);
    	return [ mGlanceView];
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mView = new AareView();
    	mModel = new AareSchwummModel(mView.method(:onReceive));
    	mDelegate = new AareDelegate(mModel);
        return [ mView, mDelegate ];
    }
   

}