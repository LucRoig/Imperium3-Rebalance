// void, Obj This

Unit this;
this = This.AsUnit();

while (!.Stop(1000));

if (.IsHeirOf("TTeutonRider")) 
	.Mutate("TTeutonArcher");
else if (.IsHeirOf("TTeutonArcher")) 
 	.Mutate("TTeutonRider");
