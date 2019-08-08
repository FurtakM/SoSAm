dialog.team_review=AddSkinEle_Tex(getElement(dialog.back,anchorNone,1024,768,false),'1024team_review.png');

dialog.team_review.caption     = getLabelEX(dialog.team_review,anchorLTR,XYWH(0,18,320,39),Trebuchet_20,loc(TID_InGame_Team_review_Title),
                                            {shadowtext=true,wordwrap=true,font_colour=RGB(200,50,50),text_halign=ALIGN_MIDDLE,nomouseevent=true,});
dialog.team_review.explanation = getLabelEX(dialog.team_review,anchorLTR,XYWH(15,80,230,50),Tahoma_13,'',
                                            {wordwrap=true,font_colour=RGB(221,224,211),text_halign=ALIGN_MIDDLE,nomouseevent=true,});

dialog.team_review.ok = AddDialogButton(DBT_NORMAL,{
	type=TYPE_IMAGEBUTTON,
	parent=dialog.team_review,
	anchor=anchorB,
	x=900,
	y=715,
	width=90,
	height=24,
	text=loc(TID_msg_Ok),
	font_colour_disabled=GRAY(127),
	callback_mouseclick='',
        hint=loc(TID_msg_Ok),
});

dialog.team_review.people = {};

for i=1,4 do
        dialog.team_review.people[i] = getElementEX(dialog.team_review,anchorLTRB,XYWH(0,0,0,0),true,
                                                    {type=TYPE_UNITLIST, colour1=BLACKA(0), texture2='SGUI/FaceIcons.png',
                                                     font_name=Tahoma_13,});
end;

setXYWHV(dialog.team_review.people[1],293,37,324,133);
setXYWHV(dialog.team_review.people[2],293,188,324,500);
setXYWHV(dialog.team_review.people[3],676,188,324,500);
setXYWHV(dialog.team_review.people[4],676,37,324,133);

--OW_TEAMSELECTUNITLIST_SETUP(dialog.team_review.people[1].ID,dialog.team_review.people[2].ID,dialog.team_review.people[3].ID,dialog.team_review.people[4].ID);

dialog.team_review.inner           = getBlankElementA(dialog.team_review,anchorTLBR);
setVisible(dialog.team_review.inner,false);
setXYWHV(dialog.team_review.inner,17,320,230,400);
dialog.team_review.inner.img       = getBlankImage(dialog.team_review.inner,anchorLT,false,false);
setXYWHV(dialog.team_review.inner.img,0,0,60,80);

dialog.team_review.inner.name     = getLabelEX(dialog.team_review.inner,anchorLT,XYWH(-2,80+3,0,0),Tahoma_10,'',{text_case=CASE_TITLE});
dialog.team_review.inner.classlvl = getLabelEX(dialog.team_review.inner,anchorLT,XYWH(-2,80+3+16,0,0),Tahoma_10,'',{text_case=CASE_TITLE});

dialog.team_review.inner.profs = {};
for i=1,10 do
        dialog.team_review.inner.profs[i] = getImageButtonEX(dialog.team_review.inner,anchorRB,XYWH(mod(i-1,5)*44,getHeight(dialog.team_review.inner)-88+div(i-1,5)*44,41,41),
                                                             '','','OW_TEAMSELECT_CHANGECLASS(dialog.team_review.inner.profs['..i..'].CLASSID);',SKINTYPE_TEXTURE,{SKINTEXTURE='button-change-questionmark.png',hint='',visible=false});
end;

dialog.team_review.inner.skillrow = {};

for i=1,4 do
        dialog.team_review.inner.skillrow[i] = RewardSkills_AddSkillRow(dialog.team_review.inner);
        setXYWHV(dialog.team_review.inner.skillrow[i],0,(i-1)*39+80+3+16+16,getWidth(dialog.team_review.inner),39);

        setFontName(dialog.team_review.inner.skillrow[i].exp,Tahoma_10);
end;


function FROMOW_TEAMREVIEW_HIDE()
        HideDialog(dialog.team_review);
end;
