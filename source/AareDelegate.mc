using Toybox.Communications;
using Toybox.WatchUi as UI;

(:glance)
class AareDelegate extends UI.BehaviorDelegate {
    
    var model;
    
        // Set up the callback to the view
    function initialize(model) {
    	self.model = model;
        UI.BehaviorDelegate.initialize();
    }
    
    function onSelect() {
    	// update data
        model.makeAPIRequest();
        return true;
    }


}