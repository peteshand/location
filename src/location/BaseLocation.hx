package location;

import signals.Signal2;
import notifier.Notifier;
import delay.Delay;

/**
 * ...
 * @author P.J.Shand
 */
class BaseLocation extends Notifier<String> {
	#if js
	@:noCompletion private static function __init__() {
		untyped Object.defineProperties(BaseLocation.prototype, {
			"uri": {
				get: untyped js.Syntax.code("function () { return this.get_uri (); }"),
				set: untyped js.Syntax.code("function (v) { return this.set_uri (v); }")
			},
		});
	}
	#end

	var updateHistory:Bool = true;
	var _history = new Array<String>();
	var queueValue:String;
	var queuedUpdateHistory:Bool = true;
	var properties = new Map<String, RouteData>();

	public var queueURI:Bool = true;

	var URI = new Notifier<String>("");

	public var uri(get, set):String;
	public var uriWithoutHistory(null, set):String;
	public var previousUri(get, null):String;

	var fullPath(get, null):String;

	public function new() {
		super("");
		set("uri", URI);
	}

	public function set(property:String, notifier:Notifier<String>) {
		var routeData = properties.get(property);
		if (routeData == null) {
			routeData = new RouteData(property);
			routeData.add((key, value) -> {
				this.value = fullPath;
			});
			properties.set(property, routeData);
		}
		routeData.notifier = notifier;
	}

	function updateProp() {}

	public function get(property:String):String {
		var routeData:RouteData = properties.get(property);
		if (routeData == null)
			return null;
		return routeData.value;
	}

	function get_fullPath():String {
		var fullPath:String = "";
		for (key in properties.keys()) {
			var routeData:RouteData = properties.get(key);
			if (key == 'uri') {
				fullPath += routeData.value;
			} else if (routeData.value != null) {
				fullPath += "/" + key + "/" + routeData.value;
			}
		}
		return fullPath;
	}

	function decode() {
		if (value == null)
			return;
		var split:Array<String> = value.split("/");
		var map = new Map<String, String>();
		// uri = split[0];
		map.set("uri", split[0]);

		for (key in properties.keys()) {
			if (key == 'uri')
				continue;
			for (i in 1...split.length) {
				if (split[i] == key) {
					if (i < split.length - 1) {
						// set(key, split[i + 1]);
						map.set(key, split[i + 1]);
					}
				}
			}
		}

		for (key in properties.keys()) {
			if (!map.exists(key)) {
				// trace("Can't find " + key);
				properties.get(key).value = null;
			}
		}
		for (key => v1 in map.keyValueIterator()) {
			var routeData:RouteData = properties.get(key);
			routeData.value = v1;
		}
	}

	private function get_uri():String {
		return URI.value;
		// return get('uri');
	}

	private function set_uri(value:String):String {
		URI.value = value;
		// set('uri', value);
		return value;
	}

	override function set_value(v:Null<String>):Null<String> {
		Delay.killDelay(updateValue);
		Delay.nextFrame(updateValue, [v]);
		return v;
	}

	function updateValue(v:Null<String>):Void {
		if (!changeRequired(v))
			return;
		_value = v;
		decode();
		if (updateHistory)
			_history.push(v);
		trace("value = " + v);
		this.dispatch();
	}

	override public function silentlySet(value:String) {
		setUriWithoutUpdate(value);
	}

	public function setUriWithoutUpdate(value:String):Void {
		_value = value;
		_history.push(_value);
	}

	function set_uriWithoutHistory(value:String):String {
		updateHistory = false;
		this.uri = value;
		updateHistory = true;
		return value;
	}

	function queue(value:String, updateHistory:Bool):Void {
		queuedUpdateHistory = updateHistory;
		queueValue = value;
	}

	public function goBack(backNum:Int = 1):Void {
		if (_history.length < backNum)
			return;
		for (i in 0...backNum)
			_history.pop();
		_value = _history[_history.length - 1];
		this.dispatch();
	}

	function get_previousUri():String {
		if (_history.length > 1)
			return _history[_history.length - 2];
		else
			return "";
	}

	public function goBackUri(backNum:Int = 1):String {
		if (_history.length < backNum)
			return null;
		return _history[_history.length - 1 - backNum];
	}
}

class RouteData extends Signal2<String, String> {
	public var key:String;
	public var notifier(get, set):Notifier<String>;
	public var value(get, set):String;

	var _notifier:Notifier<String>;

	public function new(key:String) {
		this.key = key;
		super();
	}

	function get_value() {
		if (_notifier == null)
			return null;
		return _notifier.value;
	}

	function set_value(value:String) {
		if (_notifier == null)
			return value;
		return _notifier.value = value;
	}

	function get_notifier() {
		return _notifier;
	}

	function set_notifier(value:Notifier<String>) {
		if (_notifier != null) {
			_notifier.remove(updateProp);
		}
		_notifier = value;
		if (_notifier != null) {
			_notifier.add(updateProp).fireOnAdd();
		}
		return value;
	}

	function updateProp() {
		dispatch(key, notifier.value);
	}
}
