unite-winpath
=============

With unite.vim, add or remove path to PATH environment variable in Windows.  
unite.vimのインターフェースを使って、  
PATH環境変数にパスを追加あるいは削除することができます。  
変更できるのはユーザ環境変数のみです。  

unite-source は winpath, winpath/add が追加されます。  
unite-kind は path_fragment が追加されます。  
action は edit, add, delete があります。  

PATH以外の環境変数を操作する winenvi も同梱しています。

unite-source は winenvi, winenvi/new が追加されます。  
unite-kind は envi が追加されます。  
action は edit, new, delete があります。  
