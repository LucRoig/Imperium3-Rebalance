//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_PlayerTowns;

Sleep(150000);
nExit = 0;
while(nExit < 1 )
{
	Sleep(15000);
	OL_PlayerTowns = ClassPlayerObjs(cBaseTownhall, 1 ).GetObjList();
	for(nCount = 0; nCount < OL_PlayerTowns.count; nCount += 1 )
	{
		if( (OL_PlayerTowns[nCount].AsBuilding().settlement.max_population / 3 ) >= OL_PlayerTowns[nCount].AsBuilding().settlement.population )
		{
			obj = OL_PlayerTowns[nCount];
			ShowHint(
				Translate("Town population"),
				Translate("The more population your towns have, the more resources they produce. Do not let your population decrease too much! To increase your town population you could call peasants from your tavern (or marketplace) or bring in villagers from other villages and place them in the townhall."),
				obj);
			nExit += 1;
			break;
		}
	}
}