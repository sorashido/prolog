## オセロ

(1)実行方法、実行例

実行例
```
3 ?- go.
                        Start Osero!!
  1  2  3  4  5  6  7  8
1|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
2|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
3|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
4|  |  |  |○ |● |  |  |  |
 |--|--|--|--|--|--|--|--|
5|  |  |  |● |○ |  |  |  |
 |--|--|--|--|--|--|--|--|
6|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
7|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
8|  |  |  |  |  |  |  |  |
 -------------------------  0
        Black:2  White:2

computer
  1  2  3  4  5  6  7  8
1|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
2|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
3|  |  |  |● |  |  |  |  |
 |--|--|--|--|--|--|--|--|
4|  |  |  |● |● |  |  |  |
 |--|--|--|--|--|--|--|--|
5|  |  |  |● |○ |  |  |  |
 |--|--|--|--|--|--|--|--|
6|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
7|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
8|  |  |  |  |  |  |  |  |
 -------------------------  1
        Black:4  White:1

computer
  1  2  3  4  5  6  7  8
1|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
2|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
3|  |  |○ |● |  |  |  |  |
 |--|--|--|--|--|--|--|--|
4|  |  |  |○ |● |  |  |  |
 |--|--|--|--|--|--|--|--|
5|  |  |  |● |○ |  |  |  |
 |--|--|--|--|--|--|--|--|
6|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
7|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
8|  |  |  |  |  |  |  |  |
 -------------------------  2
        Black:3  White:3

computer
  1  2  3  4  5  6  7  8
1|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
2|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
3|  |  |○ |● |  |  |  |  |
 |--|--|--|--|--|--|--|--|
4|  |  |● |● |● |  |  |  |
 |--|--|--|--|--|--|--|--|
5|  |  |  |● |○ |  |  |  |
 |--|--|--|--|--|--|--|--|
6|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
7|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
8|  |  |  |  |  |  |  |  |
 -------------------------  3
        Black:5  White:2

computer
  1  2  3  4  5  6  7  8
1|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
2|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
3|  |  |○ |● |  |  |  |  |
 |--|--|--|--|--|--|--|--|
4|  |  |○ |● |● |  |  |  |
 |--|--|--|--|--|--|--|--|
5|  |  |○ |○ |○ |  |  |  |
 |--|--|--|--|--|--|--|--|
6|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
7|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
8|  |  |  |  |  |  |  |  |
 -------------------------  4
        Black:3  White:5

computer
  1  2  3  4  5  6  7  8
1|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
2|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
3|  |  |○ |● |  |  |  |  |
 |--|--|--|--|--|--|--|--|
4|  |  |● |● |● |  |  |  |
 |--|--|--|--|--|--|--|--|
5|  |● |○ |○ |○ |  |  |  |
 |--|--|--|--|--|--|--|--|
6|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
7|  |  |  |  |  |  |  |  |
 |--|--|--|--|--|--|--|--|
8|  |  |  |  |  |  |  |  |
 -------------------------  5
        Black:5  White:4


中略

computer
  1  2  3  4  5  6  7  8
1|○ |○ |○ |○ |○ |○ |  |○ |
 |--|--|--|--|--|--|--|--|
2|● |● |● |○ |○ |● |● |○ |
 |--|--|--|--|--|--|--|--|
3|● |● |○ |● |○ |○ |● |○ |
 |--|--|--|--|--|--|--|--|
4|● |○ |● |● |● |● |○ |○ |
 |--|--|--|--|--|--|--|--|
5|● |○ |○ |● |○ |● |○ |○ |
 |--|--|--|--|--|--|--|--|
6|● |● |○ |○ |● |● |● |○ |
 |--|--|--|--|--|--|--|--|
7|● |● |● |● |● |● |● |○ |
 |--|--|--|--|--|--|--|--|
8|○ |○ |○ |○ |  |● |  |○ |
 -------------------------  57
        Black:30  White:31

computer
  1  2  3  4  5  6  7  8
1|○ |○ |○ |○ |○ |○ |  |○ |
 |--|--|--|--|--|--|--|--|
2|● |● |● |○ |○ |● |● |○ |
 |--|--|--|--|--|--|--|--|
3|● |● |○ |● |○ |○ |● |○ |
 |--|--|--|--|--|--|--|--|
4|● |○ |● |● |● |● |○ |○ |
 |--|--|--|--|--|--|--|--|
5|● |○ |○ |● |○ |● |○ |○ |
 |--|--|--|--|--|--|--|--|
6|● |● |○ |○ |○ |● |○ |○ |
 |--|--|--|--|--|--|--|--|
7|● |● |● |○ |○ |○ |● |○ |
 |--|--|--|--|--|--|--|--|
8|○ |○ |○ |○ |○ |● |  |○ |
 -------------------------  58
        Black:25  White:37

computer
  1  2  3  4  5  6  7  8
1|○ |○ |○ |○ |○ |○ |  |○ |
 |--|--|--|--|--|--|--|--|
2|● |● |● |○ |○ |● |● |○ |
 |--|--|--|--|--|--|--|--|
3|● |● |○ |● |○ |○ |● |○ |
 |--|--|--|--|--|--|--|--|
4|● |○ |● |● |● |● |○ |○ |
 |--|--|--|--|--|--|--|--|
5|● |○ |○ |● |○ |● |○ |○ |
 |--|--|--|--|--|--|--|--|
6|● |● |○ |○ |● |● |○ |○ |
 |--|--|--|--|--|--|--|--|
7|● |● |● |○ |○ |● |● |○ |
 |--|--|--|--|--|--|--|--|
8|○ |○ |○ |○ |○ |● |● |○ |
 -------------------------  59
        Black:28  White:35

computer
  1  2  3  4  5  6  7  8
1|○ |○ |○ |○ |○ |○ |○ |○ |
 |--|--|--|--|--|--|--|--|
2|● |● |● |○ |○ |○ |○ |○ |
 |--|--|--|--|--|--|--|--|
3|● |● |○ |● |○ |○ |○ |○ |
 |--|--|--|--|--|--|--|--|
4|● |○ |● |● |● |● |○ |○ |
 |--|--|--|--|--|--|--|--|
5|● |○ |○ |● |○ |● |○ |○ |
 |--|--|--|--|--|--|--|--|
6|● |● |○ |○ |● |● |○ |○ |
 |--|--|--|--|--|--|--|--|
7|● |● |● |○ |○ |● |● |○ |
 |--|--|--|--|--|--|--|--|
8|○ |○ |○ |○ |○ |● |● |○ |
 -------------------------  60
        Black:25  White:39
!!!!WHITE WIN!!!!
------------End------------
true.
```

