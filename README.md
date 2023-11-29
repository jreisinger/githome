Githome is a simple way to manage your Unix home (dot) files, using only git.

The idea is that you track your $HOME files in a bare git repo.

```
$ git init --bare $HOME/github.com/jreisinger/githome
$ alias githome='git --work-tree=$HOME --git-dir=$HOME/github.com/jreisinger/githome'
$ githome remote add origin git@github.com:jreisinger/githome.git
```

You ignore all files in your $HOME

```
$ cat $HOME/.gitignore
*
!.gitignore
```

except for those you want to track

```
$ githome add .gitignore # you'll need -f for all other files
$ githome commit -m "genesis"
$ githome ls-tree main -r --name-only
.gitignore
```
