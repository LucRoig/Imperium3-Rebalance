// void, Obj This, Obj bld

Unit this;
point pt;
Building building;

this = This.AsUnit;

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);

if (!bld.IsValid)
	return;
if (.hero.IsValid) 
	.DetachFrom(.hero);

building = bld.AsBuilding;

.SetEntering(true);
pt = building.GetEnterPoint(this);
while (bld.IsValid)
	if (.GotoEnter(pt, 0, 1000, false, 0))
		break;

//.pr("unit::enter: entering");
if (bld.IsValid)
	building.settlement.AddUnit(this);
else
	.AddCommand(false, "move", pt + Point(0, 1)); /// prevent moving all units on the same place
