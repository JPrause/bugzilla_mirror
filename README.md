# Bugzilla Mirror

[![Build Status](https://travis-ci.org/ManageIQ/bugzilla_mirror.svg)](https://travis-ci.org/ManageIQ/bugzilla_mirror)
[![Code Climate](https://codeclimate.com/github/ManageIQ/bugzilla_mirror/badges/gpa.svg)](https://codeclimate.com/github/ManageIQ/bugzilla_mirror)

The Bugzilla Mirror is an application designed to simplify and improve the
experience of using Bugzilla.  The application mirrors all of the bugs of a
specific project.  Although it doesn't mirror *all* of the data provided by
Bugzilla, such as attachments, having less data in a simpler schema means that
query performance is dramatically increased.

In addition to providing a web UI for accessing the application, a REST API
is provided.  This REST API can be accessed in a programmatic way with the
[Bugzilla Mirror Client](https://github.com/ManageIQ/bugzilla_mirror_client).
