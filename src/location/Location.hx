package location;

/**
 * ...
 * @author P.J.Shand
 */
class Location extends BaseLocation
{
	@:isVar static public var instance(get, null):Location;
	public function new() {
		super();
	}

	static function get_instance():Location
	{
		if (instance == null) instance = new Location();
		return instance;
	}
}