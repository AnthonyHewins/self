function parseKatex(html) {
    const tokens = html.split("$$");
    if (tokens.length < 3)
        return html;

    for (var i = 1; i < tokens.length; i += 2) {
        tokens[i] = render(tokens[i]);
    }

    return tokens.join("");
}

function render(string, displayMode) {
    return katex.renderToString(
        //Replace <[/]p>, &nbsp;, &nbsp;[ ], </p><p> with empty string.
        string.replace(/(<[\/]{0,1}p>|&nbsp;[ ]{0,1})/g, ''),
        {throwOnError: false, displayMode: displayMode}
    );
}

export default parseKatex;
