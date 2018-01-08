// void, Obj This

while (!This.IsValid()) Sleep(1000);

while (This.stamina > 0) {
	Sleep(4000);
	if (This.stamina == 0) break;
	This.SetStamina(This.stamina - 1);
}

This.Damage(10000);

while (1) Sleep(100000);
