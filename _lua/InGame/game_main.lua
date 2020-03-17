game=AddElement({
	type=TYPE_ELEMENT,
	anchor=anchorLTRB,
	x=0,
	y=0,
	width=LayoutWidth,
	height=LayoutHeight,
	colour1=BLACK(),--A(0),
	visible=false,
	nomouseeventthis=true,
});

gamewindow=AddElement({
	type=TYPE_ELEMENT,
	parent=game,
	anchor=anchorLT,
	x=0,
	y=0,
	width=LayoutWidth,
	height=371,
	colour1=WHITEA(0),
	texture_blend=false,
	--nomousevent=true,
	--nomouseeventthis=true,
	--visible=false,
});

gamewindow.pause=AddElement({
	type=TYPE_LABEL,
	parent=gamewindow,
	anchor=anchorLTRB,
	x=0,
	y=0,
	width=gamewindow.width,
	height=gamewindow.height,
	nomousevent=true,
	nomouseeventthis=true,
	visible=false,
	font_name=Trebuchet_30,
	text=loc(TID_msg_GamePaused),
	text_halign=ALIGN_MIDDLE,
        shadowtext=true,
        text_case=CASE_UPPER,
        font_colour=RGB(255,255,255),
});

OW_SETPAUSELABEL(gamewindow.pause.ID);

game.xicht=AddElement({
	type=TYPE_ELEMENT,
	parent=gamewindow,
	anchor=anchorLT,
	x=10,
	y=85+30,
	width=80,
	height=100,
	--colour1=WHITEA(0),
	texture_blend=false,
	nomousevent=true,
	nomouseeventthis=true,
	visible=false,
});

game.xicht.say=AddElement({
	type=TYPE_LABEL,
	parent=gamewindow,
	anchor=anchorLT,
	x=7,
	y=elementBottom(game.xicht)+2,
	width=550,
	height=15,
	font_colour_background=BLACKA(127),
	font_name=Tahoma_13,
	text='',
	text_halign=ALIGN_LEFT,
	text_valign=ALIGN_TOP,
	wordwrap=true,
	nomousevent=true,
	nomouseeventthis=true,
	visible=false,
        automaxwidth=550,
        autosize=true,
        shadowtext=true,
});

game.ui = AddElement({
	type=TYPE_ELEMENT,
	parent=game,
	anchor=anchorLTRB,
	x=0,
	y=0,
	width=LayoutWidth,
	height=LayoutHeight,
	colour1=BLACKA(0),
	nomouseeventthis=true,
});


game.ui.toolbar = AddElement({
	type=TYPE_ELEMENT,
	parent=game.ui,
	anchor=anchorLT,
	x=0,
	y=0,
	width=517,
	height=54,
        nomouseeventthis=true,
});

uisettings = interface.current.game.ui;

function OnToolbarClick(ID)
         switch(ID) : caseof {
			[1]   = function (x) OW_TOOLBARBUTTON(ID); end, -- Menu
			[2]   = function (x) end,          -- Team Review
			[3]   = function (x) if getvalue(OWV_MULTIPLAYER) then display_diplomacy(); else OW_TOOLBARBUTTON(ID); end; end, -- Objectives / Diplomacy
			[4]   = function (x) dialog.options.Show(); end, -- Options
			[5]   = function (x) end, -- Help
		      }
end;

function makeToolbarButton(ID)
	return AddElement({
		type=TYPE_IMAGEBUTTON,
		parent=game.ui.toolbar,
		anchor=anchorLT,
		x=uisettings.toolBtns[1]+(ID-1)*uisettings.toolBtns[5],
		y=uisettings.toolBtns[2],
		width=uisettings.toolBtns[3],
		height=uisettings.toolBtns[4],
		text='',
		callback_mouseclick='OnToolbarClick('..ID..');',
	});
end;

game.ui.toolbtns = {};

for i=1,5 do
 game.ui.toolbtns[i] = makeToolbarButton(i);
end;

game.ui.toolbar.pause = AddElement({
	type=TYPE_IMAGEBUTTON,
	parent=game.ui.toolbar,
	anchor=anchorLT,
	x=0,
	y=0,
	width=0,
	height=0,
	callback_mouseclick='OW_PAUSE();',
	text='',
	hint=loc(TID_Game_window_button_Pause),
});

game.ui.minimap = getBlankElement(game.ui,anchorRB);

game.ui.minimap.map     = getBlankElementA(game.ui.minimap,anchorRB);
game.ui.minimap.map.img = getBlankElement(game.ui.minimap.map,anchorNone);

MMLeft = False;

function MinimapDown(X,Y,B)
	OW_MINIMAP_CLICK(X,Y,B);
	if (B == 0) then
		MMLeft = true;
	end;
end;

function MinimapMove(X,Y)
	if (MMLeft) then
		OW_MINIMAP_CLICK(X,Y,0);
	end;
end;

function MinimapUp(B)
	if (B == 0) then
		MMLeft = false;
	end;
end;

set_Callback(game.ui.minimap.map.img.ID,CALLBACK_MOUSEDOWN,'MinimapDown(%x,%y,%b)');
set_Callback(game.ui.minimap.map.img.ID,CALLBACK_MOUSEMOVE,'MinimapMove(%x,%y)');
set_Callback(game.ui.minimap.map.img.ID,CALLBACK_MOUSEUP,'MinimapUp(%b)');
set_Property(game.ui.minimap.map.img.ID,PROP_BORDER_TYPE,BORDER_TYPE_OUTER);

function MakeMinimapCorner(I,X,Y)
	return AddElement({
		type=TYPE_ELEMENT,
		parent=game.ui.minimap.map.img,
		anchor=anchorLT,
		x=0,
		y=0,
		width=6,
		height=6,
		visible=false,
		texture='SGUI/minimap_corners.png',
		subtexture=true,
		subcoords=SUBCOORD(X,Y,6,6),
		nomouseevent=true,
	});
end;

game.ui.minimap.map.img.corners = {};

game.ui.minimap.map.img.corners[1] = MakeMinimapCorner(1,1,1);
game.ui.minimap.map.img.corners[2] = MakeMinimapCorner(2,9,1);
game.ui.minimap.map.img.corners[3] = MakeMinimapCorner(3,1,9);
game.ui.minimap.map.img.corners[4] = MakeMinimapCorner(4,9,9);

game.ui.infopanel = getBlankElement(game.ui,anchorLB);

game.ui.commpanel  = getBlankElementA(game.ui,anchorLB);
game.ui.commpanel1 = getBlankElement(game.ui.commpanel,anchorLT);

game.ui.commpanel1.undo  = getImageButtonEX(game.ui.commpanel1,anchorLB,XYWH(20,0,31,17),'','','OW_SEL_UNDOREDO(true)',SKINTYPE_TEXTURE,{SKINTEXTURE='SelectionUndo.png',hint=loc(TID_ui_comm_bt_hint_SelectionUndo)});
game.ui.commpanel1.redo  = getImageButtonEX(game.ui.commpanel1,anchorLB,XYWH(20,0,31,17),'','','OW_SEL_UNDOREDO(false)',SKINTYPE_TEXTURE,{SKINTEXTURE='SelectionRedo.png',hint=loc(TID_ui_comm_bt_hint_SelectionRedo)});
game.ui.commpanel1.speed = AddSkinnedElement(addSliderElement(game.ui.commpanel1, anchorNone, XYWH(0,0,90+10+16+16,16), 0, 6, 0, '', 'OW_set(SETTING_SPEED,game.ui.commpanel1.speed.POS+1)'),SKINTYPE_SLIDERINT);

setHint(game.ui.commpanel1.speed.bar,loc(TID_Other_SpeedBar));

