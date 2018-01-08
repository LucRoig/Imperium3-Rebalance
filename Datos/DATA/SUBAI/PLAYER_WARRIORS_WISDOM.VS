//void, int player
Squad s;
int i,j;
int nsq, nu;
ObjList ol;
Unit u;

while (true) {
	Sleep(60000);
	nsq = NumSquads(player);
	for (i = 0; i < nsq; i += 1) {
		s = GetSquad(player,i);
		ol = s.Units();
		nu = ol.count;
		for (j = 0; j < nu; j += 1) {
			u = ol[j];
			if (u.IsValid) {
				if (u.IsHeirOf("Military")) {
					if (u.inherentlevel<12)
					  u.SetExperience(u.experience + 1);
				}
			}
		}
	}
}