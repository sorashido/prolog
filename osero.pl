%オセロの盤面は8*8の64マスとする
%
%以下が初期状態
%   1 2 3 4 5 6 7 8
% 1| | | | | | | | |
% 2| | | | | | | | |
% 3| | | | | | | | |
% 4| | | |○|●| | | |
% 5| | | |●|○| | | |
% 6| | | | | | | | |
% 7| | | | | | | | |
% 8| | | | | | | | |
%
%	●..黒色:1
%	○..白色:2
%	縦がx,横がy
%

%%%%リストの操作と、盤面の操作%%%%

%リストの参照
accesslist(0,[X|_],X):- !.
accesslist(N,[_|Rest],X):-N1 is N-1,accesslist(N1,Rest,X).

%盤面の要素の参照
accessboard(ROW,COL,BOARD,X):-
	NROW is ROW -1,
	NCOL is COL -1,
	(((NROW>=0,NROW<8,NCOL>=0,NCOL<8),!,
	accesslist(NROW,BOARD,BOARD_ROW),
	accesslist(NCOL,BOARD_ROW,X));
	X is 0).

%リストの削除
removelist(0,[_|Rest],Rest):-!.
removelist(N,[Y|Rest1],[Y|Rest2]):-
    N1 is N-1,removelist(N1,Rest1,Rest2).

%盤面の要素の削除
removeboard(ROW,COL,BOARD,X):-
	NROW is ROW -1,
	NCOL is COL -1,
	accesslist(NROW,BOARD,BOARD_ROW),
	removelist(NROW,BOARD,NBOARD),
	removelist(NCOL,BOARD_ROW,NBOARD_ROW),
	insertlist(NBOARD_ROW,NROW,NBOARD,X).

%挿入
insertlist(X,0,Rest,[X|Rest]):-!.
insertlist(X,N,[Y|Rest1],[Y|Rest2]):-
    N1 is N-1,insertlist(X,N1,Rest1,Rest2).

%盤面の要素の挿入
insertboard(X,ROW,COL,BOARD,ANS):-
	NROW is ROW -1,
	NCOL is COL -1,
	accesslist(NROW,BOARD,BOARD_ROW),
	insertlist(X,NCOL,BOARD_ROW,NBOARD_ROW),
	removelist(NROW,BOARD,NBOARD),
	insertlist(NBOARD_ROW,NROW,NBOARD,ANS).

%連結
conc([], List, List).
conc([X | L1], L2, [X | List]) :-conc(L1, L2, List).

%リストへ含むかの判定
member(X,[X|_]):-!.
member(X,[_|L]):-member(X,L).


%ここから下がオセロに関する定義

%%%%盤面と、評価値のセット%%%%
%序盤、中盤、終盤にて評価値を代える
init_board(BOARD,EVAL_BOARD1,EVAL_BOARD2,EVAL_BOARD3):-
	BOARD=[[0,0,0,0,0,0,0,0],
	   [0,0,0,0,0,0,0,0],
       [0,0,0,0,0,0,0,0],
       [0,0,0,2,1,0,0,0],
       [0,0,0,1,2,0,0,0],
       [0,0,0,0,0,0,0,0],
	   [0,0,0,0,0,0,0,0],
	   [0,0,0,0,0,0,0,0]],
	EVAL_BOARD1=
		[[30,-12,0,-1,-1,0,-12,30],
 		[-12,-15,-3,-3,-3,-3,-15,-12],
 		[0,-3,0,-1,-1,0,-3,0],
 		[-1,-3,-1,-1,-1,-1,-3,-1],
 		[-1,-3,-1,-1,-1,-1,-3,-1],
 		[0,-3,0,-1,-1,0,-3,0],
 		[-12,-15,-3,-3,-3,-3,-15,-12],
 		[30,-12,0,-1,-1,0,-12,30]],
	EVAL_BOARD2=
		[[15,0,1,2,2,1,0,15],
 		[0,0,3,1,1,3,0,0],
 		[3,3,5,3,1,5,3,3],
 		[0,1,1,1,1,1,1,1],
 		[0,1,1,1,1,1,1,1],
 		[3,1,5,3,1,5,1,3],
 		[0,0,3,1,1,3,0,0],
 		[15,0,1,2,2,1,0,15]],
	EVAL_BOARD3=
		[[8,0,1,2,2,1,0,8],
 		[0,0,3,1,1,3,0,0],
 		[1,3,5,3,1,5,3,1],
 		[1,1,1,1,1,1,1,1],
 		[1,1,1,1,1,1,1,1],
 		[1,1,5,3,1,5,1,1],
 		[0,0,3,1,1,3,0,0],
 		[8,0,1,2,2,1,0,8]].

