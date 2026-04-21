# Secrets

This repo expects an encrypted SOPS file at `secrets/contact.yaml` with this shape:

```yaml
contact:
  email: you@example.com
```

Create it and encrypt in-place:

```bash
sops -e -i secrets/contact.yaml
```
