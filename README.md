<div align="center">

# Sapphire Protocol

### Custom protocol for data communication based on TCP

</div>

VERSION: 1 BYTE
TYPE: 1 BYTE - GET / POST etc { GET = 0, POST = 1, NONE = 2 }

CLIENT ADDY: 4 BYTE
INCREMENTAL: 1 BYTE

PATH_LEN: 2 BYTE
PATH: * BYTE

CONTENT LEN: 4 BYTE
CONTENT TYPE: 1 BYTE
CONTENT: * BYTE


- [ ] Server
- [ ] Custom url = saph://{url}
- [ ] Github Addy - "repo.user.github"

- [ ] Front end
- [ ] GTK - prolly
- [ ] Language ??? C / Rust / Golang?

- [ ] WASM?