%%%%表示%%%%

disp(BOARD):-
	write("  1  2  3  4  5  6  7  8"),nl,put(49),
	disp_start(BOARD,0,64).
disp_start(BOARD,LOOP,MAX):-
	put(124),	%|
	LOOP<MAX,!,
	ROW is LOOP//8+1,
	COL is LOOP mod 8+1,
	accessboard(ROW,COL,BOARD,X),
	((X=:=1,!,put(9679));
	(X=:=2,!,put(9675));
	put(32)),
	(((COL=:=8,ROW=\=8),!,put(32),put(124),nl,
		write(" |--|--|--|--|--|--|--|--|"),nl,
		NROW is ROW+1,write(NROW));put(32)),
	NLOOP is LOOP +1,
	disp_start(BOARD,NLOOP,MAX);
	put(32),put(32),nl,
	write(" ------------------------- "),true.

%%%%黒石と白石の入れ替え(ひっくり返す作業)%%%%

change_stone(POS,BOARD,ANS):-
	accesslist(0,POS,X),
	accesslist(1,POS,Y),
	accessboard(X,Y,BOARD,STONE),
	((STONE=:=1,!,
	removeboard(X,Y,BOARD,NBOARD),
	insertboard(2,X,Y,NBOARD,ANS));
	(STONE=:=2,!,
	removeboard(X,Y,BOARD,NBOARD),
	insertboard(1,X,Y,NBOARD,ANS));
	ANS=BOARD).

%%%%BOARDから黒が取れる座標と、数を数える%%%%

check_board_black(BOARD,BCANGET,BCANNUM,BNUM):-
	check_board_black_start(BOARD,BCANGET,[],BCANNUM,0,0,0,BNUM).
check_board_black_start(BOARD,BCANGET,TEMPGET,BCANNUM,TEMPNUM,LOOP,TEMPBNUM,BNUM):-
	LOOP < 64,!,
	ROW is LOOP//8+1,
	COL is LOOP mod 8+1,
	accessboard(ROW,COL,BOARD,X),
    ((X=:=1,!,NTEMPBNUM is TEMPBNUM+1);NTEMPBNUM is TEMPBNUM),
    serch_black_stone(BOARD,ROW,COL,ANS),
	((X=:=0,ANS=:=1),!,
	 conc(TEMPGET,[[ROW,COL]],NTEMPGET),
	 NTEMPNUM is TEMPNUM +1;
	NTEMPGET = TEMPGET,
	NTEMPNUM is TEMPNUM),
	NLOOP is LOOP + 1,
	check_board_black_start(BOARD,BCANGET,NTEMPGET,BCANNUM,NTEMPNUM,NLOOP,NTEMPBNUM,BNUM);
	BCANGET = TEMPGET,BCANNUM is TEMPNUM,BNUM is TEMPBNUM,true.

%黒石をROW,COLに置くことが出来るかを調べる。
serch_black_stone(BOARD,ROW,COL,ANS):-
	serch_line_black(BOARD,ROW,COL,[-1,-1],ANS1),
	serch_line_black(BOARD,ROW,COL,[-1,0],ANS2),
	serch_line_black(BOARD,ROW,COL,[-1,1],ANS3),
	serch_line_black(BOARD,ROW,COL,[0,-1],ANS4),
	serch_line_black(BOARD,ROW,COL,[0,1],ANS5),
	serch_line_black(BOARD,ROW,COL,[1,-1],ANS6),
	serch_line_black(BOARD,ROW,COL,[1,0],ANS7),
	serch_line_black(BOARD,ROW,COL,[1,1],ANS8),
	((ANS1=:=0,ANS2=:=0,ANS3=:=0,ANS4=:=0,ANS5=:=0,ANS6=:=0,ANS7=:=0,ANS8=:=0),!,ANS is 0;
	ANS is 1),true.

%黒からみて、白色がとれるのならば
serch_line_black(BOARD,ROW,COL,DIR,ANS):-
	accesslist(0,DIR,X),
	accesslist(1,DIR,Y),
	accessboard(ROW,COL,BOARD,Z1),
	accessboard(ROW+X,COL+Y,BOARD,Z2),
	(Z1=:=0,Z2=:=2),!,serch_line_black_start(BOARD,ROW,COL,DIR,ANS);
	ANS is 0,true.
