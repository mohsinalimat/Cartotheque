# Cartotheque

This class allows you to make a credit card selection page



## Screenshots
![Cartotheque](/screenshots/screen.gif)


## Usage

```swift
let cartotheque = Cartotheque()
cartotheque.dataSource = self
```
Implement a CartothequeDataSource protocol

```swift
func cards() -> [CardView] {
    return getCards()
}
```

