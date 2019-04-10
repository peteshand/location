package location.robotlegs;

import condition.IConditionView;
import condition.IConditionMediator;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import location.ILocationView;
import location.robotlegs.LocationViewMediator;

class LocationViewExtension implements DescribedType implements IExtension
{
	public function new() { }
	
	public function extend(context:IContext):Void
	{
		context.injector.map(Location).asSingleton();
		var mediatorMap:IMediatorMap = context.injector.getInstance(IMediatorMap);
		mediatorMap.map(ILocationView).toMediator(LocationViewMediator);
		mediatorMap.map(IConditionView).toMediator(IConditionMediator);
	}
}