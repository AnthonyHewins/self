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

class HtmlRenderer {
    ckeditorRenderer(node, instance) {
        const renderTarget = this._getRenderTarget(node)

        ClassicEditor.create(node).then(instance => {
            instance.model.document.on(
                "change:data",
                () => {renderTarget.innerHTML = parseKatex(instance.getData(), false)}
            )
        })
        .catch(error => console.error(error));
    }

    textareaRenderer(node, katexNode) {
        const renderTarget = this._getRenderTarget(node)

        var lambda
        if (katexNode)
            lambda = () => {renderTarget.innerHTML = parseKatex(node.value)}
        else
            lambda = () => {renderTarget.innerHTML = node.value}
                
        node.addEventListener("input", lambda)
    }

    _getRenderTarget(node) {
        var renderTarget = document.querySelector(node.dataset.target);

        if (renderTarget == null)
            throw new Error("Need data-target to render HTML");

        return renderTarget;
    }
}

document.addEventListener("DOMContentLoaded", function() {    
    var renderer = new HtmlRenderer()

    document.querySelectorAll('.wysiwig').forEach(node => renderer.ckeditorRenderer(node))
    document.querySelectorAll('.katex-input').forEach(node => renderer.textareaRenderer(node, true))
    document.querySelectorAll('.html-input').forEach(node => renderer.textareaRenderer(node, false))
});
