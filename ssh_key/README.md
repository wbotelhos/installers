# Generate

Generates a private and public key locally.

You will choose:

- The home path;
- The key name; and
- Comment.

The key will be RSA of 4096 bits.

```bash
./generate.sh
```

# Upload

Uploads the keys to a remote sever.

You will choose:

- The private key path;
- If private key will be uploaded;
- If public key will be uploaded;
- The user to connect to remote server;
- The host of remote server;
- The remote home server where key will be copied; and
- The name of the new remote key.

```bash
./upload.sh
```

# Authorize

Appends the locally public key content to a remote `authorized_keys` file.

You will choose:

- The local public key path;
- The user to connect to remote server; and
- The host of remote server;

```bash
./authorize.sh
```
