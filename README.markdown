# AppFeed

A minimal Mac OS X app.net client

## REQUIREMENTS

* Mountain Lion
* Xcode 4.5(latest beta), _maybe_ 4.4
* Courage

## HOWTO

* Create a app.net client app.
* Use "x-com-toxicsoftware-appfeed:///" as the Callback URL.
* Don't forget to do a submodule update!
* Build and run the app, follow the instructions for setting the client id

## GOALS

* I want to make a stable featureful app.net client that works _really_ well in full screen mode. Whether this means multiple column (tweetdeck style but less shit) or not is up for debate

## TODO/BUGS

* UI is ass. Not too interested in UI until basic network and database functionality is there.
* Overloading of the term stream: https://alpha.app.net/schwa/post/52516 - this is a problem in code. As real app.net streams come online I expect a refactor will be needed.
* Deleting
* User Lists
* User Info
* Database will grow and grow. Need to prune at some point.
* Code is being "sketched out" and is far from well designed. Expect a lot of churn/refactoring
* <del>Refresh</del> (implemented)
* <del>Posting</del> (implemented)

## FEATURE IDEAS

* Use the Latent Semantic Mapping framework to classify posts
* Intelligently handle hashtags, usernames, urls etc - provide popover contextual info/actions on these item, e.g. hashtags popover will have a "view all posts with this hashtag" action.
* Markdown support
* Built in filtering, blocking, spam control and triggered actions
* Relying on server to fix spam problem is foolish
* Actions include user notifications, scripts?
* Built in fav star style functionality
* Statistics on your behavior and on per people (how spammy is that person, how many tweets per hour enter my stream)

## LICENSE

* I haven't included a license yet but all code will be licensed under the BSD 2 clause license.
