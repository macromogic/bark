# Bark (oh-my-zsh plugin)

[中文 README](README.zh-CN.md)

Run any command and get a Bark push notification when it finishes (with duration + exit code).

## What it does

This plugin adds a `bark` wrapper function:

- Runs the command you pass in.
- Measures elapsed time.
- Sends a Bark notification titled **Command finished** or **Command failed**.
- Notification body includes: command, duration, exit code.

## Requirements

- `curl` (required to send the notification)
- `python3` (optional; used for millisecond timestamps and URL encoding; the plugin falls back when unavailable)

## Install

### oh-my-zsh

1. Clone into your custom plugins directory:

   ```sh
   git clone https://github.com/macromogic/bark.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/bark
   ```

2. Enable it in `~/.zshrc`:

   ```sh
   plugins=(... bark)
   ```

3. Restart your shell.

### Antigen

```sh
antigen bundle macromogic/bark
```

### Zinit

```sh
zinit light macromogic/bark
```

## Configuration

Set these environment variables in your `~/.zshrc`:

```sh
export BARK_KEY="your_device_key"                 # required
export BARK_SERVER="https://api.day.app"          # optional (defaults to official service)
export BARK_GROUP="terminal"                      # optional
export BARK_SOUND="minuet"                        # optional
export BARK_LEVEL="active"                        # optional: active / timeSensitive / passive
export BARK_ICON="https://example.com/icon.png"   # optional
```

## Usage

```sh
bark sleep 5
bark make test
bark long_running_cmd --with flags
```

## Security note

Treat `BARK_KEY` like a secret. Don’t commit it to git or paste it into issues/PRs.

## License

MIT. See `LICENSE`.
