//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;
int cost;

this = objs[0].AsBuilding();
if (!.IsValid()) return;

cost = GetCmdStaminaCost("starvation");
if (.stamina < cost) return;
.SetStamina(.stamina - cost);
.GlobalSpellStart(gsStarvation, player);

.SetCommand("starvation");