//void, int playerid

Obj obj;
int nExit;

Sleep(650000);

while(nExit < 1 )
{
	Sleep(30000);
	if( Count(playerid, cMilitary ) > 0 )
	{
		if( WasSelectionAssigned(playerid) )
		{
			break;
		}
		else
		{
			if( IsSelectionAssigned(playerid) )
			{
				break;
			}
			else
			{
				ShowHint(
					Translate("Assigning groups"),
					Translate("You may assign a group of units to a number by selecting them and pressing CTRL and # (at the same time), where # is the number of the slot they'll fill on the left side of the screen. To get direct control of the group simply press the number or double click on the appropriate slot."),
					obj);
				nExit += 1;
			}
		}
	}
}