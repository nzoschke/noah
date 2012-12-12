# Runtime Profile Scripts

Recently, the Heroku Runtime introduced a change in how we run your code:

```diff
-  execlp("bash", "bash", "-c", command, (char *) NULL))
+  execlp("bash", "bash", "--login", "-c", command, (char *) NULL))
```

The introduction of a "login shell" brings us one step closer to the vision of the Heroku Runtime: 

> The Heroku Runtime operates a platform for dynamic execution of arbitrary code in a secure and scalable multi-tenant environment.

By running all dynos as a login shell, we improved the flexibility of the platform with a classic Unix primitive: profile scripts.

As the [Bash Reference Manual explains](http://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files), a login shell automatically sources /etc/profile then ~/.profile before executing the command. These scripts offer hooks to control the execution environment.

In a terminal, profile scripts customize the command prompt, append to $PATH for a package manager, etc.

On the platform, profile scripts influence the contract between the Heroku Runtime and your code:

```
Heroku Runtime sets $HOME and $PORT
Heroku Runtime sets values from `heroku config`
Heroku Runtime executes login shell 
Login shell sources /etc/profile, which sources $HOME/.profile.d/*
Login shell sources $HOME/.profile
Login shell executes command
```

### Buildpacks

The most immediate use of profile scripts on Heroku is for [buildpacks](https://devcenter.heroku.com/articles/buildpacks), which should now add [.profile.d/](https://devcenter.heroku.com/articles/labs-dot-profile-d) scripts:

```bash
$ heroku run "cat .profile.d/ruby.sh"
Running `cat .profile.d/ruby.sh` attached to terminal... up, run.1
export GEM_PATH=${GEM_PATH:-$HOME/vendor/bundle/ruby/1.9.1}
export LANG=${LANG:-en_US.UTF-8}
export PATH="$HOME/bin:$HOME/vendor/bundle/ruby/1.9.1/bin:$PATH"
export RACK_ENV=${RACK_ENV:-production}
```

This script fills in the environment that the Ruby needs for Bundler and Rails, but honors any settings in `heroku config`.

Previously, buildpacks altered `heroku config` to set the expected environment:

```bash
$ heroku config
GEM_PATH: vendor/bundle/ruby/1.9.1
LANG:     en_US.UTF-8
PATH:     bin:vendor/bundle/ruby/1.9.1/bin:/usr/local/bin:/usr/bin:/bin
RACK_ENV: production
```

Although this worked, it was a leaky abstraction. `heroku config` is intended for app config and secrets like DATABASE_URL, not static settings for a buildpack. Here, `heroku config:remove PATH` breaks the app.

### Your App

A .profile script may also prove useful to your application.

For example, you can use one to set up the ~/.ssh/ directory in every dyno to use SSH private and public key contents from `heroku config`:

```bash
$ cat .profile
#!/bin/bash

echo "setting up ~/.ssh via .profile"
mkdir -p $HOME/.ssh

cat >$HOME/.ssh/config <<EOF
StrictHostKeyChecking no
EOF

[ -n "$SSH_PRIVATE_KEY" ] && echo "$SSH_PRIVATE_KEY" >$HOME/.ssh/id_rsa
[ -n "$SSH_PUBLIC_KEY" ]  && echo "$SSH_PUBLIC_KEY"  >$HOME/.ssh/id_rsa.pub
```

Now `heroku run "git clone git@github.com:username/private-repo.git"` works.

A dyno is always a container you fully control. With login shell and profile scripts you have an additional Unix-y way of setting up the environment.

Heroku believes that profile scripts are a common pattern for any application, both installed by a buildpack and used for custom application logic.

This feature should excite intrepid Unix fans. If this is you, [the Heroku Runtime is hiring engineers](http://heroku.theresumator.com/apply/W4eur1/Systems-Engineer.html) to help run billions of shells.

-Noah