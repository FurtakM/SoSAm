dialog.team_select=AddSkinEle_Tex(getElement(dialog.back,anchorNone,1024,768,false),'1024team_select.png');

dialog.team_select.caption     = getLabelEX(dialog.team_select,anchorLTR,XYWH(0,18,320,39),Trebuchet_20,loc(TID_Other_Team_select_Title),
                                            {shadowtext=true,wordwrap=true,font_colour=RGB(200,50,50),text_halign=ALIGN_MIDDLE,nomouseevent=true,});
dialog.team_select.explanation = getLabelEX(dialog.team_select,anchorLTR,XYWH(15,80,230,50),Tahoma_13,'',
                                            {wordwrap=true,font_colour=RGB(221,224,211),text_halign=ALIGN_MIDDLE,nomouseevent=true,});

dialog.team_select.ok = AddDialogButton(DBT_NORMAL,{
    type=TYPE_IMAGEBUTTON,
    parent=dialog.team_select,
    anchor=anchorB,
    x=906,
    y=715,
    width=90,
    height=24,
    text=loc(TID_msg_Ok),
    font_colour_disabled=GRAY(127),
    callback_mouseclick='OW_TEAMSELECT_CLOSE(dialog.team_select.FORMID);',
        hint=loc(TID_msg_Ok),
});

-- left panel
dialog.team_select.cancel   = getImageButtonEX(dialog.team_select,anchorRB,XYWH(277,713,77,27),'','','OW_TEAMSELECT_CANCEL(dialog.team_select.FORMID);',
                                             SKINTYPE_TEXTURE,{SKINTEXTURE='button-cancel.png',hint=loc(TID_msg_Cancel)});

dialog.team_select.fire     = getImageButtonEX(dialog.team_select,anchorRB,XYWH(550,713,77,27),'','','OW_TEAMSELECT_HIREFIRE();',
                                             SKINTYPE_TEXTURE,{enabled=false, SKINTEXTURE='button-fire.png',callback_mousedblclick='OW_TEAMSELECT_HIREFIRE();'});
-- todo -- clear 'choosen team' window
dialog.team_select.fire_all = getImageButtonEX(dialog.team_select,anchorRB,XYWH(467,713,77,27),'','','OW_TEAMSELECT_HIREFIRE();',
                                             SKINTYPE_TEXTURE,{enabled=false, SKINTEXTURE='button-fire-all.png',callback_mousedblclick='OW_TEAMSELECT_HIREFIRE();'});

-- right panel
dialog.team_select.hire     = getImageButtonEX(dialog.team_select,anchorLB,XYWH(657,713,77,27),'','','OW_TEAMSELECT_HIREFIRE();',
                                             SKINTYPE_TEXTURE,{enabled=false, SKINTEXTURE='button-hire.png',callback_mousedblclick='OW_TEAMSELECT_HIREFIRE();'});
-- todo -- hire 'x' units counting from left - where x is max allowed units
dialog.team_select.hire_top = getImageButtonEX(dialog.team_select,anchorLB,XYWH(740,713,77,27),'','','OW_TEAMSELECT_HIREFIRE();',
                                             SKINTYPE_TEXTURE,{enabled=false, SKINTEXTURE='button-hire-top.png',callback_mousedblclick='OW_TEAMSELECT_HIREFIRE();'});

-- todo -- hire 'x' random units - where x is max allowed units
dialog.team_select.hire_rnd = getImageButtonEX(dialog.team_select,anchorLB,XYWH(823,713,77,27),'','','OW_TEAMSELECT_HIREFIRE();',
                                             SKINTYPE_TEXTURE,{enabled=false, SKINTEXTURE='button-hire-rnd.png',callback_mousedblclick='OW_TEAMSELECT_HIREFIRE();'});


dialog.team_select.people = {};

for i=1,4 do
        dialog.team_select.people[i] = getElementEX(dialog.team_select,anchorLTRB,XYWH(0,0,0,0),true,
                                                    {type=TYPE_UNITLIST, colour1=BLACKA(0), texture2='SGUI/FaceIcons.png',
                                                     font_name=Tahoma_13,});
end;

setXYWHV(dialog.team_select.people[1],293,37,324,133);
setXYWHV(dialog.team_select.people[2],293,188,324,500);
setXYWHV(dialog.team_select.people[3],676,188,324,500);
setXYWHV(dialog.team_select.people[4],676,37,324,133);

OW_TEAMSELECTUNITLIST_SETUP(dialog.team_select.people[1].ID,dialog.team_select.people[2].ID,dialog.team_select.people[3].ID,dialog.team_select.people[4].ID);

