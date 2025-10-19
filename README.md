# Standby

This app was originally forked from [https://github.com/SemihK/standby](https://github.com/SemihK/standby), but has been modified for personal use and the fork has been detached.

## Purpose

The purpose of this app is to replace an Amazon Echo display, which has been showing an increasing number of advertisements. Since I have a spare iPhone 11, I decided to create this app to serve as a replacement, running on the iPhone.

## App Description

This app is a personalized digital photo frame that displays photos, the current date and time, and weather information.

To prevent screen burn-in from static UI elements like the clock's comma or the settings gear icon, the app will display a full-screen photo at a regular interval. This ensures that the pixels on the screen are changing and helps to preserve the life of the display.

## Setup

To use the weather feature, you will need to add your own OpenWeatherMap API key. You can get a free API key by signing up on the [OpenWeatherMap website](https://openweathermap.org/appid).

Once you have your API key, you will need to add it to the following file:

`StandByTime/standbytime/Model/OpenWeatherService.swift`

Open this file and replace the placeholder text with your API key:

```swift
private let apiKey = "YOUR_API_KEY" // TODO: Replace with your OpenWeatherMap API key
```