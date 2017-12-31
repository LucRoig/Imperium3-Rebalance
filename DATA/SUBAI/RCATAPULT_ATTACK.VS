// void, Obj me, Obj target

Catapult  this;
this = me.AsCatapult();
if (!.IsValid) return;
if (.CmdCount() > 1)
	return;
.SetTarget( target );
