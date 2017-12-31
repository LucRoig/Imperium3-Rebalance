// void, Obj This, Obj obj

Unit  this;
Ship  ship;
ObjList ol;

this = This.AsUnit;
ship = obj.AsShip;

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);

if( ship.IsValid ) {
	ol = ship.GetUnitsOnBoard;
	if( !ol.Contains(this) ) {
		ship.NotifyBoardUnit( this );
		.AddCommand( true, "boardshipcommon", obj );
	}
}