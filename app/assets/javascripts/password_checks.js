document.addEventListener("DOMContentLoaded", function() {
    const confirm_pw = document.getElementById('confirm')
    const new_pw = document.getElementById('new')
    
    const div_confirm_pw = document.getElementById('confirm-field')
    const div_new_pw = document.getElementById('new-field')

    const form = document.getElementById('pw-change')
    const submit = document.getElementById('submit')

    const pw_validations = function() {
        if (new_pw.value != confirm_pw.value) {
            form.classList.add("error")
            div_confirm_pw.classList.add("error")
            div_new_pw.classList.add("error")
            submit.disabled = true
        } else {
            form.classList.remove("error")
            div_confirm_pw.classList.remove("error")
            div_new_pw.classList.remove("error")
            submit.disabled = false
        }
    }
 
    new_pw.addEventListener("input", pw_validations)
    confirm_pw.addEventListener("input", pw_validations)
})
