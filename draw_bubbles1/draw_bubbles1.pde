import oscP5.*;
import netP5.*;
OscP5 oscp5;
int OSC_LISTEN_ON = 12345;
PImage img;
PVector source;
float bubblesize = 160;
int BUBBLE_MAX = 1;

//use arraylist to create dynamic array
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();

void setup() {
  size(1424, 900);
  img = loadImage("bubble.png");
  oscp5 = new OscP5(this, OSC_LISTEN_ON);
  source = new PVector();
  source.x = width/2*3;
  source.y = height;
   
  //add first bubble to arraylist
  bubbles.add(new Bubble());
}
  
void draw() {
  background(0);
  imageMode(CENTER);
  
  //loop through array list after bubbles have been added by blowing sensor to draw buubles
  for (int i = bubbles.size()-1; i >= 0; i--) { 
    Bubble bubble = bubbles.get(i);
    bubble.update();
    bubble.draw();
  }  
}
  
void oscEvent(OscMessage msg){
  if (msg.addrPattern().contains("/blowforce")){
    float blowf = msg.get(0).floatValue();
    
    //bow sensor adds bubbles to array
      for(int i = 0; i < BUBBLE_MAX; i++){  
        bubbles.add(new Bubble());
        //print number of bubbles in array
        int total = bubbles.size();
        println("The total number of bubbles is: " + total);
        //remove some bubbles from the arraylist
        if(bubbles.get(i).pos.y < 0){
        bubbles.remove(i);
        println("Now the number of bubbles is: " + bubbles.size()); // Show arraylist size after removing items
        }
      }
   
    println("### received blow force " + blowf);
  } else {
    println("### unknown message");
  }
}
