//void, int playerid

ObjList heroes;
int i;

Sleep(410000);

while(Count(playerid, cHero) < 1)
{
	Sleep(11000);
}
Sleep(30000);
heroes = ControllableObjs(playerid, cHero).GetObjList();

for (i = 0; i < heroes.count; i += 1)
	if (heroes[i].AsHero().army.count > 0)
		return;

if (heroes.count > 0)
	ShowTutorial(
		Translate("Attaching units"),
		Translate("In order to increase the effectiveness of your army it is better to attach it to a hero so they could share some of his bonuses. To attach units to a hero simply select them then right-click on the hero of your choice."),
		heroes[0]);
