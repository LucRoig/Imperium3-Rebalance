//void, ObjList objs,point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	u = objs[i].AsUnit;
	if (u.IsValid) {
		u.SetLastAttackTime();
		u.SetVisible(true);
	}
}