serch_line_black_start(BOARD,ROW,COL,DIR,ANS):-
	accesslist(0,DIR,X),
	accesslist(1,DIR,Y),
	accessboard(ROW+X,COL+Y,BOARD,Z),
	((Z=:=2,!,serch_line_black_start(BOARD,ROW+X,COL+Y,DIR,ANS));
	(Z=:=1,!,ANS is 1,true);
	ANS is 0),true.

%%%上記の白石バージョン%%%%

check_board_white(BOARD,WCANGET,WCANNUM,WNUM):-
	check_board_white_start(BOARD,WCANGET,[],WCANNUM,0,0,0,WNUM).
check_board_white_start(BOARD,WCANGET,TEMPGET,WCANNUM,TEMPCANNUM,LOOP,TEMPWNUM,WNUM):-
	LOOP < 64,!,
	ROW is LOOP//8+1,
	COL is LOOP mod 8+1,
	accessboard(ROW,COL,BOARD,X),
    ((X=:=2,!,NTEMPWNUM is TEMPWNUM+1);NTEMPWNUM is TEMPWNUM),
    serch_white_stone(BOARD,ROW,COL,ANS),
	((X=:=0,ANS=:=1),!,
	conc(TEMPGET,[[ROW,COL]],NTEMPGET),
	NTEMPNUM is TEMPCANNUM +1;
	NTEMPGET = TEMPGET,
	NTEMPNUM is TEMPCANNUM),
	NLOOP is LOOP + 1,
	check_board_white_start(BOARD,WCANGET,NTEMPGET,WCANNUM,NTEMPNUM,NLOOP,NTEMPWNUM,WNUM);
	WCANGET = TEMPGET,WCANNUM is TEMPCANNUM,WNUM = TEMPWNUM,true.

%白石をROW,COLに置くことが出来るかを調べる。
serch_white_stone(BOARD,ROW,COL,ANS):-
	serch_line_white(BOARD,ROW,COL,[-1,-1],ANS1),
	serch_line_white(BOARD,ROW,COL,[-1,0],ANS2),
	serch_line_white(BOARD,ROW,COL,[-1,1],ANS3),
	serch_line_white(BOARD,ROW,COL,[0,-1],ANS4),
	serch_line_white(BOARD,ROW,COL,[0,1],ANS5),
	serch_line_white(BOARD,ROW,COL,[1,-1],ANS6),
	serch_line_white(BOARD,ROW,COL,[1,0],ANS7),
	serch_line_white(BOARD,ROW,COL,[1,1],ANS8),
	((ANS1=:=0,ANS2=:=0,ANS3=:=0,ANS4=:=0,ANS5=:=0,ANS6=:=0,ANS7=:=0,ANS8=:=0),!,ANS is 0;
	ANS is 1),true.

%白石からみて黒石がとれるのならば
serch_line_white(BOARD,ROW,COL,DIR,ANS):-
	accesslist(0,DIR,X),
	accesslist(1,DIR,Y),
	accessboard(ROW,COL,BOARD,Z1),
	accessboard(ROW+X,COL+Y,BOARD,Z2),
	(Z1=:=0,Z2=:=1),!,serch_line_white_start(BOARD,ROW,COL,DIR,ANS);
	ANS is 0,true.
serch_line_white_start(BOARD,ROW,COL,DIR,ANS):-
	accesslist(0,DIR,X),
	accesslist(1,DIR,Y),
	accessboard(ROW+X,COL+Y,BOARD,Z),
	((Z=:=1,!,serch_line_white_start(BOARD,ROW+X,COL+Y,DIR,ANS));
	(Z=:=2,!,ANS is 1,true);
	ANS is 0),true.

%%%%盤面のチェック%%%%%

check_board(BOARD,NEND):-
	check_board_black(BOARD,BCANGET,BCANNUM,BNUM),
	check_board_white(BOARD,WCANGET,WCANNUM,WNUM),
	nl,write("	Black:"),write(BNUM),write("  White:"),write(WNUM),nl,
	(((BCANNUM=:=0,WCANNUM=:=0,BNUM > WNUM),!,write("!!!!BLACK WIN!!!!"),NEND is 1);
	((BCANNUM=:=0,WCANNUM=:=0,WNUM > BNUM),!,write("!!!!WHITE WIN!!!!"),NEND is 1);
	((BCANNUM=:=0,WCANNUM=:=0,WNUM =:= BNUM),!,write("!!!!DRAW!!!!"),NEND is 1);NEND is 0).

