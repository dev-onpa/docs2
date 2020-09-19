#


AWS Windows
WIN-07RHJ3HOELL

## 원격
18.216.169.137
Administrator
XN$KmU82R(



## AD DS


## AD FS
https://archmond.net/?p=5999

Add-KdsRootKey –EffectiveTime (Get-Date).AddHours(-10)
New-ADServiceAccount ADFSGrpManager -DNSHostName adfs.onlinepowers.com -ServicePrincipalNames http/adfs.onlinepowers.com


https://adfs.onlinepowers.com/adfs/ls/idpinitiatedsignon


id: emoldino\emoldino
pw: P@ssw0rd


## Azure SSO (SAML)
> 2020.08.06

