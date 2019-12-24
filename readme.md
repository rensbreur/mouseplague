# mouseplague

This app makes each mouse connected to your Mac have a seperate cursor on the screen.

![Screenshot](screenshot.png)

This project does not have any dependencies. On running the app, macOS will ask to accept the permissions that are necessary for mouseplague to work.

### What is working
* Support for multiple monitors setup.
* Support for an infinite number of connected mice.
* Mouse acceleration.

### What does not work yet
* Hovering or dragging with any secondary mouse.
* The MacBook internal trackpad has a delay and haptic feedback does not work if it is used as a secondary mouse.

### Technical details

mouseplague uses the HID Manager from IOKit to communicate with mouse devices and uses the Quartz Event Services framework to perform clicks. One of the mice connected to the computer will be the main mouse and will work as before.
