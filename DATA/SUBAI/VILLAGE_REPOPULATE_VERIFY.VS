//bool, ObjList objs, str OUT reasonText

Building this;
str class, dest;
int minpop,i;
ObjList olBuildings;
bool bBrokenVillage;

this = objs[0].AsBuilding;
if (!.IsValid())
	return false;

minpop = GetConst("MinPopulation");

bBrokenVillage = true;
if (.settlement.population>=minpop)
	return false;
	
if (!.IsBroken() && !.IsVeryBroken())
	bBrokenVillage = false;

olBuildings = .settlement.Buildings();
for (i=0; i<olBuildings.count;i+=1)
{
	Building b;
	b = olBuildings[i];
	if (!b.IsValid) continue;
	if ((b.IsBroken() || b.IsVeryBroken()))
	  bBrokenVillage = true;	
}

if (!bBrokenVillage)
	return false;

dest = cmdparam;
class = ParseStr(dest, dest);

this = objs[0].AsBuilding;
if ((cmdcost_gold > .settlement.gold) || (cmdcost_food > .settlement.food) || (cmdcost_pop>0 && cmdcost_pop + minpop > .settlement.population) )
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
