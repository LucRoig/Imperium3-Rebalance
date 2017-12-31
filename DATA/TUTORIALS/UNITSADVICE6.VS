//void, int playerid

Obj obj;

if( WaitQueryCountBetween(ClassPlayerObjs(cWagon, playerid ), 1, 100, 480000 ) )
{
	obj = ClassPlayerObjs(cWagon, playerid ).GetObjList()[0];
	ShowHint(
		Translate("Caravans"),
		Translate("Caravans transport resources from one settlement to another. They can also be used to provide food to your army when the need arises. Note that caravans can be captured."),
		obj);
}
else
{
	ShowHint(
		Translate("Caravan production"),
		Translate("Caravans can be produced in any of your encampments and shipyards. They are used to transport resources from one settlement to another. Caravans can also provide food to your army when the need arises. Note that caravans can be captured."),
		obj);
}