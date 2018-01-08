//void, int playerid

Obj obj;
int nExit;

Sleep(130000);

while(nExit < 1 )
{
	Sleep(10000);
	if(HasStarvingArmy(20000) )
	{
		obj = StarvingArmyPos(20000);
		ShowHint(
			Translate("Starvation"),
			Translate("Some of your warriors are starving! You are to bring them near a settlement with food otherwise their health will diminish to 10% of its maximum value. Alternatively you can also bring caravans loaded with food near your army to feed them."),
			obj);
		nExit += 1;
	}
}