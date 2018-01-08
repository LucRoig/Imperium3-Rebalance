//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_Holders;

Sleep(600000 );
OL_Holders = ClassPlayerObjs(cItemHolder, 15 ).GetObjList();
while(nExit < 1 )
{
	Sleep(30000);	
	for(nCount = 0; nCount < OL_Holders.count; nCount += 1 )
	{
		if(IsExplored(OL_Holders[nCount].pos, playerid) )
		{
			obj = OL_Holders[nCount];
			ShowHint(
				Translate("Places of interest"),
				Translate("Throughout the map there are a number of locations that provide minor items or heal units located nearby. All item holders are marked by a circle of small stones around them. To get an item select a unit then right-click on the item holder."),
				obj);
			nExit += 1;
			break;
		}
	}
}