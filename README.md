# DDS49957

面向 DDS/PLL 实验控制的 FPGA 工程快照，包含 VHDL、Verilog、Vivado Block Design、IP 配置和板卡约束。项目名保留原仓库拼写；资料涉及 AD9910、AD9957。

[在线文档](https://xiaoshecode.github.io/xiaoshecode/repos/DDS49957/) · [结构与检查记录](docs/maintenance.md)

## 工程结构

| 路径 | 内容 |
| --- | --- |
| `sources_1/code_save/` | 手写 UART、SPI、并行接口、衰减器、profile 同步、PLL 配置逻辑 |
| `sources_1/bd/` | `DDS49957`、`design_1` Block Design 和生成包装层 |
| `sources_1/ip_save/` | 时钟、FIFO、ILA、VIO 等 Xilinx IP 配置 |
| `constrs_1/` | AD9910/AD9957 两套参考约束，按实际板卡选择 |
| 根目录硬件资料 | 供核对原理图、接口和引脚；不能代替时序约束检查 |

保留这些路径以维持 Vivado 引用；不要把生成的 BD/IP 输出与手写模块混合重命名。

## 环境与恢复工程

`DDS49957.bd` 中记录 Vivado **2018.1** 和器件 **xc7k70tfbv676-1**。仓库没有完整 `.xpr` 或可一键重建工程的 Tcl，因此尚不能承诺全新检出即可构建。

1. 在与硬件匹配的 Vivado 环境中建立工程，先核对器件和 IP 版本。
2. 按设计依赖导入手写 HDL、所需 `.xci` 和一个选定的 Block Design；不同设计变体不要全部混用。
3. 重新生成 IP/BD 输出，检查 module reference；仓库中引用的 `uart`、`SPI_Master` 并不等同于所有已保存的 VHDL entity 名称。
4. 按所用板卡选择约束，核对时钟、复位、I/O 电平和引脚，再执行综合、实现、时序检查。

## 检查状态（2026-10-30）

已对 3 个手写 Verilog 文件做 pyslang 语法/展开检查，并修正 `profile_sync` 的 4 位寄存器与 3 位接口不一致问题。VHDL、厂商 IP、混合语言集成、时序和上板功能尚未验证。

已知待完成：`pll_config_mcu.v` 的 `spi_tx_data` 仅在复位时赋值，缺少 PLL 寄存器表；`profile_sync.v` 的 `profile_switch` 和内部 profile 输入当前未使用。实现这些功能需要确认硬件协议，不能将当前快照视为完整可用固件。

## 维护规范

按 `.editorconfig` 编辑新增文本；新增模块要说明时钟域、复位极性、参数单位并提供自检 testbench。保留生成文件来源，提交前检查 `git diff --check`。仓库未提供统一开源许可证，复用前请向作者确认授权范围。
