// void, Obj This

Settlement this;
int min_resource, refresh, food_sales, food_income, required_gold, gold_income, reserved_food;
int i;
Wagon wagon;
bool bProduceGold, bSellFood, bWagon;
ObjList olLibyansOut;
ObjList olUnitsOut;
str strCommand;

this = This.AsBuilding().settlement;

refresh = GetConst("OutpostRefresh");
food_sales = GetConst("GOutpostFoodSales");
food_income = GetConst("GOutpostGoldReturn");
gold_income = GetConst("ROutpostGoldReturn");
required_gold = GetConst("ROutpostRequiredGold");
min_resource = GetConst("MinResQtyToTransport");
bProduceGold = This.IsHeirOf("ROutpost") || This.IsHeirOf("EOutpost");

while (1) {
	if (.IsIndependent())
	{
			Sleep(refresh);
			continue;
	}

	Sleep(refresh);
	bSellFood = EnvReadString(this, "GOutpostSellFood") == "yes";
	// gaul outpost behaviour
	if (!bProduceGold && bSellFood && .food > food_sales) {
		.SetFood(.food - food_sales);
		.SetGold(.gold + food_income);
		.GoldConverted(food_income);
	}
	// roman outpost behaviour
	if(bProduceGold && .gold >= required_gold) {
		.SetGold(.gold + gold_income);
		.GoldConverted(gold_income);
	}
	// send resources
	if (.supplied == this)
		.StopSupply();
	if (!.supplied.IsValid()) continue;
	if (!DiplGetCeaseFire(.player, .supplied.player)) continue;
	bWagon = false;
	if (.gold > min_resource) {
		int gold;
		gold = 1000;
		if (bProduceGold && .gold > required_gold && .gold - required_gold < 1000)
			gold = .gold - required_gold;
		if (gold > min_resource) {
			wagon = .CreateMuleGold(gold);
			wagon.SetCommand("unload", .supplied.GetCentralBuilding());
			bWagon = true;
		}
	}
	if (.Units.count)
		reserved_food = 100;
	else
		reserved_food = 0;	
	if (!bWagon && .food > (min_resource + reserved_food) && !bSellFood) {
		if (.food - reserved_food > 1000)
			wagon = .CreateMuleFood(1000);
		else
			wagon = .CreateMuleFood(.food - reserved_food);
		wagon.SetCommand("unload", .supplied.GetCentralBuilding());
	}
	olLibyansOut.Clear;
	for(i=0; i<.Units.count; i+=1) {
		if( .Units[i].IsHeirOf("CMaceman") && !.Units[i].AsUnit.GetCommanded ) {
			olLibyansOut.Add(.Units[i]);
		}
	}

	if( !.supplied.GetCentralBuilding.IsHeirOf("BaseVillage") ) {
		if( olLibyansOut.count >= 5 )
			olLibyansOut.SetCommand("enter", .supplied.GetCentralBuilding());
	}

	if( .Units.count ) 
	{
		point pt;

		olUnitsOut.Clear;
		for(i=0; i<.Units.count; i+=1) {
			if( This.AsBuilding.IsEnemy(.Units[i] ) ) {
				olUnitsOut.Add(.Units[i]);
			}
			if (i % 50 == 49) Sleep(1);
		}
		olUnitsOut.ClearDead;

		pt.Set(1,0);
		pt.SetLen(This.AsBuilding.radius);
		pt.Rot(rand(360));
		pt = pt + This.AsBuilding.pos;
		olUnitsOut.SetCommand("advance", pt);
	}
	
}
