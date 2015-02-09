/* SniffAndBlink, by David Rueter. This sketch uses tcpdump to sniff
network packets and blink the screen whenever a packet is received:
a kind of network activity light that can listen to any available
network.
Compatible with mac osx only at the moment.

Developed for the course Art of Surveillance at SAIC.
*/

import java.io.*;

Process p;
BufferedReader stdout;
InputStream stdoutStream;

BufferedReader stderr;
InputStream stderrStream;

long lastPacketTime;

void setup(){
  size(640,480);
  startSniffer();
}


void draw() {
  try {
    while (stderr.ready()){
        System.err.println(stderr.readLine());
      }
      while (stdoutStream.available() > 0){
        String packet = stdout.readLine();
        packetReceived(packet);
      }
  } catch (IOException e){
    e.printStackTrace();
    exit();  
  }
  updateBackgroundColor();
}
/** This method is called whenever a packet is received. The packet
data is contained in the packet String argument. Change what it does
to change how this sketch responds to packets.
**/
void packetReceived(String packet){
  lastPacketTime = millis();
  System.out.println(packet);
}

void updateBackgroundColor(){
  float c = (lastPacketTime - millis());
  c = pow(c, 2);
  c *= -.01f;
  c += 255;
  
  c = max(0, c);
  c = min(255, c);
  background(color(c,c,c));
}



/* Utility methods */

void keyPressed(){
  if (key == 'q'){
    shutdown();
  }  
}

/** Starts a sniffer subprocess using tcpdump.
**/
void startSniffer(){
  try {   
    p = Runtime.getRuntime().exec("/usr/sbin/tcpdump -I -B 1 -i en0");  
    stdoutStream = p.getInputStream();
    stderrStream = p.getErrorStream();
    stdout = new BufferedReader(new InputStreamReader(stdoutStream));
    stderr = new BufferedReader(new InputStreamReader(stderrStream));
     
    Runtime.getRuntime().addShutdownHook(new Thread(){
        public void run(){
          shutdown();         
        }  
    });
      
  } catch (IOException e){
    e.printStackTrace();
    exit();
  }    
}

/** Make sure the process is terminated. If this doesn't happen,
zombie processes can sit around and mess things up, or the OS
networking subsystem can be left in a non-working state.
**/
synchronized void shutdown() {
  p.destroy(); /* no need to check if already destroyed,
  it's cool to call this multiple times, we just need to make
  sure the subprocess is dead. */
  System.out.println("Sniffer subprocess destroyed.");
}


