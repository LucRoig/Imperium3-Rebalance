//void, int playerid

Obj obj;
ObjList OL_Heroes, OL_Temp;
int nExit, nCount1, nCount2, nHP, nMaxHP, nRandom;

nRandom = rand(5);
if(nRandom != 0 )
{
	return;
}
Sleep(155000);
nExit = 1;

while(nExit == 1)
{
	Sleep(60000);
	OL_Heroes = ClassPlayerObjs(cHero, playerid).GetObjList();
	for(nCount1 = 0; nCount1 < OL_Heroes.count; nCount1 += 1 )
	{
		nHP = 0;
		nMaxHP = 0;
		OL_Temp = OL_Heroes[nCount1].AsHero().army;
		if(OL_Temp.count > 20 )
		{
			for(nCount2 = 0; nCount2 < OL_Temp.count; nCount2 += 1 )
			{
				nHP += OL_Temp[nCount2].health;
				nMaxHP += OL_Temp[nCount2].maxhealth;
			}
			if( (nHP * 3 ) < nMaxHP )
			{
				obj = OL_Heroes[nCount1];
				ShowHint(
					Translate("Faster healing"),
					Translate("When the health of your army is low you may put it in a fortification (outpost or townhall), where it will heal faster, provided there is enough food there."),
					obj);
				nExit += 1;
			}
		}
	}
}	