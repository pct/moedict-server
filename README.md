# 萌字典 API Server

## 緣起
寫程式造福社會

## 致謝
[http://g0v.tw](http://g0v.tw)

[http://3du.tw](http://3du.tw)

## 快照
![](https://raw.github.com/pct/moedict-server/master/screenshots/1.png)

## 字庫
參照 [https://github.com/yllan/moedict-mac](https://github.com/yllan/moedict-mac) 及 kcwu 的 sqlite 檔案

## iOS app client?
參照 [https://github.com/pct/moedict-ios-app](https://github.com/pct/moedict-ios-app) 建置

## 編譯
`取得 db.sqlite3` (參照前述字庫說明)

`$ cd moedict-server`

`$ npm install` (install node.js modules)

`$ node app` (run server)

## TODO
1. 沒加入安全設計，會被亂玩
2. 程式碼未優化
3. 「詞」仍無資料，應該是 bug