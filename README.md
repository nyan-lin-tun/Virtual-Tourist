# Virtual-Tourist
Udacity iOS Nano degree project

The Virtual Tourist app downloads and stores images from Flickr. The app allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.

### Flickr API Keys:
This app uses the Flickr API to get the photos associated to location. In order to use this app, you'll have to provide your own Flickr API key. To configure it, you'll need to add a new file called <strong>keys.xcconfig</strong>, inside the <strong>Secrets/</strong> folder.

Inside this file you can place your api key like this: <br> 

<code>FLICKR_API_KEY = YOUR_FLICKR_API_KEY</code> <br> 
<code>FLICKR_API_SECRET = YOUR_FLICKR_API_SECRET</code>

There's also a TestKeys.xcconfig file you can use to copy this simple configuration.
