// void, Settlement set, int playerid
int GoldRate;
Sleep(100);

set.SetGold(set.gold + 5000);
set.GoldConverted(5000);
GoldRate = 50;

while (1) {
	Sleep(2000);
	if (set.IsValid) {
		if (set.player == playerid)	{
			set.SetGold(set.gold + GoldRate);
			set.GoldConverted(GoldRate);
		}
	}
}
