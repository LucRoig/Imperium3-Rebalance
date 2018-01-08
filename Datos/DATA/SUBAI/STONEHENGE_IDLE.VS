// void, Obj This

Building this;
int count;

this = This.AsBuilding();

if (!this.IsValid()) {
	//pr("Ivalid stonehenge!");
	while (1) Sleep(100000);  // fixme!!
}

while (1) {
	Sleep(1000);

	count = .StonehengeNumControllingMages();
	if (count > 0) {
		if (.stamina < 100)
			.SetStamina(.stamina + 1);

		if (count < 50)
			Sleep(12500 / count - 250);
	}
}

