package location.robotlegs;

import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.bundles.mvcs.Mediator;

/**
* ...
* @author P.J.Shand
*/
class LocationViewMediator extends Mediator
{
    @inject public var view:ILocationView;
	//@inject public var mediatorMap:IMediatorMap;

    override public function initialize():Void
	{
        //mediatorMap.map(ViewClass).toMediator(MediatorClass);
        //view.initialize();
	}
}