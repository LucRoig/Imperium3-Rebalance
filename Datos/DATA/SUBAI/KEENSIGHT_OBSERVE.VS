//void, Obj This

Unit this;
int i;

this = This.AsUnit;

Sleep(rand(500) + 500);

if (!.IsValid) while(true) Sleep(50000);

while(.IsAlive) {
	Sleep(rand(200) + 1000);
	RevealHiddenEnemyUnits(.pos, .sight, .player);
}

//prevent behavior script from terminating (this will lockup the game)
while(true) Sleep(50000);
