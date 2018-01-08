// bool, Obj this, Obj other

Building me;
Building it;

me = this.AsBuilding();
it = other.AsBuilding();

if (!me.IsValid() || !it.IsValid())
	return false;

return me.player == it.player || DiplGetShareSupport(me.player, other.player);