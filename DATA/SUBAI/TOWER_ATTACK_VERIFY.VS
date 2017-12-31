//bool, Obj this, Obj other

Settlement sett; 
sett = .AsBuilding().settlement();

if (sett.IsOutpost() && sett.IsIndependent)
{
	return false;
}

if (sett.UnitsCount() == 0) {
	return false;
}
if (this.IsValidTarget(other) && other.IsAlive()) {
	return .CanAttack(other);
}
return false;