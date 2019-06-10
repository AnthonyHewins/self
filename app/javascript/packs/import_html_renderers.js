import HtmlRenderer from "../src/HtmlRenderer";

document.addEventListener("DOMContentLoaded", function() {    
    var renderer = new HtmlRenderer()

    document.querySelectorAll('.wysiwig').forEach(node => renderer.ckeditorRenderer(node))
    document.querySelectorAll('.katex-input').forEach(node => renderer.textareaRenderer(node, true))
    document.querySelectorAll('.html-input').forEach(node => renderer.textareaRenderer(node, false))
});
