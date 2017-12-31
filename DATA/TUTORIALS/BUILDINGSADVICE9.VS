//void, int playerid

Obj obj;
ObjList OL_PlayerBuildings;
int nExit, nCount;

Sleep(20000);
nExit = 0;

OL_PlayerBuildings = ClassPlayerObjs(cBuilding, playerid).GetObjList();
for(nCount = 0; nCount < OL_PlayerBuildings.count; nCount += 1 )
{
	if( OL_PlayerBuildings[nCount]._LastSelectionTime() != -1 )
	{
		nExit += 1;
	}
}
if(nExit == 0 )
{
	ShowTutorial(
		Translate("Select a building"),
		Translate("Each of the buildings in your town has its use. To examine a building and get a list of the various commands simply left-click on it."),
		obj);
}