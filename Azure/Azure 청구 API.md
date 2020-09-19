

> https://microsoft.github.io/AzureTipsAndTricks/blog/tip223.html

```
dbclose@MacBook-Pro ~$ az ad sp create-for-rbac -n "azure-test"
Changing "azure-test" to a valid URI of "http://azure-test", which is the required format used for service principal names
Creating a role assignment under the scope of "/subscriptions/459a1df5-548a-45ce-b665-b1c479d786e9"
  Retrying role assignment creation: 1/36
{
  "appId": "ef15e692-0fea-482c-a1dc-c1d474b698ea",
  "displayName": "azure-test",
  "name": "http://azure-test",
  "password": "ba627aa9-30d5-4656-8b55-31221ce114ab",
  "tenant": "6d6e5e0b-0033-43d2-bc45-b590f106e2f6"
}
```

```
dbclose@MacBook-Pro ~$ az account show --query id
"459a1df5-548a-45ce-b665-b1c479d786e9"
dbclose@MacBook-Pro ~$
```

## POST MAN 설정 