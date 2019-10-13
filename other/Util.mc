

class Util {

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
}