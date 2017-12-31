// void, Obj This

Unit u;
Druid this;
Query q;
ObjList ol;
ObjList olFriendly;
int h;
int i;
int th;

this = This.AsDruid;

if (.InHolder())
	return;
if(EnvReadString(.player, "Mass Heal") != "researched")
	return;
q = ObjsInCircle(.pos, .range, "Unit");
ol = q.GetObjList();
h = 1000;

for (i = ol.count - 1; i >= 0; i -= 1) {
	u = ol[i].AsUnit;
	if (u.IsValid) if (!.IsEnemy(u)) if (u.health < u.maxhealth) {
		olFriendly.Add(u);
	}
}

for (i = olFriendly.count - 1; i >= 0; i -= 1) {
	u = olFriendly[i];
	if (u.health < u.maxhealth) {
		th = u.maxhealth - u.health;
		if (th > h) {
			th = h;
		}
		u.Heal(th);
		CreateFeedback("Heal", u);
		h -= th;
		if (h == 0)
			break;
	}
}
