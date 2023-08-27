// LEFT&RIGHT:UP&DOWN
int[] Direction;          //移動方向
int[] Vector;             //速度
boolean onSpace;          //スペースが押されたかどうか
boolean isRight;     //プレイヤーが右を向いているかどうか

final int Gravity = 1;        //重力

//各写真
//プレイヤー用画像
PImage playerStandLeft;   
PImage playerStandRight;
PImage[] playerRunLeft;
PImage[] playerRunRight;
PImage playerDead;
//ゴール(宝物)
PImage treasure;
//敵(静)
PImage enemy;

//タイトル
PImage title;
PImage[] sleep;
PImage wakeup;

//　1フレーム前の位置と比較する用
//  0----1
//  |    |
//  |    |
//  3----2
int[] nowPointX;
int[] nowPointY;
int[] beforePointX;
int[] beforePointY;

// 接地しているかどうか
boolean playerOnGround;

//プレイヤー横幅・高さ
int playerWidth=50;
int playerHeight=50;
//プレイヤー位置
int playerX;
int playerY;
// 画面の大きさ
int width=1000,height=500;

//地図情報
// 0:無 1:足場 2:敵 3:ゴール
int[][][] MAP={
 {{0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,3,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0},
  {0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0},
  {0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0},
  {0,0,0,0,0,0,1,1,1,0,1,1,1,1,1,1,0,0,0,1},
  {1,0,0,0,0,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0}}
  
,{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,2,0,0,2,0,0,0,3,0,0,0,0,0,0,0,0}}
  
  //コピー用
,{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}

};

//メニュー画面背景用データ
float[][] initCirclePos;  //初期座標
float[]   initCircleR;     //大きさ
float[][] initCircleSpeed; //速度
int[][]   initCircleColor; //色

//データ初期化用関数
void initData()
{
  // 各点の初期値は0
  for (int i=0; i<4; i++)
  {
    Direction[i%2]=0;
    Vector[i%2]=0;

    nowPointX[i]=0;
    nowPointY[i]=0;
    beforePointX[i]=0;
    beforePointY[i]=0;
  }
  //最初は接地していない
  playerOnGround=false;
  
  //左から50、下から50の位置より開始
  playerX=50;
  playerY=height-50;
  
  //ジャンプ用フラグはfalseに戻す(念の為)
  onSpace=false;
  //最初は右向きにする
  isRight=true;
  
}

void setup()
{
  surface.setResizable(true);
  surface.setSize(width, height);
  frameRate(30);

  PFont font=createFont("MS ゴシック", 50);
  textFont(font);
  textAlign(CENTER);
  noStroke();

  //画像設定
  playerDead=loadImage("dead.png");
  playerStandLeft=loadImage("left.png");
  playerStandRight=loadImage("right.png");
  playerRunLeft=new PImage[2];
  playerRunRight=new PImage[2];
  playerRunLeft[0]=loadImage("leftRun1.png");
  playerRunLeft[1]=loadImage("leftRun2.png");
  playerRunRight[0]=loadImage("rightRun1.png");
  playerRunRight[1]=loadImage("rightRun2.png");
  treasure=loadImage("treasure.png");
  enemy=loadImage("enemy.png");
  title=loadImage("title.png");
  sleep=new PImage[5];
  sleep[0]=loadImage("sleep1.png");
  sleep[1]=loadImage("sleep1.png");
  sleep[2]=loadImage("sleep2.png");
  sleep[3]=loadImage("sleep3.png");
  sleep[4]=loadImage("sleep4.png");
  wakeup=loadImage("wakeup.png");

  //各種配列の初期化
  Direction=new int[2];
  Vector=new int[2];
  nowPointX=new int[4];
  nowPointY=new int[4];
  beforePointX=new int[4];
  beforePointY=new int[4];
  //各初期化
  initData();
  
  initCirclePos = new float[10][2];
  initCircleSpeed = new float[10][2];
  initCircleR = new float[10];
  initCircleColor = new int[10][3];
  
  //すべてランダムで決定
  for(int i=0;i<10;i++)
  {
    initCirclePos[i][0]=random(1000);
    initCirclePos[i][1]=random(500);
    
    // 0にならないよう補正
    initCircleSpeed[i][0]=random(5)+0.5;
    initCircleSpeed[i][1]=random(5)+0.5;
    
    // ランダムで(-1 or 1)をかけ、方向を決める
    initCircleSpeed[i][0]*=float(int(random(2))*2-1);
    initCircleSpeed[i][1]*=float(int(random(2))*2-1);
    
    initCircleR[i]=random(200)+50;
    initCircleColor[i][0]=int(random(255));
    initCircleColor[i][1]=int(random(255));
    initCircleColor[i][2]=int(random(255));
  }
}

