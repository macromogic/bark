# Contributing

Thanks for contributing!

## Local checks

Run these from the repo root:

```sh
zsh -n bark.plugin.zsh
zsh -fc 'source ./bark.plugin.zsh; typeset -f bark >/dev/null'
```

## Pull requests

- Keep changes focused and backward-compatible when possible.
- If behavior/config changes, update **both** `README.md` and `README.zh-CN.md`.
- Avoid adding network calls to CI.

