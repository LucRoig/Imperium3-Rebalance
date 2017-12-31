// void, Obj This

Settlement s;
ObjList ol;
Query q;
Unit u;
int i, give;
int nSleepTime = 2000;

s = This.AsBuilding().settlement;
q = ObjsInSight(This, "Unit");

Sleep(rand(nSleepTime) + 1000);

while (1)
{
	Sleep(MAX(nSleepTime, 1));
	nSleepTime = 2000;
	if (!WaitNonEmptyQuery(q, -1))
		continue;
	if (s.food == 0)
		continue;
	ol = q.GetObjList();
	ol.ClearDead();
	for (i = 0; i < ol.count; i += 1)
	{
		if (i % 40 == 39)
			{ Sleep(15); nSleepTime -= 15; }
		if (ol[i].IsDead)
			continue; // could be dead because of the above sleep
		u = ol[i].AsUnit();
		if (!DiplGetShareSupport(This.player, u.player))
			continue;
		give = 20 - u.food;
		if (give <= 0)
			continue;
		if (give > s.food)
			give = s.food;
		u.SetFood(u.food + give);
		s.SetFood(s.food - give);
	}
	ol.Clear();
}
