package location.robotlegs;

import robotlegs.bender.extensions.modelMap.api.IModelMap;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import location.Location;

class LocationExtension implements DescribedType implements IExtension {
	public function new() {}

	public function extend(context:IContext):Void {
		var modelMap:IModelMap = context.injector.getInstance(IModelMap);
		if (modelMap == null) {
			context.injector.map(Location).toValue(Location.instance);
		} else {
			modelMap.map(Location, "scene").toValue(Location.instance);
		}
	}
}
