import ddf.minim.analysis.*;
import ddf.minim.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

int OSC_LISTEN_ON = 54321;
int OSC_SEND_TO = 12345;
String destination = "127.0.0.1";

Minim minim;
AudioInput in;

//Fast Fourier Transform
FFT fft;
float []kfactor;
int kindex;


void setup(){
  size(600, 500);
  oscP5 = new OscP5(this, OSC_LISTEN_ON);
  dest = new NetAddress(destination, OSC_SEND_TO);
  
  kfactor = new float[width];
  
  minim = new Minim(this); //initializes audio engine
  in = minim.getLineIn(); //captures mic input
  fft = new FFT(in.bufferSize(), in.sampleRate()); //performs analysis on the frequency domain of the input 
}

int get_index() {
  if(kindex == 0) return 0;
  if(kindex > width-1) return (width % kindex);
   else return kindex;
}

int inc_index() {
  kindex++;
  if(kindex > width) kindex = 0;
  return kindex;
}

void osc_dispatch_value(float val) {
  OscMessage msg = new OscMessage("/blowforce");
  msg.add(val); // add a parameter to our message
  // send the message
  oscP5.send(msg, dest); 
}

void draw(){
  background(50, 220, 50);
  fill(255);
  noStroke();
  //ellipse(mouseX, mouseY, 20, 20);
  stroke(255, 255, 0);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize() - 1; i++){
    line( i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50 );
    line( i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50 );
  }
  
  String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
  text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
  
  //draw the FTT
  stroke (255, 0, 0);
  fft.forward( in.mix );
  for(int i = 0; i < fft.specSize(); i++){
    line(i, height, i, height - fft.getBand(i)*8);
  }
  
  float blowPower = 0;
  
  for(int j = 0; j <3; j++) {
    blowPower = blowPower + fft.getBand(j);
    //blowPower = blowPower/30;
    noStroke();
    ellipse(blowPower*width/2, mouseY, 20, 20);
  }
  
  blowPower = blowPower/30;
  
  int idx = get_index();
  kfactor[idx] = blowPower;
  inc_index();
  
  // draw the blowing-detection buffer
  stroke (0, 180, 220);
  for(int i = 0; i < width-1; i++) {
    line( i, 250 + kfactor[i]*50, i+1, 250 - kfactor[i+1]*50 );
  }
 
  if(blowPower > 0.5){
    osc_dispatch_value(blowPower);
  }
  
}
