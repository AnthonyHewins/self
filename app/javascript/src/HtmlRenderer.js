import parseKatex from './KatexParser';

class HtmlRenderer {
    ckeditorRenderer(node, instance) {
        const renderTarget = this._getRenderTarget(node)
        return () => {renderTarget.innerHTML = parseKatex(instance.getData(), false)}
    }

    textareaRenderer(node) {
        const renderTarget = this._getRenderTarget(node);
        return () => {renderTarget.innerHTML = parseKatex(node.value)}
    }

    _getRenderTarget(node) {
        var renderTarget = document.querySelector(node.dataset.target);

        if (renderTarget == null)
            throw new Error("Need data-target to render HTML");

        return renderTarget;
    }
}

export default HtmlRenderer;
