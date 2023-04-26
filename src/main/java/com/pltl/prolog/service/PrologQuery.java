package com.pltl.prolog.service;

import com.pltl.prolog.model.TreeNode;
import org.jpl7.Atom;
import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;
import org.springframework.stereotype.Service;

import java.util.Map;

import static org.springframework.util.CollectionUtils.isEmpty;

@Service
public class PrologQuery {

    public TreeNode queryProve(String theorem) {
        JPL.init();
        Term consult_arg[] = {
                new Atom("C:/Users/user/Desktop/UNI/8 semestras/Bakalauras/Programa/bakalauras.pl")
        };
        Query consult_query = new Query("consult", consult_arg);
        consult_query.allSolutions();

        Map<String, Term> result = Query.oneSolution(String.format("prove(%s, X)", theorem));

        if (isEmpty(result)) {
            return new TreeNode();
        }

        TreeNode root = new TreeNode();
        root.setValue(theorem);

        return mapToTreeNode(root, result.get("X"));
    }

    private TreeNode mapToTreeNode(TreeNode root, Term x) {
        TreeNode child1 = new TreeNode();
        Term argument1 = x.arg(1);
        root.setRule(argument1.arg(2).toString());
        child1.setValue(argument1.arg(1).toString());

        Term argument2 = x.arg(2).arg(1);
        if (!argument2.isAtom() && !argument2.arg(1).isAtom()) {
            mapToTreeNode(child1, argument2);
        }
        root.addChild(child1);

        try {
            TreeNode child2 = new TreeNode();
            Term argument3 = x.arg(2).arg(2).arg(1);
            root.setRule(argument3.arg(2).toString());
            child2.setValue(argument3.arg(1).toString());

            Term argument4 = x.arg(2).arg(2).arg(2).arg(1);
            if (!argument4.isAtom() && !argument4.arg(1).isAtom()) {
                mapToTreeNode(child2, argument4);
            }
            root.addChild(child2);
        } catch (Exception e) {
        }
        return root;
    }


//    private TreeNode mapToTreeNode(TreeNode root, Term x) {
//        TreeNode child = new TreeNode();
//        for (int i = 1; i <= x.arity(); i++) {
//            Term argument = x.arg(i);
//            if (i % 2 == 1) {
//                child = new TreeNode();
//                root.addChild(child);
//            }
//            if (argument.isAtom() || argument.arg(1).isAtom()) {
//                continue;
//            }
//            else if (!argument.isList()) {
//                root.setRule(argument.arg(2).toString());
//                child.setValue(argument.arg(1).toString());
//            } else if (argument.arg(1).isList()){
//                mapToTreeNode(child, argument.arg(1));
//            } else {
//                mapToTreeNode(child, argument);
//            }
//        }
//
//        return root;
//    }
}
