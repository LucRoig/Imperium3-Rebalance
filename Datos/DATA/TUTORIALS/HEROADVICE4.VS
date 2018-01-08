//void, int playerid

int n_Count, n_Exit;
Obj obj;
ObjList OL_Heroes;
IntArray nA_OldHeroSparePoints, nA_NewHeroSparePoints;

Sleep(30000);

n_Exit = 0;

while(n_Exit < 1 )
{
	Sleep(1000);
	OL_Heroes = ControllableObjs(playerid, cHero).GetObjList();
	for(n_Count = 0; n_Count < OL_Heroes.count; n_Count += 1 )
	{
		obj = OL_Heroes[n_Count];
		if (!obj.IsValid)
			continue;
		if (obj.IsDead)
			continue;
		nA_OldHeroSparePoints[n_Count] = obj.AsHero().AvailableSkillPoints();
		nA_NewHeroSparePoints[n_Count] = 0;
		if(nA_OldHeroSparePoints[n_Count] > 0 )
		{

			nA_NewHeroSparePoints[n_Count] += 1;
		}
		Sleep(40000);
		if(nA_OldHeroSparePoints[n_Count] > 0 )
		{
			if(nA_NewHeroSparePoints[n_Count] > 0 )
			{
				ShowHint(Translate("Hero Advancement"),
				Translate("When a hero advances in level, he receives a skill point which could be allocated on one of his skills."),
				obj );
				n_Exit += 1;
			}
		}
	}
}