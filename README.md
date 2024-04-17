# smooth-route-ios

<br />
<div align="center">
  <a href="https://github.com/kmekarski/smooth-route-ios">
<img src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/ed7d77c6-ebf2-4f3e-bf89-41bbae9fb124" alt="Logo" width="240" height="240">
  </a>
  <h3 align="center">Enhancing your driving experience</h3>
</div>

## About the project

Smooth Route is an iOS app for collecting and processing road quality data build with SwiftUI and UIKit.
Reports are based shocks detected by device's accelerometer and then sent and proccessed on the Firebase server.
It uses the Apple MapKit framework to display information about the quality of routes on the map.

<br />
<div align="center">
  <h3>Watch the video presentation of this project here!</h3>
  <a href="https://youtu.be/vn4O-AucFew">
    <img src="https://img.youtube.com/vi/vn4O-AucFew/0.jpg" alt="SmoothRoute Video Presentation">
  </a>
</div>

#### Searching for routes
Starting screen is simply showing user's location on the map. 
To search for route, tap searchbar at the top of the screen, and then type in desired address.

<div align="center">
  <img width="200" alt="Starting screen" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/7e10f09e-636a-42c2-8d93-252dc2b62c83">
  <img width="200" alt="Typing in address" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/a03e1269-5aa0-4e01-9aaf-57818acf6a55">
</div>

#### Getting results
Once data about routes' quality is downloaded from Firebase, they are presented along with their quality ratings. If there is insufficient data about route's quality, a warning is displayed, alerting the user that the information may not be comprehensive.

<div align="center">
  <img width="200" alt="Meaningful results" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/b76b3c61-9644-4b0d-a7c1-62e439e8e613">
  <img width="200" alt="Meaningful detailed results" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/0780f255-51b5-437d-966c-794735e3f37d">
  <img width="200" alt="Getting blank results" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/09833870-0db9-4827-983a-bece25e22369">
  <img width="200" alt="Detailed blank results" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/536a57e0-bebc-49b9-8f38-586fb43e0750">
</div>

#### Collecting data

After selecting a route, the user is navigated to the driving screen. Here, they can see the chosen route, real-time road quality ratings measured by device's accelerometer, and the option to submit manual report based on personal opinion.
<div align="center">
  <img width="200" alt="Started driving" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/f6b55567-bbde-4827-921b-cff4f7aef5e3">
  <img width="200" alt="Manual report" src="https://github.com/kmekarski/smooth-route-ios/assets/72306134/1e993089-0c80-45c9-b98e-62e3346ca17d">
</div>
