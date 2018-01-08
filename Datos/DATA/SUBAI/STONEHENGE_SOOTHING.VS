// void, Obj This

Building this;
int it, k, l, c;
ObjList player_units;
Unit unit;
int duration, time_step;

this = This.AsBuilding();
if (!.IsValid()) return;

duration = GetConst("StonehengeSoothingTime");
time_step = GetConst("StonehengeSoothingTimeStep");

PlaySound("data/Sound Entities/StonehengeSpell.xml");

for (it = duration/time_step; it > 0; it -= 1) {
	for (k = 1; k <= 16; k += 1) {
		player_units = GetPlayerUnits(k);
		player_units.ClearDead();
		c = player_units.count();
		for (l = 0; l < c; l += 1) {
			unit = player_units[l].AsUnit();
			if (unit.stamina < unit.maxstamina) {
				unit.SetStamina(unit.maxstamina);
				CreateFeedback("StaminaBoost", unit);
			}
			if (l % 30 == 0) Sleep(10);
		}
	}
	
	Sleep(time_step);
}
