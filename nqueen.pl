%rep11: 第11回 演習課題レポート
%2015年6月18日  25115078 柴田大地
%
%min_conf 版 N_queens問題
%
%[熟語の説明]
%n_queens(N) //Nクイーンの解を求める
%

%/*リストの操作とか*/
accesslist(0,[X|_],X):- !.
accesslist(N,[_|Rest],X):-N1 is N-1,accesslist(N1,Rest,X).
%/*削除*/
removelist(0,[_|Rest],Rest):-!.
removelist(N,[Y|Rest1],[Y|Rest2]):-
    N1 is N-1,removelist(N1,Rest1,Rest2).
%/*挿入*/
insertlist(X,0,Rest,[X|Rest]):-!.
insertlist(X,N,[Y|Rest1],[Y|Rest2]):-
    N1 is N-1,insertlist(X,N1,Rest1,Rest2).
%/*連結*/
conc([], List, List).
conc([X | L1], L2, [X | List]) :-conc(L1, L2, List).
%/*リストへ含むかの判定*/
member(X,[X|_]):-!.
member(X,[_|L]):-member(X,L).

%/*初期化*/
%/* Nは個数 AnsはN個のランダムなリスト(数にかぶりはない=同じ行と列にいない)*/
init_queens(N,Ans):-
    init_start([],N,0,Ans).

init_start(Queens,N,Loop,Ans):-
    Loop < N,!,                          %
    init_get(Queens,N,Temp),             %Queensへ入れる値を求める
    conc([Temp],Queens,NewQueens),       %Queensへ追加
    NLoop is Loop +1,
    init_start(NewQueens,N,NLoop,Ans);   %ループ
    Loop =:=N,Ans=Queens,true.           %Ansに値を入れ終了

init_get(Queens,N,Temp):-
    Temp1 is random(N),                  %ランダムに値を手に入れる
    not(member(Temp1,Queens)),!,         %条件分岐
    Temp=Temp1,true;                     %終了
    init_get(Queens,N,Temp).             %もう一度

%/*衝突数の計算*/
%/*Queensの衝突数 Attacked*/
get_attack(Queens,N,Ans):-
    get_attack_start(Queens,N,0,[],Ans).

get_attack_start(Queens,N,Loop,Attack,FAns):-
    Loop < N,!,
    get_conf(Queens,N,Loop,Ans),                %Loop番目のQueensの衝突数Ansを求める
    conc(Attack,[Ans],NewAttack),                   %後ろへ連結
    NLoop is Loop +1,
    get_attack_start(Queens,N,NLoop,NewAttack,FAns); %N回ループ
    Loop =:=N,FAns=Attack,true.

%/*num列目のクイーンがいくつ衝突しているか計算*/
get_conf(Queens,N,Num,Ans):-
    get_conf_start(Queens,N,Num,0,0,Ans).

get_conf_start(Queens,N,Num,Conf,Loop,Ans):-
    Loop < N,!,
    Temp is Loop-Num,
    accesslist(Loop,Queens,X),                    %X=queens[Loop]
    accesslist(Num,Queens,Y),                     %Y=queens[Num]<-この衝突数を知りたい
    (Num=\=Loop,
     (X=:=Y;                                      %条件のうちいずれかを満たせば
     Temp+Y=:=X;
     Temp+X=:=Y),
    NConf is Conf+1,!;							  %いずれかを満たせばConfに1を加える
    NConf is Conf),
    NLoop is Loop +1,
    get_conf_start(Queens,N,Num,NConf,NLoop,Ans); %ループ
    Loop =:= N,Ans is Conf,true,!.                %失敗すればカット

%/*解く*/
solve_queens(Queens,N,Loop,Attacked):-
    Loop < 10000,!,                                  %ループ数が10000回を超えた ら解なしで終了
    ((check_attack(Attacked),!,write(Queens));       %終了条件を満たしていれば終了
    select_move_queen(Attacked,N,SelectNum),         %どのクイーンを動かすか選択
    search_conf(Queens,N,SelectNum,Conf),            %動かした場合の衝突数を求める
    change_queen(Queens,N,Conf,SelectNum,NewQueens), %クイーンの交換
    get_attack(NewQueens,N,NewAttacked),             %衝突数を計算
    NLoop is Loop+1,
    solve_queens(NewQueens,N,NLoop,NewAttacked));    %ループ
    Loop =:=10000,write(notslove),true.              %解が見つからない場合の処理

%/*解の条件を満たしているか調べる*/
check_attack([]):-!.           %空になれば終了
check_attack([First|Rest]):-   %要素は全て0ならばOK
    First=:=0,
    check_attack(Rest).

%/*衝突しているクイーンからランダムに選択*/
select_move_queen(Attacked,N,Ans):-   %
    Ans is random(N),                 %ランダムに選んだ物が衝突していなければOK
    accesslist(Ans,Attacked,X),
    X=\=0,!,true;
    select_move_queen(Attacked,N,Ans).

%/*SelectNumのQueenを動かしたときの衝突数を求める*/
search_conf(Queens,N,SelectNum,Ans):-
    search_conf_start(Queens,N,SelectNum,[],0,Ans).
search_conf_start(Queens,N,SelectNum,TmpAns,Loop,FinalAns):-
    Loop < N,!,
    removelist(SelectNum,Queens,Queens1),          %クイーンのSelectNum番目を消 去
    insertlist(Loop,SelectNum,Queens1,Queens2),    %クイーンのSelectNumへLoopを 挿入
    get_conf(Queens2,N,SelectNum,Ans),             %移動したクイーンの衝突数を求める
    conc(TmpAns,[Ans],NewTmpAns),                  %連結
    NLoop is Loop+1,
    search_conf_start(Queens,N,SelectNum,NewTmpAns,NLoop,FinalAns);%ループ
    Loop =:=N,FinalAns = TmpAns,true.

%/*クイーンの入れ替え*/
change_queen(Queens,N,Conf,SelectNum,NewQueens):-
    get_min(Conf,N,Move),                         %衝突数最小の数を取り出す
    removelist(SelectNum,Queens,Queens1),         %元々を削除
    insertlist(Move,SelectNum,Queens1,NewQueens). %挿入

%/*最小を取り出す*/
get_min(Conf,N,Ans):-get_min_start(Conf,N,[],0,10,Ans).%Conf最小がAns

get_min_start(Conf,N,List,Loop,Min,Ans):-
    Loop < N,!,
    accesslist(Loop,Conf,X),             %Loop番目のConfを取り出す
    ((X=:=Min,!,                         %最小値に等しかったら
     NewMin = Min,                       %
     conc(List,[Loop],NewList));         %最小値のリストを更新する
    (X<Min,!,                            %最小値が更新されたら
     NewMin = X,
     NewList=[Loop]);                    %最小値のリストを新しくする
     NewList =List,
     NewMin =Min),
    NLoop is Loop+1,
    get_min_start(Conf,N,NewList,NLoop,NewMin,Ans);
    length(List,AnsL),Tmp is random(AnsL),Loop=:=N,accesslist(Tmp,List,Ans),true.

%/*main文*/
n_queens(N):-
    init_queens(N,Queens),                %盤面をランダムに初期化
    get_attack(Queens,N,Attacked),        %衝突数を計算
    solve_queens(Queens,N,0,Attacked).    %解く
/*
実行結果
*/
/*
考察
*/