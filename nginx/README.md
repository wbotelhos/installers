# NGINX

## nginx.sh

Check the section "vars"

# Install

It will download and pre compile without activate it.

```bash
./nginx.sh install {{version}}
```

# Activate

It will activate the given version.
If not already installed, will be.

```bash
./nginx.sh activate {{version}}
```

# Deactivate

It will deactivate the current version.
No one will be replaced.

```bash
./nginx.sh deactivate
```

# Configure

It will replace the variables on config files and copy it to the given path.

```bash
./nginx.sh configure
```

# Tips

## Removing the version

1. Before compile:

```bash
sudo vim /usr/local/src/nginx-{{version}}/src/http/ngx_http_header_filter_module.c
```

2. Find the lines:

```bash
static char ngx_http_server_string[] = "Server: nginx" CRLF;
static char ngx_http_server_full_string[] = "Server: " NGINX_VER CRLF;
```

3. Change it to:

```bash
static char ngx_http_server_string[] = "" CRLF;
static char ngx_http_server_full_string[] = "" CRLF;
```
