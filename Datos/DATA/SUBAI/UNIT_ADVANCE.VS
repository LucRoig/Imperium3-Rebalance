// void, Obj me, point pt

Unit this;
Obj u;

this = me.AsUnit();

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);
 
while (1) 
{
	//pr("advance: searching for new enemy");
	u = .BestTargetInSquadSight();
	if (u.IsAlive())
	if (.IsValidTarget(u))
	{
		if (u.attack > 0)	
		{
			Sleep(rand(80) + 20); // prevent cycling advance->engage->advance->...
			.AddCommand(true, "advance", pt);
			.AddCommand(true, "engage");
			return;
		}
	} 
	
	//pr("advance: no target in sight - returning to source point!");
	if (.Goto(pt, 0, 2000, true, 0)) return;
	
}
