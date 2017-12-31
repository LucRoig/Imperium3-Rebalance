//void, Obj THIS

Unit this;
int BestMountaineerLevel;

this = THIS.AsUnit;
if (.IsValid) {
	BestMountaineerLevel = EnvReadInt(.player, "BestMountaineerLevel");
	if (BestMountaineerLevel < .level) {
		EnvWriteInt(.player, "BestMountaineerLevel", .level);
	}
}
