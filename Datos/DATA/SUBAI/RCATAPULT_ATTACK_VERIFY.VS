//bool, Obj me, Obj other

Catapult this;
this = me.AsCatapult();

if (!other.IsValid()) return false;
if (!.IsEnemy(other) || !.IsValidTarget(other)) return false;
if (!.InRange(other.pos)) return false;

return true;
	