game.ui.commpanel2 = getBlankElement(game.ui.commpanel,anchorLT);
game.ui.commpanel2.chassis  = makeCombobox_UI(game.ui.commpanel2,XYWH(0,0,120,16),'OW_COMMCOMBOS_INDEXCHANGE(0);');
game.ui.commpanel2.engine = makeCombobox_UI(game.ui.commpanel2,XYWH(0,0,120,16),'OW_COMMCOMBOS_INDEXCHANGE(1);');
game.ui.commpanel2.control = makeCombobox_UI(game.ui.commpanel2,XYWH(0,0,120,16),'OW_COMMCOMBOS_INDEXCHANGE(2);');
game.ui.commpanel2.weapon  = makeCombobox_UI(game.ui.commpanel2,XYWH(0,0,120,16),'OW_COMMCOMBOS_INDEXCHANGE(3);');
game.ui.commpanel3 = getBlankElement(game.ui.commpanel,anchorLT);
game.ui.commpanel3.weapon  = makeCombobox_UI(game.ui.commpanel3,XYWH(0,0,120,16),'OW_COMMCOMBOS_INDEXCHANGE(4);');

OW_COMMCOMBOS_SETUP(game.ui.commpanel2.chassis.list.ID,game.ui.commpanel2.engine.list.ID,game.ui.commpanel2.control.list.ID,game.ui.commpanel2.weapon.list.ID,game.ui.commpanel3.weapon.list.ID);

setHint(game.ui.commpanel2.chassis.label,loc(TID_Factory_Chassis_Select));
setHint(game.ui.commpanel2.engine.label,loc(TID_Factory_Engine_Select));
setHint(game.ui.commpanel2.control.label,loc(TID_Factory_Control_Select));
setHint(game.ui.commpanel2.weapon.label,loc(TID_Factory_Weapon_Select));
setHint(game.ui.commpanel3.weapon.label,loc(TID_Factory_Weapon_Select));

function makeCommButton(CID)
	return AddElement({
		type=TYPE_SPRITEMAPBUTTONS,
		parent=game.ui.commpanel,
		anchor=anchorLT,
		x=uisettings.commBtns[1]+math.mod(CID,3)*(uisettings.commBtns[3]),
		y=uisettings.commBtns[2]+math.floor(CID/3)*(uisettings.commBtns[4]),
		width=uisettings.commBtns[3],
		height=uisettings.commBtns[4],
		text='',
		--callback_mouseclick='OW_COMMBUTTON('..CID..');',
		visible=false,
	});
end;

game.ui.commpanel.buttons = {};

for c = 1, 9 do
	game.ui.commpanel.buttons[c] = makeCommButton(c-1);
	OW_COMMBUTTON_SETUP(c-1,game.ui.commpanel.buttons[c].ID);
end;

game.ui.facepanel  = getBlankElementA(game.ui,anchorLB);

game.ui.facepanelL = getBlankElementNoMouse(game.ui.facepanel,anchorLT);
game.ui.facepanelM = getBlankElementNoMouse(game.ui.facepanel,anchorLT);
game.ui.facepanelR = getBlankElementNoMouse(game.ui.facepanel,anchorLT);
game.ui.facepanelA = getBlankElementA(game.ui.facepanel,anchorLB);

game.ui.facepanelA.people = AddElement({
			type=TYPE_UNITLIST,
			parent=game.ui.facepanelA,
			anchor=anchorLTRB,
			colour1=BLACKA(0),
			texture2='SGUI/FaceIcons.png',
			font_name=Tahoma_10B, --Numbers only so safe for Japanese
                        callback_mouseleave='OW_CLEAR_LASTFACEMOUSEOVER()',
		});

OW_UNITLIST_SETUP(0,game.ui.facepanelA.people.ID);

game.ui.facepanelA.vehicle = AddElement({
			type=TYPE_UNITLIST,
			parent=game.ui.facepanelA,
			anchor=anchorTRB,
			colour1=BLACKA(0),
			texture2='SGUI/FaceIcons.png',
			font_name=Tahoma_10B, --Numbers only so safe for Japanese
                        callback_mouseleave='OW_CLEAR_LASTFACEMOUSEOVER()',
		});

OW_UNITLIST_SETUP(1,game.ui.facepanelA.vehicle.ID);

game.ui.facepanelA.building = AddElement({
			type=TYPE_UNITLIST,
			parent=game.ui.facepanelA,
			anchor=anchorTRB,
			colour1=BLACKA(0),
			texture2='SGUI/FaceIcons.png',
			font_name=Tahoma_10B, --Numbers only so safe for Japanese
                        callback_mouseleave='OW_CLEAR_LASTFACEMOUSEOVER()',
		});

OW_UNITLIST_SETUP(2,game.ui.facepanelA.building.ID);

game.ui.facepanelA.spliter = {};

game.ui.facepanelA.spliter[1] = AddElement({
	type=TYPE_ELEMENT,
	parent=game.ui.facepanelA,
	anchor=anchorLTB,
	y=0,
	width=14,
	height=0,
	subtexture=true,
	callback_mousedown='SpliterMouseDown(%x,1)',
	callback_mouseover='if (SpliterMouse.Down == 0) then setSpliterCoords(1,14); end;',
	callback_mouseleave='SpliterMouseLeave(1)',
});

game.ui.facepanelA.spliter[2] = AddElement({
	type=TYPE_ELEMENT,
	parent=game.ui.facepanelA,
	anchor=anchorLTB,
	y=0,
	width=14,
	height=0,
	subtexture=true,
	callback_mousedown='SpliterMouseDown(%x,2)',
	callback_mouseover='if (SpliterMouse.Down == 0) then setSpliterCoords(2,14); end;',
	callback_mouseleave='SpliterMouseLeave(2)',
});

SpliterTimerID = 0;

function SpliterMouseLeave(ID)
	if (SpliterMouse.Down == 0) then
		setSpliterCoords(ID,0);
	else
		SpliterTimerID = AddRepeatableTimer(0.25,'SpliterMouseLeave('..ID..')',SpliterTimerID);
	end;
end;

function setSpliterCoords(ID,X)
	set_SubCoords(game.ui.facepanelA.spliter[ID].ID,PROP_SUBCOORDS,SUBCOORD(X,0,14,196));
end;

SpliterMouse = {X=0,AW=0,LastX=0,Down=0};

function ApplySpliter(X,A,B,Spliter,W)
	local NW = math.max(50,math.min(X,W-50));

	setWidth(A,NW);
	setX(Spliter,getX(A)+NW);
	setX(B,getX(Spliter)+14);
	setWidth(B,W-NW);
end;

function FacePanelMove(X)
	SpliterMouse.LastX = X;

	if (SpliterMouse.Down == 1) then
		ApplySpliter(SpliterMouse.AW+X-SpliterMouse.X,game.ui.facepanelA.people,game.ui.facepanelA.vehicle,game.ui.facepanelA.spliter[1],getX(game.ui.facepanelA.spliter[2])-14);
		OW_SETTING_WRITE('GAME','FACE_SPLITER1',(100/getWidth(game.ui.facepanelA))*getX(game.ui.facepanelA.spliter[1]));
	else
		ApplySpliter(SpliterMouse.AW+X-SpliterMouse.X,game.ui.facepanelA.vehicle,game.ui.facepanelA.building,game.ui.facepanelA.spliter[2],getWidth(game.ui.facepanelA)-getX(game.ui.facepanelA.vehicle)-14);
		OW_SETTING_WRITE('GAME','FACE_SPLITER2',(100/getWidth(game.ui.facepanelA))*(getX(game.ui.facepanelA.spliter[2])-14));
	end;
end;

function setFacePanelMMA(VALUE)
	set_Callback(game.ui.facepanelA.ID,CALLBACK_MOUSEMOVEANY,VALUE);
end;

function setFacePanelMUA(VALUE)
	set_Callback(game.ui.facepanelA.ID,CALLBACK_MOUSEUPANY,VALUE);
end;

