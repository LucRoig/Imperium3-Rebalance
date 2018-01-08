//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_Teleports;

Sleep(250000);
OL_Teleports = ClassPlayerObjs(cTeleport, 15 ).GetObjList();
while(nExit < 1 )
{
	Sleep(30000);	
	for(nCount = 0; nCount < OL_Teleports.count; nCount += 1 )
	{
		if(IsExplored(OL_Teleports[nCount].pos, playerid) )
		{
			obj = OL_Teleports[nCount];
			ShowHint(
				Translate("Caves"),
				Translate("Caves are used to move armies between distant map locations. However, they always go in pairs - each cave transports units only to its corresponding one on the map."),
				obj);
			nExit += 1;
			break;
		}
	}
}