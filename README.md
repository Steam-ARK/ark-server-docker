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

当 [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) 通道无法安装成功时，可使用此方法：

1. 创建 [Github](https://github.com/) 账号（若已有则跳过）
2. 配置 [Github SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
3. Frok 此仓库（目的是使用 SSH 下载）: `https://github.com/lyy289065406/ark.git`
4. 创建并切换工作目录: `volumes/steam/games`
5. 使用 SSH 下载到该目录: `git clone --depth 1 --branch master git@github.com:${你的用户名}/ark.git`
6. 解压大文件: `bin/unpack_7zip.sh` 或 `bin/unpack_7zip.ps1`（需要预装 [7-zip](https://www.7-zip.org/) 命令行）

> 更多细节详见 [ARK](https://github.com/lyy289065406/ark.git) 的 [README.md](ttps://github.com/lyy289065406/ark.git) 说明


### 0x33 运行 ARK 服务端

1. 启动服务端: `bin/run_ark.sh`（首次启动约 15 分钟）
2. steam 添加服务器: 查看 `->` 服务器 `->` 收藏夹 `->` 添加服务器 `->` `${云主机公网 IP}:27015`
3. 开始游戏吧 ~


### 0x34 关于定制 ARK 启动脚本

1. 首先停止镜像: `bin/stop.sh`
2. ARK 的核心启动脚本在 `bin/ark.sh`，目前是使用了默认配置
3. 可以参考 [ARK Server configuration](https://ark.fandom.com/wiki/Server_configuration) 的参数说明，修改该脚本
4. 修改完成后，需要重新构建镜像: `bin/build.sh`
5. 运行镜像: `bin/run_docker.sh`
6. 运行服务端: `bin/run_ark.sh`


## 暴露服务

以下服务端口需要：

- docker 映射到宿主机（已配置到 [docker-compose.yml](./docker-compose.yml)）
- 主机防火墙准入（Linux 若没有安装 iptables 则不需要）
- 云主机配置安全组策略

| 协议 | 端口 | 是否必要 | 用途 |
|:---:|:---:|:---:|:---|
| UDP | 7777 | 是 | 当私服的房主开启房间后，其他玩家寻找主机的端口？ |
| UDP | 7778 | 是 |  |
| TCP | 27020 | 否 |  |
| UDP | 27015 | 是 |  |


- "7777:7777/udp"
      # Raw UDP socket port (always Game client port +1)  : 自定义的服务器端口
      - "7778:7778/udp"
      # RCON management port: 服务器命令行管理工具 RCON 的连接端口
      - "27020:27020/tcp"
      # Steam's server-list port
      - "27015:27015/udp"






#其中数字是这游戏的steamapp id
网站查看https://steamcommunity.com/app
搜索需要查看的游戏，然后看浏览器网址窗口app后面跟的数值就是这个app的id



Variable	Default value	Explanation
SESSION_NAME	Dockerized ARK Server by github.com/hermsi1337	The name of your ARK-session which is visible in game when searching for servers
SERVER_MAP	TheIsland	Desired map you want to play
SERVER_PASSWORD	YouShallNotPass	Server password which is required to join your session. (overwrite with empty string if you want to disable password authentication)
ADMIN_PASSWORD	Th155houldD3f1n3tlyB3Chang3d	Admin-password in order to access the admin console of ARK
MAX_PLAYERS	20	Maximum number of players to join your session
UPDATE_ON_START	false	Whether you want to update the ARK-server upon startup or not
BACKUP_ON_STOP	false	Create a backup before gracefully stopping the ARK-server
PRE_UPDATE_BACKUP	true	Create a backup before updating ARK-server
WARN_ON_STOP	true	Broadcast a warning upon graceful shutdown
ENABLE_CROSSPLAY	false	Enable crossplay. When enabled battleye should be disabled as it likes to disconnect epic players
DISABLE_BATTLEYE	false	Disable Battleye protection
ARK_SERVER_VOLUME	/app	Path where the server-files are stored
GAME_CLIENT_PORT	7777	Exposed game-client port
UDP_SOCKET_PORT	7778	Raw UDP socket port (always Game client port +1)
RCON_PORT	27020	Exposed RCON port
SERVER_LIST_PORT	27015	Exposed server-list port
GAME_MOD_IDS	empty	Additional game-mods you want to install, seperated by comma. (e.g. GAME_MOD_IDS="487516323,487516324,487516325")



ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?Port=7779?QueryPort=27017AltSaveDirectoryName=gudao?SessionName="ARK原初-孤岛"?MaxPlayers=30?ServerAutoForceRespawnWildDinosInterval=259200?AllowCrateSpawnsOnTopOfStructures=True -ForceAllowCaveFlyers -AutoDestroyStructures -clusterid=2022 -ClusterDirOverride=/home/steam/ark/arkwq -NoBattlEye -crossplay -nosteamclient -game -server -log




参数说明：

        地图：要开什么地图就在地图位置写入相应的地图名（这里是孤岛）

        端口：服务端的端口（必须唯一）

        搜索端口：在steam上搜索时使用的端口（必须唯一）

        组内名称：在这个服务器上的名字（必须唯一）

        服务器名称：在steam服务器上看到的名称

        最大人数：服务器可容纳的人数

        组名称：这个服务器上开的地图组名称（多个图希望哪些图互通的就设置一样，如一个孤岛的设置是2022，一个畸变的设置也是2022，这俩个图就能互通）

        集群目录：服务器上传缓存的位置玩家上传到方舟的角色和物品的缓存）

ShooterGame/Binaries/Linux/ShooterGameServer 地图?listen?Port=端口?QueryPort=搜索端口AltSaveDirectoryName=组内名称?SessionName="服务器名称"?MaxPlayers=最大人数?ServerAutoForceRespawnWildDinosInterval=259200?AllowCrateSpawnsOnTopOfStructures=True -ForceAllowCaveFlyers -AutoDestroyStructures -clusterid=组名称 -ClusterDirOverride=集群目录 -NoBattlEye -crossplay -nosteamclient -game -server -log

2.游戏配置文件：

        全局文件配置：

在/home/steam/ARK/ShooterGame/Saved/Config/LinuxServer文件夹下的Game.ini和GameUserSettings.ini一般只设置GameUserSettings.ini文件




## 参考文档

https://blog.csdn.net/xiaotian2333333/article/details/124733348


没用到  https://github.com/arkmanager/ark-server-tools

- 《[方舟生存进化: docker一键部署](https://ssst0n3.github.io/post/%E6%B8%B8%E6%88%8F/%E6%96%B9%E8%88%9F%E7%94%9F%E5%AD%98%E8%BF%9B%E5%8C%96-docker%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2.html)》
- 《[ark-server-tools](https://github.com/arkmanager/ark-server-tools)》
- 《[arkserver](https://github.com/thmhoag/arkserver)》
- 《[Dockerize ARK managed with ARK-Server-Tools](https://hub.docker.com/r/hermsi/ark-server/)》


```
[S_API FAIL] SteamAPI_Init() failed; SteamAPI_IsSteamRunning() failed.
/home/buildbot/buildslave/steam_rel_client_linux64/build/src/clientdll/applicationmanager.cpp (3004) : Assertion Failed: CApplicationManager::GetMountVolume: invalid index
/home/buildbot/buildslave/steam_rel_client_linux64/build/src/clientdll/applicationmanager.cpp (3004) : Assertion Failed: CApplicationManager::GetMountVolume: invalid index
/home/buildbot/buildslave/steam_rel_client_linux64/build/src/clientdll/applicationmanager.cpp (3155) : Assertion Failed: m_vecInstallBaseFolders.Count() > 0
```
这个报错对启动服务器无影响，最少需要启动15分钟
https://community.teklab.de/thread/9383-ark-gameserver-startet-nicht/




清除分支历史： https://blog.csdn.net/jhsword/article/details/107543884
ark 服务端上传到 github ?