# 📦 v3.1-1 Release Notes

> **Release date**: 2026-06-09
> **Target**: OpenWRT 21.02+, Python 3.8+, aarch64/armv7/x86_64
> **Artifact**: `broadlinkac_3.1-1_aarch64_cortex-a55.ipk` (36 KB)

## 🎯 一句话总结

**v3.0 → v3.1 是一次"修 bug 为主、新功能为辅"的稳定版升级**。本轮共修复 12+ 个真实问题（涉及台风、天气、定时、配置同步等多个核心模块），全部在生产路由器上验证过。

## ✨ 本版新功能

1. **日志下载** —— LuCI 工具栏新增 `📋` 按钮，弹窗显示最近 14 天日期网格，标红可点，下载 `.md` 文件到本地
2. **大圆按钮优化** —— `▶` 字符替代 `⏻`（Android/Windows 跨平台可用），CSS transform 微调视觉居中
3. **设备下拉框位置** —— 移到左边，"请稍候..."移到刷新按钮左侧，UI 更紧凑
4. **首次打开自动扫描** —— 全新装用户无设备时自动调 `discover`，失败显示 6s 提示
5. **总开关 enabled** —— CBI 设置页可一键启停整个 service

## 🐛 修复的 Bug（按严重度）

### P0（紧急，已修 3 项）

| # | Bug | 修复 |
|---|-----|------|
| 1 | **风速映射失配**：前端 `data-fan="low/medium/high"` 永远回退到 `FAN_AUTO` | `ac_control.py` 两个 `fan_map`（hvac_ir + protocols/）都加 `low→FAN_1 / medium→FAN_2 / high→FAN_3` 兼容映射 |
| 2 | **双重拉数据**：service 启动后 daemon 上来再拉一次，和 `init()` 末尾的立即拉重复 | `scheduler.py` `_weather_loop` / `_typhoon_loop` 首次 `time.sleep(interval)` 再拉，让 `init()` 的立即拉当"启动后第一发" |
| 3 | **空 MAC 误匹配**：`_uci_set_device("", dev)` 会因 `"" in line == True` 写错设备节 | ① 入口 `if not mac: return` 早返回；② 模糊匹配改精确匹配 `val == mac`；③ `save_device` 入口加 MAC 校验 |

### P1（重要，已修 3 项 + 1 项回退 + 2 项误判/设计保留）

| # | Bug | 修复 |
|---|-----|------|
| 1 | `selectLocation` 单引号注入（Nominatim 返回 `St. John's` 会截断 onclick） | 改用 `data-*` + `encodeURIComponent` + 读时 `decodeURIComponent` |
| 2 | 新设备不注册 scheduler（`register_all_jobs` 只在启动时跑一次） | 新增 `re_register()` 函数，discover/save_device/save_schedule 三处末尾调用 |
| 3 | `auto_adjust` 整点触发偏离用户作息 | 改回 `sch.every(2).hours` 相对间隔（用户明确：24h 都可能有需要）|
| 4 | 日志解析错误 | **误判** —— 台风双日志都带 `[HH:MM]`，`get_last_ac_state` 倒序能正确匹配 |
| 5 | Controller stderr 被吞 | **设计** —— `subprocess.run(capture_output=True)` 吞 stderr 是为不污染 status JSON |

### P2（次要，已修 3 项 + 1 项撤回 + 1 项误判）

| # | Bug | 修复 |
|---|-----|------|
| 1 | `typhoon_threat_distance` 不走 cache（每次调用重打 NMC 服务器） | 强制走 `_ty_cache`，缓存空才 `fetch_and_cache()` 兜底 |
| 2 | 台风 `ty_ac_off_sent` 标志位漏关（用户手动开机后漏关 30min） | 删标志位，改读 `get_last_ac_state()` 查真实状态，**< 100km 强制发关**（用户安全设计意图）|
| 3 | `init()` 异常保护（半损坏 JSON 会让 procd 反复重启刷 syslog） | 整体 try/except，失败时降级用空 defaults 撑住 |
| 4 | UCI 默认 Beijing | **撤回** —— 用户明确是设计行为（"宁可错不可无"）|
| 5 | service 写 syslog | **误判** —— `procd_set_param stdout/stderr 1` 已经在管 |

## 🌤️ 天气回退链加固