dialog.team_select.inner           = getBlankElementA(dialog.team_select,anchorTLBR);
setVisible(dialog.team_select.inner,false);
setXYWHV(dialog.team_select.inner,17,320,230,400);
dialog.team_select.inner.img       = getBlankImage(dialog.team_select.inner,anchorLT,false,false);
setXYWHV(dialog.team_select.inner.img,0,0,60,80);

dialog.team_select.inner.name     = getLabelEX(dialog.team_select.inner,anchorLT,XYWH(-2,80+3,0,0),Tahoma_10,'',{text_case=CASE_TITLE});
dialog.team_select.inner.classlvl = getLabelEX(dialog.team_select.inner,anchorLT,XYWH(-2,80+3+16,0,0),Tahoma_10,'',{text_case=CASE_TITLE});

dialog.team_select.inner.profs = {};
for i=1,10 do
        dialog.team_select.inner.profs[i] = getImageButtonEX(dialog.team_select.inner,anchorRB,XYWH(mod(i-1,5)*44,getHeight(dialog.team_select.inner)-88+div(i-1,5)*44,41,41),
                                                             '','','OW_TEAMSELECT_CHANGECLASS(dialog.team_select.inner.profs['..i..'].CLASSID);',SKINTYPE_TEXTURE,{SKINTEXTURE='button-change-questionmark.png',hint='',visible=false});
end;

dialog.team_select.inner.skillrow = {};

for i=1,4 do
        dialog.team_select.inner.skillrow[i] = RewardSkills_AddSkillRow(dialog.team_select.inner);
        setXYWHV(dialog.team_select.inner.skillrow[i],0,(i-1)*39+80+3+16+16,getWidth(dialog.team_select.inner),39);

        setFontName(dialog.team_select.inner.skillrow[i].exp,Tahoma_10);
end;

function dialog.team_select.getProfTexture(CLASSID)
        texture = '';
        switch(CLASSID) : caseof {
                        [class_soldier]       = function (x)
                                                        texture = 'button-change-soldier.png';
                                                end,
                        [class_engineer]      = function (x)
                                                        texture = 'button-change-engineer.png';
                                                end,
                        [class_mechanic]      = function (x)
                                                        texture = 'button-change-mechanic.png';
                                                end,
                        [class_scientist]     = function (x)
                                                        texture = 'button-change-scientist.png';
                                                end,
                        [class_sniper]        = function (x)
                                                        texture = 'button-change-sniper.png';
                                                end,
                        [class_mortarer]      = function (x)
                                                        texture = 'button-change-mortar.png';
                                                end,
                        [class_bazooker]      = function (x)
                                                        texture = 'button-change-bazooka.png';
                                                end,
        ----------------------------------------------
                        default               = function (x)
                                                        texture = 'button-change-questionmark.png';
                                                end,
    }
        return texture;
end;

dialog.team_select.MINPEOPLE = 0;
dialog.team_select.MAXPEOPLE = 0;

