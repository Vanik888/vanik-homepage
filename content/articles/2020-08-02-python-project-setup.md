+++
date = 2022-10-07
isPopular = false
tags = ["python", "DevOps", "work environment"]
thumbnailPath = "self/img/articles/2020-08-02-python-project-setup/thumb1.jpeg" 
title = "Tooling you should use for your python projects"
+++
In this article I am will share some basic tools I recommend to use with 
every python project.

# Pyenv
The first tool in my daily toolbox is pyenv.
Pyenv allows to install and manage multiple python environments at the same time.

### Key benefits: 
- you can install any python version available in pypi at your machine
- time saving: you do not need to care about the installation process, pyevn will do everything for you
- manages virtualenvironments- it is a single tool to add manage both the python version
as well as the virtualenvironments.

### How to install
To install the main package run
```shell
brew install pyenv
```
and the the virtualenv manager
```shell
brew install pyenv-virtualenv
```

Add to ~/.bash_profile 
```shell

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### The useful commands
List all available python versions
```shell
pyenv install --list
```

Install specific python version (the python will be installed in ~/.pyenv/versions)
```shell
pyenv install 3.5.5
```

Uninstall python version
```shell
pyenv uninstall 2.7.15
```

Show commands
```shell
pyenv commands
```

Show all installed versions
```shell
pyenv versions
```

Show current active version
```shell
pyenv version
```


Show the full path to the binary
```shell
pyenv which pip
```


Set local python version (creates .python-version)
```shell
pyenv local 3.4.5
```

VIrtualenv
Create a virtualenv
```shell
pyenv virtualenv 3.5.5 project1
```

Activate an environment 
```shell
pyenv virtualenv 3.5.5 project1

cd project1

# will activate the virtualenv (if you cd out of the project dir virtualenv will be different)
pyenv local project1
```

Activate the environment
```shell
pyenv activate venv
```
Deactivate the environment
```shell
pyenv deactivate venv
```

List the virtual environments
```shell
pyenv virtualenvs
```

To see which pip is used
```shell
pyenv which pip
```









