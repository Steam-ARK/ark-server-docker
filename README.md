# ARK-server-docker

> docker 部署 ARK（方舟-生存进化）

------

## 0x00 介绍

此为 steam 版 ARK 的 docker 服务端，可用于搭建私人联机服务器。


## 0x10 运行环境

![](https://img.shields.io/badge/OS|Linux-red.svg) ![](https://img.shields.io/badge/OS|Windows-blue.svg)


## 0x10 硬件要求

| 硬件 | 最低配置 | 推荐配置 | 流畅配置 |
|:---:|:---:|:---:|:---:|
| CPU | 2C | 4C | 8C|
| 内存 | 6G | 8G | 16G |
| 硬盘 | 30G | 50G | 100G |

> ARK 当前版本（20221129）的服务端大小为 18812537984 bytes，约 18G，因为要从 steam 服务器下载，所以国内非常慢甚至连接不上。建议使用香港或韩国的云主机，从海外下载速度较快且不会被 GFW 拦截、国内也有不错的访问速度


## 0x30 部署步骤

### 0x31 预操作

以下命令使用 root 用户执行: 

1. 安装 [python3](https://www.python.org/downloads/)、 docker、 docker-compose、 git
2. 创建 steam 用户: `adduser steam`
3. 添加 steam 用户到 docker 组: `usermod -aG docker steam`
4. 切换到 steam 用户: `su - steam`

之所以要添加 steam 用户，是因为下面构建的 [SteamCMD docker](https://hub.docker.com/r/cm2network/steamcmd/) 镜像内强制使用了 steam 用户。

由于 docker 需要从宿主机挂载服务端的游戏目录，如果宿主机使用 root 用户挂载，会导致 docker 内的用户没有权限而无法读写。

所以宿主机需要创建一个非 root 用户、而为了方便起见就用了相同的 steam 用户。

> **之后的所有命令必须使用 steam 用户执行。**


### 0x31 部署镜像

1. 下载此仓库: `git clone --depth 1 --branch master https://github.com/lyy289065406/ark-server-docker.git`
2. 进入根目录: `cd ark-server-docker`
3. 构建镜像: `bin/build.sh`（镜像中不含游戏本体，只有用于下载游戏的 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) ）
4. 运行镜像: `bin/run_docker.sh`


### 0x32 部署 ARK 服务端（SteamCMD 通道）

安装游戏: `bin/install_game.sh`，此为命令执行后会打开 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) 交互终端，依次输入：

1. 创建 ARK 游戏目录: `force_install_dir /home/steam/games/ark`
2. 匿名登录 steam : `login anonymous`
3. 下载 ARK 服务端: `app_update 376030`（游戏约 18G，超级慢而且可能失败）

<details>
<summary>关于 steam app id 376030 ...</summary>
<br/>

在 steam 中每个游戏都有一个唯一且固定的 APP ID，可以在商店页面地址中查看（跟在 `/app/` 后的数字）：

| APP ID | 游戏名称 | 描述 |
|:---:|:---|:---|
| 346110 | ARK: Survival Evolved | ARK 客户端 |
| 376030 | ARK: Survival Evolved Dedicated Server | ARK 专用服务端 |

</details>


### 0x32 部署 ARK 服务端（Github 通道）

当 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) 通道无法安装成功时，可使用此方法（否则应该跳过）：

<details>
<summary>展开</summary>
<br/>

