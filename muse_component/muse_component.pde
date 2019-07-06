import oscP5.*;
  
// OSC PARAMETERS & PORTS
int recvPort = 7000;
OscP5 oscP5;
  
// DISPLAY PARAMETERS
int WIDTH = 1000;
int HEIGHT = 1000;
  
void setting(){
  size(WIDTH,HEIGHT);
}
  
void setup(){
    
  frameRate(60);
    
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);
  background(0);
}

void draw(){
  background(0);
}
  
void oscEvent(OscMessage msg) {
  System.out.println("### got a message " + msg);
  //if (msg.checkAddrPattern("muse/elements/experimental/mellow")==true) {  
  //  print(msg.get(0).floatValue());
 // } 
}
