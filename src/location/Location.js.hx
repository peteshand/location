package location;

import js.Browser;

/**
 * ...
 * @author P.J.Shand
 */
class Location extends BaseLocation {
	@:isVar static public var instance(get, null):Location;

	var queryStr:Map<String, String>;

	public function new() {
		super();

		var reg = new EReg("([^?=&]+)(=([^&]*))?", "g");

		Browser.window.addEventListener('hashchange', onHashChange);
		onHashChange();

		var initialTitle:String = Browser.document.title;
		this.add(() -> {
			Browser.location.hash = "#" + this.uri;
			Browser.document.title = initialTitle + " - " + this.uri;
		});
	}

	function onHashChange(e:Dynamic = null) {
		var hash:String = Browser.location.hash.substring(1);
		if (hash.indexOf("?") != -1) {
			var split:Array<String> = hash.split("?");
			hash = split[0];
			var query:String = split[1];
			queryStr = new Map<String, String>();
			var querySplit:Array<String> = query.split("&");
			for (i in 0...querySplit.length) {
				var s:Array<String> = querySplit[i].split("=");
				if (s.length > 1)
					queryStr.set(s[0], s[1]);
				else
					queryStr.set(s[0], null);
				trace(s);
			}
		}

		this.uri = hash;
	}

	static function get_instance():Location {
		if (instance == null)
			instance = new Location();
		return instance;
	}
}
