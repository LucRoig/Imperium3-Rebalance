// void, Obj This

Building this;
int it, k, l, c;
ObjList player_units;
Unit unit;
int duration, time_step, damage;

this = This.AsBuilding();
if (!.IsValid()) return;

duration = GetConst("StonehengeSacrificeTime");
time_step = GetConst("StonehengeSacrificeTimeStep");
damage = GetConst("StonehengeSacrificeDamage");

PlaySound("data/Sound Entities/StonehengeSpell.xml");

for (it = duration/time_step; it > 0; it -= 1) {
	for (k = 1; k <= 16; k += 1) {
		player_units = GetPlayerUnits(k, "BaseMage");
		player_units.ClearDead();
		c = player_units.count();
		for (l = 0; l < c; l += 1) {
			player_units[l].AsUnit().Damage(damage);
			if (l % 30 == 0) Sleep(10);
		}
	}
	
	Sleep(time_step);
}
