//bool, ObjList objs, str OUT reasonText

str strUnit, cdrCmdParam;
bool bResearched;

strUnit = ParseStr(cmdparam, cdrCmdParam);
bResearched = EnvReadString(objs[0].AsBuilding.settlement, strUnit) == "researched";

if( cdrCmdParam == "spec" )
{
	if (bResearched)
		if(objs[0].AsBuilding) 
			if ((cmdcost_gold > objs[0].AsBuilding.settlement.gold) || (cmdcost_food > objs[0].AsBuilding.settlement.food) || (cmdcost_pop > objs[0].AsBuilding.settlement.population) )
			{
				reasonText = rollover(objs[0].AsBuilding(),strUnit,true);
				return bResearched;
			}
			else
			  reasonText = rollover(objs[0].AsBuilding(),strUnit,true);
	return bResearched;
}

if( cdrCmdParam == "non-spec" )
{
	if (!bResearched)
		if(objs[0].AsBuilding) 
			if ((cmdcost_gold > objs[0].AsBuilding.settlement.gold) || (cmdcost_food > objs[0].AsBuilding.settlement.food) || (cmdcost_pop>0 && cmdcost_pop + GetConst("MinPopulation") > objs[0].AsBuilding.settlement.population) )
			{
				reasonText = rollover(objs[0].AsBuilding(),strUnit,true);
				return !bResearched;
			}
			else
			  reasonText = rollover(objs[0].AsBuilding(),strUnit,true);
			 
	return !bResearched;
}

reasonText = "Invalid command param : " + cmdparam;
return true;
