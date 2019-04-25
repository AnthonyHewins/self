import CKEditorRenderer from "../src/CKEditorRenderer";
import parseKatex from "../src/KatexParser";

var CKEDITORS = {};

document.addEventListener("DOMContentLoaded", function() {    
    const getRenderTarget = function(node) {
        var renderTarget = document.querySelector(node.dataset.target);

        if (renderTarget == null && isUsingKatex)
            throw new Error("Need data-target to perform rendering");

        return renderTarget;
    }

    // Create a listener that renders HTML as its written in CKEditor
    var renderer = new CKEditorRenderer()
    document.querySelectorAll('.wysiwig').forEach(node => {
        ClassicEditor.create(node)
            .then(instance => {
                CKEDITORS[node.id] = instance;
                return instance;
            })
            .then(instance => renderer.addEventListener(instance, node))
            .catch(error => console.error(error));
    });

    // Create a listener that renders HTML as its written in some regular HTML node
    document.querySelectorAll('.katex-input').forEach(node => {
        if (!node.classList.contains("wysiwig")) {
            const target = getRenderTarget(node);
            node.addEventListener("input", function() {
                target.innerHTML = parseKatex(node.value)
            })
        }
    })
});

window.CKEDITORS = CKEDITORS;
