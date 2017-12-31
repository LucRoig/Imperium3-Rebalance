// void, Obj THIS

Building this;
Unit u;
ObjList ol;
int HealthDistrubute, Give, i;

this = THIS.AsBuilding;

ol = .settlement.ObjectsAround("Unit");
HealthDistrubute = 2000;
for(i = 0; i < ol.count; i += 1) {
	Unit u;
	u = ol[i].AsUnit;
	if (u.health < u.maxhealth && !.IsEnemy(u)) {
		CreateFeedback("Heal", u);
		Give = u.maxhealth - u.health;
		if (Give > HealthDistrubute) Give = HealthDistrubute;
		HealthDistrubute -= Give;
		u.Heal(Give);
		if (HealthDistrubute == 0) break;
	}
}
