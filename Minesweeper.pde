import de.bezier.guido.*;
public static final int NUM_ROWS = 10;
public static final int NUM_COLS = 10;
public static final int NUM_MINES = (int)(Math.random()*5)+2;
private MSButton[][] gRid; //2d array of minesweeper 
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper  that are mined
public boolean endGame, isLost;
public boolean stop = false;
 

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    gRid = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r ++)
        for (int c = 0; c < NUM_COLS; c ++)
          gRid[r][c] = new MSButton(r, c);    
    
    
    setMines();
}
public void setMines(){
  while(mines.size() < NUM_MINES){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(gRid[r][c]))
      mines.add(gRid[r][c]);
  }
}

public void draw ()
{
    background( 0 );
    //if(isWon() == true)
    //    displayWinningMessage();
    //if(isWon() == false)
    //    displayLosingMessage();
}
public boolean isWon(){
  for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c <   NUM_COLS; c++) {
          if(!mines.contains(gRid[r][c]) && gRid[r][c].clicked == false) {
          return false;
          }
        }
      }
    return true; 
}

public void displayLosingMessage(){
     for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(mines.contains(gRid[r][c])){
          gRid[r][c].clicked = true; 
        }
      }
    }  
    stop = true;
     background(0);
     //  textAlign(CENTER);
     // textSize(40);
      fill(0);
      text("OMG You won!!", width/2, height/2);
    gRid[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("Y"); 
    gRid[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("O"); 
    gRid[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("U"); 
    gRid[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("F"); 
    gRid[NUM_ROWS/2][NUM_COLS/2].setLabel("A"); 
    gRid[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("I"); 
    gRid[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("L");
    gRid[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("!"); 
}

public void displayWinningMessage(){
    // if(isWon()) {
    //   //background(0);
    //  // textAlign(CENTER);
    //  //textSize(40);
    //  fill(255, 155, 255);
    //  text("OMG You won!!", width/2, height/2);
    //gRid[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("O"); 
    //gRid[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("M"); 
    //gRid[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("G"); 
    //gRid[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("U"); 
    //gRid[NUM_ROWS/2][NUM_COLS/2 +1].setLabel("W"); 
    //gRid[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("I"); 
    //gRid[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("N");
    // }
}

public boolean isValid(int r, int c){
     return (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS);
}

public int countMines(int row, int col){
    int numMines = 0;
    for(int i = row-1; i <= row+1; i++){
    for(int j = col-1; j <= col+1; j++)
      if(isValid(i,j) && mines.contains(gRid[i][j]))
      numMines++;
            //System.out.println(numMines);

    }
          if(mines.contains(gRid[row][col]))
    numMines--;
    
    return numMines;
}


public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        if(stop == true)
        return;
        if(mouseButton == LEFT && !flagged && !isLost){
          clicked = true;
          if(countMines(myRow, myCol) == 0){
            for(int i = myRow-1; i<myRow+1; i++){
              for(int j = myCol-1; j< myCol+1; j++){
                if(isValid(i, j) && !gRid[i][j].clicked && (i != myRow || j != myCol))
                gRid[i][j].mousePressed(); // recursion
              }
            }
          }
        }
        if  (mines.contains( this ))
          displayLosingMessage();
        else if(mouseButton == RIGHT && !clicked && !isLost){
          flagged = !flagged;
        }
    }
    public void draw () {    
        if (clicked && mines.contains(this))
          isLost = true;
        if (mines.contains(this) && isLost)
          fill(255, 0, 0);
        //else if (mines.contains(this) && isWon())
        //  fill(0, 255, 0);
        else if (flagged)
          fill(0, 0, 255);
        else if (clicked)
          fill(200,200,100);
        else 
        fill(100,180,100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
        
       if (clicked && !mines.contains(this) && countMines(myRow, myCol) > 0) {
      fill(255);
      text(countMines(myRow, myCol), x + width/2, y + height/2);
      }
      if(isWon()){
      background(0);
            fill(255, 155, 255);
            textAlign(CENTER);
      text("OMG you won!!", 200,200);
      }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
