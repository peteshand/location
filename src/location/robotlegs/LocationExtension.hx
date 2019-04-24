package location.robotlegs;

import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import location.Location;

class LocationExtension implements DescribedType implements IExtension
{
	public function new() { }
	
	public function extend(context:IContext):Void
	{
		context.injector.map(Location).asSingleton();
	}
}