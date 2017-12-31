// void, Obj This

Query qUnitsAroundMe;
Query qAnimals;
ObjList l;
Unit unit;
int i, j, count;

Sleep(rand(1000) + 500);

qUnitsAroundMe = ObjsInRange(This, "Unit", 300);
// remove animals
// find animals around
qAnimals = Union(ObjsInRange(This, "LionF", 300),ObjsInRange(This, "LionM", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "Bear", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "Boar", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "Wolf", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "BearUnit", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "BoarUnit", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "WolfUnit", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "LionFUnit", 300));
qAnimals = Union(qAnimals,ObjsInRange(This, "LionMUnit", 300));
// remove them
qUnitsAroundMe = Subtract(qUnitsAroundMe, qAnimals);

while(1)
{
	Sleep(1000);
	if (qUnitsAroundMe.count == 0)
		continue;
	l = qUnitsAroundMe.GetObjList();
	l.ClearDead();
	l = l.ObjInjured();
	count = l.count;
	if (count == 0)
		continue;
	j = rand(count);
	unit = l[j];
	unit.Heal(200);
	CreateFeedback("Heal", unit);
	Sleep(1000);
}
