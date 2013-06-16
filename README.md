# ~/.vim.mine

My portable vim configuration, which can be applied standalone or on
top of [janus](https://github.com/carlhuda/janus).  Janus is detected
automatically, such that settings for plugins supplied by janus won't
get loaded (and raise errors) if you don't have janus installed yet for
whatever reason.  Vim-related config files are backed with a *.old
extension and not just overwritten.

For GNU/Linux, it has both global and local installation modes, so that
the same settings and config can be linked to from all users (including
root) when you have control of a whole machine.  This is very nice when
you wind up in Vim under <code>sudo</code>, for example.

On the Mac, it just installs to your own home dir under
<code>/Users</code>.  This works fine because <code>sudo</code>
preserves your environment so you get your own Vim settings anyway.

Installation just involves making appropriate symlinks to files in your
<code>~/.vim.mine</code> dir.

### Local Install (Mac or Linux)

To install to just your own home dir:

<pre>
  $ cd .vim.mine
  $ ./installer.sh self
  
  # uninstall
  $ ./installer.sh clean self
</pre>

### Global install (GNU/Linux)

To install to your own home dir, <code>/root</code>, and any other user
under <code>/home</code>:

<pre>
  $ cd .vim.mine
  $ ./installer.sh all-users
  
  # uninstall
  $ ./installer.sh clean all-users
</pre>

### Where to put your own settings and mappings

The settings and mappings in these files are either sourced in a
<code>.vimrc.after</code> if janus is present, or just
<code>~/.vimrc</code> if it's not.  It's a little more involved than
that, but it's not hard to figure out.  The point is, there's a place
for your linux-only stuff, your mac-only stuff, gvim-only stuff, all
with or without janus.
  
<pre>
  ~/.vim.mine $ find . -name *settings*.vim
      ./common/gvim.settings.vim
      ./common/settings.after_janus.vim
      ./common/settings.vim
      ./linux/gvim.settings.vim
      ./mac/settings.before_janus.vim
      ./mac/settings.vim
</pre>
