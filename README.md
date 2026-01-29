**README.md**

# Flick
Flick is a gesture-based music controller built for Apple Watch. The goal is to remove the need to open your device or fumble with tiny buttons when you just want to skip a song.

## How it works
Three simple wrist gestures control your media:
- **Flick left**: Next track
- **Flick right**: Previous track  
- **Hold upside-down**: Play/Pause

The app uses your Watch's accelerometer and gyroscope to detect these movements.

## Why I made this
I wanted something dead simple for controlling music while skiing, biking, or being active. Pulling out my phone on the slopes is cold and annoying. Trying to tap AirPod controls with gloves on doesn't work all that great.
The iPod Shuffle had the right idea with physical simplicity all those years ago, but I wanted to make it modern and take it a step further.

## Current status
At gestures untested at this moment, but all graphics and app flow are up and running. A welcome screen greets you upon first luanch, and a simple tutorial walks you through each gesture.
Volume control isn't possible because WatchOS doesn't expose those APIs, even for remote playback. There may be a workaround as I learn more.

## Installation
Want to test it yourself? You can sideload for free to your own personal device after authenticating yourself to develop on that device.
How to use:
- Clone this repo and open it in Xcode
- Build it to your Apple Watch

---

Flick is made for people who don't want to break their flow just to skip a song.
