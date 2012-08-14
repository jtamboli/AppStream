# AppFeed

A minimal Mac OS X app.net client

## REQUIREMENTS

* Mountain Lion
* Xcode 4.5(latest beta), _maybe_ 4.4
* Courage

## HOWTO

* Create a app.net client app.
* Use "x-com-toxicsoftware-appfeed:///" as the Callback URL.
* Build and run the app, follow the instructions for setting the client id

## GOALS

* I want to make a stable featureful app.net client that works _really_ well in full screen mode. Whether this means multiple column (tweetdeck style but less shit) or not is up for debate
* Use the Latent Semantic Mapping framework to classify posts
* Intelligently handle hashtags, usernames, urls etc - provide popover contextual info/actions on these item, e.g. hashtags popover will have a "view all posts with this hashtag" action.

## TODO/BUGS

* All post sorting is broken. Not parsing ISO8601 dates yet.
* UI is ass. Not too interested in UI until basic network and database functionality is there.
* Overloading of the term stream: https://alpha.app.net/schwa/post/52516 - this is a problem in code. As real app.net streams come online I expect a refactor will be needed.
* Posting
* Deleting
* User Lists
* User Info
* Database will grow and grow. Need to prune at some point.
* Refresh
* Code is being "sketched out" and is far from well designed. Expect a lot of churn/refactoring

## LICENSE

* I haven't included a license yet but all code will be licensed under the BSD 2 clause license.
