//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_PlayerVillages, OL_UnattachedVillages;

Sleep(120000);
while(nExit < 1 )
{
	Sleep(60000 );
	OL_PlayerVillages = ClassPlayerObjs(cBaseVillage, playerid ).GetObjList();
	for(nCount = 0; nCount < OL_PlayerVillages.count; nCount += 1 )
	{
		if(!OL_PlayerVillages[nCount].AsBuilding().settlement.supplied.IsValid() )
		{
			if(OL_UnattachedVillages.Contains(OL_PlayerVillages[nCount]) )
			{
				obj = OL_PlayerVillages[nCount];
				ShowHint(
					Translate("Supply"),
					Translate("You can order your villages to automatically send the food that they produce to another village, outpost or settlement by selecting the village and right-clicking on the chosen destination (village, outpost or settlement). When this is done a food caravan begins transporting food from one place to another depending on the food storage of the village. Should the caravan be killed or captured before reaching its destination the food won't be available."),
					obj);
				nExit += 1;
				break;
			}
			else
			{
				OL_UnattachedVillages.Add( OL_PlayerVillages[nCount] );
			}
		}
	}
}