function dialog.team_select.updateText(DATA)
--[[
    DATA BREAKDOWN
            PROFS : Array of
                    ID   : Integer; // Class ID
                    NAME : String;  // Localized Name of Class
                    MIN  : Integer; // Minimum amount of this class
                    MAX  : Integer; // Maximum amount of this class
            PROF_COUNT : Integer;
            UNITS : Array of
                    UNITID   : Integer; // ID of Unit (Same as SAIL uses)
                    UNITNAME : String; // Localized Name of Unit
                    PROF     : Integer; // Class ID
            UNIT_COUNT : Integer;
--]]

        local exp  = dialog.team_select.explanation;
        local min  = dialog.team_select.MINPEOPLE;
        local max  = dialog.team_select.MAXPEOPLE;
        local text = '';

        if ((min == max) and (DATA.UNIT_COUNT ~= min)) then
                text = loc1(TID_Other_Team_select_Choose_Exactly,max) .. '\n';
        else
                if ((DATA.UNIT_COUNT < min)) then
                        if (max < 1000) then
                                text = loc2(TID_Other_Team_select_Choose_From_To,min,max) .. '\n';
                        else
                                text = loc2(TID_Other_Team_select_Choose_Min,min) .. '\n';
                        end;
                else
                        if (DATA.UNIT_COUNT > max) then
                                if (min > 0) then
                                        text = loc2(TID_Other_Team_select_Choose_From_To,min,max) .. '\n';
                                else
                                        text = loc1(TID_Other_Team_select_Choose_Max,max) .. '\n';
                                end;
                        end;
                end;
        end;

        local nums = {};
        local num  = 0;

        for i = 1,99 do
                nums[i] = 0;
        end;

        for i = 1,DATA.UNIT_COUNT do
                nums[DATA.UNITS[i].PROF] = nums[DATA.UNITS[i].PROF] + 1;
        end;

        for i = 1,DATA.PROF_COUNT do
                min  = DATA.PROFS[i].MIN;
                max  = DATA.PROFS[i].MAX;
                num  = nums[DATA.PROFS[i].ID];

                if ((min == max) and (num ~= min)) then
                        text = text .. loc2(TID_Other_Team_select_Exactly,min,DATA.PROFS[i].NAME) .. '\n';
                else
                        if ((min == max) and (num > 0)) then
                                text = text .. loc1(TID_Other_Team_select_None,DATA.PROFS[i].NAME) .. '\n';
                        else
                                if ((min > 0) and (num < min)) then
                                        if (max < 1000) then
                                                text = text .. loc3(TID_Other_Team_select_Interval,min,max,DATA.PROFS[i].NAME) .. '\n';
                                        else
                                                text = text .. loc2(TID_Other_Team_select_At_Least,min,DATA.PROFS[i].NAME) .. '\n';
                                        end;
                                else
                                        if ((max < 1000) and (num > max)) then
                                                if (min > 0) then
                                                        text = text .. loc3(TID_Other_Team_select_Interval,min,max,DATA.PROFS[i].NAME) .. '\n';
                                                else
                                                        text = text .. loc2(TID_Other_Team_select_At_Most,max,DATA.PROFS[i].NAME) .. '\n';
                                                end;
                                        end;
                                end;
                        end;
                end;
        end;

        setText(exp,text);

        setEnabled(dialog.team_select.ok,(text == ''));

        -- Setup the Class Change Buttons --
        for i = 1,10 do
                local prof = dialog.team_select.inner.profs[i];

                if i <= DATA.PROF_COUNT then
                        prof.SKINTEXTURE = dialog.team_select.getProfTexture(DATA.PROFS[i].ID);
                        prof.CLASSID     = DATA.PROFS[i].ID;

                        setInterfaceTexture(prof,prof.SKINTEXTURE);
                        setHint(prof,DATA.PROFS[i].NAME);
                        setVisible(prof,true);
                else
                        setVisible(prof,false);
                end;
        end;
        ------------------------------------
end;

function FROMOW_CHARACTERSELECT_SHOW(DATA)
--[[
    DATA BREAKDOWN
            FORMID : Integer; // ID of the Altar Form
            MIN : Integer; //Min amount of people
            MAX : Integer; //Max amount of people
            PROFS : Array of
                    ID   : Integer; // Class ID
                    NAME : String;  // Localized Name of Class
                    MIN  : Integer; // Minimum amount of this class
                    MAX  : Integer; // Maximum amount of this class
            PROF_COUNT : Integer;
            UNITS : Array of
                    UNITID   : Integer; // ID of Unit (Same as SAIL uses)
                    UNITNAME : String; // Localized Name of Unit
                    PROF     : Integer; // Class ID
            UNIT_COUNT : Integer;
--]]
    local ui = interface.current.game.ui.charselect;


        dialog.team_select.FORMID    = DATA.FORMID;

        dialog.team_select.MINPEOPLE = DATA.MIN;
        dialog.team_select.MAXPEOPLE = DATA.MAX;

        dialog.team_select.updateText(DATA);

        setFontColourBoth(dialog.team_skills.inner.name,RGB(120,195,126));
        setFontColourBoth(dialog.team_skills.inner.classlvl,RGB(120,195,126));

        setFontColourBoth(dialog.team_select.people[1],RGB(120,195,126));
        setFontColourBoth(dialog.team_select.people[2],RGB(120,195,126));
        setFontColourBoth(dialog.team_select.people[3],RGB(120,195,126));
        setFontColourBoth(dialog.team_select.people[4],RGB(120,195,126));

        setEnabled(dialog.team_select.ok,false);

        setImageButtonEnable(dialog.team_select.hire,false,ui.enablecol,ui.disablecol);
        setImageButtonEnable(dialog.team_select.fire,false,ui.enablecol,ui.disablecol);

        setWH(dialog.team_select.hire,ui.butW,ui.butH);
        setWH(dialog.team_select.fire,ui.butW,ui.butH);
        setWH(dialog.team_select.cancel,ui.butW,ui.butH);


        local X = Int(ui.area.X);
        local W = (Int(ui.area.W)-20)/2;
        local Y = Int(ui.area.Y);
        local H = (Int(ui.area.H)-20-ui.topH);

        setXYWHV(dialog.team_select.people[1],X,Y,W,ui.topH);
    setXYWHV(dialog.team_select.people[2],X,Y+ui.topH+20,W,H);
    setXYWHV(dialog.team_select.people[3],X+20+W,Y+ui.topH+20,W,H);
    setXYWHV(dialog.team_select.people[4],X+20+W,Y,W,ui.topH);

        setXYWH(dialog.team_select.caption,ui.captionarea);
    setXYWH(dialog.team_select.explanation,ui.detailsarea);
        setXYWH(dialog.team_select.inner,ui.infoarea);


        setVisible(dialog.team_select.inner,false);
        ShowDialog2(dialog.team_select,true);
