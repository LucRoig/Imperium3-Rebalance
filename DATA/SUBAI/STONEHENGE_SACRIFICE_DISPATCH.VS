//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;
int cost;

this = objs[0].AsBuilding();
if (!.IsValid()) return;

cost = GetCmdStaminaCost("sacrifice");
if (.stamina < cost) return;
.SetStamina(.stamina - cost);
.GlobalSpellStart(gsDivineSacrifice, player);

.SetCommand("sacrifice");