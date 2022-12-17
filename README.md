# ARK-server-docker

> docker 一键部署 ARK（方舟-生存进化）

------

## 0x00 介绍

此为 steam 版 ARK 的 docker 服务端，可用于搭建私人联机服务器。

搭建过程只用到官方原生的 [SteamCMD docker](https://hub.docker.com/r/cm2network/steamcmd/) 和 [ARK Server configuration](https://ark.fandom.com/wiki/Server_configuration) 配置。

> 此工程没有引入网上其他比较热门的 ARK 部署工具，所以它们的配置项均不适用


## 0x10 运行环境

![](https://img.shields.io/badge/Linux%20x64-red.svg) ![](https://img.shields.io/badge/Windows%20x64-blue.svg)


## 0x10 硬件要求

| 硬件 | 最低配置 | 推荐配置 | 流畅配置 |
|:---:|:---:|:---:|:---:|
| CPU | 2C | 4C | 8C|
| 内存 | 6G | 8G | 16G |
| 虚拟内存 | 4G | 4G | 4G |
| 硬盘 | 50G | 100G | 100G |

> ARK 当前版本的服务端大小为 18812537984 bytes，约 18G，因为要从 steam 服务器下载，所以国内非常慢甚至连接不上。建议使用香港或韩国的云主机，从海外下载速度较快且不会被 GFW 拦截、国内也有不错的访问速度


## 0x30 部署步骤

### 0x31 预操作

1. 使用 root 用户安装 [python3](https://www.python.org/downloads/)、 docker、 docker-compose、 git
2. 使用 root 用户设置虚拟内存（推荐 4G）
3. 添加 id=1000 的用户到 docker 组: `usermod -aG docker $(grep 1000 /etc/passwd | awk -F: '{print $1}')`
4. 切换到 id=1000 的用户: `su - $(grep 1000 /etc/passwd | awk -F: '{print $1}')`
5. **之后所有步骤使用 id=1000 的用户执行**

之所以要使用 id=1000 的用户，是因为下面构建的 [SteamCMD docker](https://hub.docker.com/r/cm2network/steamcmd/) 镜像内也强制使用了 id=1000 的用户（steam）。

由于 docker 需要从宿主机挂载服务端的游戏目录，如果宿主机使用 root 用户挂载，会导致 docker 内的用户没有权限而无法读写。所以宿主机需要使用 id=1000 的用户启动 docker。

> 在 Linux 中， root 的 id=0， 而 1-999 是保留给系统用户的，普通用户的 id 从 1000 开始，docker 内一般只有一个普通用户，故默认 id=1000。


### 0x31 部署镜像

1. 下载此仓库: `git clone --depth 1 --branch master https://github.com/lyy289065406/ark-server-docker.git`
2. 进入根目录: `cd ark-server-docker`
3. 构建镜像: `bin/build.[sh|ps1]`（镜像中不含游戏本体，只有用于下载游戏的 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) ）
4. 运行镜像: `bin/run_docker.[sh|ps1]`

> 如果不想自己构建镜像，可以使用现成的镜像: [expm02/ark-server-docker:latest](https://hub.docker.com/repository/docker/expm02/ark-server-docker)


### 0x32 部署 ARK 服务端（SteamCMD 通道）

安装游戏: `bin/install_game.[sh|ps1]`，此为命令执行后会打开 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) 交互终端，依次输入：

1. 创建 ARK 游戏目录: `force_install_dir /home/steam/games/ark`
2. 匿名登录 steam : `login anonymous`
3. 下载 ARK 服务端: `app_update 376030`（游戏约 18G，超级慢而且可能失败）

> `app_update 376030` 可能会因为网络原因多次失败，重新执行即可，会断点下载

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
3. Frok 此仓库（目的是使用 SSH 下载）: [`https://github.com/lyy289065406/ark.git`](https://github.com/lyy289065406/ark)
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
| 可控 | GameModIds |   | 服务器已安装支持的 MOD ID 列表 |
| 可控 | ActiveMods |   | 服务器当前激活的 MOD ID 列表 |
| 可控 | DifficultyOffset | 0.2 | 游戏难度，最大值 3 。难度越高、怪物等級越高 |
| 可控 | HarvestAmountMultiplier | 1.0 | 资源获得倍率，最大值 3 。<br/>影响行为包括：砍伐树木、采摘浆果、分解尸体、开采岩石等 |
| 可控 | TamingSpeedMultiplier | 1.0 | 驯服恐龙倍率，最大值未知。此项越大、驯服速度越快 |
| 可控 | ResourcesRespawnPeriodMultiplier | 1.0 | 资源重生倍率。此项越小、重生速率越快。资源包括：树木、岩石、灌木等 |
| 可控 | CropGrowthSpeedMultiplier | 1.0 | 作物生长倍率。此项越大、作物成长越快 |
| 可控 | XPMultiplier | 1.0 | 指定玩家、部落和恐龙在各种行动中获得的经验获得倍率。此项越大、获得经验越多 |
| 硬编码 | serverPVE | True | PVE 模式 |
| 硬编码 | RCONEnabled | True | 是否启用 RCON 服务器在线管理工具 |
| 硬编码 | RCONPort | 32330 | RCON 的服务端口 |
| 硬编码 | servergamelog |  | 记录 Admin 在 RCON 的操作日志 |
| 硬编码 | ShowFloatingDamageText | True | 类似 RPG 游戏浮现伤害文字 |
| 硬编码 | ServerAutoForceRespawnWildDinosInterval |  | 服务器重启时强制刷新野生恐龙 |
| 硬编码 | AutoDestroyStructures |  | 随着时间推移，自动销毁附近废弃的部落建筑 |
| 硬编码 | NoBattlEye |  | 不启动 BattleEye 反作弊工具 |
| 硬编码 | crossplay |  | 允许跨平台（Epic 和 Steam 互通） |
| 硬编码 | server |  | 作为服务器启动（可有可无） |
| 硬编码 | log |  | 记录服务器的游戏日志 |


启动过一次服务端后，会在 `ShooterGame/Saved/Config/LinuxServer/` 目录下自动创建 `GameUserSettings.ini` 和 `Game.ini` 配置文件，可以参考 [ARK Server configuration](https://ark.fandom.com/wiki/Server_configuration) 的参数说明修改这些配置文件。

除了上表的**可控**配置项，均可在配置文件中修改。否则需要修改脚本 [`bin/ark.sh`](./bin/ark.sh)。

1. 修改完成后，需要停止镜像: `bin/stop.[sh|ps1]`
2. 如果修改过 [`bin/ark.sh`](./bin/ark.sh)，还需要重新构建镜像: `bin/build.[sh|ps1]`
3. 再次运行镜像: `bin/run_docker.[sh|ps1]`
4. 然后运行 ARK 服务端: `bin/run_ark.[sh|ps1]`


## 0x70 重启服务

只有第一次需要执行上述的步骤，配置好之后，只需要简单 3 条命令即可：

1. 停止镜像: `bin/stop.[sh|ps1]`
2. 运行镜像: `bin/run_docker.[sh|ps1]`（参数见脚本内）
3. 运行 ARK: `bin/run_ark.[sh|ps1]`（参数见脚本内）


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

> `bin/backup.[sh|ps1]` 脚本会自动删除 3 天前的存档记录，避免服务器硬盘溢出


## 0x90 安装 MOD

在 [ark-mods](https://github.com/lyy289065406/ark-mods) 仓库中列出了推荐的 MOD。

把期望要安装的 MOD 复制到 `./volumes/steam/games/ark/ShooterGame/Content/Mods` 目录后，在使用 `bin/run_ark.[sh|ps1]` 脚本启动服务器时，通过 `-i ${MOD_IDS}` 按需指定即可。

> 详见 《[在 ARK 安装 MOD 指引](./AddMod.md)》


## 0xA0 定制个性化脚本

虽然用 `bin/run_ark.[sh|ps1]` 脚本可以一键启动，但是定制个性化服务时的启动参数还是太多，不方便记忆。

所以可以自行再添加一些封装脚本在 [`sbin`](./sbin/) 目录（此目录不会把文件同步到 Git 仓库），可以参考样例 [`sbin/onekey_demo.sh`](./sbin/onekey_demo.sh)：

```bash
#!/bin/bash
# sbin/onekey_demo.sh
#------------------------------------------------
# 示例：sbin/onekey_demo.sh 
#           [-s ${ServerName}]                  # 服务器名称（在 steam 服务器上看到的）
#           [-m ${MapName}]                     # 地图名
#           [-c ${PlayerAmount}]                # 最大玩家数
#           [-p ${ServerPassword}]              # 服务器密码
#           [-a ${AminPassword}]                # 管理员密码
#           [-d ${Difficulty}]                  # 游戏难度
#           [-h ${HarvestAmount}]               # 资源获得倍率
#           [-t ${TamingSpeed}]                 # 驯服恐龙倍率
#           [-r ${ResourcesRespawnPeriod}]      # 资源重生倍率
#           [-g ${CropGrowthSpeed}]             # 作物生长倍率
#           [-x ${XPMultiplier}]                # 经验获得倍率
#           [-i ${ModIds}]                      # 地图 MOD ID 列表，用英文逗号分隔
#------------------------------------------------

# 启动容器
bin/run_docker.sh
sleep 5

# 启动 ARK 服务端
bin/run_ark.sh  -s "EXP_ARK_Server" -p "EXP123456" -a "ADMIN654321" \
                -h "3" -t "5" -r "0.5" -g "2" -x "10" -c "10" \
                -m "Ragnarok" -i "1404697612,928102085,2885013943,751991809,731604991,889745138,902616446,1211297684,893904615,895711211,1232362083,618916953,722649005"

```


## 0xB0 升级服务端

因为 steam 的客户端会自动升级，当版本不匹配时，客户端无法找到服务端，此时需要使用 steam 通道在线升级：

1. 重新构建镜像（因为新版本需要更新 SteamCMD 才能下载）: `bin/build.[sh|ps1] -c OFF`
2. 启动容器: `bin/run_docker.[sh|ps1]`
3. 打开 steam 交互终端: `bin/install_game.[sh|ps1]`
4. 匿名登录 steam : `login anonymous`
5. 更新 ARK 服务端: `app_update 376030 validate`（游戏约 18G，超级慢而且可能失败）


## 0xC0 更多脚本说明

- 构建 ARK 环境镜像: `bin/build.[sh|ps1]`
- 发布 ARK 环境镜像: `bin/deploy.[sh|ps1]`
- 运行 ARK 环境容器: `bin/run_docker.[sh|ps1]`（参数见脚本内）
- 安装 ARK 服务端: `bin/install_game.[sh|ps1]`
- 运行 ARK 服务端: `bin/run_ark.[sh|ps1]`（参数见脚本内）
- 进入 ARK 环境容器终端: `bin/terminal.[sh|ps1]`（参数见脚本内）
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