## アルゴリズム/データ構造の説明

オセロをするための一連の流れは以下のとおりである。
```
盤面のチェック（石の数や勝利条件の判定）
↓
黒石をどこに置くかを決める
↓
石を置き、盤面を新たにする
↓
盤面のチェック
↓
白石をどこに置くか決める
↓
石を置き、盤面を新たにする
```
以上をどちらも置けなくなるまで繰り返す。
コンピュータがどこに置くかの決めるために、石の位置による局面評価を行っている。

盤面を表すために、リストを用いており、
要素が0ならば、何も置かれていない
1ならば黒石、2ならば白石を意味する。

初期状態ならば以下のようにあらわされる。
```
BOARD=[[0,0,0,0,0,0,0,0],
	   [0,0,0,0,0,0,0,0],
       [0,0,0,0,0,0,0,0],
       [0,0,0,2,1,0,0,0],
       [0,0,0,1,2,0,0,0],
       [0,0,0,0,0,0,0,0],
	   [0,0,0,0,0,0,0,0],
	   [0,0,0,0,0,0,0,0]].
```
## 述語の説明
```
accesslist(N,LIST,X)::リストの参照
accessboard(ROW,COL,BOARD,X)::盤面の要素を参照する

removelist(X,LIST,Rest)::リストの削除
removeboard(ROW,COL,BOARD,X)::盤面の要素の削除

insertlist(X,N,LIST,Result)::リストに要素を挿入
insertboard(X,ROW,COL,BOARD,ANS)::%盤面の要素の挿入

conc(LIST1,LIST2,LIST3)::連結

member(X,LIST)::リストへ含むかの判定

init_board(BOARD,EVAL_BOARD1,EVAL_BOARD2,EVAL_BOARD3)::盤面と評価値のセット

disp(BOARD)::表示

change_stone(POS,BOARD,ANS)::石をひっくり返す
check_board_black(BOARD,BCANGET,BCANNUM,BNUM)::盤面において、黒がとれる位置とその数を数える
check_board_white(BOARD,WCANGET,WCANNUM,WNUM)::盤面において、白がとれる位置とその数を数える
check_board(BOARD,NEND)::盤面のチェック

player(BOARD,ANS,LOOP)::手動で石を打つ
computer(BOARD,ANS,LOOP)::コンピュータ

eval_stone_black(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM)::黒の評価値を計算し、評価値の最も高いものを返す
eval_stone_black2(BOARD,BCANGET,BCANNUM,MAXLIST,MAXNUM,LIMIT,MAXANS)::黒の評価値を計算し、リミットの値よりも小さな最も大きい評価値のものを返す。

eval_stone_white(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM)::白の評価値を計算し、評価値の最も高くなるものを返す
eval_stone_white2(BOARD,WCANGET,WCANNUM,MAXLIST,MAXNUM,LIMIT,MAXANS)::白の評価値を計算し、リミットの値よりも小さな最も大きい評価値のものを返す。

eval_board(BOARD,BANS,WANS)::盤面の評価値の計算を行う

refresh_board(BOARD,STONE,LOOP,FBOARD)::%盤面に新しい石を置いた後の結果を返す 手番により黒石か白石かを判定

othello()::メイン関数
```

## 参考文献のリスト
- http://uguisu.skr.jp/othello/7-1.html
- http://www.geocities.jp/m_hiroi/prolog/
- http://qiita.com/kataware/items/1713cde6fe463d329c2a
