import { html, text } from "../lib/dom.js";

function paintRpgle(line) {
  const escaped = text(line);
  if (/^\s{5}\*/.test(line) || /^\s*\*/.test(line.trim())) {
    return `<span class="tok-comment">${escaped}</span>`;
  }
  return escaped
    .replace(/\b(MDISPATCH|MNEW|MVALID|MQUOTE|MPLAN|MINIT|EXSR|SELECT|WHEN|IF|ENDIF|LEAVESR|BEGSR|EVAL|CLEAR|RETURN|MONITOR|ON-ERROR|ENDMON)\b/g, '<span class="tok-kw">$1</span>')
    .replace(/'([^']+)'/g, '<span class="tok-str">\'$1\'</span>')
    .replace(/\b(CTXDS|RESDS|RSRC|CXEVENT|RCREJECT)\b/g, '<span class="tok-id">$1</span>');
}

export function renderCodePanel(code, fragmentOffset = 0) {
  const lines = String(code.source ?? "").split("\n");
  const marks = new Map();
  (code.highlights ?? []).forEach((block, index) => {
    (block.lines ?? []).forEach((lineNo) => {
      marks.set(lineNo, { index, label: block.label });
    });
  });

  const rows = lines
    .map((line, offset) => {
      const lineNo = offset + 1;
      const mark = marks.get(lineNo);
      const fragmentClass = mark ? ` fragment custom highlight-line` : "";
      const fragmentIndex = mark ? ` data-fragment-index="${mark.index + fragmentOffset}"` : "";
      const displayNo = (code.startLine ?? 1) + offset;
      return html`
        <div class="code-line${fragmentClass}"${fragmentIndex} data-label="${text(mark?.label ?? "")}">
          <span class="code-no">${displayNo}</span>
          <code>${paintRpgle(line)}</code>
        </div>`;
    })
    .join("");

  return html`
    <aside class="code-panel" data-component="code">
      <div class="code-head">
        <span>${text(code.caption ?? "Code")}</span>
        <span>${text(code.file ?? "")}</span>
      </div>
      <pre class="code-body language-${text(code.language ?? "plaintext")}">${rows}</pre>
    </aside>`;
}

export function renderCode(slide) {
  return html`
    <div class="slide-frame">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      ${renderCodePanel(slide.data ?? {})}
    </div>`;
}
