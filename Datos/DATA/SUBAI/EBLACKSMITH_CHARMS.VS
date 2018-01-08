// void, Obj This 
// Add item that is specified in cmdparam to up to max-units friendly units without it around the townhall

Building bld;
Settlement this;
int max_units;
str charmitem;

EnvWriteString(This.AsBuilding, "researching", "yes");

This.Progress();

EnvWriteString(This.AsBuilding, "researching", "no");

max_units = 50;
charmitem = cmdparam;
bld = This.AsBuilding();
if (bld.IsValid) {
	this = bld.settlement;
	if (.IsValid) {
		ObjList l;
		int i;
		Unit u;

		l = .ObjectsAround("Military");
		for (i = l.count; i > 0;) {
			i -= 1;
			u = l[i].AsUnit();
			if (u.AsHero()) continue;
			if (!bld.IsEnemy(u) && max_units>0 && !u.HasItem(charmitem) && !u.IsHeirOf("Sentry")) {
				u.AddItem(charmitem);
				max_units-=1;
			}
		}	
	}
}
