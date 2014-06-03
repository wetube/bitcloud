# CONTRIBUTING
If you have any questions feel free to contact us on our 
[mailing list](http://bitcloudproject.org/w/Mailing_list) or on 
[IRC](http://webchat.freenode.net/?channels=bitcloud).

### FORK
Fork bitcloud on [on GitHub](https://github.com/wetube/bitcloud/fork) and clone 
your repository.

```
$ git clone https://github.com/your-username/bitcloud.git
$ cd bitcloud
$ git remote add upstream https://github.com/wetube/bitcloud
```

### CODE

**This part is incomplete**

* Publicly available functions and types are prefixed with `bc_`, and macros with`BC_`.

* Use two spaces and no tabs.

* Don't leave whitespace at the end of lines.

* Lines should be at most 80 characters long, but this isn't a hard limit.

* Use C89-style `/* ... */` comments.

* All variables are assigned before use.

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

Try to address all feedback/comments you receive, if you have to make changes 
apply them in a separate commit and push them using the command mentioned above.
Post a comment in the pull request afterwards; GitHub does not send out 
notifications when you add commits.

### LICENSE HEADER


All source files should have the following header, edit as needed:


```

/*
 * This file is part of the bitcloud project.
 * 
 * Copyright (C) 2012-2013 Random Company, Inc.
 * (Written by John Doe <john@example.com> for Random Company, Inc.)
 *
 * Copyright (C) 2014 Your name <your@email.com>
 *
 * See licensing conditions in "License.txt".
 *
 */

```

