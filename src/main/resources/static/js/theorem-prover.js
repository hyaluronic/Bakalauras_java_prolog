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
        var ruleDiv = document.createElement('div');
        ruleDiv.className = 'rule';
        ruleDiv.textContent = `(${treeNode.rule})`;
        newNodeDiv.appendChild(ruleDiv);
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