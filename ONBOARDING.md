# Onboarding

## AWS CLI

### Installer AWS CLI v2 : 
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html 

### Vérifier que tout est bon :
```bash
aws sts get-caller-identity
```

### Résultat attendu (avec votre propre account ID) :
```json
{
    "UserId": "AIDA...",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/votre-user"
}
```
Si votre Account ID apparaît, la connexion est OK.


