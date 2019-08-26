package location;

import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class BaseLocation extends Notifier<String> {
	#if js
	@:noCompletion private static function __init__() {
		untyped Object.defineProperties(BaseLocation.prototype, {
			"uri": {
				get: untyped __js__("function () { return this.get_uri (); }"),
				set: untyped __js__("function (v) { return this.set_uri (v); }")
			},
		});
	}
	#end

	var updateHistory:Bool = true;
	var _history = new Array<String>();
	var queueValue:String;
	var queuedUpdateHistory:Bool = true;
	var modifiers:Array<String->String> = [];

	public var queueURI:Bool = true;
	public var goBackUri:String;

	public var uri(get, set):String;
	public var uriWithoutHistory(null, set):String;
	public var previousUri(get, null):String;

	public function new() {
		super("");
	}

	public function addModifier(modifier:String->String) {
		modifiers.push(modifier);
	}

	private function get_uri():String {
		return this.value;
	}

	private function set_uri(value:String):String {
		for (modifier in modifiers) {
			value = modifier(value);
		}
		return this.value = value;
	}

	override function set_value(v:Null<String>):Null<String> {
		if (!changeRequired(v))
			return v;
		goBackUri = null;
		_value = v;
		if (updateHistory)
			_history.push(v);
		this.dispatch();
		if (v == "app://teacherLogin/") {
			trace("uri = " + v);
		}
		trace("uri = " + v);
		return v;
	}

	override public function silentlySet(value:String) {
		setUriWithoutUpdate(value);
	}

	public function setUriWithoutUpdate(value:String):Void {
		goBackUri = _value;
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
		goBackUri = _value;
		for (i in 0...backNum)
			_history.pop();
		value = _history[_history.length - 1];
	}

	function get_previousUri():String {
		if (_history.length > 1)
			return _history[_history.length - 2];
		else
			return "";
	}
}
