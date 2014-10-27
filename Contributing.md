# GUIDELINES

### SECURITY

The team is currently working on improving project security and code security to 
ensure Bitcloud sustainability as a wild open source application platform.

If you would like access to the [collaborative Cloud 9 development environment](https://ide.c9.io/gnosticat1on/bitcloud)
that has been established for the Bitcloud project, please request access.  
At first, you will only be given Read access to the workspace. No write access will 
be granted until after your contributions to the code have been accepted.

Please recognize that the designers and contributors thus far may or may not seek
to have themselves known, and that is okay.  The group is very close, yet secretive
to support security for all involved.

### FOCUS

The focus is on the code, always.  Development of documentation is secondary to 
development of working and accepted code.

The source code is changing rapidly.  The time it would take to update documentation 
after updating code would result in unnecessary resource drain, when resources 
already are scarce.

Therefore, most documentation will exist within the living code.  Other documentation 
exists, but not all of it may be published.  See SECURITY, above.

### ORGANIZATION

There aren't many of us.  We will know it when we get there, but the core group 
of active developers on the team would probably have to number at least 8 before 
it warrants us spending time building and testing more complete project management 
tools.

We have had issues with our information when we used free or third-party (e.g., Google) 
provided organization tools.  As a result, we tend to trust very few tools available.

[Riseup free email](http://www.riseup.net) is a trusted source for free email 
service.  With minimal logs and sympathetic management, use your Riseup account 
for project communication.  Donate to them, too.  (I do, every month.)

Email works great for communication, but sometimes you want something more conversational.  
That's where [IRC](http://webchat.freenode.net/?channels=bitcloud) comes in.  No, 
someone from the core team won't always be there.  In fact, we only have windows 
of time available for chat.  We have jobs that actually pay us.  These take most 
of our time away from things like IRC, for the most part.  

We welcome all respectful conversation, though.  And I don't want to dissuade you 
from reaching out to us using IRC.  We actually are on there more than we should be.

The discussion boards pretty much fell apart as the Bitcoin fanatics who missed the 
boat tried to join the Bitcloud project thinking it would be their golden ticket to 
fortune.  The boards are still up and we'd love to continue the conversation, but minimal 
input has been contributed to the forums for almost a year.

We have Skype, but only very rarely are available for conversation.

# CONTRIBUTING
If you have any questions about the code or are interested in contributing,
feel free to contact us on our [mailing list](http://bitcloudproject.org/w/Mailing_list) 
or on [IRC](http://webchat.freenode.net/?channels=bitcloud).

### FORK
Fork bitcloud [on GitHub](https://github.com/wetube/bitcloud/fork) and clone 
your repository.

```
$ git clone https://github.com/your-username/bitcloud.git
$ cd bitcloud
$ git remote add upstream https://github.com/wetube/bitcloud
```

### CODE

Try to follow the same format of coding there is when editing code

* Publicly available functions and types are prefixed with `bc_`, and macros with`BC_`.

* Don't leave whitespace at the end of lines.

* Try to keep lines at around 80 characters long.

* All variables are assigned before use (to avoid bugs).

* All header files should have `#define` guards to prevent multiple inclusion. The format should be `<COMPONENT>_H` (e.g. `bitcloud.h` has `BITCLOUD_H`).

* Use `0` for integers, `NULL` for pointers, and `'\0'` for chars.


### COMMIT

Make sure git knows your name and email address:

```
$ git config --global user.name "Random Developer"
$ git config --global user.email "random.developer@example.org"
```
You might find Git GUIs such as [git-cola](http://git-cola.github.io/) useful 
at this part.

Commit logs consist of a single-line summary and a description separated by a 
blank line, it's highly recommended to:

* Have a concise summary, 50 characters max.
* Wrap everything else at 72 columns

Here's an example:

```
subsystem: explaining the commit in one line

Body of commit message is a few lines of text, explaining things
in more detail, possibly giving some background about the issue
being fixed, etc etc.

Do proper word-wrap and keep columns shorter than about
72 characters or so. That way `git log` will show things
nicely even when it is indented. 
```

### REBASE

Use `git rebase` when changes appear on upstream to make sure you're not editing 
outdated code.

```
$ git fetch upstream
$ git rebase upstream/master
```

### PUSH

To push your local changes to your online repository.

```
$ git push origin master
```

Go to https://github.com/your-username/bitcloud/compare/wetube:master...master
and click "Create Pull Request" and fill out the form

To have your pull request accepted you have to agree with the following 
Developer's Certificate of Origin 1.1 by adding a "sign-off" line at the end of 
your pull request:
```
Signed-off-by: Random Developer <random.developer@example.org>
```

You have to use your real name.

Developer's Certificate of Origin 1.1:

```
By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I have
the right to submit it under the open source license indicated in the file; or

(b) The contribution is based upon previous work that, to the best of my
knowledge, is covered under an appropriate open source license and I have the
right under that license to submit that work with modifications, whether created
in whole or in part by me, under the same open source license (unless I am
permitted to submit under a different license), as indicated in the file; or

(c) The contribution was provided directly to me by some other person who
certified (a), (b) or (c) and I have not modified it; and

(d) In the case of each of (a), (b), or (c), I understand and agree that
this project and the contribution are public and that a record of the contribution
(including all personal information I submit with it, including my sign-off) is
maintained indefinitely and may be redistributed consistent with this project or
 the open source license indicated in the file.
```

Try to address all feedback/comments you receive, if you have to make changes 
apply them in a separate commit and push them using the command mentioned above.
Post a comment in the pull request afterwards; GitHub does not send out 
notifications when you add commits.

### LICENSE HEADER


All source files should have the following header:

```
/* This file is part of the Bitcloud project
 * Distributed under the MIT License, see the accompanying file License. */

```

Do not add attributions (e.g. `Copyright (C) 2014 John Doe <john.doe@email.com>`) 
to the source code, `git` maintains a history of who changed what, you can submit 
a patch to the `Credits` file to add yourself.



