//void, int playerid

Obj obj;
int nCount, nExit;
ObjList OL_TTents;

Sleep(73000);
OL_TTents = ClassPlayerObjs(cTTent, 15 ).GetObjList();
while(nExit < 1 )
{
	Sleep(10000);	
	for(nCount = 0; nCount < OL_TTents.count; nCount += 1 )
	{
		if(IsExplored(OL_TTents[nCount].pos, playerid) )
		{
			obj = OL_TTents[nCount];
			ShowHint(
				Translate("Teuton camps"),
				Translate("Teuton camps are neutral and would attack anyone who goes close to them. If you are strong enough to vanquish the guards of a Teuton camp it will become yours to command and provide you with Teuton Riders over time."),
				obj);
			nExit += 1;
			break;
		}
	}
}