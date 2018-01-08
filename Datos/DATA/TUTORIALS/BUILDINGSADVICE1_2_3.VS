//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_EnemyBuildings;
IntArray nA_VisibleBuildings, nA_Loyality;

Sleep(120000);
nExit = 0;
OL_EnemyBuildings = Substract(EnemyObjs(playerid, cBuilding ), EnemyObjs(playerid, cTTent ) ).GetObjList();
for(nCount = 0; nCount < OL_EnemyBuildings.count; nCount += 1 )	
{
	nA_VisibleBuildings[nCount] = 0;
	nA_Loyality[nCount] = 0;
}

while(nExit < 1 )
{
	Sleep(20000);
	for(nCount = 0; nCount < OL_EnemyBuildings.count; nCount += 1 )
	{
		if( (OL_EnemyBuildings[nCount].player != 15 ) && ( OL_EnemyBuildings[nCount].player != playerid )  )
		{
			if(!Intersect(ObjsInCircle(OL_EnemyBuildings[nCount].pos , 500 , cMilitary), ClassPlayerObjs(cMilitary, playerid ) ).IsEmpty() )
			{
				if(nA_VisibleBuildings[nCount] == 0 )
				{
					nA_Loyality[nCount] = OL_EnemyBuildings[nCount].AsBuilding().settlement.loyalty;
					nA_VisibleBuildings[nCount] += 1;
				}
				else
				{
					if(OL_EnemyBuildings[nCount].AsBuilding().settlement.loyalty >= nA_Loyality[nCount] )
					{
						nA_VisibleBuildings[nCount] += 1;
					}
					else
					{
						nA_VisibleBuildings[nCount] = 0;
					}
				}
			}
			if(nA_VisibleBuildings[nCount] > 1 )
			{
				obj = OL_EnemyBuildings[nCount];
				ShowHint(
					Translate("Capturing"),
					Translate("When your forces are near an enemy outpost, village or settlement you could order them to capture it by selecting your warriors and right-clicking on it. To successfully perform the capturing process, however, it is necessary that your troops are more than the defenders of the encampment. As time passes your armies will slowly decrease the loyalty of the enemy outpost, village or settlement. When that loyalty falls to 0 the encampment is yours to control. You could also capture allied settlements by ordering one single warrior to do so."),
					obj);
				nExit += 1;
				break;
			}
		}
	}
}
