//void, Obj attached

Unit u;

if (rand(1000) > 100)
	return;
if(attached.AsUnit.InHolder)
	return;

u = Place("GGhost", attached.pos, attached.player);
u.SetStamina(5);
u.SetLevel(attached.AsUnit.level);
u.SetCommand("spawn");
SwapSelectedObj(attached, u);
