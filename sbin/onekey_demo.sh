#!/bin/bash
# 启动 ARK 服务
# 更多配置参数见: https://ark.fandom.com/wiki/Server_configuration
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