function SpliterMouseDown(X,ID)
	setFacePanelMMA('if (SpliterMouse.Down > 0) then FacePanelMove(%x); end;');
	setFacePanelMUA('if (SpliterMouse.Down > 0) then FacePanelMove(SpliterMouse.LastX,0); SpliterMouse.Down = 0; setFacePanelMMA(""); setFacePanelMUA(""); end;');

	SpliterMouse.X  = X+getX(game.ui.facepanelA.spliter[ID]);
	if (ID == 1) then
		SpliterMouse.AW = getWidth(game.ui.facepanelA.people);
	else
		SpliterMouse.AW = getWidth(game.ui.facepanelA.vehicle);
	end;

	SpliterMouse.Down = ID;
	FacePanelMove(SpliterMouse.X);
end;

function setFacePanel()
	local fs1 = OW_SETTING_READ_NUMBER('GAME', 'FACE_SPLITER1', 40);
	local fs2 = OW_SETTING_READ_NUMBER('GAME', 'FACE_SPLITER2', 70)-fs1;
	ApplySpliter((getWidth(game.ui.facepanelA)/100)*fs1,game.ui.facepanelA.people,game.ui.facepanelA.vehicle,game.ui.facepanelA.spliter[1],getX(game.ui.facepanelA.spliter[2])-14);
	ApplySpliter((getWidth(game.ui.facepanelA)/100)*fs2,game.ui.facepanelA.vehicle,game.ui.facepanelA.building,game.ui.facepanelA.spliter[2],getWidth(game.ui.facepanelA)-getX(game.ui.facepanelA.vehicle)-14);
end;

game.ui.logpanel = getBlankElementA(game.ui.facepanel,anchorLB);

game.ui.logpanel.log = AddElement({
	type=TYPE_TEXTBOX,
	parent=game.ui.logpanel,
	anchor=anchorLTR,
	x=0,
	y=0,
	width=game.ui.facepanel.width-13,
	height=110,
	colour1=RGB(16,31,24),
	font_name=Tahoma_13,
	wordwrap=true,
	bevel_colour1=RGB(76,148,128),
	bevel_colour2=RGB(76,148,128),
	text='',
	--edges=true,
	callback_mousedblclick='OW_LOG_DBLCLICK(%y);',
});

game.ui.logpanel.ok = AddDialogButton(DBT_NORMAL,{
	type=TYPE_IMAGEBUTTON,
	parent=game.ui.logpanel,
	anchor=anchorRB,
	x=0,
	y=game.ui.logpanel.log.height+5,
	width=150,
	height=24,
	text=loc(TID_Main_Menu_Options_OK),
	font_colour_disabled=GRAY(127),
	callback_mouseclick='setVisible(game.ui.logpanel,false);setVisible(game.ui.facepanelA,true);',
});

game.ui.logpanel.logscroll = AddElement({
	type=TYPE_SCROLLBAR,
	parent=game.ui.logpanel,
	anchor=anchorTRB,
	x=0,
	y=0,
	width=16,
	height=0,
	colour1=WHITE(),
	colour2=WHITE(),
	texture2="scrollbar.png",
	tile=true,
});

sgui_set(game.ui.logpanel.log.ID,PROP_SCROLLBAR,game.ui.logpanel.logscroll.ID);

game.ui.logpanel.hidedialogcheck = getCheckBoxEX_UI(game.ui.logpanel,anchorLT,XYWH(0,game.ui.logpanel.log.height+5,17,17),loc(TID_InGame_Msg_Hide_Dialog),{},'OW_LOGCHECK(0,getChecked(game.ui.logpanel.hidedialogcheck))',{checked=false,});
game.ui.logpanel.hideothercheck  = getCheckBoxEX_UI(game.ui.logpanel,anchorLT,XYWH(0,game.ui.logpanel.hidedialogcheck.y+17+5,17,17),loc(TID_InGame_Msg_Hide_Other),{},'OW_LOGCHECK(1,getChecked(game.ui.logpanel.hideothercheck))',{checked=false,});
game.ui.logpanel.hidehintcheck   = getCheckBoxEX_UI(game.ui.logpanel,anchorLT,XYWH(0,game.ui.logpanel.hideothercheck.y+17+5,17,17),loc(TID_InGame_Msg_Hide_Hint),{},'OW_LOGCHECK(2,getChecked(game.ui.logpanel.hidehintcheck))',{checked=false,});
--[[
game.ui.logpanel.hidedialogcheck=makeCheckBox2({
	type=TYPE_CHECKBOX,
	parent=game.ui.logpanel,
	x=0,
	y=game.ui.logpanel.log.height+5,
	width=17,
	height=17,
	callback_checked='OW_LOGCHECK(0,getChecked(game.ui.logpanel.hidedialogcheck))',
	checked=false,
	bevel=false,
	colour2=WHITE(),
},loc(TID_InGame_Msg_Hide_Dialog));

game.ui.logpanel.hideothercheck=makeCheckBox2({
	type=TYPE_CHECKBOX,
	parent=game.ui.logpanel,
	x=0,
	y=game.ui.logpanel.hidedialogcheck.y+17+5,
	width=17,
	height=17,
	callback_checked='OW_LOGCHECK(1,getChecked(game.ui.logpanel.hideothercheck))',
	checked=false,
	bevel=false,
	colour2=WHITE(),
},loc(TID_InGame_Msg_Hide_Other));

game.ui.logpanel.hidehintcheck=makeCheckBox2({
	type=TYPE_CHECKBOX,
	parent=game.ui.logpanel,
	x=0,
	y=game.ui.logpanel.hideothercheck.y+17+5,
	width=17,
	height=17,
	callback_checked='OW_LOGCHECK(2,getChecked(game.ui.logpanel.hidehintcheck))',
	checked=false,
	bevel=false,
	colour2=WHITE(),
},loc(TID_InGame_Msg_Hide_Hint));
--]]
OW_INGAMELOG_SET(game.ui.logpanel.log.ID);

game.ui.hintbar  = getBlankElementA(game.ui,anchorLB);
game.ui.hintbarL = getBlankElement(game.ui.hintbar,anchorLT);
game.ui.hintbarM = getBlankElement(game.ui.hintbar,anchorLT);
game.ui.hintbarR = getBlankElement(game.ui.hintbar,anchorLT);

game.ui.hintbarA  = getBlankElementA(game.ui.hintbar,anchorLB);

game.ui.hintbar.log = AddElement({
		type=TYPE_IMAGEBUTTON,
		parent=game.ui.hintbar,
		anchor=anchorLT,
		x=10,
		y=0,
		width=19,
		height=19,
		text='',
		texture='SGUI/'..interface.current.side..'/'..'LogButton.png',
		callback_mouseclick='setVisible(game.ui.logpanel,getVisible(game.ui.facepanelA));setVisible(game.ui.facepanelA,not getVisible(game.ui.facepanelA));',
		hint=loc(TID_InGame_Msg_Log_Button),
	});

function MakeHint(Filename)
	local ele = AddElement({
		type=TYPE_ELEMENT,
		parent=game.ui.hintbarA,
		anchor=anchorL,
		x=-1,
		y=0,
		width=19,
		height=19,
		visible=false,
		texture='SGUI/'..interface.current.side..'/'..Filename,
		overdraw=true,
	});

	sgui_bringtofront(ele.ID);

	return ele.ID;
end;

OW_HINTBAR_SET(game.ui.hintbarA.ID);

game.filmtop = AddElement({
	type=TYPE_ELEMENT,
	parent=game,
	anchor=anchorLTR,--{top=true,bottom=false,left=true,right=true},
	x=0,
	y=0,
	width=LayoutWidth,
	height=54,
	visible=false,
	colour1=BLACK(),
});

game.filmbottom = AddElement({
	type=TYPE_ELEMENT,
	parent=game,
	anchor=anchorLRB,--{top=false,bottom=true,left=true,right=true},
	x=0,
	y=0,
	width=LayoutWidth,
	height=54,
	visible=false,
	colour1=BLACK(),
});

