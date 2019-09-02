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

function parse(renderTarget, raw) {
    renderTarget.innerHTML = raw;
    renderMathInElement(
        renderTarget, {
            delimiters: [
                {left: "$$$", right: "$$$", display: true},
                {left: "$$", right: "$$", display: false}
            ],
            preprocess: str => str.replace(/(<[\/]{0,1}p>|&nbsp;[ ]{0,1})/g, ''),
            throwOnError: false
        }
    );
}

class HtmlRenderer {
    ckeditorRenderer(node, instance) {
        const renderTarget = this._getRenderTarget(node)

        ClassicEditor.create(node).then(instance => {
            instance.model.document.on(
                "change:data", () => parse(renderTarget, instance.getData())
            )
        }).catch(error => console.error(error));
    }

    textareaRenderer(node) {
        const renderTarget = this._getRenderTarget(node)
        node.addEventListener(
            "input",
            () => parse(renderTarget, node.value.replace(escapeHtmlRegex, s => entityMap[s]))
        )
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
    document.querySelectorAll('.katex-input').forEach(node => renderer.textareaRenderer(node))
});
