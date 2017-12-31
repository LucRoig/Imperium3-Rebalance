//void, int playerid

Sleep(35000);
if(EnvReadInt(playerid, "HeroBuilt") != 1 )
{
	if (ControllableObjs(playerid, cHero).IsEmpty() )
	{
		ObjList ol; ol = ClassPlayerObjs(cBaseTownhall, playerid).GetObjList();
		if (ol.count > 0)
			ShowTutorial(
				Translate("Hiring heroes"),
				Translate("Heroes are powerful leaders with special abilities that could command your armies. You can hire a hero from your stronghold."),
				ol[0]);
	}
}