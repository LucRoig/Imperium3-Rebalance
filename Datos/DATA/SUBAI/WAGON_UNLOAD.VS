// void, Obj This, Obj Bld

Wagon this;
Building bld;
point pt;

this = This.AsWagon();
bld = Bld.AsBuilding();

.SetEntering(true);
pt = bld.GetEnterPoint(this);
while(!.GotoEnter(pt, 0, 2000, false, 2500))
{
	if (.IsEnemy(bld))
		return; /// the next command should be to return back
}

if (.restype == 1) { // food
  bld.settlement.SetFood(bld.settlement.food + .amount);
} else { // gold
  bld.settlement.SetGold(bld.settlement.gold + .amount);
}
.SetFood(0);//WTF?
.SetGold(0);
.Erase();