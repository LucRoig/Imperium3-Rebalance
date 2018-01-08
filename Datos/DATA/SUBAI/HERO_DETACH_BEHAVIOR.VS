// void, Obj This

Hero this;
int nDetachDistance, nDetachDistanceEngage, nRecallDistance;
int i, distance;

nDetachDistance = GetConst("DetachDistance");
nDetachDistanceEngage = GetConst("DetachDistanceEngage");
nRecallDistance = GetConst("RecallDistance");

this = This.AsHero;

while( 1 )
{
	if( .IsValid )
	{
		if (IsAIPlayer(.player))
		{
			Sleep(20 * 1000);
			continue;
		}
		.army.ClearDead;
		for(i=0; i<.army.count; i+=1) {
			Unit u; u = .army[i].AsUnit;
			if( u.IsValid ) {
				distance = Dist(.posRH, u.posRH);
				if( u.command == "approach" ) {
					continue;
				} else if( 
					u.command != "engage" && 
					u.command != "engage_unit_type" &&
					u.command != "attack" && 
					u.command != "attack_unit_type" && 
					u.command != "capture"
					) {
					if( distance > nDetachDistance ) {
						if( u.command == "idle" )
							u.SetCommand("attach", this);
						else
							u.AddCommand(false, "attach", this);
						u.DetachFrom(this);
					}
				} else {
					if( distance > nDetachDistanceEngage ) {
						u.SetCommand("approach_hero", this);
						u.AddCommand(false, "engage");
					}
				}
			}
			Sleep(14);
		}	
	}
	
	Sleep(3017); // 
}