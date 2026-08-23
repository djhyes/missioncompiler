const { useEffect, useMemo, useState } = React;

function TrafficLights() {
  return (
    <div className="traffic-lights" aria-hidden="true">
      <span className="traffic-light red"></span>
      <span className="traffic-light yellow"></span>
      <span className="traffic-light green"></span>
    </div>
  );
}

function Sidebar({ scenarios, activeId, onSelect, screen }) {
  return (
    <aside className="sidebar" aria-label="示例任务">
      <div className="brand">
        <div className="brand-mark">MC</div>
        <div className="brand-copy">
          <span className="brand-name">MissionCompiler</span>
          <span className="brand-subtitle">AI 任务编译器</span>
        </div>
      </div>

      <div className="sidebar-label">风险场景</div>
      <div className="scenario-list">
        {scenarios.map((scenario) => (
          <button
            className={`scenario-item ${scenario.id === activeId ? "active" : ""}`}
            key={scenario.id}
            type="button"
            onClick={() => onSelect(scenario.id)}
          >
            <span className={`scenario-dot ${scenario.dot}`}></span>
            <span>
              <span className="scenario-name">{scenario.name}</span>
              <span className="scenario-kind">{scenario.kind}</span>
            </span>
          </button>
        ))}
      </div>

      <div className="sidebar-footer">
        <div className="local-status">本地演示环境</div>
        <div>当前只展示产品流程，不会调用 Agent、安装能力或修改配置。</div>
        <div style={{ marginTop: 8 }}>状态：{screen === "complete" ? "演示已完成" : "无真实执行"}</div>
      </div>
    </aside>
  );
}

function ComposeScreen({ scenario, prompt, onPromptChange, onAnalyze }) {
  return (
    <div className="main-inner" data-screen-label="01 原始需求">
      <div className="eyebrow">从目标开始</div>
      <h1>你只需要说，想完成什么。</h1>
      <p className="lead">
        MissionCompiler 会先只读检查项目，整理目标、权限、能力与验收条件；你确认方案以后，它才会开始修改。
      </p>

      <div className="composer">
        <textarea
          aria-label="原始任务"
          value={prompt}
          onChange={(event) => onPromptChange(event.target.value)}
        ></textarea>
        <div className="composer-footer">
          <span className="composer-note">示例：{scenario.kind}</span>
          <button className="button primary" type="button" onClick={onAnalyze} disabled={!prompt.trim()}>
            只读分析任务
          </button>
        </div>
      </div>

      <div className="feature-strip" aria-label="产品承诺">
        <div className="feature">
          <div className="feature-title">先保护现有工作</div>
          <div className="feature-copy">检查 Git、目录和未提交改动</div>
        </div>
        <div className="feature">
          <div className="feature-title">先解释再执行</div>
          <div className="feature-copy">目标、影响、风险与回滚一次看懂</div>
        </div>
        <div className="feature">
          <div className="feature-title">完成必须有证据</div>
          <div className="feature-copy">测试、检查和 Review 对照验收</div>
        </div>
      </div>
    </div>
  );
}

