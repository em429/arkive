<img src="https://github.com/qirpi/arkive/blob/main/app/assets/images/arkive_mascot.webp" width="300px"></img>

# Arkive: A private web archive

Arkive is a marriage of three ideas: __bookmarking__, __archiving__ (mirroring) and __read-later__ services.

All three have the same core purpose: saving stuff for later, yet go about it in very different ways, each with it's own strenghts and weaknesses. 

Let's look at the pros and cons of each:

* Bookmarks:
  - Pros: easy to save links to (always just a shortcut away), private, good organization capabiliites
  - Cons: linkrot (sites taken down..etc), sync problems
* (Offsite) Archiving:
  - Pros: protection from linkrot, backing up
  - Cons: public without option for private
* Read-later:
  - Pros: remembering interesting articles, marking as read, organization, removal of visual disturbances and ads
  - Cons: linkrot, at the whim of a third-party, not fully private

Arkive is designed to solve all these problems at once — an archival / bookmarking / read-later system, that:
  - Protects you from linkrot by:
    - auto-submitting links to the internet archive
    - extracting readable content and saving it in database
  - Easy and quick to submit links to
    - using the UI
    - using the API: simply POST your url to /
      + this makes one-tap save possible with e.g. HTTP Shortcuts on Android using the share menu
    - if no title is provided, it's fetched automatically
  - Easy to read anywhere thanks to the responsive webui
  - Has basic organizational abilities:
    - Articles can be marked as read
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
