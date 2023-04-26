function visualizeTree(treeData, container) {
    console.log("FUCK");
    const margin = { top: 20, right: 90, bottom: 30, left: 90 };
    const width = 960 - margin.left - margin.right;
    const height = 500 - margin.top - margin.bottom;

    const svg = d3.select(container)
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    const tree = d3.tree().size([height, width]);

    const root = d3.hierarchy(treeData);
    root.x0 = height / 2;
    root.y0 = 0;

    update(root);

    function update(source) {
        const treeData = tree(root);
        const nodes = treeData.descendants();
        const links = treeData.descendants().slice(1);

        nodes.forEach((d) => d.y = d.depth * 180);

        const node = svg.selectAll("g.node")
            .data(nodes, (d) => d.id || (d.id = ++i));

        const nodeEnter = node.enter().append("g")
            .attr("class", "node")
            .attr("transform", (d) => "translate(" + source.y0 + "," + source.x0 + ")")
            .on("click", (event, d) => {
                d.children = d.children ? null : d._children;
                update(d);
            });

        nodeEnter.append("circle")
            .attr("r", 1e-6)
            .style("fill", (d) => d._children ? "lightsteelblue" : "#fff");

        nodeEnter.append("text")
            .attr("x", (d) => d.children || d._children ? -13 : 13)
            .attr("dy", ".35em")
            .attr("text-anchor", (d) => d.children || d._children ? "end" : "start")
            .text((d) => d.data.value)
            .style("fill-opacity", 1e-6);

        const nodeUpdate = nodeEnter.merge(node);

        nodeUpdate.transition()
            .duration(750)
            .attr("transform", (d) => "translate(" + d.y + "," + d.x + ")");

        nodeUpdate.select("circle")
            .attr("r", 10
            .style("fill", (d) => d._children ? "lightsteelblue" : "#fff");

        nodeUpdate.select("text")
            .style("fill-opacity", 1);

        const nodeExit = node.exit().transition()
            .duration(750)
            .attr("transform", (d) => "translate(" + source.y + "," + source.x + ")")
            .remove();

        nodeExit.select("circle")
            .attr("r", 1e-6);

        nodeExit.select("text")
            .style("fill-opacity", 1e-6);

        const link = svg.selectAll("path.link")
            .data(links, (d) => d.id);

        const linkEnter = link.enter().insert("path", "g")
            .attr("class", "link")
            .attr("d", () => {
                const o = { x: source.x0, y: source.y0 };
                return diagonal(o, o);
            });

        const linkUpdate = linkEnter.merge(link);

        linkUpdate.transition()
            .duration(750)
            .attr("d", (d) => diagonal(d, d.parent));

        link.exit().transition()
            .duration(750)
            .attr("d", () => {
                const o = { x: source.x, y: source.y };
                return diagonal(o, o);
            })
            .remove();

        nodes.forEach((d) => {
            d.x0 = d.x;
            d.y0 = d.y;
        });

        function diagonal(s, d) {
            const path = `M ${s.y} ${s.x}
                C ${(s.y + d.y) / 2} ${s.x},
                  ${(s.y + d.y) / 2} ${d.x},
                  ${d.y} ${d.x}`;
            return path;
        }
    }
}