%%%%手動で石を打つ%%%%

player(BOARD,ANS,LOOP):-
	X is LOOP mod 2,
	((X=:=0,!,player_black(BOARD,ANS1));
	(X=:=1,!,player_white(BOARD,ANS1))),
	ANS = ANS1.

player_black(BOARD,ANS1):-
	nl,write(" black turn:"),nl,
	check_board_black(BOARD,BCANGET,BCANNUM,BNUM),
	BCANNUM =\=0,!,
	write(" can get "),write(BCANGET),nl,
	write(" x,y:"),
	get(C),get(D),get(E),
	NC is C-48,
	NE is E-48,
	ANS =[NC,NE],
	((member(ANS,BCANGET),!,ANS1=ANS);write("can't put!!"),write("you can get"),write(BCANGET),player_black(BOARD,ANS1));
	write("pass"),ANS1 = [-1,-1].

player_white(BOARD,ANS1):-
	nl,write(" white turn:"),nl,
	check_board_white(BOARD,WCANGET,WCANNUM,WNUM),
	WCANNUM =\=0,!,
	write(" can get "),write(WCANGET),nl,
	write(" x,y::"),
	get(C),get(D),get(E),
	NC is C-48,
	NE is E-48,
	ANS =[NC,NE],
	((member(ANS,WCANGET),!,ANS1=ANS);write("can't put!!"),write("you can get"),write(WCANGET),player_white(BOARD,ANS1));
	write("pass"),ANS1 = [-1,-1].

%%%Computerの実装%%%

computer(BOARD,ANS,LOOP):-
	X is LOOP mod 2,
	((X=:=0,!,computer_blackD(BOARD,ANS1)); %コンピュータA~Dまで選ぶ
	(X=:=1,!,computer_whiteA(BOARD,ANS1))), %
	ANS = ANS1.

