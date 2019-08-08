import oscP5.*;
import java.util.Random;

// OSC PARAMETERS & PORTS
int recvPort = 7000;
OscP5 oscP5;

boolean blinked = false;
boolean before_blinked = false;
boolean left = false;
boolean before_left = false;
boolean right = false;
boolean before_right = false;

boolean front = false;
boolean before_front = false;
boolean back = false;
boolean before_back = false;

int state = 0;

boolean state_rect[] = {true, true, true};
int position_rect[][]  = new int[3][2];
int colour_rect[]  = new int[3];

int position_now[] = new int[2];
int colour_now;

int begintime;
int endtime;

void setting(){
}
  
void setup(){
  size(1000,1000);
  strokeWeight(3);
  frameRate(60);
  position_now[0] = 500;
  position_now[1] = 500;
  colour_now = 1;
  Random random = new Random();
  for(int i =0;i<3;i++){
    position_rect[i][0] = random.nextInt(7)*100;
    position_rect[i][1] = random.nextInt(7)*100;
    colour_rect[i] = random.nextInt(3);
  }
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);
  background(0);
}

void draw(){ 
  if(state == 0){
    textSize(50);
    text("Press Any Key to Start", 250, 400, 700, 500);
    begintime = millis();
    if (keyPressed == true){
      state++;
    }
  }else if(state == 2){
    background(100);
    fill(0);
    textSize(50);
    text("Your time is " + ((endtime - begintime)/1000) + "sec", 250, 400, 700, 500);
    if (keyPressed == true){
      exit();
    }
  }else{
    background(100);
    
    if(!state_rect[0]&!state_rect[1]&!state_rect[2]){
      endtime = millis();
      state = 2;
    }
    
    if((position_now[0] == position_rect[0][0]) & (position_now[1] == position_rect[0][1]) & (colour_now == colour_rect[0])){
      state_rect[0] = false;
    }else if((position_now[0] == position_rect[1][0]) & (position_now[1] == position_rect[1][1]) & (colour_now == colour_rect[1])){
      state_rect[1] = false;
    }else if((position_now[0] == position_rect[2][0]) & (position_now[1] == position_rect[2][1]) & (colour_now == colour_rect[2])){
      state_rect[2] = false;
    }
    
    for(int i = 0;i<3;i++){
      if(state_rect[i]){
        drawer(position_rect[i][0],position_rect[i][1],colour_rect[i]);
      }
    }
    fill(0);
     textSize(30);
     text(((millis() - begintime) /1000) + " sec", 20, 10, 300, 100);
     if(blinked && !before_blinked){
        System.out.println("### you are blinking");
        before_blinked = true;
         
        colour_now = (colour_now + 1)%3;
      }else if(!blinked){
        before_blinked = false;
      }
       
      if(left && !before_left){
        System.out.println("### your head moved left");
        position_now[0] = position_now[0]+ 100;
        before_left = true;
      }else if(!left){
        before_left = false;
      }
      if(right && !before_right){
        System.out.println("### your head moved right");
        position_now[0] = position_now[0] - 100;
        before_right = true;
      }else if(!right){
        before_right = false;
      }
      if(front && !before_front){
        System.out.println("### your head moved front");
        position_now[1] = position_now[1] - 100;
        before_front = true;
      }else if(!front){
        before_front = false;
      }
      if(back && !before_back){
        System.out.println("### your head moved back");
        position_now[1] = position_now[1] + 100;
        before_back = true;
      }else if(!back){
        before_back = false;
      }
      drawer(position_now[0],position_now[1],colour_now);
  }
}

void drawer(int position_x,int position_y,int colour){

  if(colour == 0){
    fill(255,0,0);
  }else if(colour == 1){
    fill(0,255,0);
  }else{
    fill(0,0,255);
  }
  rect(position_x,position_y,300,300);
}
  
void oscEvent(OscMessage msg) {  
  if(msg.checkAddrPattern("muse/acc")==true) {  
      if(msg.get(1).floatValue() > 0.5){
        left = true;
      }else if(msg.get(1).floatValue() < 0){
        right = true;
      }else{
        left = false;
        right = false;
      }
      if(msg.get(0).floatValue() > 0.2){
        front = true;
      }else if(msg.get(0).floatValue() < -0.2){
        back = true;
      }else{
        back = false;
        front = false;
      }
  } 
  if (msg.checkAddrPattern("muse/elements/blink")==true) {  
    //System.out.println(msg.get(0).intValue());
    if(msg.get(0).intValue()==1){
      blinked = true;
    }else{
      blinked = false;
    }
  }
}
