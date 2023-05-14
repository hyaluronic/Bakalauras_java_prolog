function appendOperation(op) {
    var theoremInput = document.getElementById('theorem');
    var start = theoremInput.selectionStart;
    var end = theoremInput.selectionEnd;
    var theoremValue = theoremInput.value;

    if (start || start === 0) {
        theoremInput.value = theoremValue.slice(0, start) + ' ' + op + ' ' + theoremValue.slice(end);
        theoremInput.selectionStart = start + op.length + 2; // Add 2 for the added spaces
        theoremInput.selectionEnd = start + op.length + 2;
    } else {
        theoremInput.value += ' ' + op + ' ';
    }
}

var theoremInput = document.getElementById('theorem');
theoremInput.addEventListener('input', function () {
    var value = theoremInput.value;
    var selectionStart = theoremInput.selectionStart;
    var replacedValue = value
        .replace(/ and(?=\s|$)/gi, ' ∧')
        .replace(/ or(?=\s|$)/gi, ' ∨')
        .replace(/neg(?=\s|$)/gi, '¬')
        .replace(/always(?=\s|$)/gi, '□')
        .replace(/next(?=\s|$)/gi, '◯')
        .replace(/impl(?=\s|$)/gi, '⊃')
        .replace(/implication(?=\s|$)/gi, '⊃')
        .replace(/->(?=\s|$)/gi, '⊃')
        .replace(/seq(?=\s|$)/gi, '=>');
    if (replacedValue !== value) {
        theoremInput.value = replacedValue;
        theoremInput.selectionStart = selectionStart - (value.length - replacedValue.length);
        theoremInput.selectionEnd = theoremInput.selectionStart;
    }
});

function handleKeyDown(event) {
    if (event.keyCode === 13 || event.which === 13) {
        event.preventDefault();
        submitTheorem();
    }
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
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            var theoremTreeDiv = document.getElementById('theorem-tree');
            theoremTreeDiv.innerHTML = '';
            appendTreeNode(theoremTreeDiv, data);
        })
        .catch(error => {
            var theoremTreeDiv = document.getElementById('theorem-tree');
            theoremTreeDiv.innerHTML = 'Not valid';
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

        if (treeNode.children && treeNode.children.length > 0) {
            var childrenDiv = document.createElement('div');
            childrenDiv.className = 'children';
            treeNode.children.forEach(child => {
                appendTreeNode(childrenDiv, child);
            });
            newNodeDiv.appendChild(childrenDiv);
        }

        // Wait for the elements to be rendered to get their widths
        setTimeout(function () {
            // Set the width of the rule line to be the same as the theorem text
            var max_width = Math.max(theoremDiv.offsetWidth, newNodeDiv.offsetWidth);
            ruleLine.style.width = max_width + 'px';
            // childrenDiv.style.gap = ruleDiv.offsetWidth + 15 + 'px'
        }, 0);
    }

    parentNode.appendChild(newNodeDiv);
}