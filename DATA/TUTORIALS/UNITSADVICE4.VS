//void, int playerid

Obj obj;
int nPlayerHeroes, nPlayerUnits, nExit;

Sleep(550000);
nExit = 0;

nPlayerUnits = Count(playerid, cMilitary );
if(nPlayerUnits < 30 )
{
	ShowHint(
		Translate("Build more warriors"),
		Translate("It is advisable to train some more warriors in the barracks."),
		obj);
}
