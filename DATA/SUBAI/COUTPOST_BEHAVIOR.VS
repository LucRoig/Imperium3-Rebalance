//void, Obj This

Building this;
ObjList ol;
Unit uRecruit;
int i;
int nSleepTime = 60000;

this = This.AsBuilding();

Sleep(rand(nSleepTime) + 10000);

while (1)
{
	ol = .settlement.Units.ObjClass("Peasant");
	ol.ClearDead();
	ol = ol.ObjAlly(.player);
	if (ol.count > 0)
	{
		i = rand(ol.count);
		ol[i].Erase;
		uRecruit = Place("CMaceman", .pos, .player);
		.settlement.ForceAddUnit(uRecruit);
		ol.Clear();
	}
	Sleep(nSleepTime);
}
