//void, int playerid

Obj obj;

Sleep(720000);
WaitQueryCountBetween(ClassPlayerObjs(cMilitary, playerid), 1, 100, -1 );
Sleep(500);
obj = ClassPlayerObjs(cMilitary, playerid).GetObjList()[0];
ShowTutorial(
	Translate("Unit stats"),
	Translate("When you select a certain unit you can see its stats displayed in the upper part of the screen as follows: level, damage, armor, stamina, health, specials and the current quantity food."),
	obj);