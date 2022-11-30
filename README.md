<img src="https://github.com/qirpi/arkive/blob/main/app/assets/images/arkive_mascot.webp" width="300px"></img>

# Arkive: A private web archive

Arkive is a marriage of three ideas: bookmarking, archiving (mirroring) and read-it-later. Let's see what appeals to me from each, and why I thought a merge is necessary for my purposes. All three have the same core purpose: saving stuff for later, yet go about it in very different ways so each have it's own strenght. So apart from the core appeal, each has more: (at least to me)

* Bookmarks appeal is easy organization and that they are easy to add stuff to, they are private
  - The downsides are: linkrot (sites taken down..etc), sync problems
* (Offsite) Archving's appeal is protecting from linkrot and backing up
  - The downside: not private, usually lacks organizational options 
* Read-later service's appeal is not forgetting interesting articles, organization, marking as read, removing visual disturbances, ads ..etc
  - The downside: linkrot, at the whim of a third-party


Arkive is designed to solve all these problems at once — an archival / bookmarking / read-later system, that:
  - Protects you from linkrot by:
    - auto-submitting links to the internet archive
    - extracting readable content and save it in database
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