OW_GAMEWINDOW_SET(gamewindow.ID);
OW_XICHT_SET(game.xicht.ID,game.xicht.say.ID);
OW_FILM_SET(game.filmtop.ID,game.filmbottom.ID);
OW_MINIMAP_SET(game.ui.minimap.map.ID,game.ui.minimap.map.img.ID,game.ui.minimap.map.img.corners[1].ID,game.ui.minimap.map.img.corners[2].ID,game.ui.minimap.map.img.corners[3].ID,game.ui.minimap.map.img.corners[4].ID);

function FROMOW_SHOWFILMS(VIS) -- OW CALLS THIS
	setVisible(game.filmtop,VIS);
	setVisible(game.filmbottom,VIS);

	setVisible(game.ui,not VIS);

	MMLeft=false;
	SpliterMouse.Down=0;
end;

function FROMOW_SETGAMEWINDOW(W,H,T)
        --setTag(gamewindow,T);    --set_Property(gamewindow.ID,PROP_Y,T);
	set_Property(gamewindow.ID,PROP_W,W);
	set_Property(gamewindow.ID,PROP_H,H);
end;

function setAHint(Element,HintID)
	set_Property(Element.ID,PROP_HINT,loc(HintID));
end;

function setToolbarHints()
	setAHint(game.ui.toolbtns[1],791);
	setAHint(game.ui.toolbtns[2],792);
	if (IsMultiplayer) then
		setAHint(game.ui.toolbtns[3],794);
	else
		setAHint(game.ui.toolbtns[3],793);
	end;
	setAHint(game.ui.toolbtns[4],795);
	setAHint(game.ui.toolbtns[5],796);
end;


game.HintLabel       = getLabel(game,anchorLRB,209,514,500,0,Tahoma_13B,'');
set_Property(game.HintLabel.ID,PROP_SHADOWTEXT,true);
setFontColour(game.HintLabel,RGB(250,250,250));
game.HintLabel_Timer = 0;


function FROMOW_INGAME_HINT(DATA)
--[[ DATA BREAKDOWN
        HINT String
        TIME Integer
--]]

        setText(game.HintLabel,DATA.HINT);

        local valid = (DATA.TIME > 0) and (DATA.HINT ~= '');

        setVisible(game.HintLabel,valid);

        if valid then
                game.HintLabel_Timer = AddRepeatableTimer((DATA.TIME/1000)*1.5,'setVisible(game.HintLabel,false);',game.HintLabel_Timer);
        end;
end;

game.Display_Strings = {};

for i = 1,15 do
        game.Display_Strings[i] = getLabel(game,anchorTR,ScrWidth-100,i*15+50,100,0,Tahoma_13B,'');
        setTextHAlign(game.Display_Strings[i],ALIGN_RIGHT);
        set_Property(game.Display_Strings[i].ID,PROP_SHADOWTEXT,true);
        setFontColour(game.Display_Strings[i],RGB(250,250,250));
        set_Colour(game.Display_Strings[i].ID,PROP_FONT_COL_BACK,BLACKA(127));
        set_Property(game.Display_Strings[i].ID,PROP_NOMOUSEEVT,true);
end;

function FROMOW_DISPLAY_STRINGS(DATA)
        for i = 1,15 do
                setText(game.Display_Strings[i],DATA[i]);
        end;
end;

function FROMOW_DISPLAY_STRINGS_ADJUST_TOP(DATA)
        setY(game.Display_Strings[DATA.ID],DATA.TOP+15+(DATA.ID*10));
        setX(game.Display_Strings[DATA.ID],ScrWidth-getWidth(game.Display_Strings[DATA.ID]));
end;


game.chat = getElementEX(game,anchorLB,XYWH(10,ScrHeight-300-200,500,300),true,{});
setColour1(game.chat,BLACKA(127));
setAlpha(game.chat,180);
set_Property(game.chat.ID,PROP_NOMOUSEEVTTHIS,true);

game.chat.labels = {};

for i=1,5 do
        game.chat.labels[i] = getLabel(game.chat,anchorLT,0,game.chat.height-i*15,0,15,Tahoma_13B,'');
        set_Property(game.chat.labels[i].ID,PROP_OUTLINE,true);
        setVisible(game.chat.labels[i],false);
        game.chat.labels[i].time = 0;
end;

game.chat.listbox = AddElement({
	type=TYPE_TEXTBOX,
	parent=game.chat,
	anchor={top=true,bottom=true,left=true,right=true},
	x=0+20,
	y=0,
	width=game.chat.width-12-1-20,
	height=game.chat.height-20-4,
	colour1=ListBox_Colour1,
	text="",
--        shadowtext=true,
        font_style_outline=true,
        nomouseeventthis=true,
        font_name=Tahoma_13B,
        bottomup=true,
		wordwrap=true,
});

game.chat.scroll = AddElement({
	type=TYPE_SCROLLBAR,
	parent=game.chat,
	anchor={top=true,bottom=true,left=false,right=true},
	x=game.chat.listbox.x+game.chat.listbox.width+1,
	y=game.chat.listbox.y,
	width=12,
	height=game.chat.listbox.height,
	colour1=Scrollbar_Colour1,
	colour2=Scrollbar_Colour2,
	texture2="scrollbar.png",
});

sgui_set(game.chat.listbox.ID,PROP_SCROLLBAR,game.chat.scroll.ID);

game.chat.edit = AddElement({
        type=TYPE_EDIT,
	parent=game.chat,
	anchor=anchorLRB,
	text='',
        colour1=IRCBackCol,
	autosize=false,
	bevel=true,
	bevel_colour1=GRAYA(14,200),
	bevel_colour2=GRAYA(14,200),
	gradient=true,
	gradient_colour1=GRAY(44),
	gradient_colour2=GRAY(20),
--	font_name=data,
        x=0,
	y=game.chat.listbox.height+4,
	width=getWidth(game.chat),
	height=20,
        callback_keypress='game.chat.edit.onkeypress(%k);',
});
game.chat.CheckersArea = getElementEX(game.chat,anchorLB,XYWH(0,0,20,game.chat.listbox.height),true,{colour1=RGBA(0,0,0,200), nomouseevent=false});

game.chat.CheckerAlly = getElementEX(game.chat.CheckersArea,anchorLB,XYWH(2,game.chat.CheckersArea.height-18*1,16,16),true,{--colour1=RGB(255,255,255),
	texture = "SGUI/Amer/chat_allycheck.png",subtexture=true, subcoords=SUBCOORD(0,16,16,16),  callback_mouseclick = "setChatPool(1);", hint = loc(TID_InGame_Diplomacy_Send_Allies)});
game.chat.CheckerFriends = getElementEX(game.chat.CheckersArea,anchorLB,XYWH(2,game.chat.CheckersArea.height-18*2,16,16),true,{--colour1=RGB(255,255,255),
	texture = "SGUI/Amer/chat_friendcheck.png",subtexture=true, subcoords=SUBCOORD(0,16,16,16),  callback_mouseclick = "setChatPool(2);" , hint = loc(TID_InGame_Diplomacy_Send_Friends2)});
game.chat.CheckerAll = getElementEX(game.chat.CheckersArea,anchorLB,XYWH(2,game.chat.CheckersArea.height-18*3,16,16),true,{--colour1=RGB(255,255,255),
	texture = "SGUI/Amer/chat_allcheck.png" ,subtexture=true, subcoords=SUBCOORD(0,16,16,16),  callback_mouseclick = "setChatPool(3);", hint = loc(TID_InGame_Diplomacy_Send_All)});

game.chat.CustomBorder = getElementEX(game.chat.CheckersArea,anchorLB,XYWH(0,game.chat.CheckersArea.height-18*13-4,20,18*10+2),true,{colour1=RGBA(0,0,0,0) });
game.chat.CheckerCustom = getElementEX(game.chat.CheckersArea,anchorLB,XYWH(2,game.chat.CheckersArea.height-18*4-2,16,16),true,{--colour1=RGB(255,255,255),
	texture = "SGUI/Amer/chat_customcheck.png" ,subtexture=true, subcoords=SUBCOORD(0,16,16,16),  callback_mouseclick = "setChatPool(4);", hint = loc(TID_InGame_Diplomacy_Send_Choice)});

