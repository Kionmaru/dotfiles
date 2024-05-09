# Dotfiles: Best way to store in a bare git repository

**Disclaimer:** The title is slightly hyperbolic, there are other proven solutions to the problem. I do think the technique below is very elegant though.

Note: Translated to markdown by LLM, original is [here](https://www.atlassian.com/git/tutorials/dotfiles).

Recently, I read about an amazing technique in an Hacker News thread where people shared their solutions for storing dotfiles. User StreakyCobra showcased his elegant setup which made so much sense that I decided to switch my own system to the same technique. This method requires only Git as a prerequisite and offers several benefits including:

- No extra tooling
- No symlinks
- Files are tracked on a version control system
- You can use different branches for different computers
- Easy replication of configurations on new installations

This method involves creating a Git bare repository in a "side" folder like `$HOME/.cfg` or `$HOME/.myconfig` using an alias that ensures commands are run against this repository instead of the usual local `.git` folder, which could interfere with other Git repositories around.

## Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:
```bash
git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
```
- The first line creates a folder `~/.cfg`, which is a Git bare repository that will track our files.
- We then create an alias `config` that we will use instead of the regular git when interacting with our configuration repository.
- A flag is set - locally to the repository - to hide untracked files. This is so that later when you type `config status` and other commands, untracked files do not show up as untracked.

Additionally, you can add the alias definition by hand to your `.bashrc` file or simply use the provided fourth line for convenience.

## Installation on a new system (or migration)

If you already store your configuration/dotfiles in a Git repository, migrating to this setup on a new system involves these steps:

1. Ensure the alias is committed to your `.bashrc` or `.zsh`.
```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
2. Add the following line to your `.gitignore` file:
```makefile
.cfg
```
3. Clone your dotfiles into a bare repository in a hidden folder within your `$HOME`.
```bash
git clone --bare <git-repo-url> $HOME/.cfg
```
4. Define the alias in the current shell scope.
```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
5. Checkout the actual content from the bare repository to your `$HOME`.
```bash
config checkout
```
6. Set the flag `showUntrackedFiles` to no for this specific (local) repository.
```bash
config config --local status.showUntrackedFiles no
```
7. You can now add and update dotfiles using the following commands:
```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```
8. Create a simple installation script with these steps, store it as a Bitbucket snippet, create a short URL, and call it like this on any new machine you want to set up:
```bash
curl -Lks http://bit.do/cfg-install | /bin/bash
```

The final configuration I used is tested in many freshly minted Alpine Linux containers and looks like this:
```bash
git clone --bare https://bitbucket.org/durdn/cfg.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no
```
