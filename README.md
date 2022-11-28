# ARK-docker

> docker 部署 ARK（方舟生存进化）

------

## 介绍

此为 steam 版 ARK 的 docker 服务端，可用于搭建私人联机服务器。


## 运行环境

![](https://img.shields.io/badge/OS|Linux-red.svg) ![](https://img.shields.io/badge/OS|Windows-blue.svg)


## 硬件要求

| 硬件 | 最低配置 | 推荐配置 | 流畅配置 |
|:---:|:---:|:---:|:---:|
| CPU | 2C | 4C | 8C|
| 内存 | 6G | 8G | 16G |
| 硬盘 | 30G | 50G | 100G |

> ARK 当期版本的服务端大小为 18812537984 字节，约 18G，因为要从 steam 服务器下载，所以国内非常慢甚至连接不上。建议使用香港或韩国的云主机，从海外下载速度较快且不会被 GFW 拦截、国内也有不错的访问速度


## 部署步骤（标准）

1. 创建 steam 用户: TODO （docker 内的 steamCMD 使用了 steam 用户，导致若宿主机使用了 root 用户，会导致在挂载目录后 docker 内无法读写，所以禁止使用）
2. 安装 python3、docker、docker-compose
3. 授权 steam 用户: docker ... xxx TODO
4. 下载此仓库: `git clone --depth 1 --branch master https://github.com/lyy289065406/ark-docker.git`
5. 进入根目录: `cd ark-docker`
6. 构建镜像: `bin/build.sh`（镜像中不含游戏本体，只有用于下载游戏的 steamCMD ）
7. 运行镜像: `bin/run.sh`
8. 安装游戏: `bin/install_game.sh`，此为命令执行后会打开 steamCMD 交互终端，依次输入：
  - 创建 ARK 游戏目录: `force_install_dir /home/steam/games/ark`
  - 匿名登录 steam : `login anonymous`
  - 下载 ARK 服务端: `app_update 376030`（约 18G，超级慢而且可能失败）
9. 修改配置 xxxxx TODO
10. 启动服务端: `bin/ark_start.sh`（首次启动约 15 分钟）
11. steam 添加服务器: 查看 `->` 服务器 `->` 收藏夹 `->` 添加服务器 `->` `${云主机公网 IP}:27015`
12. 开始游戏吧 ~


<details>
<summary>关于 steam app id 376030 ...</summary>
<br/>

在 steam 中每个游戏都有一个唯一且固定的 APP ID，可以在商店页面地址中查看（跟在 `/app/` 后的数字）：

| APP ID | 游戏名称 | 描述 |
|:---:|:---|:---|
| 346110 | ARK: Survival Evolved | ARK 客户端 |
| 376030 | ARK: Survival Evolved Dedicated Server | ARK 专用服务端 |

</details>


## 部署步骤（非标准）

> 优先使用标准的部署步骤，非标准步骤仅适用于无法通过 steamCMD 下载的情况

1. 创建 steam 用户: TODO （docker 内的 steamCMD 使用了 steam 用户，导致若宿主机使用了 root 用户，会导致在挂载目录后 docker 内无法读写，所以禁止使用）
2. 安装 python3、docker、docker-compose
3. 授权 steam 用户: docker ... xxx TODO
4. 下载此仓库: `git clone --depth 1 --branch master https://github.com/lyy289065406/ark-docker.git`
5. 进入根目录: `cd ark-docker`
6. 构建镜像: `bin/build.sh`（镜像中不含游戏本体，只有用于下载游戏的 steamCMD ）
7. 运行镜像: `bin/run.sh`
8. 拉取 ARK 完整服务端的 git 目录 :
  - 先在 Github 上 Fork https://github.com/lyy289065406/ark
  - 使用 ssh 拉取仓库到 [ark-docker/volumes/steam/games](./volumes/steam/games) 目录下: `git clone --depth 1 --branch master git@github.com:lyy289065406/ark.git` (ssh 的配置方法参考官方文档 TODO)
  - 根据 [ark](https://github.com/lyy289065406/ark.git) 的 [README.md](ttps://github.com/lyy289065406/ark.git) 说明补全大文件 TODO
9. 修改配置 xxxxx TODO
10. 启动服务端: `bin/ark_start.sh`（首次启动约 15 分钟）
11. steam 添加服务器: 查看 `->` 服务器 `->` 收藏夹 `->` 添加服务器 `->` `${云主机公网 IP}:27015`
12. 开始游戏吧 ~


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


https://developer.valvesoftware.com/wiki/SteamCMD#Docker
https://hub.docker.com/r/cm2network/steamcmd/
服务器配置：https://ark.fandom.com/wiki/Server_configuration



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