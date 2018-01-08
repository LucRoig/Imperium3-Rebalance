//void, int playerid

Obj obj;
int nCount, nExit;
Query Q_Ships;
ObjList OL_Shipyards;
IntArray nA_ShipyardStatus;

Sleep(600000);
nExit = 0;
for(nCount = 1; nCount < 17; nCount += 1 )
{
	OL_Shipyards.AddList(GetSettlements(cBaseShipyard, nCount ) );
}
for(nCount = 0; nCount < OL_Shipyards.count; nCount += 1 )
{
	nA_ShipyardStatus[nCount] = 0;
}

while(nExit < 1 )
{
	Sleep(60000);
	Q_Ships = Union( ClassPlayerObjs(cShipL, playerid ), ClassPlayerObjs(cShipS, playerid ) );
	if(!Q_Ships.IsEmpty() )
	{
		nExit += 1;
	}
	for(nCount = 0; nCount < OL_Shipyards.count; nCount += 1 )
	{
		if(OL_Shipyards[nCount].player == playerid )
		{
			nA_ShipyardStatus[nCount] += 1;
		}
		if(nA_ShipyardStatus[nCount] > 4 )
		{
			obj = OL_Shipyards[nCount];
			ShowHint(
				Translate("Building ships"),
				Translate("Use your shipyards to produce ships that can transport resources and units. There are two types of vessels - ships and boats. Boats are used solely for transporting food or gold and require that the resources in question be present at the shipyard. Ships are used for sea and coastal combat as well as transporting armies over water. The more crew a ship has the greater the speed at which it could fire at its target."),
				obj);
			nExit += 1;
			break;
		}
	}
}