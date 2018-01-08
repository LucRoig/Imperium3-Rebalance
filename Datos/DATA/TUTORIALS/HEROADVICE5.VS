//void, int playerid

int n_Count, n_Exit;
Obj obj;
ObjList OL_Heroes;
IntArray nA_HintStatus;

Sleep(80000);

n_Exit = 0;
for(n_Count = 0; n_Count < 4; n_Count += 1 )
{
	nA_HintStatus[n_Count] = 0;
}

while(n_Exit < 1 )
{
	OL_Heroes = ControllableObjs(playerid, cHero).GetObjList();
	for(n_Count = 0; n_Count < OL_Heroes.count; n_Count += 1 )
	{
		if(OL_Heroes[n_Count].AsHero().army.count > 0 )
		{
			obj = OL_Heroes[n_Count];
			if( (OL_Heroes[n_Count].AsHero().formation == "Cavalry core" ) && (nA_HintStatus[0] == 0 ) )
			{
				ShowHint(Translate("Cavalry core formation"),
				Translate("Increases the damage of the units by 4, and the range of the archers by 20% (while in formation)."),
				obj );
				nA_HintStatus[0] += 1;
			}
			if( (OL_Heroes[n_Count].AsHero().formation == "Block" ) && (nA_HintStatus[1] == 0 ) )
			{
				ShowHint(Translate("Block formation"),
				Translate("Increases the armor of the units by 6 (while in formation)."),
				obj );
				nA_HintStatus[1] += 1;
			}
			if( (OL_Heroes[n_Count].AsHero().formation == "Line" ) && (nA_HintStatus[2] == 0 ) )
			{
				ShowHint(Translate("Line formation"),
				Translate("Increases the armor and damage of the units by 2, and the range of the archers by 20% (while in formation)."),
				obj );
				nA_HintStatus[2] += 1;
			}

			if( (OL_Heroes[n_Count].AsHero().formation == "Front" ) && (nA_HintStatus[3] == 0 ) )
			{
				ShowHint(Translate("Front formation"),
				Translate("Increases the level of the units by 4 (while in formation)."),
				obj );
				nA_HintStatus[3] += 1;
			}

		}
		if( (nA_HintStatus[0] != 0 ) && (nA_HintStatus[1] != 0 ) && (nA_HintStatus[2] != 0 ) && (nA_HintStatus[3] != 0 ) )
		{
			n_Exit += 1;
		}
	}
	Sleep(30000);
}