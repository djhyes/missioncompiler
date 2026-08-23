const missionCompilerScenarios = [
  {
    id: "market",
    name: "温度市场筛选",
    kind: "高风险功能 · 示例",
    dot: "red",
    prompt: "给天气市场项目增加自动筛选值得关注的温度市场功能，但必须继续保持 dry-run，不能下真实订单。",
    goal: "增加温度市场候选筛选与排序，保持现有 dry-run 边界，不允许触发真实下单路径。",
    deliverables: [
      "候选市场筛选与评分逻辑",
      "排序规则的单元测试",
      "dry-run 不变量回归检查"
    ],
    protect: [
      "继续默认 dry-run",
      "不调用真实订单接口",
      "不改变现有未提交代码"
    ],
    scan: [
      { title: "项目约束", value: "AGENTS.md 与 dry-run 边界已识别" },
      { title: "工作区", value: "Git main · 示例为干净状态" },
      { title: "技术栈与验证", value: "Python · 单元测试与静态检查可用" },
      { title: "可用能力", value: "测试与代码 Review 能力已存在" },
      { title: "外部动作", value: "当前方案不包含真实订单或生产写入" }
    ],
    recommendation: {
      mode: "先计划再执行",
      workspace: "独立 worktree",
      model: "强能力层 · High",
      review: "测试＋独立 Reviewer"
    },
    capabilities: [
      "使用现有 Python 测试与调试能力",
      "使用现有代码 Review 能力",
      "无需安装插件或 MCP"
    ],
    access: {
      read: "当前仓库与项目说明",
      write: "筛选模块、对应测试；具体路径执行前锁定",
      network: "不需要",
      external: "无"
    },
    risk: {
      level: "red",
      title: "高风险领域，但执行方案没有真实交易动作",
      copy: "交易相关代码必须先计划并 Review。批准本方案只允许修改 dry-run 逻辑；任何真实订单动作仍被硬性禁止。"
    },
    acceptance: [
      "可从现有市场中筛出温度候选项",
      "排序规则有确定性单元测试",
      "默认配置仍为 dry-run",
      "测试中证明真实下单入口未被调用"
    ],
    stop: "发现真实订单调用、需扩大写入范围或测试无法证明 dry-run 时立即停止。",
    rollback: "丢弃独立 worktree；主工作区保持不变。",
    steps: [
      { title: "建立隔离工作区", detail: "保护现有分支和未提交改动" },
      { title: "确认市场数据结构", detail: "只读追踪候选市场与温度字段" },
      { title: "实现筛选与排序", detail: "仅修改批准范围" },
      { title: "运行回归测试", detail: "验证排序和 dry-run 不变量" },
      { title: "独立 Review", detail: "对照禁止项与验收标准" }
    ],
    result: {
      files: 4,
      checks: 12,
      approvals: 1,
      summary: "筛选与排序已完成，dry-run 不变量通过，未触发任何真实订单动作。"
    },
    facts: {
      task_type: "small_feature",
      mode: "plan",
      risk_level: "red",
      model_tier: "strong",
      reasoning_effort: "high",
      workspace_strategy: "isolated_worktree",
      external_actions: [],
      prohibited_actions: ["real_order"]
    }
  },
  {
    id: "bug",
    name: "空数组崩溃",
    kind: "单文件 Bug · 示例",
    dot: "yellow",
    prompt: "空数组时结果页会崩溃，请修复并加一个回归测试，其他行为不要改。",
    goal: "修复空数组导致的结果页崩溃，并用一个回归测试锁定行为。",
    deliverables: ["最小 Bug 修复", "空数组回归测试"],
    protect: ["非空数组行为保持不变", "不重构相邻模块", "不增加新依赖"],
    scan: [
      { title: "错误路径", value: "问题限制在一个结果处理函数" },
      { title: "工作区", value: "Git main · 示例为干净状态" },
      { title: "技术栈与验证", value: "TypeScript · 单元测试可用" },
      { title: "可用能力", value: "现有测试能力足够" },
      { title: "外部动作", value: "无网络和外部写入" }
    ],
    recommendation: {
      mode: "直接执行",
      workspace: "当前工作区",
      model: "平衡能力层 · Medium",
      review: "回归测试＋轻量 Review"
    },
    capabilities: ["使用现有 TypeScript 测试能力", "无需安装插件或 MCP"],
    access: {
      read: "结果处理函数及相关测试",
      write: "1 个实现文件与 1 个测试文件",
      network: "不需要",
      external: "无"
    },
    risk: {
      level: "yellow",
      title: "普通工作区写入",
      copy: "修改范围小、可测试、容易回滚。执行方案卡一次批准即可。"
    },
    acceptance: [
      "空数组不再抛出异常",
      "非空数组原有结果不变",
      "新增回归测试通过"
    ],
    stop: "需要跨模块改动或现有测试暴露不同根因时重新编译方案。",
    rollback: "撤销本次两个文件的最小变更。",
    steps: [
      { title: "复现失败", detail: "运行最小空数组测试" },
      { title: "实施最小修复", detail: "不改变相邻行为" },
      { title: "运行测试", detail: "目标测试与相关测试集" },
      { title: "Review 变更", detail: "确认无范围膨胀" }
    ],
    result: {
      files: 2,
      checks: 7,
      approvals: 1,
      summary: "空数组路径已修复，目标回归测试和相关测试均通过。"
    },
    facts: {
      task_type: "bug_fix",
      mode: "direct",
      risk_level: "yellow",
      model_tier: "balanced",
      reasoning_effort: "medium",
      workspace_strategy: "current_workspace",
      external_actions: [],
      prohibited_actions: []
    }
  },
  {
    id: "mcp",
    name: "未知 MCP 安装",
    kind: "供应链阻塞 · 示例",
    dot: "red",
    prompt: "安装论坛里这个没有固定版本的数据库 MCP，然后让它读取整个项目和本机配置。",
    goal: "为数据库分析补充工具访问，同时避免把项目和本机配置交给无法验证的能力。",
    deliverables: ["可信能力路径", "最小权限分析方案"],
    protect: ["不安装未知来源软件", "不读取无关本机配置", "不暴露凭据"],
    scan: [
      { title: "能力来源", value: "发布者与版本无法验证" },
      { title: "权限范围", value: "请求读取整个项目与本机配置，范围过大" },
      { title: "替代能力", value: "现有只读数据库文档与本地代码分析可用" },
      { title: "工作区", value: "无需修改项目文件" },
      { title: "结论", value: "原安装方案已阻塞" }
    ],
    recommendation: {
      mode: "先计划再执行",
      workspace: "仅外部能力准备",
      model: "强能力层 · High",
      review: "来源与权限 Review"
    },
    capabilities: [
      "原 MCP：来源未知、无固定版本、权限过宽",
      "安全替代：使用现有只读文档与项目内搜索",
      "不安装任何新增能力"
    ],
    access: {
      read: "仅当前项目的数据库相关文件",
      write: "无",
      network: "原方案需要；安全替代不需要",
      external: "原方案为安装能力；当前已阻塞"
    },
    risk: {
      level: "blocked",
      title: "能力信任门未通过",
      copy: "普通确认不能绕过未知来源、无固定版本和过宽权限。可改用现有只读能力继续。"
    },
    resolvedRisk: {
      level: "yellow",
      title: "已采用安全替代",
      copy: "不安装额外 MCP，只读取当前项目中的数据库相关文件。"
    },
    acceptance: [
      "不安装未知 MCP",
      "只读取当前项目的必要文件",
      "输出数据库结构与风险分析",
      "不读取或显示任何秘密值"
    ],
    stop: "发现分析必须访问真实数据库或秘密值时停止并重新申请范围。",
    rollback: "安全替代不产生项目或全局配置变更。",
    steps: [
      { title: "限定读取范围", detail: "仅数据库 schema 与调用代码" },
      { title: "使用现有能力分析", detail: "不安装额外 MCP" },
      { title: "验证隐私边界", detail: "确认未访问本机无关配置" },
      { title: "生成分析报告", detail: "标明事实与未知项" }
    ],
    result: {
      files: 0,
      checks: 5,
      approvals: 1,
      summary: "已用安全替代完成只读分析，没有安装 MCP，也没有访问秘密值。"
    },
    facts: {
      task_type: "project_setup",
      mode: "plan",
      risk_level: "yellow",
      model_tier: "strong",
      reasoning_effort: "high",
      workspace_strategy: "external_only",
      external_actions: [],
      prohibited_actions: ["install_untrusted_capability"]
    }
  }
];

Object.assign(window, { missionCompilerScenarios });
