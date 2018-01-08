// void, Obj This

Unit this;
Unit u;
point ptm;
int pl;

this = This.AsUnit;
if (.InShip())
	return;//ships don't have interface for adding/removing units

while (!.Stop(1000))
	;
ptm = .pos;
pl = .player;
u = Place("IVillager", ptm, pl);
if (.InHolder()) {
	.GetHolderSett.ForceAddUnit(u);
}
.Erase();
