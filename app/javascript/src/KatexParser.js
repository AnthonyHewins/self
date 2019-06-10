const entityMap = {
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#39;',
  '/': '&#x2F;',
  '`': '&#x60;',
  '=': '&#x3D;'
};

const escapeHtmlRegex = new RegExp(`[${Object.keys(entityMap).join('')}]`, "g")

function parseKatex(html, katexOnly=true) {
    var tokens = html.split("$$")
    katexOnly ? parseKatexOnly(tokens) : parseKatexAndHtml(tokens)
    return tokens.join('')
}

function parseKatexOnly(tokens) {
    for (var i = 0; i < tokens.length; i++) {
        if (i % 2 == 0)
            tokens[i] = tokens[i].replace(escapeHtmlRegex, s => entityMap[s])
        else
            tokens[i] = render(tokens[i]);
    }
}

function parseKatexAndHtml(tokens) {
    for (var i = 1; i < tokens.length; i += 2)
        tokens[i] = render(tokens[i]);
}

function render(string) {
    return katex.renderToString(
        // CKEditor adds extra <[/]p>, &nbsp;, &nbsp;[ ], </p><p> to certain things.
        // Replace all these with empty string, since LaTeX doesn't use any of it.
        string.replace(/(<[\/]{0,1}p>|&nbsp;[ ]{0,1})/g, ''),
        {throwOnError: false}
    );
}

export default parseKatex;
