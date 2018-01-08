//bool, Obj this, Obj other
Unit me,him;
Building bld;
me = this.AsUnit();
bld = other.AsBuilding();

if (bld.IsValid())
{
//	if (bld.settlement.IsOutpost())
//		if (bld.settlement.IsIndependent())
//			return false;

	if (me.IsValidCaptureTarget(bld))
		return me.IsEnemy(bld);
} 
else if(other.IsHeirOf("Wagon") )
{
	return me.IsEnemy(other);
}

return false; //in all other cases
