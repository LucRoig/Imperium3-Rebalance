// void, Obj This


Building this;
int nFeedingInterval, i;
ObjList ol;

this = This.AsBuilding();
nFeedingInterval = GetConst("DropFoodByOneIvl");

Sleep(rand(nFeedingInterval) + 1000);

if (!.settlement.IsIndependent()) 
	Sleep(20000);

while (.settlement.IsIndependent()) {
	//feed the teutons inside
	ol = .settlement.Units();

	for (i=0; i<ol.count; i+=1) {
		ol[i].AsUnit().SetFood(20);
	}
	Sleep(nFeedingInterval*2);
}
