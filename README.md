#Geekasylum Gentoo Overlay

An overlay for [Gentoo](https://www.gentoo.org/), with various packages used by
[geekasylum](https://github.com/geekasylum).

This is my personal Gentoo overlay. I've made it public in the hope that it may
be of use to others.  I make no claim that anything here is up to date,
maintained, fit for purpose, or even that it works at all.  Use it at your own
risk.

##Usage

To add this overlay to your [Portage](https://wiki.gentoo.org/wiki/Portage)
tree, create `/etc/portage/repos.conf/geekasylum`, containing:

```
[geekasylum]
location = /usr/local/portage/geekasylum
sync-type = git
sync-uri = https://github.com/geekasylum/gentoo-overlay.git
clone-depth = 1
priority = 9999
```

Then run `emerge --sync` to make this overlay available on your system.

---

*Please report issues via the GitHub Issue Tracker!*
