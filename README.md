# Find.Fun

Find.Fun is a small app to discover about nearby interesting places.

![Light theme demo](https://github.com/moonchild94/Find.Fun/blob/master/Light%20theme.gif) ![Dark theme demo](https://github.com/moonchild94/Find.Fun/blob/master/Dark%20theme.gif)

## Architecture 
`MVP` architecture has been chosen:
 * Helps to organize code better comparing with MVC and prevent overloaded controllers.
 * Makes layers less connected with each other that helps to maintain and extend the code.

## Libraries
 * `FloatingPanel` - library for floating panels. Popular, well documented, and extendable. Help to create well looking floating panels as fast as possible.
 * `Apollo` - a flexible GraphQL client for iOS, but probably might be replaced with more lightweight solution. Is used to  make communication with `digitransit` API easier.
 * `Polyline` - a lightweight maps polyline encoder/decoder. Is used to decode polyline data received from `digitransit` API and apply it to the iOS map.
 * `NotificationBannerSwift` - library for screen notifications. Simple, popular and extendable. Help to create a well looking screen messages as fast as possible.
 * `Kingfisher` - image loading library. Simple to use. Helps to get rid of tons of boilerplate code during web image downloading.

## API
### Directions API
`digitransit` service has been chosen because it was more reasonable to use Apple MapKit in the application but google API can not be used without google maps since their policy doesn't allow to use it with 3rd party maps (https://developers.google.com/maps/documentation/directions/policies). 

## What might be improved
 * Improve handling a cluster point tap action. It might show a list of clustered places in a floating panel.
 * Add accessibility by supporting dynamic type.
 * `digitransit` can be used only for Finland. We can use apple directions in case of other countries.
 * Show user's travelled way.
 * Add more transport types.
