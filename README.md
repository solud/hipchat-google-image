# hipchat-google-image

Add functionality to your hipchat rooms with this integration. When configured and running, type a simple command to display the first result of a google image search based on the text after the command. Think of it like Google's "I'm feeling lucky" button, but with image results, in Hipchat rooms. 

In a hipchat room, typing:
/i hipchat is cool

Would have this script post the following image URI to the room, along with a preview of the image in the room.
http://blog-content.hipchat.com/wp-content/uploads/2010/03/SXSW2010-utexas-HCI-professor-chris_rivers-hipchat-shirt.png

* Google Safe-search is on by default. 
* Be careful as introducing this may cause a productivity loss with room users finding interesting search results. 

Install
====
* bundle install
* Use Hipchat's "Build your own" integration plugin to set up a public endpoint on which this script listens for POST calls from Hipchat. 
* Assign a command to the app in the integration creation screen (currently /i is handled but can be easily adjusted)
* Take the API token displayed and place it in the "tokens" hash as the value for a key containing the name of the room in which you create the integration. Multiple rooms are supported, just add another key to the tokens hash.
* Make sure the configured endpoint is reachable externally

Tested with Ruby 2.2