// aで左、dで右に方向を入れる
// プレイヤーが接地しているならスペースキーでジャンプ
void keyPressed()
{
  if (key=='a' || key=='A')       Direction[0]=1;
  if (key=='d' || key=='D')       Direction[0]=-1;
  if (key==' ' && playerOnGround) onSpace=true;
}

//キーを離すとフラグを0に
void keyReleased()
{
  if (key=='a' || key=='A')  Direction[0]=0;
  if (key=='d' || key=='D') Direction[0]=0;
}

//タイマー系
int gameTimer=0;      //プレイヤーのアニメーション決定用
int accentTimer=0;    //アルファ値決定用
int titlePhase=0;          //タイトル用画像切り替え
float sita=0;         //角度

//画面遷移用定数
final int START=0;    //スタート画面
final int MENU=1;     //メニュー
final int GAME=2;     //ゲーム
final int GAMEOVER=3; //ゲームオーバー
int GAMEMODE=START;

//ステージ決定用
int STAGE=0;

//クリアしたかどうか
boolean isClear=false;

//メニュー画面へいくかどうか
boolean toMenu=false;

//フォント
PFont font;

void draw()
{
  background(255);
  
  // switch文で画面状態を切り替え
  switch (GAMEMODE)
  {
    case START:
    //メニューへ遷移
    if(toMenu)
    {
      delay(500);
      GAMEMODE=MENU;
    }
    background(250,0,250);
    fill(0);
    image(title,0,0);        //タイトル
    font=createFont("MS ゴシック", 50);
    textFont(font);
    fill(0,255,255,int(accentTimer));                      //accentTimerでa値を決定
    text("PLEASE PRESS ANY KEY...", width/2, height/2+200);
    
    if(keyPressed)
    {
      toMenu=true;  //任意のキーを押下するとメニュー画面へ
      image(wakeup,50,height-50);
    }
    else
    {
      image(sleep[titlePhase],50,height-50);
    }
    
    accentTimer=int(100.0*sin(sita)+150.0);  //正弦波で数値(50,250)を往復
    titlePhase=int(2.0*sin(sita)+2.5);       //正弦波で数値(0,4)を往復
    sita+=0.1;
    sita%=6.28;                              //一周したら0に(オーバーフロー対策)

    break;

    case MENU:
    fill(0);
    initData();  //メニューに戻るたびにデータを初期化
    
    //円の表示
    for(int i=0;i<10;i++)
    {
      fill(initCircleColor[i][0],initCircleColor[i][1],initCircleColor[i][2]);
      ellipse(initCirclePos[i][0],initCirclePos[i][1],initCircleR[i],initCircleR[i]);
      
      //ランダムな速度で円を動かす
      initCirclePos[i][0]+=initCircleSpeed[i][0];
      initCirclePos[i][1]+=initCircleSpeed[i][1];
      
      //端まで行けば方向転換
      if(initCirclePos[i][0]<0 || width<initCirclePos[i][0])
      {
        initCircleSpeed[i][0]*=-1;
      }
      if(initCirclePos[i][1]<0 || height<initCirclePos[i][1])
      {
        initCircleSpeed[i][1]*=-1;
      }
    }
    
    fill(0);
    font=createFont("MS ゴシック", 50);
    textFont(font);
    text("ステージを選択してください",width/2 ,height/2-170);
    font=createFont("MS ゴシック", 100);
    textFont(font);
    
    //ステージ番号の上にカーソルがあれば
    if(width/2-100-25<=mouseX && mouseX<=width/2-100+25&&
       height/2-75<=mouseY && mouseY<=height/2)
    {
      fill(255,0,0);    //文字を赤くする
      if(mousePressed)  //この状態でマウスを押すとゲームスタート
      {
        STAGE=0;
        GAMEMODE=GAME;
      }
    }
    else
    {
      fill(0);
    }
    text("1",width/2-100,height/2);
    
    //上に同じ
    if(width/2+100-25<=mouseX && mouseX<=width/2+100+25&&
       height/2-75<=mouseY && mouseY<=height/2)
    {
      fill(255,0,0);
      if(mousePressed)
      {
        STAGE=1;
        GAMEMODE=GAME;
      }
    }
    else
    {
      fill(0);
    }
    text("2",width/2+100,height/2);
    break;

    case GAME:
    background(255);
   
    //クリアしていたら
    if(isClear)
    {
      delay(2000);    //一定時間停止
      isClear=false;  //フラグは元に戻す
      GAMEMODE=MENU;  //メニューへ戻る
      break;          //脱出
    }
    
    //すり抜け防止用if
    if(Vector[1]<20)
      Vector[1]+=Gravity;  //重力で速度を減らす(プログラム的には増やす)
    
    //マップ読み込み
    for(int iY=0;iY<10;iY++)    //Y座標
    {
      for(int iX=0;iX<20;iX++)  //X座標
      {
        if(MAP[STAGE][iY][iX]==0)//0ならなにもしない
        {
          continue;
        }
        else if(MAP[STAGE][iY][iX]==1)  //1なら足場を設置
        {
          fill(0);
          rect(iX*50,iY*50,50,10);  //横50、縦10の四角形
          
          //プレイヤーが足場の上にいれば
          if(!(playerX+49<iX*50 || iX*50+49<playerX))
          {
            if((beforePointY[2]<=iY*50 && iY*50<= nowPointY[2]))
            {
              playerY=iY*50-50;    //足場から落ちないように押し出し
              Vector[1]=0;        //速度を調整
              playerOnGround=true; //接地判定を入れる
            }
          }
        }
        else if(MAP[STAGE][iY][iX]==2)  //2なら敵を設置
        {
          fill(0);
          image(enemy,iX*50,iY*50);  //敵画像を表示
          
          //プレイヤーが敵に触れていれば
          if(playerX<iX*50+50&&iX*50<playerX+49&&
             playerY<iY*50+50&&iY*50<playerY+49)
          {
            delay(500);        //少し遅らせて
            GAMEMODE=GAMEOVER; //ゲームオーバー画面へ
          }
        }
        else if(MAP[STAGE][iY][iX]==3)    //3ならゴール(宝物)を設置
        {
          image(treasure,iX*50,iY*50);  //ゴール画像を表示
          
          //プレイヤーが触れていれば
          if(playerX<iX*50+50&&iX*50<playerX+49&&
             playerY<iY*50+50&&iY*50<playerY+49)
          {
            fill(255,0,0);
            font=createFont("MS ゴシック", 100);
            textFont(font);
            text("GAME CLEAR!",width/2,height/2);
            isClear=true;    //フラグを入れる。おそらくdraw()関数を出た時点で描画されるので、この回では終了しない
          }
        }
      }
    }
    
    //各点を更新
    beforePointX[0]=nowPointX[0];
    beforePointY[0]=nowPointY[0];
    beforePointX[1]=nowPointX[1];
    beforePointY[1]=nowPointY[1];
    beforePointX[2]=nowPointX[2];
    beforePointY[2]=playerY+50;
    beforePointX[3]=nowPointX[3];
    beforePointY[3]=nowPointY[3];
    
    //速度設定
    Vector[0]=Direction[0]*-5;
    
    //プレイヤーが地面にいる時、位置を調整
    if(height-50<=playerY)
    {
      playerY=height-50;
      Vector[1] =  0;
      playerOnGround=true;  //接地フラグを入れる
    }
   
    //ジャンプ
    if(onSpace&&playerOnGround)
    {
      Vector[1]=-15;
      
      //各フラグを解除
      onSpace=false;
      playerOnGround=false;
    }
    
    //プレイヤー位置更新
    playerX+=Vector[0];
    playerY+=Vector[1];
    
    //左端、右端を超えないようにする
    if(playerX<0)
    {
      playerX=0;
    }
    else if(width-50<playerX)
    {
        playerX=width-50;
    }
    
        //プレイヤーのアニメーション
    if (Direction[0]==1)
    {
      //時間に応じて2つの画像を切り替え
      if (gameTimer<5)
      {
        image(playerRunLeft[0], playerX, playerY, playerWidth, playerHeight);
      }
      else
      {
        image(playerRunLeft[1], playerX, playerY, playerWidth, playerHeight);
      }
      isRight=false;
    }
    else if (Direction[0]==-1)
    {
      if (gameTimer<5)
      {
        image(playerRunRight[0], playerX, playerY, playerWidth, playerHeight);
      }
      else
      {
        image(playerRunRight[1], playerX, playerY, playerWidth, playerHeight);
      }
      isRight=true;
    }
    else      //静止している時
    {
      //動いていたときの方向を向く
      if (isRight)
      {
        image(playerStandRight, playerX, playerY, playerWidth, playerHeight);
      }
      else
      {
        image(playerStandLeft, playerX, playerY, playerWidth, playerHeight);
      }
    }

    
    //位置更新
    nowPointX[0]=playerX;
    nowPointY[0]=playerY;
    nowPointX[1]=playerX+50;
    nowPointY[1]=playerY;
    nowPointX[2]=playerX+50;
    nowPointY[2]=playerY+50;
    nowPointX[3]=playerX;
    nowPointY[3]=playerY+50;
    
    break;
    
    case GAMEOVER:
    image(playerDead,playerX,playerY,50,50);  //死亡時の画像を表示
    
    font=createFont("MS ゴシック", 100);
    textFont(font);
    fill(255,0,0);
    text("GAME OVER!",width/2,height/2-50);
    fill(0);
    font=createFont("MS ゴシック", 32);
    textFont(font);
    text("PLEASE PRESS ANY KEY...",width/2,height/2+50);
    
    if(keyPressed)
      GAMEMODE=MENU;  //メニューへ戻る
    
    break;

    default :
    break;  
  }
  
  //タイマーを更新
  //オーバーフロー対策にmodをかける
  gameTimer++;
  gameTimer%=10;
}
