//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_Stonehenges;

Sleep(20000 + rand(20000) );
OL_Stonehenges = ClassPlayerObjs(cStonehenge, 15 ).GetObjList();
while(nExit < 1 )
{
	Sleep(20000 + rand(20000) );	
	for(nCount = 0; nCount < OL_Stonehenges.count; nCount += 1 )
	{
		if(IsExplored(OL_Stonehenges[nCount].pos, playerid) )
		{
			obj = OL_Stonehenges[nCount];
			ShowHint(
				Translate("Stonehenges"),
				Translate("In stonhenges you can cast global spells which will have an effect all over the map. In order to use a stonehenge you need to have one of more sages near it so that the stonehenge could accumulate enough power to cast spells."),
				obj);
			nExit += 1;
			break;
		}
	}
}