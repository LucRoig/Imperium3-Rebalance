// void, Obj This

Building this;
Query crowd;
ObjList list;
int i, j, count;
Unit unit;

this = This.AsBuilding();

Sleep(rand(1000) + 500);

if (!this.IsValid()) {
	//pr("Ivalid stonehenge!");
	while (1) Sleep(100000);  // fixme!!
}

crowd = ObjsInRange(this, "Unit", .sight);
while(1) {
	Sleep(1000);
	if (crowd.count == 0) continue;
	list = crowd.GetObjList();
	list.ClearDead();
	count = list.count;
	j = rand(count);
	for (i = 0; i < count; i += 1) {
		unit = list[(i + j) % count];
		if (unit.stamina != unit.maxstamina) {
			unit.SetStamina(10);
			CreateFeedback("StaminaBoost", unit);
			Sleep(1000);
			break;
		}
	}
}