function ScanningScreen({ scenario, scanIndex }) {
  const progress = Math.min(100, Math.round((scanIndex / scenario.scan.length) * 100));
  return (
    <div className="main-inner" data-screen-label="02 只读扫描">
      <div className="screen-header">
        <div className="screen-header-copy">
          <div className="eyebrow">只读预检查</div>
          <h2>正在理解任务和真实环境</h2>
          <p className="muted">不会修改文件，也不会安装任何新能力。</p>
        </div>
        <span className="status-badge blue">扫描中</span>
      </div>

      <div className="progress-track" aria-label={`扫描进度 ${progress}%`}>
        <div className="progress-bar" style={{ width: `${progress}%` }}></div>
      </div>

      <div className="scan-panel">
        {scenario.scan.map((item, index) => {
          const state = index < scanIndex ? "done" : index === scanIndex ? "active" : "";
          return (
            <div className={`scan-item ${state}`} key={item.title}>
              <span className="scan-marker">✓</span>
              <div>
                <div className="scan-title">{item.title}</div>
                <div className="scan-value">{item.value}</div>
              </div>
              <span className="scan-value">{state === "done" ? "已确认" : state === "active" ? "检查中" : "等待"}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function RiskBanner({ risk }) {
  const isRed = risk.level === "red" || risk.level === "blocked";
  return (
    <div className={`risk-banner ${isRed ? "red" : ""}`}>
      <div className="risk-accent"></div>
      <div className="risk-content">
        <div className="risk-title">{risk.title}</div>
        <p className="risk-copy">{risk.copy}</p>
      </div>
    </div>
  );
}

function ProposalItem({ id, title, summary, openId, onToggle, children }) {
  const open = openId === id;
  return (
    <div className={`proposal-item ${open ? "open" : ""}`}>
      <button className="proposal-item-trigger" type="button" onClick={() => onToggle(open ? null : id)} aria-expanded={open}>
        <span className="proposal-item-chevron" aria-hidden="true">›</span>
        <span className="proposal-item-title">{title}</span>
        <span className="proposal-item-summary">{summary}</span>
      </button>
      {open && <div className="proposal-item-content">{children}</div>}
    </div>
  );
}

function ProposalScreen({ scenario, resolved, onResolve, onApprove, onEdit, onCancel }) {
  const [openId, setOpenId] = useState(null);
  const blocked = scenario.risk.level === "blocked" && !resolved;
  const shownRisk = resolved && scenario.resolvedRisk ? scenario.resolvedRisk : scenario.risk;
  return (
    <div className="main-inner" data-screen-label="03 执行方案">
      <div className="screen-header">
        <div className="screen-header-copy">
          <div className="eyebrow">MissionCompiler 执行方案</div>
          <h2>{blocked ? "方案已阻塞，需要换一条安全路径" : "方案已准备好，等待你的确认"}</h2>
        </div>
        <span className={`status-badge ${blocked ? "red" : "blue"}`}>{blocked ? "已阻塞" : "待批准"}</span>
      </div>

      <div className="proposal-quickline">
        <span>{scenario.recommendation.mode}</span>
        <span>·</span>
        <span>{blocked ? "已阻塞" : shownRisk.level === "red" ? "逐次批准" : "需要批准"}</span>
        <span>·</span>
        <span>{scenario.recommendation.workspace}</span>
      </div>

      <div className="proposal-list">
        <ProposalItem id="goal" title="目标" summary="原始需求" openId={openId} onToggle={setOpenId}>
          <p>{scenario.goal}</p>
        </ProposalItem>

        <ProposalItem id="route" title="推荐执行方式" summary="Plan、模型与工作区" openId={openId} onToggle={setOpenId}>
          <div className="recommendation-grid">
            <div><div className="detail-key">方式</div><div className="detail-value">{scenario.recommendation.mode}</div></div>
            <div><div className="detail-key">工作区</div><div className="detail-value">{scenario.recommendation.workspace}</div></div>
            <div><div className="detail-key">模型层级</div><div className="detail-value">{scenario.recommendation.model}</div></div>
            <div><div className="detail-key">完成检查</div><div className="detail-value">{scenario.recommendation.review}</div></div>
          </div>
        </ProposalItem>

        <ProposalItem id="deliverables" title="交付物" summary={`${scenario.deliverables.length} 项`} openId={openId} onToggle={setOpenId}>
          <ul className="plain-list">
            {scenario.deliverables.map((item) => <li key={item}>{item}</li>)}
          </ul>
        </ProposalItem>

        <ProposalItem id="protect" title="保护项" summary={`${scenario.protect.length} 项`} openId={openId} onToggle={setOpenId}>
          <ul className="plain-list">
            {scenario.protect.map((item) => <li key={item}>{item}</li>)}
          </ul>
        </ProposalItem>

        <ProposalItem id="capabilities" title="能力与权限" summary="按需加载" openId={openId} onToggle={setOpenId}>
          <ul className="plain-list">
            {scenario.capabilities.map((item) => <li key={item}>{item}</li>)}
          </ul>
        </ProposalItem>

        <ProposalItem id="risk" title="风险与审批" summary={blocked ? "已阻塞" : shownRisk.level === "red" ? "逐次批准" : "需要批准"} openId={openId} onToggle={setOpenId}>
          <RiskBanner risk={shownRisk} />
        </ProposalItem>

        <ProposalItem id="acceptance" title="验收条件" summary={`${scenario.acceptance.length} 项`} openId={openId} onToggle={setOpenId}>
          <ol className="criteria-list">
            {scenario.acceptance.map((item) => <li key={item}>{item}</li>)}
          </ol>
        </ProposalItem>

        <ProposalItem id="rollback" title="停止与回滚" summary="执行保护" openId={openId} onToggle={setOpenId}>
          <div>
            <p><strong>停止：</strong>{scenario.stop}</p>
            <p style={{ marginBottom: 0 }}><strong>回滚：</strong>{scenario.rollback}</p>
          </div>
        </ProposalItem>
      </div>

      <div className="proposal-actions">
        <button className="button ghost" type="button" onClick={onCancel}>取消</button>
        <button className="button secondary" type="button" onClick={onEdit}>修改方案</button>
        {blocked ? (
          <button className="button primary" type="button" onClick={onResolve}>采用安全替代方案</button>
        ) : (
          <button className="button primary" type="button" onClick={onApprove}>按推荐方案执行</button>
        )}
      </div>
    </div>
  );
}

function RunningScreen({ scenario, runIndex }) {
  const progress = Math.min(100, Math.round((runIndex / scenario.steps.length) * 100));
  return (
    <div className="main-inner" data-screen-label="04 模拟执行">
      <div className="screen-header">
        <div className="screen-header-copy">
          <div className="eyebrow">受约束执行</div>
          <h2>正在按已批准范围工作</h2>
          <p className="muted">这是交互演示，不会真的修改项目或连接外部服务。</p>
        </div>
        <span className="status-badge blue">执行中</span>
      </div>

      <div className="progress-track" aria-label={`执行进度 ${progress}%`}>
        <div className="progress-bar" style={{ width: `${progress}%` }}></div>
      </div>

      <ol className="step-list" style={{ marginTop: 22 }}>
        {scenario.steps.map((step, index) => {
          const state = index < runIndex ? "done" : index === runIndex ? "active" : "";
          return (
            <li className={`run-step ${state}`} key={step.title}>
              <span className="run-step-marker">{state === "done" ? "✓" : index + 1}</span>
              <div>
                <div className="run-step-title">{step.title}</div>
                <div className="run-step-detail">{step.detail}</div>
              </div>
              <span className="run-step-status">{state === "done" ? "通过" : state === "active" ? "进行中" : "等待"}</span>
            </li>
          );
        })}
      </ol>
    </div>
  );
}

function CompleteScreen({ scenario, onRestart }) {
  return (
    <div className="main-inner" data-screen-label="05 验收报告">
      <div className="eyebrow">验收报告</div>
      <h2>任务达到完成条件</h2>

      <div className="complete-banner">
        <div className="complete-mark">✓</div>
        <div>
          <h3 style={{ marginBottom: 2 }}>所有 required 检查已通过</h3>
          <p className="muted" style={{ marginBottom: 0 }}>{scenario.result.summary}</p>
        </div>
      </div>

      <div className="result-grid">
        <div className="result-stat">
          <div className="result-number">{scenario.result.files}</div>
          <div className="result-label">修改文件</div>
        </div>
        <div className="result-stat">
          <div className="result-number">{scenario.result.checks}</div>
          <div className="result-label">验证检查</div>
        </div>
        <div className="result-stat">
          <div className="result-number">{scenario.result.approvals}</div>
          <div className="result-label">用户批准</div>
        </div>
      </div>

      <section className="section" style={{ marginTop: 18 }}>
        <div className="section-grid">
          <div className="section-label">验收结果</div>
          <ol className="criteria-list">
            {scenario.acceptance.map((item) => <li key={item}>{item} · 已通过</li>)}
          </ol>
        </div>
      </section>

      <section className="section">
        <div className="section-grid">
          <div className="section-label">回滚</div>
          <p style={{ marginBottom: 0 }}>{scenario.rollback}</p>
        </div>
      </section>

      <div className="button-row" style={{ justifyContent: "flex-end", marginTop: 24 }}>
        <button className="button secondary" type="button" onClick={onRestart}>开始另一个任务</button>
      </div>
    </div>
  );
}

function Inspector({ scenario, screen, resolved, technicalOpen, onToggleTechnical }) {
  const blocked = scenario.risk.level === "blocked" && !resolved;
  const riskLabel = blocked ? "Blocked" : scenario.facts.risk_level === "red" ? "Red" : "Yellow";
  const permissionRows = [
    ["读取项目", true],
    ["修改 workspace", scenario.access.write !== "无"],
    ["网络访问", scenario.access.network !== "不需要" && !(scenario.id === "mcp" && resolved)],
    ["安装能力", false],
    ["真实外部动作", false]
  ];

  return (
    <aside className="inspector" aria-label="方案技术细节">
      <div className="inspector-title">方案详情</div>

      <div className="inspector-section">
        <dl style={{ margin: 0 }}>
          <div className="inspector-kv"><dt>阶段</dt><dd>{screen === "compose" ? "等待原始需求" : screen === "scanning" ? "只读扫描" : screen === "proposal" ? "等待批准" : screen === "running" ? "受约束执行" : "验收完成"}</dd></div>
          <div className="inspector-kv"><dt>风险</dt><dd>{riskLabel}</dd></div>
          <div className="inspector-kv"><dt>方式</dt><dd>{scenario.facts.mode === "plan" ? "Plan" : "Direct"}</dd></div>
          <div className="inspector-kv"><dt>工作区</dt><dd>{scenario.facts.workspace_strategy}</dd></div>
        </dl>
      </div>

      <div className="inspector-section">
        <h3>权限边界</h3>
        <div className="permission-list">
          {permissionRows.map(([label, enabled]) => (
            <div className="permission" key={label}>
              <span className={`permission-mark ${enabled ? "" : "off"}`}>{enabled ? "✓" : "–"}</span>
              <span>{label}</span>
            </div>
          ))}
        </div>
      </div>

      <div className="inspector-section">
        <h3>预计访问范围</h3>
        <dl style={{ margin: 0 }}>
          <div className="inspector-kv"><dt>读取</dt><dd>{scenario.access.read}</dd></div>
          <div className="inspector-kv"><dt>写入</dt><dd>{scenario.access.write}</dd></div>
          <div className="inspector-kv"><dt>网络</dt><dd>{scenario.id === "mcp" && resolved ? "不需要" : scenario.access.network}</dd></div>
          <div className="inspector-kv"><dt>外部动作</dt><dd>{scenario.id === "mcp" && resolved ? "无" : scenario.access.external}</dd></div>
        </dl>
      </div>

      <button className="technical-toggle" type="button" onClick={onToggleTechnical}>
        <span>TaskSpec 技术细节</span>
        <span aria-hidden="true">{technicalOpen ? "收起" : "展开"}</span>
      </button>
      {technicalOpen && <pre className="technical-code">{JSON.stringify(scenario.facts, null, 2)}</pre>}
    </aside>
  );
}

function MissionCompilerApp() {
  const scenarios = window.missionCompilerScenarios;
  const [scenarioId, setScenarioId] = useState("market");
  const scenario = useMemo(
    () => scenarios.find((item) => item.id === scenarioId) || scenarios[0],
    [scenarioId, scenarios]
  );
  const [prompt, setPrompt] = useState(scenario.prompt);
  const [screen, setScreen] = useState("compose");
  const [scanIndex, setScanIndex] = useState(0);
  const [runIndex, setRunIndex] = useState(0);
  const [technicalOpen, setTechnicalOpen] = useState(false);
  const [inspectorOpen, setInspectorOpen] = useState(false);
  const [resolved, setResolved] = useState(false);

  useEffect(() => {
    if (screen !== "scanning") return undefined;
    let current = 0;
    let finishTimer;
    setScanIndex(0);
    const timer = window.setInterval(() => {
      current += 1;
      setScanIndex(current);
      if (current >= scenario.scan.length) {
        window.clearInterval(timer);
        finishTimer = window.setTimeout(() => setScreen("proposal"), 360);
      }
    }, 360);
    return () => {
      window.clearInterval(timer);
      window.clearTimeout(finishTimer);
    };
  }, [screen, scenario]);

  useEffect(() => {
    if (screen !== "running") return undefined;
    let current = 0;
    let finishTimer;
    setRunIndex(0);
    const timer = window.setInterval(() => {
      current += 1;
      setRunIndex(current);
      if (current >= scenario.steps.length) {
        window.clearInterval(timer);
        finishTimer = window.setTimeout(() => setScreen("complete"), 420);
      }
    }, 520);
    return () => {
      window.clearInterval(timer);
      window.clearTimeout(finishTimer);
    };
  }, [screen, scenario]);

  useEffect(() => {
    const main = document.querySelector(".main");
    if (main) main.scrollTop = 0;
  }, [screen, scenarioId]);

  function selectScenario(id) {
    const next = scenarios.find((item) => item.id === id);
    setScenarioId(id);
    setPrompt(next.prompt);
    setScreen("compose");
    setScanIndex(0);
    setRunIndex(0);
    setResolved(false);
    setTechnicalOpen(false);
    setInspectorOpen(false);
  }

  function startAnalysis() {
    setResolved(false);
    setScreen("scanning");
  }

  function restart() {
    setPrompt(scenario.prompt);
    setScreen("compose");
    setResolved(false);
    setTechnicalOpen(false);
    setInspectorOpen(false);
  }

  let content;
  if (screen === "compose") {
    content = <ComposeScreen scenario={scenario} prompt={prompt} onPromptChange={setPrompt} onAnalyze={startAnalysis} />;
  } else if (screen === "scanning") {
    content = <ScanningScreen scenario={scenario} scanIndex={scanIndex} />;
  } else if (screen === "proposal") {
    content = (
      <ProposalScreen
        scenario={scenario}
        resolved={resolved}
        onResolve={() => setResolved(true)}
        onApprove={() => setScreen("running")}
        onEdit={() => setScreen("compose")}
        onCancel={restart}
      />
    );
  } else if (screen === "running") {
    content = <RunningScreen scenario={scenario} runIndex={runIndex} />;
  } else {
    content = <CompleteScreen scenario={scenario} onRestart={restart} />;
  }

  return (
    <div className="stage">
      <div className="window">
        <header className="titlebar">
          <TrafficLights />
          <div className="window-title">MissionCompiler</div>
          <div className="prototype-actions">
            <span>交互样机 · 无真实执行</span>
            <button className={`inspector-button ${inspectorOpen ? "active" : ""}`} type="button" onClick={() => setInspectorOpen((value) => !value)}>
              技术详情
            </button>
          </div>
        </header>
        <div className={`workspace ${inspectorOpen ? "with-inspector" : ""}`}>
          <Sidebar scenarios={scenarios} activeId={scenarioId} onSelect={selectScenario} screen={screen} />
          <main className="main">{content}</main>
          {inspectorOpen && (
            <Inspector
              scenario={scenario}
              screen={screen}
              resolved={resolved}
              technicalOpen={technicalOpen}
              onToggleTechnical={() => setTechnicalOpen((value) => !value)}
            />
          )}
        </div>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<MissionCompilerApp />);