%ランダムに置く
computer_blackB(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_black(BOARD,BCANGET,BCANNUM,BNUM),
	BCANNUM =\=0,!,
	X is random(BCANNUM),
	accesslist(X,BCANGET,ANS),
	((member(ANS,BCANGET),!,ANS1=ANS);computer_blackB(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%評価値のうち、最も高いものを選ぶ
computer_blackA(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_black(BOARD,BCANGET,BCANNUM,BNUM),
	BCANNUM =\=0,!,
	eval_stone_black(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM),
	X is random(MAXNUM),
	accesslist(X,MAXLIST,ANS),
	((member(ANS,BCANGET),!,ANS1=ANS);computer_blackA(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%評価値の2番目のものを選ぶ
computer_blackC(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_black(BOARD,BCANGET,BCANNUM,BNUM),
	BCANNUM =\=0,!,
	eval_stone_black2(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM,100,MAXANS),
	eval_stone_black2(BOARD,BCANGET,BCANNUM,MAXLIST2,MAXNUM2,MAXANS,MAXANS2),
	write(MAXANS2),
	((MAXANS2 =:= -100,!,X is random(MAXNUM),accesslist(X,MAXLIST,ANS));
		X is random(MAXNUM2),accesslist(X,MAXLIST2,ANS)),
	((member(ANS,BCANGET),!,ANS1=ANS);computer_blackC(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%評価値1,2番目の物のどちらかを選ぶ
computer_blackD(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_black(BOARD,BCANGET,BCANNUM,BNUM),
	BCANNUM =\=0,!,
	eval_stone_black2(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM,100,MAXANS),
	eval_stone_black2(BOARD,BCANGET,BCANNUM,MAXLIST2,MAXNUM2,MAXANS,MAXANS2),
	conc(MAXLIST,MAXLIST2,NMAXLIST),
	NUM is MAXNUM+MAXNUM2,
	X is random(NUM),
	accesslist(X,NMAXLIST,ANS),
	((member(ANS,BCANGET),!,ANS1=ANS);computer_blackD(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%ランダムに置く
computer_whiteB(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_white(BOARD,WCANGET,WCANNUM,WNUM),
	WCANNUM =\=0,!,
	X is random(WCANNUM),
	accesslist(X,BCANGET,ANS),
	((member(ANS,WCANGET),!,ANS1=ANS);computer_whiteB(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%評価値のうち、最も高いものを選ぶ
computer_whiteA(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_white(BOARD,WCANGET,WCANNUM,WNUM),
	WCANNUM =\=0,!,
	eval_stone_white(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM),
	X is random(MAXNUM),
	accesslist(X,MAXLIST,ANS),
	((member(ANS,WCANGET),!,ANS1=ANS);computer_whiteA(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%評価値の2番目のものを選ぶ
computer_whiteC(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_white(BOARD,WCANGET,WCANNUM,WNUM),
	WCANNUM =\=0,!,
	eval_stone_white2(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM,100,MAXANS),
	eval_stone_white2(BOARD,WCANGET,WCANNUM,MAXLIST2,MAXNUM2,MAXANS,MAXANS2),
	write(MAXANS2),
	((MAXANS2 =:= -100,!,X is random(MAXNUM),accesslist(X,MAXLIST,ANS));
		X is random(MAXNUM2),accesslist(X,MAXLIST2,ANS)),
	((member(ANS,WCANGET),!,ANS1=ANS);computer_whiteC(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].

%評価値1,2番目の物のどちらかを選ぶ
computer_whiteD(BOARD,ANS1):-
	nl,write("computer"),nl,
	check_board_white(BOARD,WCANGET,WCANNUM,WNUM),
	WCANNUM =\=0,!,
	eval_stone_white2(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM,100,MAXANS),
	eval_stone_white2(BOARD,WCANGET,WCANNUM,MAXLIST2,MAXNUM2,MAXANS,MAXANS2),
	conc(MAXLIST,MAXLIST2,NMAXLIST),
	NUM is MAXNUM+MAXNUM2,
	X is random(NUM),
	accesslist(X,NMAXLIST,ANS),
	((member(ANS,WCANGET),!,ANS1=ANS);computer_whiteD(BOARD,ANS1));
	write("pass"),nl,ANS1 = [-1,-1].


%%%%盤面の評価%%%%

%黒の評価値を計算し、評価値の最も高いものを返す
eval_stone_black(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM):-
	eval_stone_black_start(BOARD,BCANGET,BCANNUM,0,0,-100,0,MAXLIST,MAXNUM).
eval_stone_black_start(BOARD,BCANGET,BCANNUM,TEMPMAXLIST,TEMPMAXNUM,MAX,LOOP,MAXLIST,MAXNUM):-
	LOOP < BCANNUM,!,
	accesslist(LOOP,BCANGET,STONE),
	accesslist(0,STONE,X),
	accesslist(1,STONE,Y),
	removeboard(X,Y,BOARD,NBOARD),
	insertboard(1,X,Y,NBOARD,NBOARD2),
	eval_board(NBOARD2,BANS,_),
	((BANS>MAX,!,conc([STONE],[],NTEMPMAXLIST),NMAX is BANS,NTEMPMAXNUM is 1);
	(BANS=:=MAX,!,conc([STONE],TEMPMAXLIST,NTEMPMAXLIST),NMAX is BANS,NTEMPMAXNUM is TEMPMAXNUM+1);
	NTEMPMAXLIST = TEMPMAXLIST,NMAX is MAX,NTEMPMAXNUM is TEMPMAXNUM),
	NLOOP is LOOP +1,
	eval_stone_black_start(BOARD,BCANGET,BCANNUM,NTEMPMAXLIST,NTEMPMAXNUM,NMAX,NLOOP,MAXLIST,MAXNUM);
	MAXLIST=TEMPMAXLIST,MAXNUM is TEMPMAXNUM,true.

%黒の評価値を計算し、リミットの値よりも小さな最も大きい評価値のものを返す。
eval_stone_black2(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM,LIMIT,MAXANS):-
	eval_stone_black_start2(BOARD,BCANGET,BCANNUM,0,0,-100,0,MAXLIST,MAXNUM,LIMIT,MAXANS).
eval_stone_black_start2(BOARD,BCANGET,BCANNUM,TEMPMAXLIST,TEMPMAXNUM,MAX,LOOP,MAXLIST,MAXNUM,LIMIT,MAXANS):-
	LOOP < BCANNUM,!,
	accesslist(LOOP,BCANGET,STONE),
	accesslist(0,STONE,X),
	accesslist(1,STONE,Y),
	removeboard(X,Y,BOARD,NBOARD),
	insertboard(1,X,Y,NBOARD,NBOARD2),
	eval_board(NBOARD2,BANS,_),
	(((LIMIT>BANS,BANS>MAX),!,conc([STONE],[],NTEMPMAXLIST),NMAX is BANS,NTEMPMAXNUM is 1);
	(BANS=:=MAX,!,conc([STONE],TEMPMAXLIST,NTEMPMAXLIST),NMAX is BANS,NTEMPMAXNUM is TEMPMAXNUM+1);
	NTEMPMAXLIST = TEMPMAXLIST,NMAX is MAX,NTEMPMAXNUM is TEMPMAXNUM),
	NLOOP is LOOP +1,
	eval_stone_black_start2(BOARD,BCANGET,BCANNUM,NTEMPMAXLIST,NTEMPMAXNUM,NMAX,NLOOP,MAXLIST,MAXNUM,LIMIT,MAXANS);
	MAXLIST=TEMPMAXLIST,MAXNUM is TEMPMAXNUM,MAXANS is MAX,true.

%白の評価値を計算し、評価値の最も高くなるものを返す
eval_stone_white(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM):-
	eval_stone_white_start(BOARD,WCANGET,WCANNUM,0,0,-100,0,MAXLIST,MAXNUM).
eval_stone_white_start(BOARD,WCANGET,WCANNUM,TEMPMAXLIST,TEMPMAXNUM,MAX,LOOP,MAXLIST,MAXNUM):-
	LOOP < WCANNUM,!,
	accesslist(LOOP,WCANGET,STONE),
	accesslist(0,STONE,X),
	accesslist(1,STONE,Y),
	removeboard(X,Y,BOARD,NBOARD),
	insertboard(2,X,Y,NBOARD,NBOARD2),
	eval_board(NBOARD2,_,WANS),
	((WANS>MAX,!,conc([STONE],[],NTEMPMAXLIST),NMAX is WANS,NTEMPMAXNUM is 1);
	(WANS=:=MAX,!,conc([STONE],TEMPMAXLIST,NTEMPMAXLIST),NMAX is WANS,NTEMPMAXNUM is TEMPMAXNUM+1);
	NTEMPMAXLIST = TEMPMAXLIST,NMAX is MAX,NTEMPMAXNUM is TEMPMAXNUM),
	NLOOP is LOOP +1,
	eval_stone_white_start(BOARD,WCANGET,WCANNUM,NTEMPMAXLIST,NTEMPMAXNUM,NMAX,NLOOP,MAXLIST,MAXNUM);
	MAXLIST=TEMPMAXLIST,MAXNUM is TEMPMAXNUM,true.

%白の評価値を計算し、リミットの値よりも小さな最も大きい評価値のものを返す。
eval_stone_white2(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM,LIMIT,MAXANS):-
	eval_stone_white_start2(BOARD,WCANGET,WCANNUM,0,0,-100,0,MAXLIST,MAXNUM,LIMIT,MAXANS).
eval_stone_white_start2(BOARD,WCANGET,WCANNUM,TEMPMAXLIST,TEMPMAXNUM,MAX,LOOP,MAXLIST,MAXNUM,LIMIT,MAXANS):-
	LOOP < WCANNUM,!,
	accesslist(LOOP,WCANGET,STONE),
	accesslist(0,STONE,X),
	accesslist(1,STONE,Y),
	removeboard(X,Y,BOARD,NBOARD),
	insertboard(2,X,Y,NBOARD,NBOARD2),
	eval_board(NBOARD2,_,WANS),
	(((LIMIT>WANS,WANS>MAX),!,conc([STONE],[],NTEMPMAXLIST),NMAX is WANS,NTEMPMAXNUM is 1);
	(WANS=:=MAX,!,conc([STONE],TEMPMAXLIST,NTEMPMAXLIST),NMAX is WANS,NTEMPMAXNUM is TEMPMAXNUM+1);
	NTEMPMAXLIST = TEMPMAXLIST,NMAX is MAX,NTEMPMAXNUM is TEMPMAXNUM),
	NLOOP is LOOP +1,
	eval_stone_white_start2(BOARD,WCANGET,WCANNUM,NTEMPMAXLIST,NTEMPMAXNUM,NMAX,NLOOP,MAXLIST,MAXNUM,LIMIT,MAXANS);
	MAXLIST=TEMPMAXLIST,MAXNUM is TEMPMAXNUM,MAXANS is MAX,true.

%序盤、中盤、終盤にて評価値を変える
%盤面の評価値の計算を行う
eval_board(BOARD,BANS,WANS):-
	check_board_black(BOARD,_,_,BNUM),
	check_board_white(BOARD,_,_,WNUM),
	(((BNUM+WNUM)>43,!,init_board(_,_,_,EVAL_BOARD));
	((BNUM+WNUM)>22,!,init_board(_,_,EVAL_BOARD,_));
	init_board(_,EVAL_BOARD,_,_)),
	eval_board_start(BOARD,EVAL_BOARD,0,0,0,BANS,WANS).
eval_board_start(BOARD,EVAL_BOARD,LOOP,TEMPBANS,TEMPWANS,BANS,WANS):-
	LOOP < 64,!,
	ROW is LOOP//8+1,
	COL is LOOP mod 8+1,
	accessboard(ROW,COL,BOARD,X),
	accessboard(ROW,COL,EVAL_BOARD,EVAL),
	((X=:=1,!,NTEMPBANS is TEMPBANS+EVAL);NTEMPBANS is TEMPBANS),
	((X=:=2,!,NTEMPWANS is TEMPWANS+EVAL);NTEMPWANS is TEMPWANS),
	NLOOP is LOOP+1,
	eval_board_start(BOARD,EVAL_BOARD,NLOOP,NTEMPBANS,NTEMPWANS,BANS,WANS);
	BANS is TEMPBANS,WANS is TEMPWANS.

%%%%盤面の更新%%%%
%盤面に新しい石を置いた後の結果を返す 手番により黒石か白石かを判定
refresh_board(BOARD,STONE,LOOP,FBOARD):-
	X is LOOP mod 2,
	accesslist(0,STONE,ROW),
	ROW =\= -1,!,
	((X=:=0,!,refresh_board_black(BOARD,STONE,FBOARD));
	(X=:=1,!,refresh_board_white(BOARD,STONE,FBOARD)));
	FBOARD=BOARD.

refresh_board_black(BOARD,STONE,FBOARD):-
	accesslist(0,STONE,ROW),
	accesslist(1,STONE,COL),
	serch_line_black(BOARD,ROW,COL,[-1,-1],ANS1),
	serch_line_black(BOARD,ROW,COL,[-1,0],ANS2),
	serch_line_black(BOARD,ROW,COL,[-1,1],ANS3),
	serch_line_black(BOARD,ROW,COL,[0,-1],ANS4),
	serch_line_black(BOARD,ROW,COL,[0,1],ANS5),
	serch_line_black(BOARD,ROW,COL,[1,-1],ANS6),
	serch_line_black(BOARD,ROW,COL,[1,0],ANS7),
	serch_line_black(BOARD,ROW,COL,[1,1],ANS8),
	((ANS1=:=1,!,change_line_black_stone(BOARD,STONE,[-1,-1],BOARD1));BOARD1 = BOARD),
	((ANS2=:=1,!,change_line_black_stone(BOARD1,STONE,[-1,0],BOARD2));BOARD2 = BOARD1),
	((ANS3=:=1,!,change_line_black_stone(BOARD2,STONE,[-1,1],BOARD3));BOARD3 = BOARD2),
	((ANS4=:=1,!,change_line_black_stone(BOARD3,STONE,[0,-1],BOARD4));BOARD4 = BOARD3),
	((ANS5=:=1,!,change_line_black_stone(BOARD4,STONE,[0,1],BOARD5));BOARD5 = BOARD4),
	((ANS6=:=1,!,change_line_black_stone(BOARD5,STONE,[1,-1],BOARD6));BOARD6 = BOARD5),
	((ANS7=:=1,!,change_line_black_stone(BOARD6,STONE,[1,0],BOARD7));BOARD7 = BOARD6),
	((ANS8=:=1,!,change_line_black_stone(BOARD7,STONE,[1,1],FBOARD));FBOARD = BOARD7).
change_line_black_stone(BOARD,STONE,DIR,ANS):-
	accesslist(0,STONE,ROW),
	accesslist(1,STONE,COL),
	removeboard(ROW,COL,BOARD,BOARD1),
	insertboard(1,ROW,COL,BOARD1,NBOARD),
	change_line_black_stone_start(NBOARD,ROW,COL,DIR,ANS).
change_line_black_stone_start(BOARD,ROW,COL,DIR,ANS):-
	accesslist(0,DIR,X),
	accesslist(1,DIR,Y),
	accessboard(ROW+X,COL+Y,BOARD,Z),
	((Z=:=2,!,
		change_stone([ROW+X,COL+Y],BOARD,NBOARD),
		change_line_black_stone_start(NBOARD,ROW+X,COL+Y,DIR,ANS));
	(Z=:=1,!,ANS = BOARD,true)).

refresh_board_white(BOARD,STONE,FBOARD):-
	accesslist(0,STONE,ROW),
	accesslist(1,STONE,COL),
	serch_line_white(BOARD,ROW,COL,[-1,-1],ANS1),
	serch_line_white(BOARD,ROW,COL,[-1,0],ANS2),
	serch_line_white(BOARD,ROW,COL,[-1,1],ANS3),
	serch_line_white(BOARD,ROW,COL,[0,-1],ANS4),
	serch_line_white(BOARD,ROW,COL,[0,1],ANS5),
	serch_line_white(BOARD,ROW,COL,[1,-1],ANS6),
	serch_line_white(BOARD,ROW,COL,[1,0],ANS7),
	serch_line_white(BOARD,ROW,COL,[1,1],ANS8),
	((ANS1=:=1,!,change_line_white_stone(BOARD,STONE,[-1,-1],BOARD1));BOARD1 = BOARD),
	((ANS2=:=1,!,change_line_white_stone(BOARD1,STONE,[-1,0],BOARD2));BOARD2 = BOARD1),
	((ANS3=:=1,!,change_line_white_stone(BOARD2,STONE,[-1,1],BOARD3));BOARD3 = BOARD2),
	((ANS4=:=1,!,change_line_white_stone(BOARD3,STONE,[0,-1],BOARD4));BOARD4 = BOARD3),
	((ANS5=:=1,!,change_line_white_stone(BOARD4,STONE,[0,1],BOARD5));BOARD5 = BOARD4),
	((ANS6=:=1,!,change_line_white_stone(BOARD5,STONE,[1,-1],BOARD6));BOARD6 = BOARD5),
	((ANS7=:=1,!,change_line_white_stone(BOARD6,STONE,[1,0],BOARD7));BOARD7 = BOARD6),
	((ANS8=:=1,!,change_line_white_stone(BOARD7,STONE,[1,1],FBOARD));FBOARD = BOARD7).
change_line_white_stone(BOARD,STONE,DIR,ANS):-
	accesslist(0,STONE,ROW),
	accesslist(1,STONE,COL),
	removeboard(ROW,COL,BOARD,BOARD1),
	insertboard(2,ROW,COL,BOARD1,NBOARD),
	change_line_white_stone_start(NBOARD,ROW,COL,DIR,ANS).
change_line_white_stone_start(BOARD,ROW,COL,DIR,ANS):-
	accesslist(0,DIR,X),
	accesslist(1,DIR,Y),
	accessboard(ROW+X,COL+Y,BOARD,Z),
	((Z=:=1,!,
		change_stone([ROW+X,COL+Y],BOARD,NBOARD),
		change_line_white_stone_start(NBOARD,ROW+X,COL+Y,DIR,ANS));
	(Z=:=2,!,ANS = BOARD,true)).

%%%%メイン関数%%%%

go():-othello().

othello():-
	init_board(BOARD,_,_,_),
	write("			Start othello!!		"),nl,
	disp(BOARD),  	   						%表示
	othello_start(BOARD,0,64).
othello_start(BOARD,LOOP,MAX):-
	LOOP<MAX,!,
	put(32),write(LOOP),
	check_board(BOARD,END1),				%盤面のチェック,END=1なら終了。
	((END1=:=1,!,nl,write("------------End------------"));
%	player(BOARD,ANS1,LOOP),				%黒石はLOOPが偶数
	computer(BOARD,ANS1,LOOP),
	refresh_board(BOARD,ANS1,LOOP,NBOARD1),	%以降BOARDでなくNBOARD1
	disp(NBOARD1),  	   					%黒石を置いた後の表示
	LOOP1 is LOOP +1,
	put(32),write(LOOP1),
	check_board(NBOARD1,END2),				%盤面のチェック,END=1なら終了。
	((END2=:=1,!,nl,write("------------End------------"));
%	player(NBOARD1,ANS2,LOOP1),				%白石ならLOOPが奇数
	computer(NBOARD1,ANS2,LOOP1),
	refresh_board(NBOARD1,ANS2,LOOP1,NBOARD2),%以降NBOARD2
	disp(NBOARD2),  	   					%白石を置いた後の表示
	LOOP2 is LOOP1 +1,
	othello_start(NBOARD2,LOOP2,MAX)));
	true.
