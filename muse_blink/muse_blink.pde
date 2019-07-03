import oscP5.*;
  
// OSC PARAMETERS & PORTS
int recvPort = 7000;
OscP5 oscP5;
  
// DISPLAY PARAMETERS
int WIDTH = 1000;
int HEIGHT = 1000;

boolean blinked = false;
boolean before_blinked = false;
  
void settings(){
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
   if(blinked && !before_blinked){
     System.out.println("### you are blinking");
     before_blinked = true;
   }else if(!blinked){
     before_blinked = false;
   }
}
  
void oscEvent(OscMessage msg) {
  //System.out.println("### got a message " + msg);
  if (msg.checkAddrPattern("muse/elements/blink")==true) {  
    if(msg.get(0).intValue()==1){
      blinked = true;
    }else{
      blinked = false;
    }
  }
}
