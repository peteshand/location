package location;

import condition.Condition;

class LocationCondition extends Condition
{
	var locations = new Condition();

	public function new() 
	{
		super();
		this.add(locations.active, true);
	}

	public function addLocation(location:String, wildcard:Bool=false):Void 
	{
		locations.or();
		locations.add(Location.instance, "==", location, wildcard);
	}
	
	public function addLocationMask(location:String, wildcard:Bool=false):Void 
	{
		locations.or();
		locations.add(Location.instance, "!=", location, wildcard);
	}
	
	public function removeLocation(location:String):Void
	{
        	locations.remove(Location.instance, "==", location);
	}
	
	public function removeLocationMask(location:String):Void
	{
        	locations.remove(Location.instance, "!=", location);
	}
}