// void, Obj me, Obj u

Unit this;
ObjList enemies;

this = me.AsUnit();

if (!.IsValid()) return;
if (!u.IsValid()) return;

.SetParryMode(false); // leave parry mode at new command

//.pr("unit::attack: attacking particular enemy");

if( u.AsBuilding.IsValid ) {
	Sleep(rand(400) + 200);
	if (!u.IsValid()) return; // buildings also can die (catapults)
}
if(.IsEnemy(u) || u.AsBuilding.IsValid)
{
	while(u.IsAlive() && .IsValidTarget(u))
	{
		if(!.IsEnemy(u) && !u.AsBuilding.IsValid)
			return;
		//.pr("unit::attack: going to enemy");
		if(.GotoAttack(u, 5000, true, 2500))
		{
			//.pr("unit::attack: fighting");
			while(.Attack(u));
		}
	} 
}
.AddCommand(true, "engage");