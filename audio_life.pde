import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
AudioInput ai;
AudioBuffer ab;
FFT fft;

float[] angle1;
float[] angle2;
float[] y, x, x2, y2;

float Q = 2000;
float E = 150;
float C1= 0;
float C2= 20;
boolean inv= false;

float time= 0;
int savedTime;
int totalTime = 1000;

int sideways=0;
int horizontal = 0;
int diagonal = 1;

float halfH;
float colorInc1;
float colorInc2;

float[] lerpedBuffer = new float[1024];
float lerpedY=0;

boolean[][] board;
boolean[][] next;
int size = 450;
float cellSize;

void setup() {
  size(1920, 1080, P3D);
  minim = new Minim(this);
  player = minim.loadFile("phonk.mp3");
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  y = new float [fft.specSize()];
  x = new float [fft.specSize()];
  x2 = new float [fft.specSize()];
  y2 = new float [fft.specSize()];
  angle1 = new float [fft.specSize()];
  angle2 = new float [fft.specSize()];
  frameRate(120);
  savedTime = millis();
  ab = player.mix;
  halfH = height/2;
  colorInc1 = 255/(float)1024;
  colorInc2 = 255/(float)500;
  colorMode(HSB);
  board = new boolean[size][size];
  next = new boolean[size][size];
  cellSize = width / (float) size;
}
boolean isAlive(int row, int col) {
  if (row >= 0 && row < size && col >= 0 && col < size)
  {
    return board[row][col];
  } else
  {
    return false;
  }
}
void draw() {
  background(0);
  drawBoard();
  update();
  fft.forward(player.mix);
  float sum = 0 ;
  for (int i = 0; i<ab.size(); i++) {
    sum +=abs(ab.get(i));
    lerpedBuffer[i] = lerp(lerpedBuffer[i], ab.get(i), 0.1f);
  }
  float average = sum / (float)ab.size();
  lerpedY = lerp(lerpedY, average, 0.1f);
  strokeWeight(4);
  stroke(255);
  fill(0);
  circle(width/2, height/2, lerpedY*1000);
  noStroke();
}
void visualization()
{
  noStroke();
  ///////////////////////////////////////////////// big core
  pushMatrix();
  translate(width/2, height/2, 0);
  for (int i = 0; i < fft.specSize(); i++) {
    y[i] = y[i];
    x[i] = x[i];
    angle2[i] = angle2[i]+fft.getFreq(i)/Q;
    rotateX(sin(angle2[i]/5)/50);
    rotateY(cos(angle2[i]/5)/50);
    fill(20, 255-fft.getFreq(i)*2, 255-fft.getBand(i)*2);
    pushMatrix();
    translate((x[i]+E), (y[i]));
    box(fft.getFreq(i)/10+fft.getFreq(i)/10);
    popMatrix();
  }
  popMatrix();

  /////////////////////////////////////////////// increase core
  pushMatrix();
  translate(width/2, height/2, 0);
  for (int i = 0; i < fft.specSize(); i++) {
    y[i] = y[i];
    x2[i] =x2[i]+fft.getFreq(i)/500;

    angle2[i] = angle2[i]/1.007+fft.getFreq(i)/6000;
    rotateX(sin(angle2[i]/5)/15);
    rotateY(cos(angle2[i]/5)/15);
    fill(20, 255-fft.getFreq(i)*2, 255-fft.getBand(i)*2);
    pushMatrix();
    translate((x[i]+E), (y[i]-50));
    box(fft.getFreq(i)/10+fft.getFreq(i)/10);
    popMatrix();
  }
  popMatrix();
}
void update()
{
  ////////////////////////////////////////////////////// diagonal
  if (diagonal == 1) {
    if ((lerpedY*500>=10)&&(lerpedY*500>=20)) {
      for (int i = 0; i < 448; i ++) {
        int x = 0;
        x = x + i;
        board[x][x+2]=true;
        board[x][x]=true;
      }
      for (int i = 0; i < 448; i ++) {
        int x = 0;
        int y = 447;
        x = x + i;
        y = y - i;
        board[x][y+2]=true;
        board[x][y]=true;
      }
    }

    if ((lerpedY*500>=30)&&(lerpedY*500>=50)) {
      for (int i = 0; i < 398; i ++) {
        int x = 50;
        int y = 0;
        x = x + i;
        y = y + i;
        board[x][y+2]=true;
        board[x][y]=true;
      }
      for (int i = 0; i < 398; i ++) {
        int x = 0;
        int y = 50;
        x = x + i;
        y = y + i;
        board[x][y+2]=true;
        board[x][y]=true;
      }
      for (int i = 0; i < 398; i ++) {
        int x = 0;
        int y = 397;
        x = x + i;
        y = y - i;
        board[x][y+2]=true;
        board[x][y]=true;
      }
      for (int i = 0; i < 398; i ++) {
        int x = 50;
        int y = 447;
        x = x + i;
        y = y - i;
        board[x][y+2]=true;
        board[x][y]=true;
      }
    }

    if ((lerpedY*500>=70)&&(lerpedY*500>=90)) {
      for (int i = 0; i < 348; i ++) {
        int x = 100;
        int y = 0;
        x = x + i;
        y = y + i;
        board[x][y+2]=true;
        board[x][y]=true;
      }

      for (int i = 0; i < 348; i ++) {
        int x = 0;
        int y = 100;
        x = x + i;
        y = y + i;
        board[x][y+2]=true;
        board[x][y]=true;
      }

      for (int i = 0; i < 348; i ++) {
        int x = 0;
        int y = 347;
        x = x + i;
        y = y - i;
        board[x][y+2]=true;
        board[x][y]=true;
      }

      for (int i = 0; i < 348; i ++) {
        int x = 100;
        int y = 447;
        x = x + i;
        y = y - i;
        board[x][y+2]=true;
        board[x][y]=true;
      }
    }
  }
  ////////////////////////////////////////////////////////// horizontal
  if (horizontal==1) {
    if ((lerpedY*500>=10)&&(lerpedY*500>=15)) {
      for (int row = 0; row < size; row ++) {
        board[row][224]=true;
      }
    }
    if ((lerpedY*500>=20)&&(lerpedY*500>=30)) {
      for (int row = 0; row < size; row ++) {
        board[row][244]=true;
        board[row][204]=true;
      }
    }
    if ((lerpedY*500>35)&&(lerpedY*500>=45)) {
      for (int row = 0; row < size; row ++) {
        board[row][264]=true;
        board[row][184]=true;
      }
    }
    if ((lerpedY*500>=50)&&(lerpedY*500>=60)) {
      for (int row = 0; row < size; row ++) {
        board[row][284]=true;
        board[row][164]=true;
      }
    }
    if ((lerpedY*500>=65)&&(lerpedY*500>=75)) {
      for (int row = 0; row < size; row ++) {
        board[row][304]=true;
        board[row][144]=true;
      }
    }
    if ((lerpedY*500>80)&&(lerpedY*500>=90)) {
      for (int row = 0; row < size; row ++) {
        board[row][324]=true;
        board[row][124]=true;
      }
    }
    if ((lerpedY*500>95)&&(lerpedY*500>=105)) {
      for (int row = 0; row < size; row ++) {
        board[row][344]=true;
        board[row][104]=true;
      }
    }
    if ((lerpedY*500>110)&&(lerpedY*500>=120)) {
      for (int row = 0; row < size; row ++) {
        board[row][364]=true;
        board[row][84]=true;
      }
    }
    if ((lerpedY*500>125)&&(lerpedY*500>=135)) {
      for (int row = 0; row < size; row ++) {
        board[row][384]=true;
        board[row][64]=true;
      }
    }
    if ((lerpedY*500>140)&&(lerpedY*500>=150)) {
      for (int row = 0; row < size; row ++) {
        board[row][404]=true;
        board[row][44]=true;
      }
    }
  }
  ////////////////////////////////////////////////////// sideways
  if (sideways==1) {
    if ((lerpedY*500>=10)&&(lerpedY*500>=15)) {
      for (int col = 0; col < size; col ++) {
        board[224][col]=true;
      }
    }
    if ((lerpedY*500>=20)&&(lerpedY*500>=30)) {
      for (int col = 0; col < size; col ++) {
        board[244][col]=true;
        board[204][col]=true;
      }
    }
    if ((lerpedY*500>35)&&(lerpedY*500>=45)) {
      for (int col = 0; col < size; col ++) {
        board[264][col]=true;
        board[184][col]=true;
      }
    }
    if ((lerpedY*500>=50)&&(lerpedY*500>=60)) {
      for (int col = 0; col < size; col ++) {
        board[284][col]=true;
        board[164][col]=true;
      }
    }
    if ((lerpedY*500>=65)&&(lerpedY*500>=75)) {
      for (int col = 0; col < size; col ++) {
        board[304][col]=true;
        board[144][col]=true;
      }
    }
    if ((lerpedY*500>80)&&(lerpedY*500>=90)) {
      for (int col = 0; col < size; col ++) {
        board[324][col]=true;
        board[124][col]=true;
      }
    }
    if ((lerpedY*500>95)&&(lerpedY*500>=105)) {
      for (int col = 0; col < size; col ++) {
        board[344][col]=true;
        board[104][col]=true;
      }
    }
    if ((lerpedY*500>110)&&(lerpedY*500>=120)) {
      for (int col = 0; col < size; col ++) {
        board[364][col]=true;
        board[84][col]=true;
      }
    }
    if ((lerpedY*500>125)&&(lerpedY*500>=135)) {
      for (int col = 0; col < size; col ++) {
        board[384][col]=true;
        board[64][col]=true;
      }
    }
    if ((lerpedY*500>140)&&(lerpedY*500>=150)) {
      for (int col = 0; col < size; col ++) {
        board[404][col]=true;
        board[44][col]=true;
      }
    }
  }
  /////////////////////////////////////////////////////////// invert color
  /////////////////////////////////////////////////////////// change between horizontal, vertical and diagonal
  /////////////////////////////////////////////////////////// due to significant changes in frequency at certain timestamps
  int passedTime = millis() - savedTime;
  println(passedTime);
  if ((passedTime>=10700)&&(passedTime<=13000)&&(lerpedY*500>=30)) {
    C1= 50;
    C2=0;
    sideways=1;
    horizontal=0;
    diagonal=0;
    Q = 1500;
    E = 160;
  }
  if ((passedTime>=23100)&&(passedTime<=27000)&&(lerpedY*500>=40)) {
    C1= 0;
    C2=100;
    sideways=0;
    horizontal=1;
    diagonal=0;
    Q = 1000;
    E = 170;
  }
  if ((passedTime>=48000)&&(passedTime<=49900)&&(lerpedY*500>=40)) {
    C1= 130;
    C2=0;
    sideways=1;
    horizontal=0;
    diagonal=1;
    Q = 500;
    E = 190;
  }
  if ((passedTime>=60000)&&(passedTime<=69900)&&(lerpedY*500>=30)) {
    C1= 0;
    C2=180;
    sideways=0;
    horizontal=1;
    diagonal=1;
    Q = 320;
    E = 210;
  }
  if ((passedTime>=75000)&&(passedTime<=89900)&&(lerpedY*500>=40)) {
    C1= 220;
    C2=0;
    sideways=1;
    horizontal=1;
    diagonal=0;
    Q = 200;
    E = 220;
  }
  if ((passedTime>=100000)&&(passedTime<=109000)&&(lerpedY*500>=40)) {
    C1= 0;
    C2=255;
    sideways=1;
    horizontal=0;
    diagonal=1;
    Q = 100;
    E = 255;
  }
  if ((passedTime>=130000)&&(passedTime<=139000)&&(lerpedY*500>=40)) {
    C1= 255;
    C2=0;
    sideways=0;
    horizontal=0;
    diagonal=1;
    Q = 50;
    E = 255;
  }
  if ((passedTime>=135000)&&(passedTime<=139000)&&(lerpedY*500>=40)) {
    C1= 0;
    C2=255;
    sideways=1;
    horizontal=1;
    diagonal=1;
    Q = 10;
    E = 255;
  }
  if ((passedTime>=135000)&&(passedTime<=139000)&&(lerpedY*500>=40)) {
    C1= 255;
    C2=0;
  }
  if ((passedTime>=140000)&&(passedTime<=144000)&&(lerpedY*500>=40)) {
    C1= 0;
    C2=255;
  }
  if ((passedTime>=145000)&&(passedTime<=149000)&&(lerpedY*500>=40)) {
    C1= 255;
    C2=0;
  }
  if ((passedTime>=150000)&&(passedTime<=154000)&&(lerpedY*500>=40)) {
    C1= 0;
    C2=255;
  }
  if ((passedTime>=155000)&&(passedTime<=159000)&&(lerpedY*500>=40)) {
    C1= 0;
    C2=0;
  }
  //////////////////////////////////////////////////////////// game of life rules and board
  //////////////////////////////////////////////////////////// any live cell with fewer than two live neighbours dies
  //////////////////////////////////////////////////////////// any live cell with two or three live neighbours lives on to the next generation
  //////////////////////////////////////////////////////////// any live cell with more than three live neighbours dies
  //////////////////////////////////////////////////////////// any dead cell with exactly three live neighbours becomes a live cell
  for (int row = 0; row < size; row ++)
  {
    for (int col = 0; col < size; col ++)
    {
      float p;
      p = countLiveCellsAround(row, col);
      if (board[row][col]==true)
      {
        if (p<2)
        {
          next[row][col]=false;
        }
        if ((p>=2)&&(p<=3))
        {
          next[row][col]=true;
        }
        if (p>3)
        {
          next[row][col]=false;
        }
      }
      if (board[row][col]==false)
      {
        if (p==3)
        {
          next[row][col]=true;
        }
        if (p>3)
        {
          next[row][col]=false;
        }
        if (p<3)
        {
          next[row][col]=false;
        }
      }
    }
  }
  boolean[][] temp;
  temp = board;
  board = next;
  next = temp;
}
int countLiveCellsAround(int row, int col)
{
  int count = 0;
  for (int r = row -1; r <= row+1; r++)
  {
    for (int c = col - 1; c <= col + 1; c ++)
    {
      if (! (c == col && r == row))
      {
        if (isAlive(r, c))
        {
          count ++;
        }
      }
    }
  }
  return count;
}
void drawBoard()
{
  background(C1);
  visualization();
  for (int row = 0; row < size; row ++)
  {
    for (int col = 0; col < size; col ++)
    {
      if (board[row][col])
      {
        fill(C2);
      } else
      {
        noFill();
      }
      float x = map(col, 0, size, 0, width);
      float y = map(row, 0, size, 0, height);
      rect(x, y, cellSize, cellSize);
    }
  }
}
