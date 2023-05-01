package com.pltl.prolog.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class TreeNode {
    private String name;
    private String rule;
    private List<TreeNode> children;

    public List<TreeNode> addChild(TreeNode child){
        if (children == null) {
            children = new ArrayList<>();
        }
        children.add(child);
        return children;
    }
}
