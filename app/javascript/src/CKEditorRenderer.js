import parseKatex from './KatexParser';

class CKEditorRenderer {
    addEventListener(ckeditor, node) {
        const isUsingKatex = node.classList.contains("katex-input");

        const renderTarget = this._getRenderTarget(node, isUsingKatex);
        if (renderTarget == null)
            return null;

        const preProcessor = isUsingKatex ? parseKatex : x => x;
        this._addOnDataChangeEvent(ckeditor, renderTarget, preProcessor);
    }

    _getRenderTarget(node, isUsingKatex) {
        var renderTarget = document.querySelector(node.dataset.target);

        if (renderTarget == null && isUsingKatex)
            throw new Error("Need data-target for one of the ClassicEditor instances");

        return renderTarget;
    }

    _addOnDataChangeEvent(ckeditor, renderTarget, preProcessor) {
        ckeditor.model.document.on("change:data", () => {
            renderTarget.innerHTML = preProcessor(ckeditor.getData());
        });
    }
}

export default CKEditorRenderer;
