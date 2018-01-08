//void, Obj owner

int charges;

if (!owner.AsUnit.IsValid)
	return;

while (1) {
	Sleep(1000);
	charges = GetUseCount();
	if (owner.health < owner.maxhealth && charges >= 25) {
		charges -= 20;
		owner.Heal(20);
		CreateFeedback("Heal", owner.AsUnit);
	} else
		if (charges < 500)
			charges += 5;
	if (charges > 500)
		charges = 500;
	ItemUsed(GetUseCount() - charges);
}
