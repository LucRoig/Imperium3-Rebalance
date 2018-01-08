//void, int player
Squad s;
Hero h;
int i;
int nsq;

while (true) {
	Sleep(60000);
	nsq = NumSquads(player);
	for (i = 0; i < nsq; i += 1) {
		s = GetSquad(player, i);
		h = s.Leader.AsHero;
		if (h.IsValid) {
			h.SetExperience(h.experience + 1);
		}
	}
}