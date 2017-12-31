//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_PlayerVillages;

Sleep(200000 );
nExit = 0;
while(nExit < 1 )
{
	Sleep(15000);
	OL_PlayerVillages = ClassPlayerObjs(cBaseVillage, 1 ).GetObjList();
	for(nCount = 0; nCount < OL_PlayerVillages.count; nCount += 1 )
	{
		if( (OL_PlayerVillages[nCount].AsBuilding().settlement.max_population / 3 ) >= OL_PlayerVillages[nCount].AsBuilding().settlement.population )
		{
			obj = OL_PlayerVillages[nCount];
			ShowHint(
				Translate("Village population"),
				Translate("The more population your villages have, the more food they produce. Do not let your population decrease too much or your people will starve! To increase the population of your village you could bring in villagers from other villages and place them in the village hall."),
				obj);
			nExit += 1;
			break;
		}
	}
}