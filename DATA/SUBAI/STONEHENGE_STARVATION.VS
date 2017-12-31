// void, Obj This

Building this;
int k, l, c, food;
ObjList things;
Settlement settle;
Wagon wagon;
int duration, time_step, percent, additional, it;

this = This.AsBuilding();
if (!.IsValid()) return;

duration = GetConst("StonehengeStarvationTime");
time_step = GetConst("StonehengeStarvationTimeStep");
percent = GetConst("StonehengeStarvationPercentFood");
additional = GetConst("StonehengeStarvationAdditionalFood");

PlaySound("data/Sound Entities/StonehengeSpell.xml");

for (it = duration/time_step; it > 0; it -= 1) {

	things = GetSettlements("Building", 0);
	c = things.count();
	for (l = 0; l < c; l += 1) {
		settle = things[l].AsBuilding().settlement();
		food = settle.food * (100 - percent) / 100 - additional;
		if (food < 0) food = 0;
		settle.SetFood(food);
		if (l % 30 == 0) Sleep(10);
	}

	for (k = 1; k <= 16; k += 1) {
		things = GetPlayerUnits(k, "Wagon");
		things.ClearDead();
		c = things.count();
		for (l = 0; l < c; l += 1) {
			wagon = things[l].AsWagon();
			if (wagon.restype() != 1) continue;
			food = wagon.amount * (100 - percent) / 100 - additional;
			if (food < 0) food = 0;
			wagon.SetFood(food);
			if (l % 30 == 0) Sleep(10);
		}
	}

	Sleep(time_step);
}
