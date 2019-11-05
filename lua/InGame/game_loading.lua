loading       = getElementEX(nil,    anchorLTRB,XYWH(0,0,LayoutWidth,LayoutHeight),false,{colour1=BLACK(),});

function loading.doEnterGame()
        setVisible(game,true);
        setVisible(loading,false);
	loading.State = false;
end;


loading.State = false;
loading.img   = getElementEX(loading,anchorNone,XYWH(0,0,LayoutWidth,LayoutHeight),true,{colour1=WHITE(),});

loading_name  = getLabelEX(loading.img,anchorLTRB,XYWH(28,35,400,25),Trebuchet_20,'',{wordwrap=true, nomouseevent=true,});
loading_coord = getLabelEX(loading.img,anchorLTRB,XYWH(28,70,400,25),Trebuchet_20,'',
                           {wordwrap=true, nomouseevent=true, text_halign=ALIGN_LEFT, text_valign=ALIGN_TOP,});

loading_brief = getLabelEX(loading.img,anchorLTRB,XYWH(781,572,205,168),Tahoma_13,'',
                           {wordwrap=true, nomouseevent=true, text_halign=ALIGN_MIDDLE, text_valign=ALIGN_MIDDLE,});
loading_text  = getLabelEX(loading.img,anchorLTRB,XYWH(0,696,loading.width,30),Tahoma_30B,loc(TID_Multi_Loading),
                           {wordwrap=true, nomouseevent=true, text_halign=ALIGN_MIDDLE,shadowtext=true,});
loading_phase = getLabelEX(loading.img,anchorLTRB,XYWH(0,696+30,loading.width,20),Trebuchet_20,'',
                           {wordwrap=true, nomouseevent=true, text_halign=ALIGN_MIDDLE,shadowtext=true,});


loading.textName  = getLabelEX(loading.img,anchorLTRB,XYWH(0,10,loading.width,30),Tahoma_30B,loc(loc(TID_InGame_NoName)),{wordwrap=true, nomouseevent=true, text_halign=ALIGN_MIDDLE,shadowtext=true,});
loading.textGameType  = getLabelEX(loading.img,anchorLTRB,XYWH(0,40,loading.width,30),Tahoma_20B,loc(loc(TID_InGame_NoName)),{wordwrap=true, nomouseevent=true, text_halign=ALIGN_MIDDLE,shadowtext=true,});

loading.players   = getElementEX(loading,anchorLTRB,XYWH(0,0,getWidth(loading),getHeight(loading)),true,{colour1=WHITEA(0),});

loadingPlayers = {};
LDIR_LEFT = 1;
LDIR_RIGHT = 2;
function makeLoadingPlayer(ID,Y,DIR, TCOLOUR)
	local player = Players[ID];
	local X = 0;
	local nationX = 2+52+2;
	local nameX = 2+52+2+40+2;
	local avatarX = 2;
	local posX = 2+52+2+40+2;
	local textAling = ALIGN_LEFT;
--	local colour = SIDE_COLOURS[player.Colour+1];
--	if TCOLOUR then
--		if player.IsSpec then
--			TCOLOUR = SIDE_COLOURS[1];
--		else
			--TCOLOUR = SIDE_COLOURS[TCOLOUR+1];
			TCOLOUR = SIDE_COLOURS[MULTI_PLAYERINFO_CURRENT_PLID[ID].COLOUR+1];
