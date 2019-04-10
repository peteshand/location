package location;

import transition.Transition;
import location.LocationCondition;

interface ILocationView
{
    var condition:LocationCondition;
    var transition:Transition;
}