export function escapeHtml(value) {
  return String(value ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

export function html(strings, ...values) {
  return strings.reduce((output, chunk, index) => {
    const value = values[index];
    if (value === undefined || value === null) {
      return output + chunk;
    }
    return output + chunk + (Array.isArray(value) ? value.join("") : String(value));
  }, "");
}

export function text(value) {
  return escapeHtml(value);
}
