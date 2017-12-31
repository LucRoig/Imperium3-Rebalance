//void, int playerid

Obj obj;
int nCount, nTemp;

Sleep(5000);
nCount = ClassPlayerObjs(cBuilding, playerid).count;
Sleep(170000);
nTemp = ClassPlayerObjs(cBuilding, playerid).count;
if(nTemp <= nCount )
{
	ShowTutorial(
		Translate("Exploration"),
		Translate("Send out troops to explore the independent territory outside your stronghold."),
		obj);
}