setBorder(game.chat.CustomBorder,BORDER_TYPE_INNER,1,RGB(200,150,50) );

game.chat.Checker = {};

for i=1, 9 do
	game.chat.Checker[i] = getElementEX(game.chat.CheckersArea,anchorLB,XYWH(2,game.chat.CheckersArea.height-18*(5+i)-2,16,16),false,{colour1=SIDE_COLOURS[i],texture= "SGUI/Amer/deb_debriefbox.png",subtexture=true, subcoords=SUBCOORD(0,0,16,16), callback_mouseclick = "setCustomGroup(" .. i .. "); setChatPool(4);"});
	game.chat.Checker[i].checked = false;
end;
 --  1 = ally , 2= friends, 3 = all, 4 custom
game.chat.currentpool = 3;
game.chat.ally = {};
game.chat.friends = {};
game.chat.all = {};
game.chat.you = 0;
game.chat.custom = {};


function setChatGroups()
	OW_MULTI_GET_ATTITUDES();
	game.chat.ally = {};
	game.chat.friends = {};
	game.chat.all = {};

	for i=1, 9 do
		if usedSides[i] then
			if MULTI_ATTITUDESINFO_CURRENT[mySide][i] == 1 then --friend
				game.chat.ally[table.getn(game.chat.ally)+1] = i;
				game.chat.friends[table.getn(game.chat.friends)+1] = i;
				game.chat.all[table.getn(game.chat.all)+1] = i;
			elseif MULTI_ATTITUDESINFO_CURRENT[mySide][i] == 0 then -- neutral
				game.chat.friends[table.getn(game.chat.friends)+1] = i;
				game.chat.all[table.getn(game.chat.all)+1] = i;
			elseif MULTI_ATTITUDESINFO_CURRENT[mySide][i] == 2 then -- enemy
				game.chat.all[table.getn(game.chat.all)+1] = i;
			end;
		end;
	end;


end;

function setCustomGroup(index)
	if game.chat.Checker[index].checked == true then
		game.chat.Checker[index].checked = false;
		setSubCoords(game.chat.Checker[index],SUBCOORD(0,0,16,16));
	else
		game.chat.Checker[index].checked = true;
		setSubCoords(game.chat.Checker[index],SUBCOORD(0,16,16,16));
	end;
		game.chat.custom = {mySide};

	for i=1, 9 do
		if game.chat.Checker[i].checked == true then
			game.chat.custom[table.getn(game.chat.custom)+1] = i;
		end;
	end;

end;

function setChatPool(index)
	if iSpec then
		index = 3;
	else
		if not (index > 0 and index < 5) then
			index = game.chat.currentpool+1;
			if index >= 5 then
				index = 1;
			end;
		end;
	end;
	game.chat.currentpool = index;


	setSubCoords(game.chat.CheckerAlly,SUBCOORD(0,0,16,16));
	setSubCoords(game.chat.CheckerFriends,SUBCOORD(0,0,16,16));
	setSubCoords(game.chat.CheckerAll,SUBCOORD(0,0,16,16));
	setSubCoords(game.chat.CheckerCustom,SUBCOORD(0,0,16,16));

	switch(index) : caseof {
		[1] = function (x) setSubCoords(game.chat.CheckerAlly,SUBCOORD(0,16,16,16)); end;
		[2] = function (x) setSubCoords(game.chat.CheckerFriends,SUBCOORD(0,16,16,16)); end;
		[3] = function (x) setSubCoords(game.chat.CheckerAll,SUBCOORD(0,16,16,16)); end;
		[4] = function (x) setSubCoords(game.chat.CheckerCustom,SUBCOORD(0,16,16,16)); end;
	};


end;

function TOOW_CHAT_SET_RECIPIENTS(type)
	if type >= 1 and type <= 3 then
		setChatGroups(data)
	end;

	local HV = {};
	switch (type) : caseof {
		[1] = function (x) HV = game.chat.ally; end;
		[2] = function (x) HV = game.chat.friends; end;
		[3] = function (x) HV = game.chat.all; end;
		[4] = function (x) HV = game.chat.custom;  end;
	};
	--local HV = {game.chat.ally, game.chat.friends , game.chat.all, game.chat.custom};
	--HV = HV[type];

	switch( table.getn(HV) ) : caseof {
		[0] = function (x) return; end;
		[1] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1); end;
		[2] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1); end;
		[3] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1); end;
		[4] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1,HV[4]-1); end;
		[5] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1,HV[4]-1,HV[5]-1); end;
		[6] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1,HV[4]-1,HV[5]-1,HV[6]-1); end;
		[7] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1,HV[4]-1,HV[5]-1,HV[6]-1,HV[7]-1); end;
		[8] = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1,HV[4]-1,HV[5]-1,HV[6]-1,HV[7]-1,HV[8]-1); end;
		default = function (x) OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[1]-1,HV[2]-1,HV[3]-1,HV[4]-1,HV[5]-1,HV[6]-1,HV[7],HV[8]-1,HV[9]-1); end;
	};
	--OW_MULTI_INGAME_SETCHAT_RECIPIENTS(HV[type]);

end;


function game.chat.edit.onkeypress(key)
	if (key == 9) then
		setChatPool(0);
		return
	elseif (key == 13) then
                game.chat.close();
				TOOW_CHAT_SET_RECIPIENTS(game.chat.currentpool);
                OW_MULTI_INGAME_SENDCHATMSG(getText(game.chat.edit));
                setText(game.chat.edit,'');
                return;
	end;
        if (key == 27) then
                game.chat.close();
                return;
        end;
end;

function getChatColour(TYPE)
        return '#C'..SIDE_COLOURS_HEX[TYPE-20+1];
end;

function game.chat.labels.doAddChat(i,TEXT)
        setAlpha(game.chat.labels[i],255);
        setVisible(game.chat.labels[i],not getVisible(game.chat.listbox));
        setText(game.chat.labels[i],TEXT);
        game.chat.labels[i].time = 10;
end;

function game.chat.labels.addChat(TEXT)
        game.chat.labels[5].time = 0;

        local chatcanvis = not getVisible(game.chat.listbox);
        local j = 0;
        for j = 1,4 do
                i = 4-j+2;
                setText(game.chat.labels[i],getText(game.chat.labels[i-1]));
                local t                    = game.chat.labels[i].time;
                game.chat.labels[i].time   = game.chat.labels[i-1].time;
                game.chat.labels[i-1].time = t;
                setAlpha(game.chat.labels[i],255);
                setVisible(game.chat.labels[i],(game.chat.labels[i].time > 0) and chatcanvis);
        end;

        game.chat.labels.doAddChat(1,TEXT);

        InGameChatTick(0); -- Fix the alpha
end;

function FROMOW_ADDCHAT(DATA)
        local text = getText(game.chat.listbox);
        local chattext = getChatColour(DATA.TYPE)..DATA.TEXT;
        if text == '' then
                setText(game.chat.listbox,chattext);
        else
                setText(game.chat.listbox,text..CHAR13..chattext);
        end;

        game.chat.labels.addChat(chattext);
end;

game.chat.timer = 0;

function game.chat.openclose(VALUE)
        set_Property(game.chat.listbox.ID,PROP_BEVEL,VALUE);
        setVisible(game.chat.edit,VALUE);
        setVisible(game.chat.scroll,VALUE);
        setVisible(game.chat.listbox,VALUE);
		setVisible(game.chat.CheckersArea, VALUE);
        OW_SET_OW_IGNORE_KEYBOARD(VALUE);

        if VALUE then
                setFocus(game.chat.edit);
                setColour1(game.chat,BLACKA(127));
                for i=1,5 do
                        setVisible(game.chat.labels[i],false);
                end;
        else
                clearFocus();
                setColour1(game.chat,BLACKA(0));
                for i=1,5 do
                        if (getText(game.chat.labels[i]) ~= '') then
                                setVisible(game.chat.labels[i],true);
                        end;
                end;
        end;
