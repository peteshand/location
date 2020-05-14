package location;

import condition.Condition;

class LocationCondition extends Condition {
	var locations = new Condition();
	var maskLocations = new Condition();

	public function new() {
		super([locations, maskLocations], () -> {
			return locations.value == true && maskLocations.value == true;
		});
	}

	public function addLocation(location:String, wildcard:Bool = false):Void {
		if (wildcard) {
			locations.or(Condition.make(Location.instance.uri != null && Location.instance.uri.indexOf(location) != -1));
		} else {
			locations.or(Condition.make(Location.instance.uri == location));
		}
		locations.currentCase.debug = location;
	}

	public function addLocationMask(location:String, wildcard:Bool = false):Void {
		if (wildcard) {
			maskLocations.and(Condition.make(Location.instance.uri != null && Location.instance.uri.indexOf(location) == -1));
		} else {
			maskLocations.and(Condition.make(Location.instance.uri != location));
		}
	}

	override public function clone() {
		var _clone = new LocationCondition();
		copyCases(this, _clone);
		copyCases(this.locations, _clone.locations);
		copyCases(this.maskLocations, _clone.maskLocations);
		_clone.check();
		return _clone;
	}

	override function toString():String {
		var s:String = "\n";
		s += locations.toString() + "\n\n";
		s += maskLocations.toString() + "\n\n";
		s += super.toString() + "\n\n";

		s += "locations.value = " + locations.value + "\n\n";
		s += "maskLocations.value = " + maskLocations.value + "\n\n";
		s += "locations = " + locations + "\n\n";
		s += "maskLocations = " + maskLocations + "\n\n";
		this.check();
		s += "this.value = " + this.value + "\n\n";
		s += "this.cases.length = " + this.cases.length + "\n\n";

		return s;
	}
}
