%include goptions;
*include arc ;
options ls=95;
goptions htext=1.7 htitle=2.5;
%let ht=1.7;
*goptions hsize=7.  vsize=7.5;
Data means;
    Input Group Y1 Y2;
    R    = .4 + .5*uniform(123131);
cards;
1  8  10
2 10   5
3 12  14
4 17  20
5 18  11
6 20  16
7 25  20
8 27  26
;
%macro fig1;
Data Fig1;
   *annocms;
   %annomac;
   %dclanno;
   %system(2,2,4);
   Set means;
   If _N_=1 then do;
    %label(2,36.5,'Scatter around group means ',BLACK,0,0, &ht ,,6);
    %label(2,35,'represented by each ellipse',BLACK,0,0,&ht,,6);
    %label(38,2,'(a)',BLACK, 0,0,&ht,,4)
   End;
 * color = 'H' || put(Group*45,HEX3.);
   color = 'BLACK';
   RX=3.3; RY=3*R;
   tilt=35 + 10*uniform(0);
   %ellipse(Y1,Y2,RX,RY,tilt,color=black,line=1+_N_,width=2);
   %label(Y1+.5,Y2,put(_N_,2.),black,0,0,1.5,,6);
Title '(a) Individual group scatter';
symbol1 v=dot h=1.5 i=none c=black r=8;
 
proc gplot data=means;
   plot y2 * y1=group /     nolegend frame    anno=fig1
                            vaxis=axis1 haxis=axis2 hm=1 vm=1;
 
   axis1 order=(0 to 40 by 10) /* length=6.5 in */;
   axis2 order=(0 to 40 by 10) /* length=6.5 in */;
 
Proc Summary data=means;
    Class GROUP;
    Var Y1 Y2;
    Output out=GRAND mean=Y1 Y2;
Proc Print data=GRAND;
%mend;
 
%macro fig2;
Data Fig2;
    %dclanno;
    %system(2,2,4);
    Length TEXT $30;
    Set GRAND;
    drop a rad xp yp Y1 Y2 group _type_ _freq_ rot tilt;
    If _TYPE_=0;
       %ellipse(Y1,Y2,16, 8, 50,color=BLACK,line=1,width=2);
       %ellipse(Y1,Y2, 4,2.5,37,color=BLACK,line=1,width=2);
       X=Y1; Y=Y2; SIZE=1.8; TEXT='+';
       FUNCTION='SYMBOL'; output;
       rad = arcos(-1)/180;
       Do a = 0 to 270 by 90;
          ang = 37+a;
          XP = Y1 + 6*cos(rad*ang);
          YP = Y2 + 6*sin(rad*ang);
          %line(Y1,Y2, XP,YP,*,2,1);
       End;
%label(26,29,'H matrix',BLACK,0,0,&ht,,6);
%label(21,15,'E matrix',BLACK,0,0,&ht,,6);
%label(1,37.5,'Deviations of group means from',BLACK,0,0,&ht,,6);
%label(1,36.0,'grand mean (outer) and pooled ',BLACK,0,0,&ht,,6);
%label(1,34.5,'within-group (inner) ellipses.',BLACK,0,0,&ht,,6);
%label(39,37,'How big is H relative to E?  ',BLACK,0,0,2,,4);
%label(38,2,'(b)',BLACK, 0,0, &ht,,4)
Title '(b) Between and Within Scatter';
Proc print;
 
Proc GPLOT data=means;
   Plot Y2 * Y1    / anno=Fig2 frame
                     vaxis=axis1 haxis=axis2 vminor=1 hminor=1;
   axis1 order=(0 to 40 by 10);
   axis2 order=(0 to 40 by 10);
	run; quit;
%mend;
 
%macro fig3;
Data Can;
   Label CAN1='First Canonical dimension'
         CAN2='Second Canonical dimension';
   CAN1=0; CAN2=0;
   output;
