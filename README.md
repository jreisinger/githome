Githome is a simple way to manage your Unix home (dot) files, using only git.

The idea is that you track your $HOME files in a bare git repo.

```
$ git init --bare $HOME/github.com/jreisinger/githome
$ alias githome='git --work-tree=$HOME --git-dir=$HOME/github.com/jreisinger/githome'
```

You ignore all files in your $HOME

```
$ cat << EOF > $HOME/.gitignore
*
!.gitignore
EOF
```

except for those you want to track

```
$ githome add .gitignore # you need -f for all other files
$ githome commit -m "genesis"
$ githome ls-tree main -r --name-only
.gitignore
```