end;

function FROMOW_CHARACTERSELECT_INFO(DATA)
--[[
    DATA BREAKDOWN
            PROFS : Array of
                    ID   : Integer; // Class ID
                    NAME : String;  // Localized Name of Class
                    MIN  : Integer; // Minimum amount of this class
                    MAX  : Integer; // Maximum amount of this class
            PROF_COUNT : Integer;
            UNITS : Array of
                    UNITID   : Integer; // ID of Unit (Same as SAIL uses)
                    UNITNAME : String; // Localized Name of Unit
                    PROF     : Integer; // Class ID
            UNIT_COUNT : Integer;
--]]
        dialog.team_select.updateText(DATA);
end;

function setImageButtonEnable(BUTTON,ENABLE,COL1,COL2)
        setEnabled(BUTTON,ENABLE);
        if (ENABLE) then
                setColour1(BUTTON,COL1);
        else
                setColour1(BUTTON,COL2);
        end;
end;

function FROMOW_CHARACTERSELECT_SELECT(DATA)
--[[
    DATA BREAKDOWN
            ID       : Integer; // ID of Unit (Same as SAIL uses)
            TEXTURE  : Integer;
            NAME     : String;
            CLASSLVL : String;
            CANHIRE  : Boolean;
            CANFIRE  : Boolean;
            UNITEXP : Array [1..4] of
                    EXP  : Integer; // Current EXP within LVL
                    EXP1 : Integer;
                    EXP2 : Integer; // Next LVL EXP
                    PROG : Integer; // Progress to Next LVL

--]]
    local ui = interface.current.game.ui.charselect;

        local inner = dialog.team_select.inner;
        setTextureFromID(inner.img,DATA.TEXTURE,60,80,60,80);
        setText(inner.name,DATA.NAME);
        setText(inner.classlvl,DATA.CLASSLVL);
        setVisible(inner,true);

        setImageButtonEnable(dialog.team_select.hire,DATA.CANHIRE,ui.enablecol,ui.disablecol);
        setImageButtonEnable(dialog.team_select.fire,DATA.CANFIRE,ui.enablecol,ui.disablecol);

        for i=1,4 do
                setInterfaceTexture(inner.skillrow[i].icon,RewardSkillIconImg[i]..RewardSkillState[1]..'.png');
                setImageBarTexture2(inner.skillrow[i].progress,'1024levelbarempty.png','1024levelbar.png');
                setImageBarProgress(inner.skillrow[i].progress,DATA.UNITEXP[i].PROG/100);

                setText(inner.skillrow[i].exp,'(LVL'..' '..DATA.UNITEXP[i].LVL..')');
                setText(inner.skillrow[i].proglabel,''..DATA.UNITEXP[i].EXP..'/'..DATA.UNITEXP[i].EXP2);

                setVisible(inner.skillrow[i].progress,DATA.UNITEXP[i].LVL < 10);
                setVisible(inner.skillrow[i].proglabel,DATA.UNITEXP[i].LVL < 10);

                for s=1,10 do
                        if (DATA.UNITEXP[i].LVL >= s) then
                                setInterfaceTexture(dialog.team_select.inner.skillrow[i].pips[s],RewardSkillImg[3]);
                                setColour1(dialog.team_select.inner.skillrow[i].pips[s],WHITE());
                        else
                                setTexture(dialog.team_select.inner.skillrow[i].pips[s],'');
                                setColour1(dialog.team_select.inner.skillrow[i].pips[s],GRAY(50));
                        end;
                        setVisible(inner.skillrow[i].pips[s],true);--DATA.UNITEXP[i].LVL >= s);
                end;
        end;
end;

function FROMOW_TEAMSELECT_HIDE()
        HideDialog(dialog.team_select);
end;
