# Mozkey APT

[Mozkey](https://github.com/koyasi777/mozkey) の非公式 APT リポジトリです。
GitHub Actions が安定版リリースを6時間ごとに確認し、新しいタグのソースを Ubuntu 24.04 (amd64) でビルドします。ソースに同梱されている `sample` 辞書プロファイルを使います。

## インストール

対象は Ubuntu 24.04 以降と Debian 13 の amd64 です。

```sh
base=https://hirobon1690.github.io/mozkey-apt
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL "$base/mozkey-archive-keyring.gpg" -o /tmp/mozkey-archive-keyring.gpg
gpg --show-keys --with-fingerprint /tmp/mozkey-archive-keyring.gpg
```

署名鍵のフィンガープリントが `3E99 D531 4803 6482 F8C3 E911 6DC7 1ABE A80C 81F8` と一致することを確認してから登録します。

```sh
sudo install -m 0644 /tmp/mozkey-archive-keyring.gpg /etc/apt/keyrings/mozkey-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mozkey-archive-keyring.gpg] $base/ ./" |
  sudo tee /etc/apt/sources.list.d/mozkey.list >/dev/null
sudo apt update
sudo apt install ibus-mozkey
```

既存の `mozkey-local` は、`ibus-mozkey` のインストール時に置き換わります。更新は `sudo apt update && sudo apt upgrade` で行えます。

## 運用

GitHub Pages の公開元は GitHub Actions です。署名に使う専用 OpenPGP 秘密鍵をリポジトリの Actions secret `APT_SIGNING_KEY` に登録します。初回や臨時の公開は **Publish Mozkey APT** ワークフローを手動実行します。Pages は最新の安定版パッケージを1つ公開します。
