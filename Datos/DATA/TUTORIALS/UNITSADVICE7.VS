//void, int playerid

ObjList ol;
Obj obj;

if( WaitQueryCountBetween(ClassPlayerObjs(cPeasant, playerid ), 1, 100, 360000 ) )
{
	ol = ClassPlayerObjs(cPeasant, playerid ).GetObjList();
	if (ol.count > 0)
		obj = ol[0];
	ShowHint(
		Translate("Villagers"),
		Translate("You can move villagers from one settlement to another by sending them to the settlement in which you wish the population to increase. Remember, the greater the population, the more resources the settlement produces."),
		obj);
}
else
{
	ShowHint(
		Translate("Villager production"),
		Translate("You can move villagers by producing them in a village and sending them to the settlement in which you wish the population to increase. Remember, the greater the population, the more resources the settlement produces."),
		obj);
}
