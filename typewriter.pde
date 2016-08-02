import java.io.FileWriter;
import java.io.*; 
FileWriter fw;
BufferedWriter bw;
PFont font;
boolean flag=false;
char [][] board = new char [24] [0];
int count[]=new int[24];
int sum;
int select = 0;
int click=0;
int i=1;
public void init() {
  frame.removeNotify();
  frame.setAlwaysOnTop(true);
  super.init();
}
void setup() {
  for (int i=0; i<24; i++ )count[i]=0;
  size(300, 300);
  background(0);
  font = loadFont("Candara-Italic-24.vlw");
  textFont(font);
}
void mousePressed() {
  if (dist(mouseX, mouseY, width, height)<24) savefile();
  else click++;
}
void board() {
  fill(255);
  for (int i = 0; i < board.length; i++) 
    for (int j = 0; j < board[i].length; j++) {
      //  自分の後ろが足りない
      if (board[i][j]=='m'||board[i][j]=='w')text(board[i][j], j*17+37, i*30+45);
      //自分の後ろが大きい
      else if (board[i][j]=='a'||board[i][j]=='s'||board[i][j]=='t'||board[i][j]=='i'||board[i][j]=='r')
      text(board[i][j], j*17+43, i*30+45);
      //それ以外
      else text(board[i][j], j*17+40, i*30+45);//mとwのときは17暗い感覚
    }
}
void savefile() {
  try {
    File file=new File("/users/temp/desktop/typewriter.txt");
    if (!file.exists()) file.createNewFile();
    FileWriter fw = new FileWriter(file, true);///true = append
    BufferedWriter bw = new BufferedWriter(fw);
    PrintWriter pw = new PrintWriter(bw);
    for (int i=0; i<select; i++)
      pw.println(board[i]);
    pw.close();
  }
  catch(IOException ioe) {
    System.out.println("Exception ");
    ioe.printStackTrace();
  }
  flag=true;
}
void delete() {
  if (select!=0&&count[select]==0)select--;  
  else if (count[select]!=0) { 
    board[select]=shorten(board[select]);
    count[select]--;
  }
  if (select < 0)select = 0;
}
void keyPressed() {
  if (keyCode==ENTER&&select<22) {
    select++;
    sum++;
  }
  //BS押したときに何もなかったら段落一つ削除
  else if (keyCode==BACKSPACE&&count[select]>=0) {
    delete();
    sum--;
    if (sum<0)sum=0;
  } else {
    board[select]=append(board[select], key);
    count[select]++;
    sum++;
  }
}
void draw() {
  background(0);
  board();
  if (flag) {
    fill(0, 255, 0);
    rect(0, i, width, 2);
    i+=height/100;
    if (i>=height) {
      i=0;  
      for (int i=0; i<sum; i++)delete();
      flag=false;
    }
  }
  fill(255);
  //クリックするごとにウィンドウサイズ不可変に
  if (click%2==1)changeWindowSize(mouseX+100, mouseY+100);
  ellipse(width, height, 40, 40);//当たり判定
}
void changeWindowSize(int w, int h) {
  //ウィンドウのサイズ変更
  //参考(http://d.hatena.ne.jp/kougaku-navi/20140725/p1)
  frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
  size(w, h);
}

