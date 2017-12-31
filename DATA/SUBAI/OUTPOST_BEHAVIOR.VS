// void, Obj This

Building this;
Query qRange, qEnemies, qFriends;
ObjList olAll1,olAll2, olDefendersOut1,olDefendersOut2, olOurDefenders;
int i;
point p;
rect rc;
int old_level_1,old_level_2, end_level_1, end_level_2;
int beg_time_1,beg_time_2,time, interval_1, interval_2; //Set new level time
bool bNoMore1, bNoMore2;

//constants
int nDefendersMax1,	//how much units from cls1 to spawn at max
	nDefendersMax2,	//how much units  from cls1  to spawn at max
	nDefendersOut1,	//how much units to keep outside if an enemy comes
	nDefendersOut2;	//how much units to keep outside if an enemy comes
int nFoodIn;

str sDefenderCls1,sDefenderCls2;// defender classes

int old_player;

this = This.AsBuilding();

Sleep(rand(1000) + 500);

if (!.settlement.IsIndependent())
  {
	Sleep(33791);
	return;
  }

sDefenderCls1 = .GetDefenderCls(1);
sDefenderCls2 = .GetDefenderCls(2);
nFoodIn = .GetOutpostFood();

nDefendersMax1 = .GetDefendersMax(1);
nDefendersMax2 = .GetDefendersMax(2);

nDefendersOut1 = .GetDefendersOut(1);
nDefendersOut2 = .GetDefendersOut(2);

rc = GetMapRect();

qRange = ObjsInRange(this, "Unit", .range);
qEnemies = Intersect(qRange, Union(EnemyObjs(.player, "Military"),EnemyObjs(.player, "BaseMage")));
qEnemies = Subtract(qEnemies,EnemyObjs(.player, "Sentry"));
qFriends = Intersect(qRange, ClassPlayerObjs("Military", .player));

qRange = ObjsInRange(this, "Building", .range);
qRange = Intersect(qRange,EnemyObjs(.player, "Catapult"));
qEnemies = Union(qEnemies, qRange);

old_player = .player;

.settlement.SetLoyalty(100); //will not be able to capture it the normal way

//---------------[ main loop ]------------------------------------

end_level_1 = .GetEndLevel(1);
end_level_2 = .GetEndLevel(2);

old_level_1 = .GetStartLevel(1);
old_level_2 = .GetStartLevel(2);

if (end_level_1 != old_level_1)
  interval_1 = 3600000 / (end_level_1 - old_level_1);
else
  interval_1 = 0;
  
if (end_level_2 != old_level_2)
  interval_2 = 3600000 / (end_level_2 - old_level_2);
else
  interval_2 = 0;

beg_time_1 = GetTime();
beg_time_2 = beg_time_1;
time = beg_time_1;

if (sDefenderCls1!="")
	for (i=0;i<nDefendersMax1; i+=1)
	{
		Unit u1;
		u1 = Place(sDefenderCls1, .pos, .player);
		.settlement.ForceAddUnit(u1);
		u1.SetFood(20);
		u1.SetFeeding( false );
		u1.SetLevel(old_level_1);
		olAll1.Add(u1);
	}
if (sDefenderCls2!="")
	for (i=0;i<nDefendersMax2; i+=1)
	{
		Unit u2;
		u2 = Place(sDefenderCls2, .pos, .player);
		.settlement.ForceAddUnit(u2);
		u2.SetFood(20);
		u2.SetFeeding( false );
		u2.SetLevel(old_level_2);
		olAll2.Add(u2);
	}

