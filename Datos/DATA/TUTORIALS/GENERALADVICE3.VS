//void, int playerid

Obj obj;

Sleep(140000 );
if(_ZoomMapLastShownTime() == -1 )
{
	ShowTutorial(
		Translate("Minimap"),
		Translate("To get a bird's eye view of the entire area press the space bar to activate the minimap. From there you can determine your global strategy as well as select settlements and issue commands. Everything which isn't explored is marked in black."),
		obj);
}