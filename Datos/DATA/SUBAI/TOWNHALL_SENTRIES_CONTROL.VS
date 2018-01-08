//void, Obj This

Building this;
int player;
int add_interval;
int add_count;
int max, curr, diff;

Sleep(rand(1000) + 300);

if (GetConst("NoSentries") != 0)
{	// disable sentries
	while (1)
		Sleep(100000);
}

this = This.AsBuilding();

add_interval = GetConst("SentriesAddTime");
add_count = GetConst("SentriesAddCount");

while (!.settlement().IsValid())
	Sleep(1000);
.settlement.AddMaxSentries(GetConst("InitialStrongholdSentries"));

while (1)
{
	player = .player;
	Sleep(add_interval);
	if (player != .player)
		continue;
	max = .settlement.GetMaxSentries();
	curr = .settlement.GetNumSentries();
	if (curr >= max)
		continue;
	diff = max - curr;
	if (diff > add_count)
		diff = add_count;
	.settlement.AddSentries(diff);
}
