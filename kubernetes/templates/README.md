### This directory contains files with parameters which must be changed to reflect the desired environment

For example: files used to create secrets would contain a prompt in environment-variable format:
```
apiVersion: v1
kind: Secret
metadata:
  name: credentials
type: Opaque
stringData:
  git-username: ${GIT_USERNAME}
  git-password: ${GIT_PASSWORD}
```

The scripts directory contains a script that can be used to find all values that need to be replaced, as well as do the replacement.

The Makefile in the base directory contains two targets: `parameters` and `environment`.

`make parameters` searches through the manifests/template directory for all variables, and loads them into a file called `parameters.txt`. Using the secrets example from above, the file would look like this:
```
GIT_USERNAME=
GIT_PASSWORD=
```

You would then edit that file to contain the correct information:
```
GIT_USERNAME=secret_git_username
GIT_PASSWORD=secret_git_password
```

Then when you execute `make environment` the invoked script will read that `parameters.txt` file and replace the values on the left of the `=` with the values on the right, and write new files with the same names as those in the `manifests/template` directory into the `manifests/` directory. At that point, files in `manifests/` will be completed, and you only need to `make deploy` and/or use `kubectl` to do what you like with them.
