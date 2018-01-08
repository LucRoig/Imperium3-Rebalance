// void, Obj This

Building this;
int start_time, k, l, c;
ObjList player_units;
Unit unit;
int level_limit;

this = This.AsBuilding();
if (!.IsValid()) return;

level_limit = GetConst("StonehengeWisdomLevelLimit");

PlaySound("data/Sound Entities/StonehengeSpell.xml");

Sleep(GetConst("StonehengeWisdomTime"));
for (k = 1; k <= 16; k += 1) {
	player_units = GetPlayerUnits(k);
	player_units.ClearDead();
	c = player_units.count();
	for (l = 0; l < c; l += 1) {
		unit = player_units[l].AsUnit();
		if (unit.IsAlive)
		if (unit.inherentlevel() < level_limit) {
			unit.SetLevel(unit.inherentlevel() + 1);
			CreateFeedback("Experience", unit);
		}
		if (l % 30 == 0) Sleep(10);
	}
}
