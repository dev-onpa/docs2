#Convert a putty .ppk key to an Amazon .pem file on OSX

This article will show you how to generate a .pem file from an existing .ppk key.

## 1. Install putty on your mac
Done easily with homebrew.

```
$ brew install putty
```

## 2. Generate the key
We will use puttygen to generate the key.

```
$ puttygen key.ppk -O private-openssh -o key.pem
```

key.ppk: the original file name/path.  
-O private-openssh: the output type. private-openssh is used to save an SSH-2 private key in OpenSSH’s format.  
-o key.pem: the output file name/path.

## 3. Install the key
Installing the key is equivalent to copying it in your ~/.ssh directory.