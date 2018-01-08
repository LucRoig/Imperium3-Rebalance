//void, int playerid

Obj obj;
int nCount, nTemp;
ObjList OL_Heroes, OL_Holders;
Query Q_Heroes;

Sleep(110000);
nCount = 0;
while(nCount < 1 )
{
	OL_Heroes = GetPlayerUnits(playerid, cHero);
	for(nTemp = 0; nTemp < OL_Heroes.count; nTemp += 1 )
	{
		if(OL_Heroes[nTemp].AsHero().army.count >= 1 )
		{
			obj = OL_Heroes[nTemp];
			ShowTutorial(
				Translate("Hero bonuses"),
				Translate("All units attached to a hero receive an additional bonus to their level as well as a number of skills, depending on the hero leading them."),
				obj);
			nCount += 1;
			break;
		}
	}
	Sleep(5000 );
}