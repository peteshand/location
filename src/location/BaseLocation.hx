package location;

import notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class BaseLocation extends Notifier<String> {
	var updateHistory:Bool = true;
	var _history = new Array<String>();
	var queueValue:String;
	var queuedUpdateHistory:Bool = true;

	public var queueURI:Bool = true;
	public var goBackUri:String;

	public var uri(get, set):String;
	public var uriWithoutHistory(null, set):String;
	public var previousUri(get, null):String;

	public function new() {
		super("");
	}

	private function get_uri():String {
		return this.value;
	}

	private function set_uri(value:String):String {
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
		if (v == "app://science/briefing/intro") {
			trace("uri = " + v);
		}
		trace("uri = " + v);
		return v;
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
