//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_EnemyGates;
IntArray nA_GatesStatus, nA_Health;

Sleep(300000 );
nExit = 0;
OL_EnemyGates = EnemyObjs(playerid, cGate ).GetObjList();
for(nCount = 0; nCount < OL_EnemyGates.count; nCount += 1 )
{
	nA_GatesStatus[nCount] = 0;
	nA_Health[nCount] = OL_EnemyGates[nCount].health;
}
while(nExit < 1 )
{
	Sleep(15000);
	if( EnvReadInt(playerid, "CatapultBuilt") == 1 )
	{
		break;
	}
	for(nCount = 0; nCount < OL_EnemyGates.count; nCount += 1 )
	{
		if(OL_EnemyGates[nCount].AsGate().AreEnemiesAround() )
		{
			if( (nA_GatesStatus[nCount] == 0 ) && (OL_EnemyGates[nCount].health != 0 ) )
			{
				nA_GatesStatus[nCount] += 1;
				nA_Health[nCount] = OL_EnemyGates[nCount].health;
			}
			else
			{
				if(nA_Health[nCount] >= OL_EnemyGates[nCount].health )
				{
					nA_GatesStatus[nCount] = 0;
				}
				else
				{
					nA_GatesStatus[nCount] += 1;
					break;
				}
			}
		}
		if(nA_GatesStatus[nCount] > 1 )
		{
			obj = OL_EnemyGates[nCount];
			ShowHint(
				Translate("Siege"),
				Translate("In order to destroy an enemy gate you need to attack it with ranged weapons or order your warriors to build a catapult (or ram) to target it. In order to create a catapult (or ram) you need to select up to 10 warriors and order them to build it from the menu, then select the area where it should be built by dragging it and right-clicking on the appropriate place. While building catapults pay attention to their effective range."),
				obj);
			nExit += 1;
			break;
		}
	}
}