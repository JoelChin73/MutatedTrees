
Tree[] tree;
float[] angle;
int[] iterations;
float[] d;
float[] treeHue;

int N = 4; //size of selection grid
int NPROG = N*N; //number of trees
int SZ= 1000; //screen size
boolean Selected = true; //selection of growing tree

int winner;

void setup(){
  size(1000,1000);
  colorMode(HSB,TWO_PI,100,100); // with the HSB, we change only hue to change the colour. TWO_PI is the range of the hue
  tree = new Tree[NPROG]; //array of 16 trees
  //arrays of the values that are randomised, later in the code
  angle = new float[NPROG];
  iterations = new int[NPROG];
  d = new float[NPROG];
  treeHue = new float[NPROG];
  initGenes();// draws the initial set of trees
  //frameRate() is low because we would want the observation more than a quick rundown. 
  //frameRate() 2 can be a little too quick for an observation, 
  //and although frameRate()at  1 may be good for observation purposes, I chose 1.4 
  //to have just a quick observation how it will grow over a period of time
  frameRate(1.4);
    
}

void draw(){
  background(0,0,100);//white background
  stroke(0);

  //creates a new generation of future aspects of the trees
  if (Selected){
    treeGrowth();
    Selected = false;
  }
  pushMatrix();
  grid();
  popMatrix();
  //drawing of trees
  development();
  generateNext();
}

void grid(){
  //drawing horizontal and vertical lines to separate the 16 trees into 16 boxes
  for (int k=0; k<N; k++){
    line(0,k*height/N,width,k*height/N);
    line(k*width/N,0,k*width/N,height);
  }
  //red highlight around the child at top left
  stroke(TWO_PI,100,100);
  noFill();
  for (int k=1;k<5; k++){
    rect(k,k,width/N-2*k,height/N-2*k);
  }
  stroke(0);
}

void initGenes(){
  //any random angle it can grow in
  for (int k=0; k<NPROG; k++){
    angle[k] = random(40)*PI/40;
  } 
  //first iteration value for the 15 trees, which are all the trees except the tree in the highlighted grid.
  for (int j=1; j<NPROG; j++){
    iterations[j] = 1;
  } 
  //tree[0] at first frame should not show any form of growth
  //hence iternations at 0 should not give any signs of growth
  //By default it has a stem, which is a line drawn.
  iterations[0] = 0;
  for (int l=0; l<NPROG; l++){
    d[l] = 0.7;
  } 
  //hue is at such a value as to portray green,
  //which is more of a natural colour for plants in general.
  for (int m=0; m<NPROG; m++){
    treeHue[m] = 0.3*TWO_PI;
  } 
}

// the development of trees are drawn here.
void development(){
  for(int k=0; k<NPROG; k++){
    int x = (int)( (k%N+0.5) * width/N);
    int y = (k/N+1) * height/N;
    pushMatrix();
    translate(x,y);
    tree[k]= new Tree(d[k] ,0, 0, angle[k], iterations[k], treeHue[k]);//giving either the initialised or the randomised values
    tree[k].draw();//drawing of trees
    popMatrix();
  }  
}


//treeGrowth makes mutated copies of the possible future tree growths
void treeGrowth(){
    //have the angle decrease or increase.
    int sign = random(2)<1?-1:+1;
    //random change of the value of the angle
    for (int j=1; j<NPROG; j++){
        angle[j] = angle[0] + sign*(random(30)*PI/180);//30 degrees of change, to prevent a overwhelming change of angle.
      }
    //random change of the value of the length of the lines drawn
    for (int k=1; k<NPROG; k++){
      if(d[k]>0.4 && d[0]>0.4){  //to prevent it from growing in the opposite direction if it chooses itself as the new biomorph
        d[k] = d[0] + sign*(random(10)/150);
      }
      else if (d[0]<=0.4 && d[k]<=0.4){
        d[k] = d[0] + (random(10)/100);  //pushes the tree back to grow upwards
      }
    }
    //random change of the value of the colour. (where a single value can come into play)
    for (int l=1; l<NPROG; l++){
      {
        treeHue[l] = treeHue[0] + sign*(random(50)/100);//0 to 0.5 change, to prevent a overwhelming change of colour.
      }
    }
}


//selection run automatically, and to transfer the selection to tree[0]
void generateNext(){

  //map the coordinates to the index of the selected Biomorph
  int mapX = (int) random(4);
  int mapY = (int) random(4);
  
  //to map the winner
  //we find the count for the tree as it draws from right to left
  //in a downward manner as well
  winner = mapY*N+mapX;
  print(winner);
  Selected = true;
  //copy the genese of the selected Biomorph to become the parent (array index 0) of the next generation
  iterations[0]= iterations[winner];
  if(iterations[0]<5){
    // to ensure iterations do not exceed 6. Iterations more than 5 takes a lot more memory to run.
    for (int j=1; j<NPROG; j++){
    iterations[j] = iterations[j]+1;
    }
  }
  //transferring the values of selected tree 
  //to tree[0] which is the highlighted tree
    angle[0] = angle[winner];
    d[0] = d[winner];
    treeHue[0] = treeHue[winner];
  }