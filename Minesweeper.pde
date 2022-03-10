import de.bezier.guido.*;
private final static int NUM_ROWS = 5;
private final static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        buttons[r][c] = new MSButton(r,c);
    
    
    setMines();
}
public void setMines()
{
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if(!mines.contains(buttons[row][col]))
    mines.add(buttons[row][col]);
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
   for(int r = 0; r < buttons.length; r++)
     for(int c = 0; c < buttons[r].length; c++)
       if(buttons[r][c].clicked == false && !mines.contains(buttons[r][c]))
         return false;
   return true;
}
public void displayLosingMessage()
{
    buttons[2][2].setLabel("You Lost!");
}
public void displayWinningMessage()
{
    buttons[2][2].setLabel("You Won!");
}
public boolean isValid(int r, int c)
{
    return (r >= 0 && c >= 0) && (r < NUM_ROWS && c < NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for(int r = row-1; r <= row+1; r++)
    for(int c = col-1; c <= col+1; c++)
      if(isValid(r,c)==true && mines.contains(buttons[r][c]))
        numMines++;
  if(mines.contains(buttons[row][col]))
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
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true)
            flagged = false;
          else if(flagged == false){
            flagged = true;
            clicked = false;
          }
        }
        else if(mines.contains(this))
          displayLosingMessage();
        else if(countMines(myRow, myCol) > 0)
          setLabel(countMines(myRow, myCol));
        else if(isValid(myRow, myCol-1) == true && buttons[myRow][myCol-1].clicked == false)
            buttons[myRow][myCol-1].mousePressed();
        else if(isValid(myRow, myCol+1) == true && buttons[myRow][myCol+1].clicked == false)
            buttons[myRow][myCol+1].mousePressed();
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