| 场景 | v3.0 行为 | v3.1 行为 |
|------|-----------|-----------|
| 用户显式选百度 + 失败 | 返 None | **仍返 None**（不偷回落和风）|
| 用户未显式选 + 百度失败 | 回落和风 | **回落和风** |
| 双源都失败 | 返 None，UI 出现 `--` | **返 `_last_weather` 旧缓存**（10min 内不至于完全没数据）|
| 无 baidu_key | 静默回落 | **加日志** `[百度实况] 无 baidu_key, 跳过 → 回落和风` |

## 🌀 台风安全策略

**v3.0 → v3.1 关键改动**：
- `judge_and_shutdown` 不再判 `power=off` 短路，**< 100km 强制发关**（哪怕用户刚手动开了空调）
- 用户唯一的"反制"路径是去 CBI 设置页关掉 `typhoon_ac_off`（沿海用户实战经验：台风来时气温不高，开风扇足矣）

**新拦截链**：
| 触发场景 | 距离 < 100km | 行为 |
|----------|-------------|------|
| 30min 台风巡检 | ✅ | **强制发关**（覆盖用户反行为）|
| 定时开机 | ✅ | 跳过（信任台风关过）|
| 定时关机 | ✅ | 跳过（避免抢发）|
| 自动调温 | ✅ | 跳过（不与台风抢发）|
| 自动调温 | power=off | 跳过（不打扰用户）|
| 自动调温 | mode/temp 一致 | 跳过（节能）|

## 🔌 架构调整

### 路径常量（修隐藏的 nobody CGI bug）
- `config.py`: `Path.home() / ".ac_controller"` → `Path("/root/.ac_controller")`（OpenWrt 上）
- `broadlinkac_api.py` 5 处 `os.path.expanduser("~/.ac_controller/...")` → 硬编码
- 修了一个老问题：uhttpd CGI 进程以 nobody 运行，`Path.home()` 解析为 `/var`，service 写在 `/root` 的日志 CGI 读不到

### 日志下载独立 endpoint
- `controller.lua` 新增 `log_download` entry（绕开 `luci.sys.exec` 4KB 截断）
- `broadlinkac_api.py` 删原来的 log_download 分支
- 前端改走 `/cgi-bin/luci/admin/services/broadlinkac/log_download?date=YYYY-MM-DD`

## 📥 安装

### 一键（推荐给新用户）
```bash
scp broadlinkac_3.1-1_aarch64_cortex-a55.ipk install.sh root@192.168.1.1:/tmp/
ssh root@192.168.1.1 "bash /tmp/install.sh"
```

### 手动
```bash
scp broadlinkac_3.1-1_aarch64_cortex-a55.ipk root@192.168.1.1:/tmp/
ssh root@192.168.1.1
opkg update
opkg install python3-light python3-pip python3-urllib python3-json python3-broadlink python3-schedule
opkg install /tmp/broadlinkac_3.1-1_aarch64_cortex-a55.ipk --force-depends
pip3 install hvac_ir
```

## ⬆️ 从 v3.0 升级

```bash
opkg install /tmp/broadlinkac_3.1-1_aarch64_cortex-a55.ipk --force-depends
# 自动保留 /etc/config/broadlinkac 和 /root/.ac_controller/ 不动
# 重启 service
/etc/init.d/broadlinkac restart
```

## 🔗 姊妹项目

- 桌面端（Windows / macOS / Linux GUI）：[BroadlinkAC-For-Agent](https://github.com/oywq00008-cell/BroadlinkAC-For-Agent)
- AI Agent Skill 接口：同上
- 共享核心算法（ac_control / typhoon / weather / scheduler）和红外协议（haier / aux_ac / panasonic）

## 📊 体积

| 项 | 大小 |
|----|------|
| IPK 主体 | 36 KB |
| opkg 依赖 | ~5 MB |
| hvac_ir (pip) | ~50 KB |
| 运行时数据（config + 日志） | < 1 MB |

## 🧪 验证环境

- OpenWrt 22.03 (Sonnix QSP 1.9 适配)
- Broadlink RM4 Mini (MAC `e870723f41ee`)
- Python 3.11.14
- uhttpd CGI
- 持续运行 1+ 周无异常

## 📝 致谢

- IR 协议基于 [python-broadlink](https://github.com/mjg59/python-broadlink) + [hvac_ir](https://github.com/nicko858/hvac_ir) 二次开发
- 天气数据来自百度地图开放平台 + 和风天气
- 台风数据来自中国气象局 (NMC)