--		end;
--	else
--		TCOLOUR = SIDE_COLOURS[player.Colour+1];
--	end;

	if DIR == LDIR_RIGHT then
		X = getWidth(loading) - 300;
		nationX = 300-(2+52+2+38);
		nameX = 300-(2+52+2+20+2+180+20);
		avatarX = 300-(2+52);
		posX = 300-(2+52+2+20+2+180+20);
		textAling = ALIGN_RIGHT;
	end;


	local p = getElementEX(
		loading.players,
		anchorLT,
		XYWH(
			X,
			Y,
			300,
			80
		),
		true,
		{
			colour1=BLACKA(50),
			gradient_colour1=RGBA(TCOLOUR.red,TCOLOUR.green,TCOLOUR.blue,200),
			gradient_colour2=RGBA(TCOLOUR.red,TCOLOUR.green,TCOLOUR.blue,20),
			gradient=true,
			edges=true,
		}
	);

	p.avatar = getElementEX(
		p,
		anchorLT,
		XYWH(
			avatarX,
			2,
			52,
			65
		),
		true,
		{
			colour1=WHITEA(255),
			edges=true,
			texture = 'Avatars/unknow.png',
		}
	);

	if player.AVATARTEX > 0 then
		SGUI_settextureid(p.avatar.ID,player.AVATARTEX,80,100,80,100);
	end;

	p.Name = getLabelEX(
		p,
		anchorLT,
		XYWH(
			nameX,
			5,
			180,
			20
		),
		Tahoma_20B,
		player.Name,
		{
			wordwrap=true,
			nomouseevent=true,
			scissor = true,
			font_colour= TCOLOUR,
			text_halign=textAling,
			shadowtext=true,
		}
	);

	if not player.IsSpec then

		local NTex = MultiDef.NationsIcons[player.Nation+1];

		if (MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1] ~= nil) then
			if (MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1][player.Nation+1] ~= nil) then
				if (MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1][player.Nation+1].TEAMS ~= nil) and MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1][player.Nation+1].TEAMS ~= false then
					if (MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1][player.Nation+1][player.Team+1] ~= nil) then
						NTex = MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1][player.Nation+1][player.Team+1].ICON;
						end;
				else
					NTex = MultiDef.MultiMap.MODIFEDNATIONS[player.Side+1][player.Nation+1].ICON;
				end;
			end;
		end;
		p.NationShadow = getElementEX(
			p,
			anchorLT,
			XYWH(
				nationX-1,
				5+1,
				38,
				38
			),
			true,
			{
				colour1=BLACKA(255),
				texture=NTex;
				shadowtext=true,
			}
		);

		p.Nation = getElementEX(
			p,
			anchorLT,
			XYWH(
				nationX,
				5,
				38,
				38
			),
			true,
			{
				colour1=WHITEA(255),
				texture=NTex;
				shadowtext=true,
			}
		);


		local SText = loc(TID_Multi_Random) ;
		if player.Side > 0 then
			SText = MultiDef.SideDef[player.Side].NAME;
		end;

		p.Pos = getLabelEX(
			p,
			anchorLT,
			XYWH(
				posX,
				5+30,
				180,
				20
			),
			Tahoma_13B,
			SText,
			{
				wordwrap=true,
				nomouseevent=true,
				scissor = true,
				text_halign=textAling,
				shadowtext=true,
			}
		);

	end;

	p.LoadingBar = getProgressBarEX_NoLabel(
		p,
		anchorLT,
		XYWH(
			5,
			getHeight(p)-12,
			getWidth(p)-10,
			10
		),
		{
			nomouseevent=NoME,
			bevel=false,
			colour1=GRAY(60),
			colour2= TCOLOUR,
			minmax={min=0,max=100},
			progress=10,
			border_size=1,
			border_type=BORDER_TYPE_OUTER,
			border_colour=GRAY(5),
		}
	);

	return p;

end;


function FROMOW_SETLOADIMAGE(filename)
	setTexture(loading.img,filename);
	setVisible(loading,true);
	setVisible(menu,false);

	resetScorebar()
	loadingPlayers = {};
	sgui_deletechildren(loading.players.ID);

	if getvalue(OWV_MULTIPLAYER) then

		setText(loading.textName, MultiDef.MapName.MAPLOC);
		setText(loading.textGameType, MultiDef.MapName.GAMETYPELOC);
