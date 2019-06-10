import parseKatex from './katex_parser';

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

export default HtmlRenderer;
