public class Bubble {
  PVector pos;
  PVector vel;
  PVector acc;
  float step;
  
//this is our constructor (it has the same name as the class)
  public Bubble(){
    acc = new PVector(random(-0.4, 0.2), random (-0.4, -0.01));
    pos = new PVector(width/2*3, height);
    vel = new PVector(random(6,10), 0);
  }
  
  public void update(){
    //change speed
    vel.x = vel.x + acc.x;
    vel.y = vel.y + acc.y;
    //change speed
    pos.x += vel.x;
    pos.y += vel.y;
  }
  
  public void draw(){
    imageMode(CENTER);
    step += 0.01;
    float xpos = pos.x;
    float ypos = pos.y;
    float disp = noise(step);
    xpos = xpos * disp;
    image(img, xpos, ypos, bubblesize, bubblesize);
  }
}
