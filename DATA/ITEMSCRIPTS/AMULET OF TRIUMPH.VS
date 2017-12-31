//void, Obj owner, Obj victim

if (owner.IsValid())
	if (owner.health < owner.maxhealth) {
		owner.Heal(100);
		CreateFeedback("Heal", owner.AsUnit);
	}
