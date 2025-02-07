# WeatherMeApp_iOS 
![48_ios_apple_icon](https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/936236cb-445f-4430-ac97-3c367f1bacf4) ![48_swift_icon-3](https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/3d35e284-a9e7-4851-9601-9439c26c41f3)

The simple weather iOS application using the new Apple WeatherKit API.


<div style="display: flex; justify-content: center;">
  <img src="https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/ae9dbf0a-adc1-4005-a944-1114349e6fee" width="28%" alt="example 1" style="margin-right: 100px;"/>
  <img src="https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/c8d86139-c0e7-4f40-8163-ade150ec194e" width="28%" alt="example 2" style="margin-right: 100px;"/>
  <img src="https://github.com/HelenaL/WeatherMeApp_iOS/assets/5014495/91059275-ce49-4454-a692-17dbc1cfe8d6" width="28%" alt="example 3" style="margin-right: 100px;"/>
</div>


# Project Details
In this project, the following technologies are used:
* WeatherKit - API for getting weather broadcast (key is not required)
* CoreData(+NSFetchedResultsController) - for storing the list of the user's cities
* CLLocationManager - for detecting user location, which is needed to show local weather (if a user allows to use their location)
* [MeshKit](https://github.com/EthanLipnik/MeshKit) - used in the project (as a package dependency) to create a gradient view for city weather 

# User Interface

<strong> List of City Weather </strong>

This screen shows a list of saved cities and weather for them. The search bar allows a user to find and add new cities. The top cell shows the weather for the user's location if it's allowed, otherwise, the cell My Location weather is hidden. On top of that, a user can delete any saved city by swiping a cell. 

<strong> Weather for City </strong>

This screen depicts detailed weather for the chosen city in three blocks:
* Current weather
* Hourly weather forecast 
* 10-day weather forecast 

Сurrent weather includes information about temperature and weather conditions (or possible weather alerts). There is a mesh gradient render on the background which is generated according to the current temperature range.

<strong> City Search </strong>

When a user starts typing the name of a city in Search bar, City Search Controller with search results is shown modally. Then a user can choose the desired city to add to the saved list of cities.