end;

function game.chat.show()
        game.chat.openclose(true);
end;

function game.chat.close()
        game.chat.openclose(false);
end;

function game.chat.setup(MULTIPLAYER)
        setY(game.chat,ScrHeight-300-250);
        game.chat.close();
        setText(game.chat.listbox,'');
        setText(game.chat.edit,'');
        for i=1,5 do
                setText(game.chat.labels[i],'');
                setVisible(game.chat.labels[i],false);
                setAlpha(game.chat.labels[i],255);
                game.chat.labels[i].time = 0;
        end;
        setVisible(game.chat,MULTIPLAYER);
end;

function FROMOW_SHOWCHAT()
        game.chat.timer = AddRepeatableTimer(0.1,'game.chat.show();',game.chat.timer);
end;

function debugIngameChat(Text)
	OW_MULTI_INGAME_SETCHAT_RECIPIENTS(mySide-1);
	OW_MULTI_INGAME_SENDCHATMSG(Text);
end;

game.pinginfo = getElementEX(game,anchorNone,XYWH(LayoutWidth/2-150/2,LayoutHeight/2-240/2,150,240),false,{colour1=BLACKA(20),nomouseevent=true});
game.pinginfo.labels = {};
game.pinginfo.lastupdate = 0;

for i=1,12 do
	game.pinginfo.labels[i] = getLabelEX(game.pinginfo,anchorLT,XYWH(0,20*(i-1),getWidth(game.pinginfo),20),Tahoma_13,'',{});
end;

game.multistats = getElementEX(game,anchorNone,XYWH(LayoutWidth/2-200/2,LayoutHeight/2-260/2,200,260),false,{colour1=WHITEA(50),nomouseevent=true});
game.multistats.labels = {};
game.multistats.lastupdate = 0;

for i=1,8 do
	game.multistats.labels[i] = getLabelEX(game.multistats,anchorLT,XYWH(0,100+20*(i-1),getWidth(game.multistats),20),Tahoma_13,'',{font_colour=BLACK()});
end;

game.multistats.graph = getElementEX(game.multistats,anchorLT,XYWH(10,0,180,100),true,{colour1=WHITE(),nomouseevent=true});
game.multistats.graph.maxlabels = {};

for i=1,2 do
	game.multistats.graph.maxlabels[i] = getLabelEX(game.multistats,anchorLT,XYWH(getX(game.multistats.graph)+getWidth(game.multistats.graph),20*(i-1),20,20),Tahoma_13,'',{font_colour=BLACK()});
end;

MULTI_PLAYERINFO_CURRENT = {};
MULTI_PLAYERINFO_CURRENT_PLID = {};
function FROMOW_MULTI_PLAYERINFO(DATA)
--[[
	COUNT		Integer
	DATA	[1..12] (COUNT)
		NAME		STRING
		SIDE		Integer
		PING		Integer
		COLOUR		Integer
		PLID		Integer
		NATION		Integer
		ISCOMP		BOOL
		ISSPEC		BOOL
		ISDEDI		BOOL
		TEAM		Integer
		TEAMPOS		Integer
		ALIVE		BOOL
		NORESPONCE	BOOL
		LOADED		BOOL
		ISSERVER    BOOL

--]]
--[[
	for i=1,12 do
		setVisible(game.pinginfo.labels[i],false);
	end;

	for i=1,DATA.COUNT do
		setText(game.pinginfo.labels[i],DATA.DATA[i].NAME..' '..DATA.DATA[i].PING);
		setVisible(game.pinginfo.labels[i],true);
	end;

	setVisible(game.pinginfo,true);
	-]]

	MULTI_PLAYERINFO_CURRENT = DATA.DATA;
	MULTI_PLAYERINFO_CURRENT_PLID = {};
	for i=1,DATA.COUNT do
		MULTI_PLAYERINFO_CURRENT_PLID[DATA.DATA[i].PLID] = DATA.DATA[i];
	end;
	MULTI_PLAYERINFO_CURRENT.COUNT = DATA.COUNT;
	if loading.State == true then
		for i=1,DATA.COUNT do
			if loadingPlayers[i] then
				if DATA.DATA[i].LOADED or DATA.DATA[i].ISCOMP then
					if loadingPlayers[i].LoadingBar then
						sgui_set(loadingPlayers[i].LoadingBar.ID,PROP_PROGRESS,100);
					end;
				end;
--					setColour1(loadingPlayers[i],SIDE_COLOURS[DATA.DATA[i].COLOUR+1]);
			end;
		end;
	end;
end;

game.multistats.labeltitles = {'Server Packet Recieved:','Server Packet Sent:','Server Bytes Recieved:','Server Bytes Sent:',
			       'Client Packet Recieved:','Client Packet Sent:','Client Bytes Recieved:','Client Bytes Sent:'};

function game.multistats.setLabel(ID,VALUE)
	if VALUE ~= nil then
        	setText(game.multistats.labels[ID],game.multistats.labeltitles[ID]..' '..VALUE);
        else
        	setText(game.multistats.labels[ID],game.multistats.labeltitles[ID]..' '..'0');
        end;
end;

function game.multistats.drawGridLine(ID,X1,X2,V1,V2,MAX,COLOUR)
	CTAPI_drawLine(ID,X1,(V1/MAX)*100,X2,(V2/MAX)*100,COLOUR);
end;

function game.multistats.drawGridLines(ID,X1,X2,DATA1,DATA2,MAXS)
	game.multistats.drawGridLine(ID,X1,X2,DATA1.SERVER_PACK_REC,DATA2.SERVER_PACK_REC,MAXS.SERVER_PACK_REC,RGB(200,0,0));
        game.multistats.drawGridLine(ID,X1,X2,DATA1.SERVER_BYTE_REC,DATA2.SERVER_BYTE_REC,MAXS.SERVER_BYTE_REC,RGB(0,200,0));
end;

function ByteToSize(VALUE)
	if VALUE < 1024 then
        	return VALUE..'B';
        end;
        VALUE = VALUE/1024;
        if VALUE < 1024 then
        	return VALUE..'KB';
        end;
        VALUE = VALUE/1024;
        if VALUE < 1024 then
        	return VALUE..'MB';
        end;
end;

function game.multistats.drawGrid(DATA,ELEMENT)
	if DATA.ID == -1 then
        	DATA.ID = CTAPI_newTexture(180,100);
                CTAPI_updateTexture(DATA.ID);
                CTAPI_setElementTexture(DATA.ID,ELEMENT);
        end;

        CTAPI_drawBox(DATA.ID,0,0,180,100,BLACKA(200));

        local toData = {};

        local minmax = {SERVER_PACK_REC=0,SERVER_BYTE_REC=0};

        for i=1,DATA.COUNT do
        	if DATA.DATA[i].SERVER_PACK_REC > minmax.SERVER_PACK_REC then
                	minmax.SERVER_PACK_REC = DATA.DATA[i].SERVER_PACK_REC;
                end;

                if DATA.DATA[i].SERVER_BYTE_REC > minmax.SERVER_BYTE_REC then
                	minmax.SERVER_BYTE_REC = DATA.DATA[i].SERVER_BYTE_REC;
                end;
        end;

        minmax.SERVER_PACK_REC = minmax.SERVER_PACK_REC + 20;
        minmax.SERVER_BYTE_REC = minmax.SERVER_BYTE_REC + 0;

        setText(game.multistats.graph.maxlabels[1],minmax.SERVER_PACK_REC);
        setText(game.multistats.graph.maxlabels[2],ByteToSize(minmax.SERVER_BYTE_REC));

        for i=1,DATA.COUNT do
        	if i < DATA.COUNT then
                	toData = DATA.DATA[i+1]
         	else
                	toData = DATA.DATA[i];
                end;

                game.multistats.drawGridLines(DATA.ID,(i-1)*3,(i)*3,DATA.DATA[i],toData,minmax);
        end;

        CTAPI_updateTexture(DATA.ID);