1. 创建 [Github](https://github.com/) 账号（若已有则跳过）
2. 配置 [Github SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
3. Frok 此仓库（目的是使用 SSH 下载）: `https://github.com/lyy289065406/ark.git`
4. 创建并切换工作目录: `volumes/steam/games`
5. 使用 SSH 下载到该目录: `git clone --depth 1 --branch master git@github.com:${你的用户名}/ark.git`
6. 解压大文件: `bin/unpack_7zip.sh` 或 `bin/unpack_7zip.ps1`（需要预装 [7-zip](https://www.7-zip.org/) 命令行）

> 更多细节详见 [ARK](https://github.com/lyy289065406/ark.git) 的 [README.md](ttps://github.com/lyy289065406/ark.git) 说明

</details>


## 0x40 暴露服务

| 协议 | 端口 | 是否必要 | 用途 |
|:---:|:---:|:---:|:---|
| UDP | 7777 | 是 | 服务端对玩家开放的端口，已硬编码不可修改 |
| UDP | 7778 | 是 | 同上 |
| UDP | 27015 | 是 | 被 steam 服务器列表搜索服务端所用的端口，已硬编码不可修改 |
| TCP | 32330 | 否 | RCON 服务器在线管理工具的端口 |

以上端口均需要：

- docker 映射到宿主机（已配置到 [docker-compose.yml](./docker-compose.yml)）
- 主机防火墙准入（Linux 若没有安装 iptables 则不需要）
- 云主机配置安全组策略


## 0x50 运行 ARK 服务端

1. 启动服务端: `bin/run_ark.sh`（首次启动约 15 分钟）
2. steam 添加服务器: 查看 `->` 服务器 `->` 收藏夹 `->` 添加服务器 `->` `${云主机公网 IP}:27015`
3. 开始游戏吧 ~


## 0x60 关于定制 ARK 启动配置

通过 `bin/run_ark.[sh/ps1]` 实际上是调用了 ARK 的核心启动脚本 [`bin/ark.sh`](./bin/ark.sh)，它默认配置了一些常用配置项：

| 分类 | 配置项 | 默认值 | 用途 |
|:---:|:---|:---|:---|
| 用户可控 | ?SessionName | EXP_ARK_Server | 在 steam 服务器列表上看到的名称 |
| 用户可控 | ?MaxPlayers | 10 | 能进入服务器的最大玩家数量 |
| 用户可控 | ?ServerPassword | EXP123456 | 玩家进入服务器时需要提供的密码 |
| 用户可控 | ?ServerAdminPassword | ADMIN654321 | 管理员通过 RCON 在线管理服务器的密码 |
| 用户可控 | ServerMap | TheIsland | 服务器地图 |
| 用户可控 | ?GameModIds |  | 服务器地图 MOD ID 列表 |
| 硬编码 | ?RCONEnabled | True | 是否启用 RCON 服务器在线管理工具 |
| 硬编码 | ?RCONPort | 32330 | RCON 的服务端口 |
| 硬编码 | ?ServerAutoForceRespawnWildDinosInterval | | 服务器重启时强制刷新野生恐龙 |
| 硬编码 | ?AllowCrateSpawnsOnTopOfStructures | | 允许补给箱出现在建筑顶部 |
| 硬编码 | -ForceAllowCaveFlyers | | 允许飞入洞穴 |
| 硬编码 | -AutoDestroyStructures | | 允许破坏建筑 |
| 硬编码 | -NoBattlEye | | 不启动 BattleEye 反作弊工具 |
| 硬编码 | -crossplay | | 允许 crossplay |
| 硬编码 | -server | | 用途不明 |

启动过一次服务端后，会在 `ShooterGame/Saved/Config/LinuxServer/` 目录下自动创建 `GameUserSettings.ini` 和 `Game.ini` 配置文件，可以参考 [ARK Server configuration](https://ark.fandom.com/wiki/Server_configuration) 的参数说明修改该配置文件。

除了上表的配置项，均可在配置文件中修改。否则需要修改脚本 [`bin/ark.sh`](./bin/ark.sh)。

1. 修改完成后，需要停止镜像: `bin/stop.sh`
2. 如果修改过 [`bin/ark.sh`](./bin/ark.sh)，还需要重新构建镜像: `bin/build.sh`
3. 再次运行镜像: `bin/run_docker.sh`
4. 然后运行服务端: `bin/run_ark.sh`



## 参考文档

- 《[Linux 搭建方舟服务器教程 方舟生存进化](https://www.bilibili.com/video/BV1Xp4y1n7pq/)》
- 《[在 Linux 系统下安装 steamCMD](https://blog.wehaox.com/archives/3.html)》
- 《[Linux 搭建 ARK 服务器](https://blog.csdn.net/xiaotian2333333/article/details/124733348)》
- 《[方舟生存进化: docker一键部署](https://ssst0n3.github.io/post/%E6%B8%B8%E6%88%8F/%E6%96%B9%E8%88%9F%E7%94%9F%E5%AD%98%E8%BF%9B%E5%8C%96-docker%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2.html)》
- 《[ark-server-tools](https://github.com/arkmanager/ark-server-tools)》
- 《[arkserver](https://github.com/thmhoag/arkserver)》
- 《[Dockerize ARK managed with ARK-Server-Tools](https://hub.docker.com/r/hermsi/ark-server/)》
