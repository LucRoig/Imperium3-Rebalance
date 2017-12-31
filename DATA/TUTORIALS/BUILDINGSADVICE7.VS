//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_Ruins;

Sleep(60000);
OL_Ruins = ClassPlayerObjs(cBaseRuins, 15 ).GetObjList();
while(nExit < 1 )
{
	Sleep(30000);	
	for(nCount = 0; nCount < OL_Ruins.count; nCount += 1 )
	{
		if(IsExplored(OL_Ruins[nCount].pos, playerid) )
		{
			obj = OL_Ruins[nCount];
			ShowHint(
				Translate("Ruins"),
				Translate("Ruins are places from where your heroes can gather powerful items that will aid them in battle. In order to acquire an item the hero must be of the specified level (displayed when the ruins are selected). Upon exiting the ruins the hero's health is always 10% of his maximum health."),
				obj);
			nExit += 1;
			break;
		}
	}
}