while (1) {
	// respawn
	olAll1.ClearDead();
	olAll2.ClearDead();
	olDefendersOut1.ClearDead();
	olDefendersOut2.ClearDead();
	
	// clear the units that were commanded from our list
	for (i = olDefendersOut1.count - 1; i >= 0; i -= 1)
		if (olDefendersOut1[i].AsUnit().GetCommanded())
			olDefendersOut1.Remove(olDefendersOut1[i]);
	for (i = olDefendersOut2.count - 1; i >= 0; i -= 1)
		if (olDefendersOut2[i].AsUnit().GetCommanded())
			olDefendersOut2.Remove(olDefendersOut2[i]);
			
	//increase level
    time = GetTime();
	olOurDefenders = .settlement.Units();
    if (interval_1>0 && (time - beg_time_1) >= interval_1 && (old_level_1+1)<=end_level_1) // set new level
    {
		Unit u;
		beg_time_1 = time;
		old_level_1+=1;
		for (i = olDefendersOut1.count() - 1; i >= 0; i -= 1) 
		{
			if (!olDefendersOut1[i].IsValid)
				continue;
			u = olDefendersOut1[i];
			if (u.inherentlevel<old_level_1)
				u.SetLevel(old_level_1);
		}
		for (i = olOurDefenders.count() - 1; i >= 0; i -= 1) 
		{
			if (!olOurDefenders[i].IsValid)
				continue;
			u = olOurDefenders[i];
			if (u.IsHeirOf(sDefenderCls1))
				if (u.inherentlevel<old_level_1)
					u.SetLevel(old_level_1);
		}
	}
	
    if (interval_2>0 &&(time - beg_time_2) >= interval_2 && (old_level_2+1)<=end_level_2) // set new level
    {
		Unit u;
		beg_time_2 = time;
		old_level_2+=1;
		for (i = olDefendersOut2.count() - 1; i >= 0; i -= 1) 
		{
			if (!olDefendersOut2[i].IsValid)
				continue;
			u = olDefendersOut2[i];
			if (u.inherentlevel<old_level_2)
				u.SetLevel(old_level_2);
		}
		for (i = olOurDefenders.count() - 1; i >= 0; i -= 1) 
		{
			if (!olOurDefenders[i].IsValid)
				continue;
			u = olOurDefenders[i];
			if (u.IsHeirOf(sDefenderCls2))
				if (u.inherentlevel<old_level_2)
					u.SetLevel(old_level_2);
		}
	}

	if (qEnemies.IsEmpty()) { // no threat around
		// command all that are out to come back in		
		for (i = 0; i < olDefendersOut1.count; i += 1)
			olDefendersOut1[i].SetCommand("enter_tent", this); //force add even though the tent does not allow units inside
		olDefendersOut1.Clear();

		for (i = 0; i < olDefendersOut2.count; i += 1)
			olDefendersOut2[i].SetCommand("enter_tent", this); //force add even though the tent does not allow units inside
		olDefendersOut2.Clear();
		
	} else {
		// do not allow our teutons to wander too far
		for (i = 0; i < olDefendersOut1.count; i += 1) 
		{
			Unit u;
			u = olDefendersOut1[i].AsUnit();
			if (.DistTo(u) > .range)  // move to closer random position
			{	
				point pos;
				pos = u.pos - .pos;
				pos.SetLen(.range / 2);
				p = pos + .pos; p.IntoRect(rc);	u.SetCommand("move", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
			}
		}
		for (i = 0; i < olDefendersOut2.count; i += 1) 
		{
			Unit u;
			u = olDefendersOut2[i].AsUnit();
			if (.DistTo(u) > .range)  // move to closer random position
			{	
				point pos;
				pos = u.pos - .pos;
				pos.SetLen(.range / 2);
				p = pos + .pos; p.IntoRect(rc);	u.SetCommand("move", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
				pos.Rot(90);	p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
			}
		}

		// get out more units if needed
        bNoMore1 = false;
        olDefendersOut1.ClearDead();
		while (olDefendersOut1.count < nDefendersOut1 && .settlement.UnitsCount() > 0 && !bNoMore1) 
		{
			point pos;
			Unit u;
			ObjList olSettUnits;
			
			olSettUnits = .settlement.Units();
			for (i=0; i<olSettUnits.count; i+=1)
	           {
				  if (olSettUnits[i].IsHeirOf(sDefenderCls1) && olDefendersOut1.count < nDefendersOut1)		
					{
						u = olSettUnits[i];
						olDefendersOut1.Add(u);
						pos.Set(0, .range / 2);
						pos.Rot(rand(360));	p = pos + .pos; p.IntoRect(rc);	u.SetCommand("guardadvance", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						bNoMore1 = false;
						Sleep(200);						
						break;
					}
					bNoMore1 = true;
	           }
		}

        bNoMore2 = false;
        olDefendersOut2.ClearDead();
		while (olDefendersOut2.count < nDefendersOut2 && .settlement.UnitsCount() > 0 && !bNoMore2) 
		{
			point pos;
			Unit u;
			ObjList olSettUnits;
			
			olSettUnits = .settlement.Units();
			for (i=0; i<olSettUnits.count; i+=1)
	           {
				  if (olSettUnits[i].IsHeirOf(sDefenderCls2)&& olDefendersOut2.count < nDefendersOut2)		
					{
						u = olSettUnits[i];
						
						olDefendersOut2.Add(u);
						pos.Set(0, .range / 2);
						pos.Rot(rand(360));	p = pos + .pos; p.IntoRect(rc);	u.SetCommand("guardadvance", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						pos.Rot(90);		p = pos + .pos; p.IntoRect(rc);	u.AddCommand(false, "guardpatrol", p);
						bNoMore2 = false;
						Sleep(200);						
						break;
					}
					bNoMore2 = true;
	           }
		}
		
		// handle the capturing
		qRange = ObjsInRange(this, "Unit", .range);
		qEnemies = Intersect(qRange, Union(EnemyObjs(.player, "Military"),EnemyObjs(.player, "BaseMage")));
		qEnemies = Subtract(qEnemies,EnemyObjs(.player, "Sentry"));
		qFriends = Intersect(qRange, ClassPlayerObjs("Military", .player));
		
		qRange = ObjsInRange(this, "Building", .range);
		qRange = Intersect(qRange,EnemyObjs(.player, "Catapult"));
		qEnemies = Union(qEnemies, qRange);

		olDefendersOut1.ClearDead();		
		olDefendersOut2.ClearDead();		
		olAll1.ClearDead();
		olAll2.ClearDead();
		if (!qEnemies.IsEmpty() && olAll1.count==0 && olAll2.count==0 && olDefendersOut1.count == 0 && olDefendersOut2.count == 0 && .settlement.UnitsCount()==0) 
		{
			qEnemies.GetObjList().ClearDead();
			if (qEnemies.GetObjList().count>0)
			  {
				int new_player;
				new_player = qEnemies.GetObjList()[rand(qEnemies.GetObjList().count)].player;
				if (new_player>8)
				  {
					Sleep(10);
					continue;
				  }
				.SetPlayer(new_player);
				.settlement.SetFood(nFoodIn);
				if (.race==Carthage) // spwan 20 villagers
				{
					Unit u1;
					int i;
					for(i=0; i<20; i+=1)
					{
						u1 = Place("CVillager", .pos, new_player);
						u1.SetFood(u1.maxfood);
						.settlement.ForceAddUnit(u1);
					}
				}
			  }
			  
			// redefine enemies and friends
			qRange = ObjsInRange(this, "Unit", .range);
			qEnemies = Intersect(qRange, Union(EnemyObjs(.player, "Military"),EnemyObjs(.player, "BaseMage")));
			qEnemies = Subtract(qEnemies,EnemyObjs(.player, "Sentry"));
			qFriends = Intersect(qRange, ClassPlayerObjs("Military", .player));
			
			qRange = ObjsInRange(this, "Building", .range);
			qRange = Intersect(qRange,EnemyObjs(.player, "Catapult"));
			qEnemies = Union(qEnemies, qRange);
			if (old_player!=.player)
			   {		
				old_player = .player;
				return;
			   }
			   
		}
		if (old_player != .player) {
			// redefine enemies and friends
			qRange = ObjsInRange(this, "Unit", .range);
			qEnemies = Intersect(qRange, Union(EnemyObjs(.player, "Military"),EnemyObjs(.player, "BaseMage")));
			qEnemies = Subtract(qEnemies,EnemyObjs(.player, "Sentry"));
			qFriends = Intersect(qRange, ClassPlayerObjs("Military", .player));
			
			qRange = ObjsInRange(this, "Building", .range);
			qRange = Intersect(qRange,EnemyObjs(.player, "Catapult"));
			qEnemies = Union(qEnemies, qRange);
			old_player = .player;
			
			return;
		}
	}
	Sleep(1000);
}
