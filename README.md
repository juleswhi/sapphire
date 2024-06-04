<div align="center">

# Sapphire Protocol

### Custom protocol for data communication based on TCP

</div>

## REQUEST

VERSION: 1 BYTE
TYPE: 1 BYTE - GET / POST etc { GET = 0, POST = 1 }

HOST: 4 BYTE
INCREMENTAL: 1 BYTE

PATH_LEN: 2 BYTE
PATH: * BYTE

CONTENT_LEN: 4 BYTE
CONTENT_TYPE: 1 BYTE
CONTENT: * BYTE

## RESPONSE

VERSION: 1 BYTE
TYPE: 1 BYTE

STATUS CODE: 1 BYTE

INCREMENTAL: 1 BYTE
INCREMENTAL_IDENTIFIER: 4 BYTE

DATE_LEN: 2 BYTE
DATE: * BYTE

CONTENT_LEN: 4 BYTE
CONTENT_TYPE: 1 BYTE
CONTENT: * BYTE


- [ ] Server
- [ ] Custom url = saph://{url}
- [ ] Github Addy - "repo.user.github"

- [ ] Front end
- [ ] GTK - prolly
- [ ] Language ??? C / Rust / Golang?

- [ ] Render markdown

- [ ] WASM?


## Status Codes


- 20 / OK


- 30 / SERVER ERROR
- 31 / RESOURCE NOT FOUND
