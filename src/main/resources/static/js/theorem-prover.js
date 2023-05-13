function appendOperation(op) {
    document.getElementById('theorem').value += ' ' + op + ' ';
}

function submitTheorem() {
    var theorem = document.getElementById('theorem').value;
    fetch('/theorem', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: theorem,
    })
        .then(response => response.json())
        .then(data => {
            var theoremTreeDiv = document.getElementById('theorem-tree');
            theoremTreeDiv.innerHTML = '';
            appendTreeNode(theoremTreeDiv, data);
        });
}

function appendTreeNode(parentNode, treeNode) {
    var newNodeDiv = document.createElement('div');
    newNodeDiv.className = 'tree-node';

    var theoremDiv = document.createElement('div');
    theoremDiv.textContent = treeNode.name;
    newNodeDiv.appendChild(theoremDiv);

    if (treeNode.rule) {
        var ruleContainer = document.createElement('div');
        ruleContainer.className = 'rule-container';
        newNodeDiv.appendChild(ruleContainer);

        // Create the rule line
        var ruleLine = document.createElement('div');
        ruleLine.className = 'rule-line';
        ruleContainer.appendChild(ruleLine);

        var ruleDiv = document.createElement('div');
        ruleDiv.className = 'rule';
        ruleDiv.textContent = `(${treeNode.rule})`;
        ruleContainer.appendChild(ruleDiv);

        // Wait for the elements to be rendered to get their widths
        setTimeout(function() {
            // Set the width of the rule line to be the same as the theorem text
            ruleLine.style.width = Math.max(theoremDiv.offsetWidth, newNodeDiv.offsetWidth) + 'px';
        }, 0);
    }

    parentNode.appendChild(newNodeDiv);

    if (treeNode.children && treeNode.children.length > 0) {
        var childrenDiv = document.createElement('div');
        childrenDiv.className = 'children';
        treeNode.children.forEach(child => {
            appendTreeNode(childrenDiv, child);
        });
        newNodeDiv.appendChild(childrenDiv);
    }
}