end;

game.multistats.gridData       = {ID=-1,COUNT=0,DATA={}};

function game.multistats.addGridData(DATA)
	local NEWDATA = copytable(DATA);
	if game.multistats.LASTDATA ~= nil then
		NEWDATA.SERVER_PACK_REC = NEWDATA.SERVER_PACK_REC-game.multistats.LASTDATA.SERVER_PACK_REC;
                NEWDATA.SERVER_BYTE_REC = NEWDATA.SERVER_BYTE_REC-game.multistats.LASTDATA.SERVER_BYTE_REC;
        end;

	if game.multistats.gridData.COUNT < 60 then
        	game.multistats.gridData.COUNT = game.multistats.gridData.COUNT + 1;
        	game.multistats.gridData.DATA[game.multistats.gridData.COUNT] = NEWDATA;
	else
        	for i=1,59 do
                	game.multistats.gridData.DATA[i] = game.multistats.gridData.DATA[i+1];
                end;

                game.multistats.gridData.DATA[60] = NEWDATA;
        end;
end;

function game.multistats.showStats()
	game.multistats.gridData.COUNT = 0;
	game.multistats.gridData.DATA  = {};
        setVisible(game.multistats,true);
end;

game.multistats.LASTDATA = nil;

function FROMOW_MULTI_STATS(DATA)
--[[
 SERVER_PACK_REC
 SERVER_PACK_SEN
 SERVER_BYTE_REC
 SERVER_BYTE_SEN

 CLIENT_PACK_REC
 CLIENT_PACK_SEN
 CLIENT_BYTE_REC
 CLIENT_BYTE_SEN
--]]

	game.multistats.addGridData(DATA);

        game.multistats.setLabel(1,DATA.SERVER_PACK_REC);
        game.multistats.setLabel(2,DATA.SERVER_PACK_SEN);
        game.multistats.setLabel(3,DATA.SERVER_BYTE_REC);
        game.multistats.setLabel(4,DATA.SERVER_BYTE_SEN);
        game.multistats.setLabel(5,DATA.CLIENT_PACK_REC);
        game.multistats.setLabel(6,DATA.CLIENT_PACK_SEN);
        game.multistats.setLabel(7,DATA.CLIENT_BYTE_REC);
        game.multistats.setLabel(8,DATA.CLIENT_BYTE_SEN);

        game.multistats.drawGrid(game.multistats.gridData,game.multistats.graph);

	setVisible(game.multistats,true);

        game.multistats.LASTDATA = DATA;
end;

regTickCallback('Multiplayer_STATS(%frametime);');


function Multiplayer_STATS(FRAMETIME)

	if getVisible(game.pinginfo) then
		game.pinginfo.lastupdate = game.pinginfo.lastupdate + FRAMETIME;
	        if game.pinginfo.lastupdate >= 1 then
        		game.pinginfo.lastupdate = 0;
        	        OW_MULTI_GET_PLAYERINFO();
	        end;
        end;

        if getVisible(game.multistats) then
		game.multistats.lastupdate = game.multistats.lastupdate + FRAMETIME;
	        if game.multistats.lastupdate >= 1 then
        		game.multistats.lastupdate = 0;
        	        OW_MULTI_GET_STATS();
	        end;
        end;

	if loading.State == true then
		OW_MULTI_GET_PLAYERINFO();
	end;
end;

--OW_MULTI_GET_PLAYERINFO
--OW_MULTI_GET_STATS


function InGameChatTick(FrameTime)
        for i=1,5 do
                if game.chat.labels[i].time > 0 then
                        game.chat.labels[i].time = game.chat.labels[i].time - FrameTime;
                        if game.chat.labels[i].time <= 0 then
                                setVisible(game.chat.labels[i],false);
                                setText(game.chat.labels[i],'');
                                setAlpha(game.chat.labels[i],255);
                        else
                                if game.chat.labels[i].time < 1 then
                                        setAlpha(game.chat.labels[i],255*game.chat.labels[i].time);
                                end;
                        end;
                end;
        end;
end;

function FROMOW_SETSPEED(MAX,POSITION)
        if game.ui.commpanel1.speed.MAX ~= MAX-1 then
                SetSliderElementMINMAX(game.ui.commpanel1.speed.SliderIndex,0,MAX-1);
        end;
        game.ui.commpanel1.speed.POS = POSITION-1;
        SetSliderElementPos(game.ui.commpanel1.speed.SliderIndex);
end;

