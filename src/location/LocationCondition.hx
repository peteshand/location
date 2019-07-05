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
		copyCases(this, _clone, 2);
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
		s += "locations.active = " + locations.active + "\n\n";
		s += "maskLocations.active = " + maskLocations.active + "\n\n";
		this.check();
		s += "this.active = " + this.active + "\n\n";
		s += "this.cases.length = " + this.cases.length + "\n\n";
		
		return s;
	}
}
