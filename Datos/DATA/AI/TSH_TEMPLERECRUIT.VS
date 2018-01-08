//void, Settlement set, int num, ObjList ol

//BUG!!!! HACK!!!!
//BE CAREFUL NOT TO DIRECTLY ASSIGN TO ol!!!!!!!
//ol IS USED TO RETURN THE OBJECTS AND ASSIGNING TO IT WILL NOT CHANGE THE ORIGINAL LIST!!!!!!!!!
//ol MUST BE CHANGED USEING ONLY THE Add/Remove METHODS!!!!!!!!!
//BUG!!!! HACK!!!!

ObjList ol2;
ObjList oll;
Building b;
Unit u;
int i;
int nRace;
str class;
str cmd;

nRace = set.GetCentralBuilding.race;
class = TempleUType(nRace);
cmd = TempleUTrain(nRace);

if (num)
{
	//steal from the AI
	oll = GetGAIKA(set.GetCentralBuilding).GetAIControlledUnits(class, set.player, num, true);
	for (i = 0; i < oll.count; i += 1)
	{
		u = oll[i].AsUnit;
		if (u.IsAlive)
		{
			if (u.hero.IsValid)
			{
				u.DetachFrom(u.hero);
			}
			ol2.Add(u);
		}
	}
	num -= ol2.count;
}

if (num)
{
	//count how many are queued
	ObjList temples;
	temples = set.TSGetAllTemples();
	for (i = 0; i < temples.count; i+=1)
	{
		num -= temples[i].CmdCount(cmd);
	}
}

//issue commands
if (num)
{
	for (i = 0; i < num; i+=1)
	{
		int gold, food;
		
		b = set.BestTemple();
		if (b.IsValid())
		{
			if (GetCmdCost(cmd, gold, food))
			{
				point ptDummy;
				Obj objDummy;
				if (set.gold < gold || set.food < food)
					break;
				set.SpentGoldOnArmy((gold + (food / 2)) * i);
				b.ExecCmd(cmd, ptDummy, objDummy, false);
			}
		}
	}
}

SetNoAIFlag(ol2, true);
ol.AddList(ol2);
