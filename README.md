instasetup
==========

### for OSX

Shell script that will download, install, and setup my **OSX** environment

to use, just copy and paste this into your bash terminal

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/FranciscoG/instasetup/master/install.sh)"
```

Of course you should always be wary of any script you're just curling from a URL you don't control. All the code is either in this repo or in other open source repos.  You can look through the install.sh script yourself or go through my explanation of each item below.

### Explanation

1. Checks for homebrew, if doesn't exist, installs it using the [install script](http://brew.sh/) provided by their developers

2. Checks for wget.  If missing, installs it via Homebrew.

3. Using wget to grab a bunch of configuration files:

  a) `.bashrc` - [from this repo](https://github.com/FranciscoG/instasetup/blob/master/.bashrc)

  b) `.bash_profile` - [from this repo](https://github.com/FranciscoG/instasetup/blob/master/.bash_profile)

  c) `.git-completion` - from https://github.com/git/git/tree/master/contrib/completion

  d) `.git-prompt.sh` - from https://github.com/git/git/tree/master/contrib/completion

  e) `.vimrc` - [from this repo](https://github.com/FranciscoG/instasetup/blob/master/.vimrc)

  f) `.jshintrc` - [from this repo](https://github.com/FranciscoG/instasetup/blob/master/.jshintrc)

  g) `.npmrc` - from this repo (it's actually [generated on the fly](https://github.com/FranciscoG/instasetup/blob/master/install.sh#L81))

  h) creates a `./vim/colors` directory if it doesn't already exist

  i) `solarized.vim` - from https://github.com/altercation/vim-colors-solarized/tree/master/colors

  j) creates a `.npm-packages` directory if it doesn't exist

4. Sets a couple of OSX prefs

  a) Add a context menu item for showing the Web Inspector in web views

  b) Show the ~/Library folder


note: 3g and 3j are created so I can use NPM without needing sudo. Explained here:
https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md

Bash scripting help from here and Shellcheck

https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md
