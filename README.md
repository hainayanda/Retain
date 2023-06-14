# Retain

Retain is object lifecylce helper that provide a simple way to control object retaining and observe it

[![CI Status](https://img.shields.io/travis/hainayanda/Retain.svg?style=flat)](https://travis-ci.org/hainayanda/Retain)
[![Version](https://img.shields.io/cocoapods/v/Retain.svg?style=flat)](https://cocoapods.org/pods/Retain)
[![License](https://img.shields.io/cocoapods/l/Retain.svg?style=flat)](https://cocoapods.org/pods/Retain)
[![Platform](https://img.shields.io/cocoapods/p/Retain.svg?style=flat)](https://cocoapods.org/pods/Retain)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Swift 5.5 or higher
- iOS 13.0 or higher
- MacOS 10.15 or higher (SPM Only)
- TVOS 13.0 or higer (SPM Only)
- XCode 13 or higher

## Installation

### Cocoapods

Retain is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Retain', '~> 1.0.0'
```

### Swift Package Manager from XCode

- Add it using XCode menu **File > Swift Package > Add Package Dependency**
- Add **<https://github.com/hainayanda/Retain.git>** as Swift Package URL
- Set rules at **version**, with **Up to Next Major** option and put **1.0.0** as its version
- Click next and wait

### Swift Package Manager from Package.swift

Add as your target dependency in **Package.swift**

```swift
dependencies: [
    .package(url: "https://github.com/hainayanda/Retain.git", .upToNextMajor(from: "1.0.0"))
]
```

Use it in your target as a `Retain`

```swift
 .target(
    name: "MyModule",
    dependencies: ["Retain"]
)
```

## Author

hainayanda, hainayanda@outlook.com

## License

Retain is available under the MIT license. See the LICENSE file for more info.

## Usage

### Observe object dealocation

You can observe object dealocation very easily by using global function `whenDealocate(for:do:)`:

```swift
let cancellable = whenDealocate(for: myObject) {
    print("myObject is dealocated")
}
```

It will produce `Combine` `AnyCancellable` and the closure will be called whenever the object is being dealocated by `ARC`.

If you prefer get the underlying publisher instead, use `dealocatePublisher(of:)`:

```swift
let myObjectDealocationPublisher: AnyPublisher<Void, Never> = dealocatePublisher(of: myObject)
```

### DealocateObservable

there's one protocol named `DealocateObservable` that can exposed the global function as a method so it can be used directly from the object itself:

```swift
class MyObject: DealocateObservable { 
    ...
    ...
}
```

so then you can do this to the object:

```swift
// get the publisher
let myObjectDealocationPublisher: AnyPublisher<Void, Never> = myObject.dealocatePublisher

// listen to the dealocation
let cancellable = myObject.whenDealocate {
    print("myObject is dealocated")
}
```

### WeakSubject propertyWrapper

There's a propertyWrapper that enable `DealocateObservable` behavior without implementing one named `WeakSubject`:

```swift
@WeakSubject var myObject: MyObject?
```

this propertyWrapper will store the object in weak variable and can be observed like `DealocateObservable` by accessing its `projectedValue`:

```swift
// get the publisher
let dealocationPublisher: AnyPublisher<Void, Never> = $myObject.dealocatePublisher

// listen to the dealocation
let cancellable = $myObject.whenDealocate {
    print("current value in myObject propertyWrapper is dealocated")
}
```

It will always emit an event for as many object assigned to this `propertyWrapper` as long the object is dealocated when still in this `propertyWrapper`.

### RetainableSubject

RetainableSubject is very similar with WeakSubject. The only difference is, we can control wether this propertyWrapper will retain the object strongly or weak:

```swift
@RetainableSubject var myObject: MyObject?
```

to change the state of the propertyWrapper retain state, just access the `projectedValue`:

```swift
// make weak
$myObject.state = .weak
$myObject.makeWeak()

// make strong
$myObject.state = .strong
$myObject.makeStrong()
```

Since `RetainableSubject` is `DealocateObservable` too, you can do something similar with `WeakSubject`:

```swift
// get the publisher
let dealocationPublisher: AnyPublisher<Void, Never> = $myObject.dealocatePublisher

// listen to the dealocation
let cancellable = $myObject.whenDealocate {
    print("current value in myObject propertyWrapper is dealocated")
}
```

## Contribute

You know how, just clone and do a pull request