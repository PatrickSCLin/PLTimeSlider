<meta name='keywords' content='iOS, slider, timeslider, time slider, custom, customization, customized, custom slider, custom picker'>

#PLTimeSlider 

PLTimeSlider is a customized slider for iOS, simple and easy to use.

####Preview

![preview](http://i.imgur.com/CP4ykW8.gif)

####Requirement 

 - XCode 8.1

####Support

 - Support custom styling
 - Support pick start time & end time
 - Magic

####Delegate

```swift
public protocol PLTimeSliderDelegate: NSObjectProtocol {
    
    func slider(slider: PLTimeSlider, valueDidChanged value: UInt, type: PLTimeSliderValueType)
    
}
```
