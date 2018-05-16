import CKEditorRenderer from "../src/CKEditorRenderer";

var CKEDITORS = {};

document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('.wysiwig').forEach(node => {
        ClassicEditor.create(node)
            .then(instance => {
                CKEDITORS[node.id] = instance;
                return instance;
            })
            .then(instance => new CKEditorRenderer().addEventListener(instance, node))
            .catch(error => console.error(error));
    });
});

window.CKEDITORS = CKEDITORS;
