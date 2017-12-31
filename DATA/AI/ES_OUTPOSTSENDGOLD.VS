// void, Settlement set

// sends also the food

Wagon wagon;
Settlement Dest;

Dest = set.BestToSupply();
if (!Dest.IsValid)
	return;
if (set.gold >= 100) {
	wagon = set.CreateMuleGold(set.gold);
	wagon.AddCommand(false, "unload", Dest.GetCentralBuilding);
	wagon.KillCommand();
}
if (set.food >= 100) {
	wagon = set.CreateMuleFood(set.food);
	wagon.AddCommand(false, "unload", Dest.GetCentralBuilding);
	wagon.KillCommand();
}
