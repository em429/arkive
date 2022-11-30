<img src="https://github.com/qirpi/arkive/blob/main/app/assets/images/arkive_mascot.webp" width="300px"></img>

# Arkive: A private web archive

Arkive is a marriage of three ideas: __bookmarking__, __archiving__ (mirroring) and __read-later__ services.

All three have the same core purpose: saving stuff for later, yet go about it in very different ways, each with it's own strenghts and weaknesses. 

Let's look at the pros and cons of each:

* __Bookmarks__:
  - _Pros_: easy to save links to (always just a shortcut away), private, good organization capabiliites
  - _Cons_: linkrot (sites taken down..etc), sync problems
* __(Offsite) Archiving__:
  - _Pros_: protection from linkrot, backing up
  - _Cons_: public without option for private
* __Read-later__:
  - _Pros_: remembering interesting articles, marking as read, organization, removal of visual disturbances and ads
  - _Cons_: linkrot, at the whim of a third-party, not fully private

__Arkive is designed to solve all these problems at once — an archival / bookmarking / read-later system, that__:
  - Protects you from linkrot by:
    - Auto-submitting links to the Internet Archive
    - Extracting readable content and saving it in database
  - Easy and quick to submit links to
    - Using the UI
    - Using the API: simply POST your url to /
      + This makes one-tap save possible with e.g. HTTP Shortcuts on Android using the share menu
    - If no title is provided, it's fetched automatically
  - Easy to read anywhere thanks to the responsive webui
  - Has basic organizational abilities:
    - Articles can be marked as read
    - Displays reading time estimates
    - TODO articles can be put into collections

### Things to cover


* Ruby: 2.7.6, Rails: 7.0.4

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
