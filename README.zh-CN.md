# Bark（oh-my-zsh 插件）

[English README](README.md)

用 `bark` 包一层命令，命令执行结束后通过 Bark 推送通知（包含耗时与退出码）。

## 它做什么

这个插件提供一个 `bark` 包装函数：

- 执行你传入的命令
- 统计耗时
- 根据退出码发送 Bark 通知：**Command finished** / **Command failed**
- 通知内容包含：命令、耗时、exit code

## 依赖

- `curl`（必须，用于发送推送）
- `python3`（可选，用于毫秒时间戳与 URL 编码；没有也会自动降级）

## 安装

### oh-my-zsh

1. 克隆到自定义插件目录：

   ```sh
   git clone https://github.com/macromogic/bark.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/bark
   ```

2. 在 `~/.zshrc` 启用：

   ```sh
   plugins=(... bark)
   ```

3. 重启终端或重新加载 zsh。

### Antigen

```sh
antigen bundle macromogic/bark
```

### Zinit

```sh
zinit light macromogic/bark
```

## 配置

在 `~/.zshrc` 配置环境变量：

```sh
export BARK_KEY="your_device_key"                 # 必填
export BARK_SERVER="https://api.day.app"          # 可选（默认官方服务）
export BARK_GROUP="terminal"                      # 可选
export BARK_SOUND="minuet"                        # 可选
export BARK_LEVEL="active"                        # 可选: active / timeSensitive / passive
export BARK_ICON="https://example.com/icon.png"   # 可选
```

## 用法

```sh
bark sleep 5
bark make test
bark long_running_cmd --with flags
```

## 安全提示

`BARK_KEY` 相当于密钥/令牌，不要提交到 git，也不要贴到 issue/PR 里。

## 许可证

MIT，见 `LICENSE`。
