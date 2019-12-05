# CustomTableView
Shows how to use SwiftUI to wrap `UITableView` when you need greater control over the table and its events.

I started developing a new app using SwiftUI. For the most part, it works well, but there are definitely some gaps. You can
find all kinds of examples appearing, probably daily, as people try out SwiftUI, and post their own findings and examples.

One of the things I need to do is present a list of data that comes from a remote server. All I really know about the data
is that I should fetch it in batches (or chunks or pages). Until I fetch the first batch of data, I have no idea how large 
the data set will be. Sometimes its just 3 items, sometimes its over 3,000 items. Rather than fetching all of the records at
once, I fetch them in batches and use the scrolling of the list to determine when to fetch the next batch.

Another thing I need to do is present multiple lists with a row of scrollable buttons to select a specific list. When a list
becomes active, it immediately fetches its first batch of data if its empty; otherwise it waits for the list to scroll to 
fetch more.

One more thing I wanted to do, but could not, was fade a button in and out as the list was scrolled. This is something our
Android version does quite well and I wanted the behavior to be the same. Unfortunately, SwiftUI's `List` does not provide
any scrolling events. There are some suggestions about looking for a bottom row but I need to trigger an animation as the list
is scrolling.

I was able to do the first two things reasonably well using the SwiftUI `List` component, but I ran into a performance problem when the list
got large. Or specifically, when I switched between lists and made one list active. For the life of me, I cannot figure out 
why this would take a long time. I determined that the SwiftUI `List` was *NOT* trying to build all of the items, but whether
or not those items were present certainly impacted the performace.

Having the need to monitor scrolling along with this performance problem, I decided to create my own SwiftUI wrapper for 
`UITableView`. I'm pretty sure the SwiftUI `List` is such a wrapper, but I don't need to be so generic. 

This GIT repro is what I came up with as a prototype. The `TableView` is the wrapped `UITableView` and it uses a `TableViewDataSource`
to supply the data to present. You also pass it something that conforms to the `TableViewDelegate` protocol which will provide feedback
during scrolling, when a row is tapped, and so forth. 

> Using the delegate pattern is not very SwiftUI-like, but as I am still somewhat of a novice with SwiftUI, this was the most
> straightforward approach I could think of to accomplish my goals. I welcome anyone who can suggest changes to make
> this component feel more at home in the SwiftUI realm.

The cells in the table are subclasses of `UITableViewCell` and use a `XIB` for layout. You can do that in code of course, but
I wanted to show how you can blend the old with the new in case you need to do that.

You can use the `TableView` like this:

```
TableView(
    dataSource: self.mutableData as TableViewDataSource, 
    delegate: self
)
```
This `TableView` is contained (look at the `ContentView.swift` file) within a `VStack` that's ultimately contained within a 
`NavigationView`. What you want to do when a row is tapped is activate a `NavigationLink`. I found a handy way to do this
on `StackOverflow.com`:

````
NavigationLink(destination: DetailView(rowIndex: self.detailViewRow), isActive: self.$detailViewActive) {
    EmptyView()
}
.frame(width: 0, height: 0)
.disabled(true)
.hidden()
````

This `NavigationLink` is hidden on the screen and tapping on a row of the `TableView` causes the `@State` vars, `detailViewRow` 
and `detailViewActive`, to be changed, and trigger the `NavigationLink`.

Check out the `TableView` source file. It isn't that big and you can certainly find ways to customize how it works.
