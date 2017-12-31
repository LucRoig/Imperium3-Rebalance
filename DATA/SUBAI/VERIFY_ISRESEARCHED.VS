//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
str dest, name, reason;
this = objs[0];
dest = cmdparam;

name = ParseStr(dest, dest);
reason = ParseStr(dest, dest);

if (reason == "")
{
	reason = rollover(this,false) + "\n<color 255 0 0>";
	reason = reason + Translatef("Requires %s1", name);
}
else
	reason = rollover(this,false) + "\n<color 255 0 0>" + Translatef(reason,name);

if(EnvReadString(.player, name) != "researched")
	if(this.AsBuilding.IsValid)
	{
		if(EnvReadString(this.AsBuilding.settlement, name) != "researched")
		{
			reasonText = reason;
			return false;
		}
	} else
	{
		reasonText = reason;
		return false;
	}
if(this.AsBuilding.IsValid)
	if ((cmdcost_gold > this.AsBuilding.settlement.gold) || (cmdcost_food > this.AsBuilding.settlement.food) || (cmdcost_pop>0 && cmdcost_pop + GetConst("MinPopulation")> this.AsBuilding.settlement.population) )
	{
		reasonText = rollover(this,true);
		return true;
	}

return true;
