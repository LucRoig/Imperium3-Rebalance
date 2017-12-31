//void, int playerid

Obj obj;
int nPlayerHeroes, nPlayerUnits, nExit;

Sleep(80000);
nExit = 0;

while(nExit < 1 )
{
	nPlayerHeroes = Count(playerid, cHero );
	nPlayerUnits = Count(playerid, cMilitary );
	if( (nPlayerHeroes == 0 ) && (nPlayerUnits >= 30 ) )
	{
		ShowHint(
			Translate("Heroes required"),
			Translate("It is advisable to hire some heroes to lead your armies and increase its effectiveness."),
			obj);
		nExit += 1;
	}
	if(nPlayerHeroes > 0 )
	{
		nExit += 1;
	}
	Sleep(15000);
}