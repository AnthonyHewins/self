import HtmlRenderer from "../src/HtmlRenderer";
import parseKatex from "../src/KatexParser";

document.addEventListener("DOMContentLoaded", function() {    
    // Create a listener that renders HTML as its written in Html
    var renderer = new HtmlRenderer()
    document.querySelectorAll('.wysiwig').forEach(node => {
        ClassicEditor.create(node)
            .then(instance => {
                instance.model.document.on("change:data", renderer.ckeditorRenderer(node, instance))
            })
            .catch(error => console.error(error));
    });

    // Create a listener that renders HTML as its written in some regular HTML node
    document.querySelectorAll('.katex-input').forEach(node => {
        node.addEventListener("input", renderer.textareaRenderer(node))
    })
});
