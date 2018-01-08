//bool, ObjList objs, str OUT reasonText

Building this;
str class, dest;

dest = cmdparam;
class = ParseStr(dest, dest);

this = objs[0].AsBuilding;

if (.IsValid())
	if (.settlement.IsVillage()) // when anuy village house is damages
	{
		ObjList olBuildings;
		int i;
		olBuildings = .settlement.Buildings();
		for (i=0; i<olBuildings.count;i+=1)
		{
			Building b;
			b = olBuildings[i];
			if (!b.IsValid) continue;
			if ((b.IsBroken() || b.IsVeryBroken()) && .settlement.population<GetConst("MinPopulation"))
			return false;	
		}
	}
			
if ((cmdcost_gold > .settlement.gold) || (cmdcost_food > .settlement.food) || (cmdcost_pop>0 && cmdcost_pop + GetConst("MinPopulation") > .settlement.population) )
{
	if (class!="")
		reasonText = rollover(this,class,true);
	else	
		reasonText = rollover(this,true);
	return true;
}

if (class!="")
	reasonText = rollover(this,class,true);
else	
	reasonText = rollover(this,true);
return true;
