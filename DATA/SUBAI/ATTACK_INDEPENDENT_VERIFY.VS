//bool, Obj this, Obj other

Unit me;
Building bld;
me = this.AsUnit();
bld = other.AsBuilding();

if (bld.IsValid())
if (me.IsValid())
{
	if (bld.settlement.IsOutpost())
		if (bld.settlement.IsIndependentGuarded())
			return true;
	if (bld.settlement.IsTTent())
			return me.IsEnemy(bld);
} 
return false; //in all other cases
