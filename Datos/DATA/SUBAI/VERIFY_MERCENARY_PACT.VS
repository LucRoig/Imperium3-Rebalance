//bool, ObjList objs, str OUT reasonText

Building tavern;

tavern = objs[0].AsBuilding;

if (EnvReadString(tavern.settlement, "Free Trade") != "researched")
{
	reasonText = rollover(tavern,true) + "\n<color 255 0 0>" + Translate("Requires Free Trade");
	return false;
}

if (EnvReadString(tavern.player, "Mercenary pact") == "researched")
 {
	reasonText = rollover(this,"Already available");
	return false;
 }

if ((cmdcost_gold > tavern.settlement.gold) || (cmdcost_food > tavern.settlement.food) || (cmdcost_pop>0 && cmdcost_pop + GetConst("MinPopulation") > tavern.settlement.population) )
{
	reasonText = rollover(tavern,true);
	return true;
}

return true;