--		if ifTeams then
			if odd(loadingTeamsCount) then
				loadingTeamsCount=loadingTeamsCount+1;
			end;
			OW_MULTI_GET_PLAYERINFO();

			local teamSpace = getHeight(loading.players) / (loadingTeamsCount/2);
			local currentTeam = 1;
			local teamLine = 0;
			for i=1, 9 do

				if loadingTCount[i] > 0 then

					local line=0;
					local baseY = 0;
					local dir = LDIR_RIGHT ;
					local yTeamPos=0;
					local X = getWidth(loading) - 300;
					local textAling = ALIGN_RIGHT ;
					local tName = 'Unknow';
					local teamTex = 'SGUI/gradient_right.png';
					local teamTexX = 150;

					if odd(currentTeam) then
						dir = LDIR_LEFT;
						teamLine = teamLine +1;
						X = 0;
						textAling = ALIGN_LEFT;
						teamTex = 'SGUI/gradient_left.png';
						teamTexX = 0;
					end;

					yTeamPos = teamSpace * (teamLine-1) + teamSpace/2;

					if odd(loadingTCount[i]) then
						baseY = -(90/2) - roundup(loadingTCount[i]/2) *90 + 90;
					else
						baseY = -90 - roundup(loadingTCount[i]/2) *90 + 90;
					end;

					if ifTeams then
						if i == 9 then
							tName = loc(TID_Multi_IsSpec);
						else
							tName = MultiDef.TeamDef[i+1].NAME;
						end;

						getLabelEX(loading.players,
							anchorLT,
							XYWH(
								X,
								yTeamPos+baseY-20,
								300,
								20),
							Tahoma_20B,
							tName,
							{
								wordwrap=false,
								nomouseevent=true,
								text_halign=textAling,
							}
						);

						getElementEX(loading.players,
							anchorLT,
							XYWH(
								X + teamTexX,
								teamSpace*(teamLine-1),
								150,
								teamSpace
							),
							true,
							{
								colour1=RGBA(TEAM_COLOURS[i].red,TEAM_COLOURS[i].green,TEAM_COLOURS[i].blue,80),--TEAM_COLOURS[i],
								texture=teamTex,
							}
						);
					end;

					for p=1, loadingTCount[i] do

						loadingPlayers[loadingTeam[i][p]] = makeLoadingPlayer(loadingTeam[i][p],yTeamPos +baseY + line*90, dir, nil);
						line=line+1;
					end;

					currentTeam = currentTeam+1;
				end;
			end;
--[[		else
			local line=0;
			local baseY = 0;

			if odd(roundup(loadingACount/2)) then
				baseY = -(80/2) - roundup(loadingACount/4) *100 + 100;
			else
				baseY = -100 - roundup(loadingACount/4) *100 + 100;
			end;

			for i=1, loadingACount do

				local dir = LDIR_RIGHT;
				if odd(i) then
					dir = LDIR_LEFT;
				end;

				loadingPlayers[loadingAlones[i] ] = makeLoadingPlayer(loadingAlones[i],(getHeight(loading.players)/2) + baseY + line*100, dir, nil);

				if not odd(i) then
					line = line+1;
				end;


			end;
		end;--]]
		initalizeDiplomacy();
	else
		setText(loading.textName, '');
		setText(loading.textGameType, '');
                PauseOW(true);
	end;
	loading.State = true;
end;

function FROMOW_LOADINGEND()
        setColour1(gamewindow,BLACK()); -- Hide it until a new frame is done! (Game changes it to WHITE)
	setToolbarHints();

        setVisible(game.ui.logpanel,false);
        setVisible(game.ui.facepanelA,true);
        setVisible(game.ui.infopanel.inner,false);

        local ismulti = getvalue(OWV_MULTIPLAYER);

        game.chat.setup(ismulti);

        setVisible(game.ui.commpanel1.speed,(not ismulti) or (ismulti and getvalue(OWV_IAMSERVER)));

	if not ismulti then
	   setText(loading_text, '');
           setText(loading_phase, loc(4001));

           set_Callback(0, CALLBACK_KEYPRESS, 'pressToContinueCallback(%k)');
	end;

end;

function pressToContinueCallback(key)
        if (key == 32 and loading.State and (getvalue(OWV_MULTIPLAYER)) == false) then
           loading_wait_for();
        end;
end;

function loading_wait_for()
        setColour1(gamewindow,BLACK()); -- Hide it until a new frame is done! (Game changes it to WHITE)
	setToolbarHints();
        setVisible(game.ui.logpanel,false);
        setVisible(game.ui.facepanelA,true);
        setVisible(game.ui.infopanel.inner,false);

        game.chat.setup(false);

        loading.doEnterGame();
end;

function PauseOW(VALUE)
        if VALUE ~= getVisible(gamewindow.pause) then
           OW_PAUSE();
        end;
end;

function FROMOW_SETLOADINGPHASE(ID)
	setText(loading_phase,loc(ID));
end;

function FROMOW_SETLOADINGTEXT(Side,Name,Coord,Brief)
        setXYWH(loading_name,Loading_SidePos[Side].Name);
	setXYWH(loading_coord,Loading_SidePos[Side].Coord);
	setXYWH(loading_brief,Loading_SidePos[Side].Brief);

	setText(loading_name,Name);
	setText(loading_coord,Coord);
	setText(loading_brief,Brief);

	setText(loading_text,loc(TID_Multi_Loading));
end;
