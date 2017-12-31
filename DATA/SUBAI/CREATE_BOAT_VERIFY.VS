//bool, ObjList objs, str OUT reasonText

if(objs.count)
{
	Building bld;
	bld = objs[0].AsBuilding();
	if(bld.IsValid)
	{
		int nRace;
		Settlement this;
		nRace = GetPlayerRace(bld.player);
		if (nRace!=-1)
		{
			if ((nRace==RepublicanRome || nRace==ImperialRome) && cmdparam!="ShipRome")
				return false;
			if (nRace==Egypt && cmdparam!="ShipEgypt")
				return false;
			if (nRace!=Egypt &&  nRace!=RepublicanRome && nRace!=ImperialRome && cmdparam!="ShipL")
				return false;				
		}
		this = bld.settlement;			
		if(.IsValid)
		{
			if(.gold < cmdcost_gold)
			{
				reasonText = rollover(bld,true);
				return true;
			}
		}
	}
}
return true;