function DoInterfaceChange_Game()
	uisettings = interface.current.game.ui;
	UpdateToolBtns(game.ui.toolbtns,uisettings.toolBtns);
	setInterfaceTexture(game.ui.toolbar,'toolbar.png');
	setWHV(game.ui.toolbar,uisettings.toolBar.X,uisettings.toolBar.Y);

	setInterfaceTexture(game.ui.toolbar.pause,'ToolBar_button_pause.png');

	setXYWH(game.ui.toolbar.pause,uisettings.pause);

	setInterfaceTexture(game.ui.minimap,'MiniMap.png');
	setXYWHV(game.ui.minimap,ScrWidth-uisettings.minimap.BACK.X,ScrHeight-uisettings.minimap.BACK.Y,uisettings.minimap.BACK.X,uisettings.minimap.BACK.Y);

	setXYWH(game.ui.minimap.map,uisettings.minimap.MAP);

	set_Colour(game.ui.minimap.map.img.ID,PROP_BORDER_COLOUR,uisettings.minimap.COLOUR);

	setInterfaceTexture(game.ui.infopanel,'InfoPanel.png');
	set_Property(game.ui.infopanel.ID,PROP_Y,ScrHeight-uisettings.infopanel.Y);
	setWHV(game.ui.infopanel,uisettings.infopanel.X,uisettings.infopanel.Y);

	set_Property(game.filmtop.ID,PROP_H,uisettings.toolBar.Y);
	set_Property(game.filmbottom.ID,PROP_H,uisettings.minimap.BACK.Y);
	set_Property(game.filmbottom.ID,PROP_Y,ScrHeight-uisettings.minimap.BACK.Y);

	setXYWHV(game.ui.commpanel,getElementRight(game.ui.infopanel),ScrHeight-uisettings.commpanel[5],uisettings.commpanel[4],uisettings.commpanel[5]);
	setWHV(game.ui.commpanel1,uisettings.commpanel[4],uisettings.commpanel[5]);
	setWHV(game.ui.commpanel2,uisettings.commpanel[4],uisettings.commpanel[5]);
	setWHV(game.ui.commpanel3,uisettings.commpanel[4],uisettings.commpanel[5]);

	setInterfaceTexture(game.ui.commpanel1,uisettings.commpanel[1]);
	setInterfaceTexture(game.ui.commpanel2,uisettings.commpanel[2]);
	setInterfaceTexture(game.ui.commpanel3,uisettings.commpanel[3]);

        setXY(game.ui.commpanel1.undo,uisettings.undobutton.X,getHeight(game.ui.commpanel1)-uisettings.undobutton.Y-getHeight(game.ui.commpanel1.undo));
        setXY(game.ui.commpanel1.redo,getWidth(game.ui.commpanel1)-uisettings.redobutton.X-getWidth(game.ui.commpanel1.redo),getHeight(game.ui.commpanel1)-uisettings.redobutton.Y-getHeight(game.ui.commpanel1.redo));

        setXY(game.ui.commpanel1.speed,22-16-5,getHeight(game.ui.commpanel1)-uisettings.speed.Y-16);
        setWH(game.ui.commpanel1.speed.slider,uisettings.speed.X,16);

	setVisible(game.ui.commpanel1,true);
	setVisible(game.ui.commpanel2,false);
	setVisible(game.ui.commpanel3,false);

        local cp2h = getHeight(game.ui.commpanel2);

        setXY(game.ui.commpanel2.weapon,12+uisettings.combooff,cp2h-6-(20*4));
        setXY(game.ui.commpanel2.chassis,12+uisettings.combooff,cp2h-6-(20*3));
        setXY(game.ui.commpanel2.control,12+uisettings.combooff,cp2h-6-(20*2));
        setXY(game.ui.commpanel2.engine,12+uisettings.combooff,cp2h-6-(20*1));

        setXY(game.ui.commpanel3.weapon,12+uisettings.combooff,cp2h-36);

	for c = 1, 9 do
		setVisible(game.ui.commpanel.buttons[c],false);
		set_Property(game.ui.commpanel.buttons[c].ID,PROP_TEXTURE,uisettings.buttons);

		setXYWHV(game.ui.commpanel.buttons[c],uisettings.commBtns[1]+math.mod((c-1),3)*(uisettings.commBtns[3]+1),uisettings.commBtns[2]+math.floor((c-1)/3)*(uisettings.commBtns[4]+1),uisettings.commBtns[3],uisettings.commBtns[4]);
	end;

	setXYWHV(game.ui.facepanel,getElementRight(game.ui.commpanel),ScrHeight-uisettings.facepanel[3],getX(game.ui.minimap)-getElementRight(game.ui.commpanel),uisettings.facepanel[3]);

	setWHV(game.ui.facepanelL,uisettings.facepanel[1],uisettings.facepanel[3]);
	setXYWHV(game.ui.facepanelM,uisettings.facepanel[1],0,getWidth(game.ui.facepanel)-uisettings.facepanel[1]-uisettings.facepanel[2],uisettings.facepanel[3]);
	setXYWHV(game.ui.facepanelR,getWidth(game.ui.facepanel)-uisettings.facepanel[2],0,uisettings.facepanel[2],uisettings.facepanel[3]);

	set_Property(game.ui.facepanelM.ID,PROP_TILE,true);

	setInterfaceTexture(game.ui.facepanelL,'FacePanelL.png');
	setInterfaceTexture(game.ui.facepanelM,'FacePanel.png');
	setInterfaceTexture(game.ui.facepanelR,'FacePanelR.png');

	setXYWHV(game.ui.hintbar,getX(game.ui.commpanel),getY(game.ui.facepanel)-uisettings.hintbar[3],getX(game.ui.minimap)-getX(game.ui.commpanel),uisettings.hintbar[3]);
	setWHV(game.ui.hintbarL,uisettings.hintbar[1],uisettings.hintbar[3]);
	setXYWHV(game.ui.hintbarM,uisettings.hintbar[1],0,getWidth(game.ui.hintbar)-uisettings.hintbar[1]-uisettings.hintbar[2],uisettings.hintbar[3]);
	setXYWHV(game.ui.hintbarR,getWidth(game.ui.hintbar)-uisettings.hintbar[2],0,uisettings.hintbar[2],uisettings.hintbar[3]);

	setXYWHV(game.ui.hintbarA,uisettings.hintbar[4].X+20,uisettings.hintbar[4].Y,getWidth(game.ui.hintbar)-uisettings.hintbar[4].X-20,19);

	set_Property(game.ui.hintbarM.ID,PROP_TILE,true);

	setInterfaceTexture(game.ui.hintbarL,'hintbarL.png');
	setInterfaceTexture(game.ui.hintbarM,'hintbarM.png');
	setInterfaceTexture(game.ui.hintbarR,'hintbarR.png');

	setXYWHV(game.ui.facepanelA,uisettings.facearea.X,uisettings.facearea.Y,getWidth(game.ui.facepanel)-(uisettings.facearea.X*2),getHeight(game.ui.facepanel)-(uisettings.facearea.Y*2));
	setXYWHV(game.ui.logpanel,getX(game.ui.facepanelA)+5,getY(game.ui.facepanelA)+3,getWidth(game.ui.facepanelA)-10,getHeight(game.ui.facepanelA));

	setWidth(game.ui.logpanel.log,getWidth(game.ui.logpanel)-uisettings.scrollsize-1);

        setX(game.ui.logpanel.ok,getWidth(game.ui.logpanel)-150-10);

	setXYWHV(game.ui.logpanel.logscroll,getElementRight(game.ui.logpanel.log)+1,0,uisettings.scrollsize,getHeight(game.ui.logpanel.log));


	setInterfaceTexture(game.ui.facepanelA.spliter[1],'sliders.png');
	setInterfaceTexture(game.ui.facepanelA.spliter[2],'sliders.png');

	setSpliterCoords(1,0);
	setSpliterCoords(2,0);

	local FPW = getWidth(game.ui.facepanelA);
	local FPH = getHeight(game.ui.facepanelA);

	setXYWHV(game.ui.facepanelA.spliter[1],FPW-400,0,14,FPH);
	setXYWHV(game.ui.facepanelA.spliter[2],FPW-200,0,14,FPH);

	setXYWHV(game.ui.facepanelA.people,0,0,FPW-400,FPH);
	setXYWHV(game.ui.facepanelA.vehicle,FPW-400+14,0,200-14,FPH);
	setXYWHV(game.ui.facepanelA.building,FPW-200+14,0,200-14,FPH);

	setFacePanel();

	setXYV(game.ui.hintbar.log,getX(game.ui.hintbarA)-20,uisettings.hintbar[4].Y);
	setInterfaceTexture(game.ui.hintbar.log,'LogButton.png');

    setInterfaceTexture1n2(game.ui.logpanel.logscroll,'scrollbar_back_v.png','scrollbar.png');

	setInterfaceTexture1n2(game.ui.logpanel.hidedialogcheck,'checkbox_unchecked.png','checkbox_checked.png');
	setInterfaceTexture1n2(game.ui.logpanel.hideothercheck,'checkbox_unchecked.png','checkbox_checked.png');
	setInterfaceTexture1n2(game.ui.logpanel.hidehintcheck,'checkbox_unchecked.png','checkbox_checked.png');

	setBevelCol(game.ui.logpanel.log,uisettings.boxcols.border,uisettings.boxcols.border);
	setColour1(game.ui.logpanel.log,uisettings.boxcols.background);
	setBorderColour(floating_hint,uisettings.boxcols.border);

	DoInterfaceChange_Game_ResourceBar();
	local Idip = uisettings.dip;
	for _, v in pairs(DipSides.SideCards ) do
		setTexture(v, Idip.frame);
	end;
	setTexture (game.ui.dip_request.left, Idip.left_req);
	setTexture (game.ui.dip_request.right, Idip.right_req);
	setTexture (game.ui.dip_request.middle, Idip.back_req);

	setWHV(game.ui.altFac,getWidth(game.ui.facepanel)-14,getHeight(game.ui.facepanel));
	setWHV(game.ui.altFac.componentsArea,getWidth(game.ui.altFac)-95,getHeight(game.ui.altFac));
	setXYWHV(game.ui.altFac.unitsArea,getWidth(game.ui.altFac.componentsArea),0,95,getHeight(game.ui.altFac));
	setTexture(game.ui.altFac.componentsArea.chassisArea_ScrollH,'/SGUI/'..interface.current.side..'/scrollbar.png');
	setTexture(game.ui.altFac.componentsArea.weaponsArea_ScrollH,'/SGUI/'..interface.current.side..'/scrollbar.png');
	setTexture(game.ui.altFac.componentsArea.controlsAndEnginesArea_ScrollH,'/SGUI/'..interface.current.side..'/scrollbar.png');

	--chat
	setTexture ( game.chat.CheckerAll, uisettings.chat.allcheckbox );
	setTexture ( game.chat.CheckerFriends , uisettings.chat.friendcheckbox );
	setTexture ( game.chat.CheckerAlly, uisettings.chat.allycheckbox );
	setTexture ( game.chat.CheckerCustom , uisettings.chat.customcheckbox );

	for i=1, 9 do
		setTexture ( game.chat.Checker[i], uisettings.chat.sidecheckbox );
	end;

	sgui_forcetextures(game.ui.ID);
end;
