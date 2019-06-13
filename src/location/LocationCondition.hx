package location;

import condition.Condition;

class LocationCondition extends Condition {
	var locations = new Condition();
	var maskLocations = new Condition();

	public function new() {
		super();
		this.add(locations.active, "==", true);
		this.add(maskLocations.active, "==", true);
	}

	public function addLocation(location:String, wildcard:Bool = false):Void {
		locations.or();
		locations.add(Location.instance, "==", location, wildcard);
	}

	public function addLocationMask(location:String, wildcard:Bool = false):Void {
		maskLocations.and();
		maskLocations.add(Location.instance, "!=", location, wildcard);
	}

	public function removeLocation(location:String):Void {
		locations.remove(Location.instance, "==", location);
	}

	public function removeLocationMask(location:String):Void {
		maskLocations.remove(Location.instance, "!=", location);
	}

	override public function clone() {
		var _clone = new LocationCondition();
		_clone.removeAll();
		copyCases(this, _clone);
		copyCases(this.locations, _clone.locations);
		copyCases(this.maskLocations, _clone.maskLocations);
		_clone.check();
		return _clone;
	}

	override function toString():String {
		var s:String = locations.toString() + "\n";
		s += numCases + " (";
		for (i in 0...cases.length) {
			s += cases[i];
			if (i < cases.length - 1)
				s += " " + cases[i].bitOperator + " ";
		}
		s += ") :: value = " + value;
		return s;
	}
}
