//void, int playerid

ObjList olSelCaravans;

Sleep(500 + rand(1000));

while (1)
{
	Sleep(1500);

	olSelCaravans = _GetSelection().ObjClass(cWagon);
	if (olSelCaravans.count == 0)
		continue;
	//olSelCaravans.RemoveList(olSelCaravans.ObjPlayer(playerid));
	olSelCaravans = olSelCaravans.ObjEnemy(playerid);
	if (olSelCaravans.count == 0)
		continue;

	ShowHint(
		Translate("Capture Caravans"),
		Translate("To capture a caravan, select some of your nearby military units and right-click on that caravan."),
		olSelCaravans[0]);
	return;
}
