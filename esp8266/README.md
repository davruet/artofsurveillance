
#Programming an ESP8266 using an Arduino as a serial passthrough

Connections:

* ESP ground to battery ground
* ESP ground to Arduino ground
* ESP 3.3v to battery 3.3v
* ESP TX to Arduino TX
* ESP RX to Arduino RX
* ESP CH_PD to battery 3.3V


To put the ESP8266 into programming mode:

* Connect ESP GPIO0 to GND and then reboot (remove ESP8266 ground and plug it back in)
* When programming finishes, unplug this connection (ESP GPIO0) and reboot again.

![Schematic](esp8266_schem.png)
![Breadboard](esp8266_bb.png)