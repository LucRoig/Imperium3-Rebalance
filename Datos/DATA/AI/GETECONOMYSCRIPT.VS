// int, Settlement set, int idPlayer

if (set.IsVillage)
	return ES_Village;
if (set.IsStronghold)
	return ES_Stronghold;

if (set.IsOutpost)
{
	int nRace; nRace = set.GetCentralBuilding.race;
	if (set.supplied.IsValid)
	{
		if (nRace == Gaul || nRace == Germany)
			return ES_OutpostSellFood;
	}
	else
		if (set.gold >= 100 || set.food >= 100)
			return ES_OutpostSendGold;
	if (nRace == Carthage)
	{
		return ES_OutpostArmy;
	}
}

if (set.IsShipyard)
	return ES_Shipyard;

return ES_NONE;