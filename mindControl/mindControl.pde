import oscP5.*;
import netP5.*;

OscP5 oscP5;

int MAX_BUFFER = 1024;

float med,att,rr;

ArrayList attH,medH,rawH,waves,nia;

void setup(){

  size(1024,768,P2D);

  attH = new ArrayList();
  medH = new ArrayList();
  rawH = new ArrayList();

  waves = new ArrayList();
  nia = new ArrayList();

  oscP5 = new OscP5(this,5003);

}



void draw(){

  background(0);


  /////////// RAW //////////////////////////

  stroke(#ff0000,100);
      try{
  for(int ii = 0; ii < 8;ii++){
    beginShape();
    for(int i = 0 ; i < waves.size();i++){
      int tmp[] = ((int[])waves.get(i));
      vertex(i,height/2-tmp[ii]/100.0);

    }
    endShape();
  }

     }catch(Exception e){
        println("Waves error;");}

  noFill();

try{
  
  /////////// AMR //////////////////////////

  stroke(255,70);

  beginShape();
  for(int i = 0 ; i < attH.size();i++){
    float tmp = (Integer)attH.get(i);
    vertex(i,height-tmp*4.0);

  }
  endShape();

  stroke(#ffcc00,70);

  beginShape();
  for(int i = 0 ; i < medH.size();i++){
    float tmp = (Integer)medH.get(i);
    vertex(i,height-tmp*4.0);

  }
  endShape();
  stroke(#00ff00,70);
  beginShape();
  for(int i = 0 ; i < rawH.size();i++){
    float tmp = (Integer)rawH.get(i);
    vertex(i,height/2-tmp/100.0);

  }
  endShape();
}catch(Exception e){println("AMR Error;");}


  /////////////// NIA ////////////////////
stroke(#ffffff,100);
  
for(int ii = 0; ii < 6;ii++){
    beginShape();
    for(int i = 0 ; i < nia.size();i++){
      float tmp[] = ((float[])nia.get(i));
      vertex(i,height/2-tmp[ii]*10.0);

    }
    endShape();
  }
}

void oscEvent(OscMessage theOscMessage) {
  

  try{
  String pattern = theOscMessage.addrPattern(); 
  if(theOscMessage.checkAddrPattern("/m/raw")){

    int mid[] = new int[8];
    for(int i = 0 ; i < 8;i++){
      mid[i] = theOscMessage.get(i).intValue();
    }

    waves.add(mid);

    if(waves.size()>MAX_BUFFER)
      waves.remove(0);
  }

  if(theOscMessage.checkAddrPattern("/m/amr")){

    
    int a = theOscMessage.get(0).intValue();
    int m = theOscMessage.get(1).intValue();
    int r = theOscMessage.get(2).intValue();

    attH.add(a);
    medH.add(m);
    rawH.add(r);

    if(attH.size()>MAX_BUFFER){
      attH.remove(0);
    }

    if(medH.size()>MAX_BUFFER){
      medH.remove(0);
    }
  
    if(rawH.size()>MAX_BUFFER){
      rawH.remove(0);
    }
  }

  }catch(Exception e){;}
 
  if(theOscMessage.checkAddrPattern("/nia/data")){

    float n[] = new float[6];
    
    for(int i = 0 ; i < n.length ; i++)
        n[i] = theOscMessage.get(i).floatValue();
    
    nia.add(n);

    if(nia.size()>MAX_BUFFER)
      nia.remove(0);
    
    /*
    println("NIA said:"+a);
     print("typetag: "+theOscMessage.typetag());
     println("timetag: "+theOscMessage.timetag());
    */
  }
  
  if(theOscMessage.checkAddrPattern("/nia/raw")){
      String test = theOscMessage.get(0).stringValue();
      println(test);
  }
  
}

