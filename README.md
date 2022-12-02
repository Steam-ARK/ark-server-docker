# ARK-server-docker

> docker 一键部署 ARK（方舟-生存进化）

------

## 0x00 介绍

此为 steam 版 ARK 的 docker 服务端，可用于搭建私人联机服务器。

搭建过程只用到官方原生的 [SteamCMD docker](https://hub.docker.com/r/cm2network/steamcmd/) 和 [ARK Server configuration](https://ark.fandom.com/wiki/Server_configuration) 配置。

> 此工程没有引入网上其他比较热门的 ARK 部署工具，所以它们的配置项均不适用


## 0x10 运行环境

![](https://img.shields.io/badge/OS|Linux-red.svg) ![](https://img.shields.io/badge/OS|Windows-blue.svg)


## 0x10 硬件要求

| 硬件 | 最低配置 | 推荐配置 | 流畅配置 |
|:---:|:---:|:---:|:---:|
| CPU | 2C | 4C | 8C|
| 内存 | 6G | 8G | 16G |
| 虚拟内存 | 4G | 4G | 4G |
| 硬盘 | 30G | 50G | 100G |

> ARK 当前版本的服务端大小为 18812537984 bytes，约 18G，因为要从 steam 服务器下载，所以国内非常慢甚至连接不上。建议使用香港或韩国的云主机，从海外下载速度较快且不会被 GFW 拦截、国内也有不错的访问速度


## 0x30 部署步骤

### 0x31 预操作

以下命令使用 root 用户执行: 

1. 安装 [python3](https://www.python.org/downloads/)、 docker、 docker-compose、 git
2. 设置虚拟内存（推荐 4G）
3. 创建 steam 用户: `adduser steam`
4. 添加 steam 用户到 docker 组: `usermod -aG docker steam`
5. 切换到 steam 用户: `su - steam`

之所以要添加 steam 用户，是因为下面构建的 [SteamCMD docker](https://hub.docker.com/r/cm2network/steamcmd/) 镜像内强制使用了 steam 用户。

由于 docker 需要从宿主机挂载服务端的游戏目录，如果宿主机使用 root 用户挂载，会导致 docker 内的用户没有权限而无法读写。

所以宿主机需要创建一个非 root 用户、而为了方便起见就用了相同的 steam 用户。

> **之后的所有命令必须使用 steam 用户执行。**


### 0x31 部署镜像

1. 下载此仓库: `git clone --depth 1 --branch master https://github.com/lyy289065406/ark-server-docker.git`
2. 进入根目录: `cd ark-server-docker`
3. 构建镜像: `bin/build.[sh|ps1]`（镜像中不含游戏本体，只有用于下载游戏的 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) ）
4. 运行镜像: `bin/run_docker.[sh|ps1]`


### 0x32 部署 ARK 服务端（SteamCMD 通道）

安装游戏: `bin/install_game.[sh|ps1]`，此为命令执行后会打开 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) 交互终端，依次输入：

1. 创建 ARK 游戏目录: `force_install_dir /home/steam/games/ark`
2. 匿名登录 steam : `login anonymous`
3. 下载 ARK 服务端: `app_update 376030`（游戏约 18G，超级慢而且可能失败）

<details>
<summary>关于 steam app id 376030 ...</summary>
<br/>

在 steam 中每个游戏都有一个唯一且固定的 APP ID，可以在商店页面地址中查看（跟在 `/app/` 后的数字）：

| APP ID | 游戏名称 | 描述 |
|:---:|:---|:---|
| 346110 | ARK: Survival Evolved | ARK 游戏客户端 |
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
6. 切换工作目录: `cd ark`
7. 解压大文件: `bin/unpack_7zip.[sh|ps1]`（需要预装 [7-zip](https://www.7-zip.org/) 命令行）

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

1. 启动 ARK 服务端: `bin/run_ark.[sh|ps1] -p ${服务器密码}`（默认密码已经公开，建议重新指定）
  - ARK 启动约需 10 ~ 15 分钟，如果想验证是否启动成功，可以进入 docker 终端: `bin/terminal.[sh|ps1]`
  - 输入命令 `netstat -nua` 查看当前监听的 UDP 端口，只要把 7777 和 7778 端口刷出来则表示已成功启动

![](./imgs/08.jpg)

2. steam 添加服务器: 
  - 查看 `->` 服务器 `->` 收藏夹
  - 添加服务器 `->` 填写 `${云主机公网 IP}:27015` -> 在此地址上寻找游戏 ...
  - 当在列表中看到自己的服务器名字后，点击 将选定游戏服务器添加至收藏夹

![](./imgs/02.jpg)

3. steam 开始游戏:
  - 加入线上方舟
  - 筛选服务器 `->` 收藏
  - 加入 `->` 输入 `服务器密码`
  - 和小伙伴愉快游戏吧 ~ 

![](./imgs/04.jpg)

![](./imgs/07.jpg)


## 0x60 关于定制 ARK 启动配置

通过 `bin/run_ark.[sh/ps1]` 实际上是调用了 ARK 的核心启动脚本 [`bin/ark.sh`](./bin/ark.sh)，它默认配置了一些常用配置项：

| 分类 | 配置项 | 默认值 | 用途 |
|:---:|:---|:---|:---|
| 可控 | SessionName | EXP_ARK_Server | 在 steam 服务器列表上看到的名称 |
| 可控 | MaxPlayers | 10 | 能进入服务器的最大玩家数量 |
| 可控 | ServerPassword | EXP123456 | 玩家进入服务器时需要提供的密码 |
| 可控 | ServerAdminPassword | ADMIN654321 | 管理员通过 RCON 在线管理服务器的密码 |
| 可控 | ServerMap | TheIsland | 服务器地图 |
| 可控 | GameModIds |   | 服务器地图 MOD ID 列表 |
| 硬编码 | RCONEnabled | True | 是否启用 RCON 服务器在线管理工具 |
| 硬编码 | RCONPort | 32330 | RCON 的服务端口 |
| 硬编码 | ServerAutoForceRespawnWildDinosInterval |  | 服务器重启时强制刷新野生恐龙 |
| 硬编码 | AllowCrateSpawnsOnTopOfStructures |  | 允许补给箱出现在建筑顶部 |
| 硬编码 | ForceAllowCaveFlyers |  | 允许翼龙进入洞穴 |
| 硬编码 | AutoDestroyStructures |  | 随着时间推移，自动销毁附近废弃的部落建筑 |
| 硬编码 | NoBattlEye |  | 不启动 BattleEye 反作弊工具 |
| 硬编码 | crossplay |  | 允许跨平台（Epic 和 Steam 互通） |
| 硬编码 | server |  | 用途不明 |

启动过一次服务端后，会在 `ShooterGame/Saved/Config/LinuxServer/` 目录下自动创建 `GameUserSettings.ini` 和 `Game.ini` 配置文件，可以参考 [ARK Server configuration](https://ark.fandom.com/wiki/Server_configuration) 的参数说明修改该配置文件。

除了上表的**可控**配置项，均可在配置文件中修改。否则需要修改脚本 [`bin/ark.sh`](./bin/ark.sh)。

1. 修改完成后，需要停止镜像: `bin/stop.[sh|ps1]`
2. 如果修改过 [`bin/ark.sh`](./bin/ark.sh)，还需要重新构建镜像: `bin/build.[sh|ps1]`
3. 再次运行镜像: `bin/run_docker.[sh|ps1]`
4. 然后运行 ARK 服务端: `bin/run_ark.[sh|ps1]`


## 0x70 重启服务

只有第一次需要执行上述的步骤，配置好之后，只需要简单 3 条命令即可：

1. 停止镜像: `bin/stop.[sh|ps1]`
2. 运行镜像: `bin/run_docker.[sh|ps1]`
3. 运行 ARK: `bin/run_ark.[sh|ps1]`

> 当服务端已经通过 SteamCMD 下载完成后，其实已经不需要 steam 用户了。此时若需要使用 root 用户，可以在上述命令后面添加 `-u root`

![](./imgs/01.jpg)


## 0x80 迁移服务

服务启动后会自动生成以下 3 个目录：

- 配置目录: `./volumes/steam/games/ark/ShooterGame/Saved/Config/*`
- 存档目录: `./volumes/steam/games/ark/ShooterGame/Saved/SavedArks/*`
- 日志目录: `./volumes/steam/games/ark/ShooterGame/Saved/Logs/*`

迁移前可以执行脚本 `bin/backup.[sh|ps1]` 将其备份到 [backup](./backup) 目录。

建议设置 `crontab -e` 定时任务自动备份 :

```
# 每小时备份一次存档
# 其中把 ${ARK_DIR} 换成实际 ark-server-docker 工程的绝对路径
# 例如: /home/steam/workspace/github/ark-server-docker
0 */1 * * * cd ${ARK_DIR} && bin/backup.sh > /tmp/backup.log
```



## 0x90 安装 MOD

1. 先到 ARK 的创意工坊订阅希望安装的 MOD（订阅后会自动下载）
2. 同时 Mod 说明里面会提供一个 MOD ID，记下来
3. 打开 steam 的 MOD 安装目录 `SteamLibrary\steamapps\workshop\content\346110`（346110 就是前面提到的 ARK 游戏客户端的 APP ID）
4. 目录下有一个以 MOD ID 命名的文件夹，有时可能还会有以 MOD ID 命名的 `*.mod` 文件，复制它们
5. 粘贴到 ARK 服务端 `./volumes/steam/games/ark/ShooterGame/Content/Mods` 的目录下
6. 重启 ARK，并且启动命令需要指定 MOD ID 的参数: `bin/run_ark.[sh|ps1] -i ${MOD_ID}`（用逗号分隔多个 MOD ID）

![](./imgs/09.jpg)


当前默认已安装的 MOD 如下，启动服务时按需选择开启即可：

| 订阅地址 | id | name | 用途 |
|:---:|:---:|:---|:---|
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=1404697612) | 1404697612 | `Awesome SpyGlass!` | A+ 望远镜 |
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=849372965) | 849372965 | `HG Stacking Mod 1000-90` | 物品叠加上限 `+1000` 负重 `-50%` |
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=768023924) | 842913750 | `HG Stacking Mod 2500-50` | 物品叠加上限 `+2500` 负重 `-50%` |
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=768023924) | 768023924 | `HG Stacking Mod 2500-90` | 物品叠加上限 `+2500` 负重 `-90%` |
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=849985437) | 849985437 | `HG Stacking Mod 5000-90` | 物品叠加上限 `+5000` 负重 `-90%` |
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=928102085) | 928102085 | `HG Stacking Mod 10000-90` | 物品叠加上限 `+10000` 负重 `-90%` |
| [Link](https://steamcommunity.com/sharedfiles/filedetails/?id=2885013943) | 2885013943 | `ARK: Monster Additions!` | 添加【怪物猎人:世界】中出现的怪物 |


## 0xE0 更多脚本说明

- 构建 ARK 环境镜像: `bin/build.[sh|ps1]`
- 运行 ARK 环境容器: `bin/run_docker.[sh|ps1]`
- 安装 ARK 服务端: `bin/install_game.[sh|ps1]`
- 运行 ARK 服务端: `bin/run_ark.[sh|ps1]`
- 进入 ARK 环境容器终端: `bin/terminal.[sh|ps1]`
- 停止 ARK 服务端与环境容器: `bin/stop.[sh|ps1]`
- 备份 ARK 服务端存档和配置文件: `bin/backup.[sh|ps1]`
- 清除 ARK 服务端存档、配置和日志文件: `bin/clean.[sh|ps1]`


## 0xFF 参考文档

- 《[Linux 搭建方舟服务器教程 方舟生存进化](https://www.bilibili.com/video/BV1Xp4y1n7pq/)》
- 《[在 Linux 系统下安装 steamCMD](https://blog.wehaox.com/archives/3.html)》
- 《[Linux 搭建 ARK 服务器](https://blog.csdn.net/xiaotian2333333/article/details/124733348)》
- 《[方舟生存进化: docker一键部署](https://ssst0n3.github.io/post/%E6%B8%B8%E6%88%8F/%E6%96%B9%E8%88%9F%E7%94%9F%E5%AD%98%E8%BF%9B%E5%8C%96-docker%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2.html)》
- 《[Dockerize ARK managed with ARK-Server-Tools](https://hub.docker.com/r/hermsi/ark-server/)》
- 《[ark-server-tools](https://github.com/arkmanager/ark-server-tools)》
- 《[arkserver](https://github.com/thmhoag/arkserver)》
