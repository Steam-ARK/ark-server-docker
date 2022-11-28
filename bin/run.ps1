#!/bin/bash
# 运行 docker 服务
#------------------------------------------------
# 命令执行示例：
# bin/run.ps1 -svc_pwd "${SPWD}" -admin_pwd "${APWD}" -max_players "${AMOUNT}" -svc_map "${MAP_NAME}" -game_mod_ids "{ID1},{ID2},...,{IDn}"
#------------------------------------------------

param(
    [string]$session_name="ARK_Docker_Server_By_EXP", 
    [string]$svc_map="TheIsland", 
    [string]$group_svc_map="ARK_Maps_By_EXP", 
    [string]$svc_pwd="svc010203", 
    [string]$admin_pwd="admin040506", 
    [int]$max_players=20, 
    [string]$update_on_start="false", 
    [string]$backup_on_stop="false", 
    [string]$pre_update_backup="true", 
    [string]$warn_on_stop="true", 
    [string]$enable_crossplay="false", 
    [string]$disable_battleye="false", 
    [string]$game_mod_ids=""
)

Write-Host "---------- Input Params ----------"
Write-Host "SESSION_NAME = ${session_name}"
Write-Host "SERVER_MAP = ${svc_map}"
Write-Host "GROUP_SERVER_MAP = ${group_svc_map}"
Write-Host "SERVER_PASSWORD = ${svc_pwd}"
Write-Host "ADMIN_PASSWORD = ${admin_pwd}"
Write-Host "MAX_PLAYERS = ${max_players}"
Write-Host "UPDATE_ON_START = ${update_on_start}"
Write-Host "BACKUP_ON_STOP = ${backup_on_stop}"
Write-Host "PRE_UPDATE_BACKUP = ${pre_update_backup}"
Write-Host "WARN_ON_STOP = ${warn_on_stop}"
Write-Host "ENABLE_CROSSPLAY = ${enable_crossplay}"
Write-Host "DISABLE_BATTLEYE = ${disable_battleye}"
Write-Host "GAME_MOD_IDS = ${game_mod_ids}"
Write-Host "----------------------------------"


$ENV:SESSION_NAME=${session_name}; `
$ENV:SERVER_MAP=${svc_map}; `
$ENV:GROUP_SERVER_MAP=${group_svc_map}; `
$ENV:SERVER_PASSWORD=${svc_pwd}; `
$ENV:ADMIN_PASSWORD=${admin_pwd}; 
$ENV:MAX_PLAYERS=${max_players}; `
$ENV:UPDATE_ON_START=${update_on_start}; `
$ENV:BACKUP_ON_STOP=${backup_on_stop}; `
$ENV:PRE_UPDATE_BACKUP=${pre_update_backup}; `
$ENV:WARN_ON_STOP=${warn_on_stop}; `
$ENV:ENABLE_CROSSPLAY=${enable_crossplay}; `
$ENV:DISABLE_BATTLEYE=${disable_battleye}; `
$ENV:GAME_MOD_IDS=${game_mod_ids}; `
docker-compose up -d
Write-Host "Server is Running ..."