Data Fig3;
   Set Can;
   %dclanno;
   Length TEXT $30;
   %system(2,2,4);
   %ellipse(CAN1,CAN2,   5, 2.5,  103,color=black,line=1,width=2);   /* H*       */
   %ellipse(CAN1,CAN2, 4.6, 1.56, 113,color=red  ,line=2,width=1);   /* HE-1     */
   %ellipse(CAN1,CAN2,   1, 1.6,    0,color=black,line=1,width=2);   /* E*       */
   %ellipse(CAN1,CAN2,   1,   1,    0,color=red  ,line=2,width=1);   /* EE-1 = I */
%label(-2.1,5.0,'H*   ',BLACK,0,0,&ht,,6);
%label(-2.0,4.0,'HE-1 ',RED  ,0,0,&ht,,6);
%label( 0.0,2.0,'E*   ',BLACK,0,0,&ht,,6);
%label(  .0, .8,'I    ',RED  ,0,0,&ht,,6);
%label( 5.9,5.8,'The E matrix is orthogonalized',BLACK,0,0,&ht,,4);
%label( 5.9,5.4,'by its principal components.  ',BLACK,0,0,&ht,,4);
%label( 5.9,4.8,'The same transformation is    ',BLACK,0,0,&ht,,4);
%label( 5.9,4.4,'applied to the H matrix.      ',BLACK,0,0,&ht,,4);
%label( 5.8,-5.8,'(c)',BLACK, 0,0,&ht,,A)
 
Title '(c) H Matrix standardized by E matrix, giving HE'
             m=(-.1,+.8) H=1.8 '-1';
proc gplot data=can;
   plot can2 * can1/ anno=fig3 frame
                     vaxis=axis1 haxis=axis2 vminor=1 hminor=1;
   axis1 order=(-6 to 6 by 2) 
         label=(a=90 r=0);
   axis2 order=(-6 to 6 by 2) 
            ;
	run; quit;
%mend;
%macro fig4;
Data Fig4;
   Set Can;
   %dclanno;
   Length TEXT $30;
   Drop rad a XP YP;
   %system(2,2,4);
   %ellipse(CAN1,CAN2, 4.6, 1.56, 113,color=RED  ,line=2,width=2);   /* HE-1     */
   %ellipse(CAN1,CAN2,   1,   1,    0,color=RED  ,line=2,width=2);   /* EE-1 = I */
   rad = arcos(-1)/180;
       Do a = 0 to 270 by 90;
          ang =113+a;
          If a=0 | a=180 then len=4.6;
                         else len=1.56;
          XP = CAN1 + len*cos(rad*ang);
          YP = CAN2 + len*sin(rad*ang);
          %line(CAN1,CAN2, XP,YP,black,1,1);
       End;
%label(-2.5,4.0,'HE-1 ',RED  ,0,0,&ht,,4);
%label(  .0, .8,'I    ',RED  ,0,0,&ht,,6);
%label( -0.8,2.5,'l',BLACK,    0,0,1.7,CGREEK,0);
      X=.;Y=.; TEXT='1'; SIZE=.9; output;
%label( 1.1,.02, 'l',BLACK,    0,0,1.7,CGREEK,0);
      X=.;Y=.; TEXT='2'; SIZE=.9; output;
%label( 5.9,5.8,'The size of HE-1 is now shown ',BLACK,0,0,&ht,,4);
%label( 5.9,5.4,'directly by the size of its   ',BLACK,0,0,&ht,,4);
%label( 5.9,5.0,'latent roots.                 ',BLACK,0,0,&ht,,4);
%label( 5.8,-5.8,'(d)',BLACK, 0,0,&ht,,A)
 
Title '(d) Principal axes of HE' m=(-.1,+.8) H=1.8 '-1';
proc gplot data=can;
   plot can2 * can1/ anno=fig4 frame
                     vaxis=axis1 haxis=axis2 vminor=1 hminor=1;
   axis1 order=(-6 to 6 by 2)
         label=(a=90 r=0);
   axis2 order=(-6 to 6 by 2)
            ;
	run; quit;
%mend;
%gdispla(OFF);
%fig1;
%fig2;
%fig3;
%fig4;

%gdispla(ON);

%panels(rows=2, cols=2, order=down);

/*
%panels(rows=1, cols=2);
%gskip;
%panels(rows=1, cols=2, replay=1:3 2:4);
*/
