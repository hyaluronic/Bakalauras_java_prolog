package com.pltl.prolog.service;

import com.pltl.prolog.model.TreeNode;
import org.jpl7.Atom;
import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;
import org.springframework.stereotype.Service;

import java.util.Map;

import static java.util.Map.entry;
import static org.springframework.util.CollectionUtils.isEmpty;

@Service
public class PrologService {

    Map<String, String> rules = Map.ofEntries(
            entry("and_left", "∧=>"),
            entry("and_right", "=>∧"),
            entry("or_left", "∨=>"),
            entry("or_right", "=>∨"),
            entry("neg_left", "¬=>"),
            entry("neg_rigth", "=>¬"),
            entry("impl_left", "⊃=>"),
            entry("impl_right", "=>⊃"),
            entry("always_left", "□=>"),
            entry("always_right", "=>□"),
            entry("next", "◯")
    );

    Map<String, String> operations = Map.ofEntries(
            entry(" and ", " ∧ "),
            entry(" or ", " ∨ "),
            entry(" neg ", " ¬"),
            entry(" impl ", " ⊃ "),
            entry(" always ", " □"),
            entry(" next ", " ◯")
    );

    public TreeNode queryProve(String theorem) {
        JPL.init();
        Term consult_arg[] = {
                new Atom("C:/Users/user/Desktop/UNI/8 semestras/Bakalauras/Programa/bakalauras.pl")
        };
        Query consult_query = new Query("consult", consult_arg);
        consult_query.allSolutions();

        theorem = getParsedTheorem(theorem);

        Map<String, Term> result = Query.oneSolution(String.format("prove(%s, X)", theorem));

        if (isEmpty(result)) {
            throw new IllegalArgumentException("Theorem is not valid");
        }

        TreeNode root = new TreeNode();
        root.setName(parseTheName(theorem.replace("[", "(").replace("]", ")")));

        return mapToTreeNode(root, result.get("X"));
    }

    private String getParsedTheorem(String theorem) {
        for (Map.Entry<String, String> entry : operations.entrySet()) {
            theorem = theorem.replaceAll(entry.getValue(), entry.getKey());
        }
        String[] cendents = theorem.split("=>");
        return parseCendent(cendents[0]) + "=>" + parseCendent(cendents[1]);
    }

    private String parseCendent(String cendent) {
        cendent = cendent.trim();
        if (cendent.startsWith("(")) {
            cendent = cendent.substring(1);
        }
        if (!cendent.startsWith("[")) {
            cendent = "[" + cendent;
        }
        if (cendent.endsWith(")")) {
            cendent = cendent.substring(0, cendent.length() - 1);
        }
        if (!cendent.endsWith("]")) {
            cendent = cendent + "]";
        }
        return cendent;
    }

    private TreeNode mapToTreeNode(TreeNode root, Term x) {
        Term[] terms = x.listToTermArray();

        // If x has two arguments
        if (terms.length == 2) {
            TreeNode child = new TreeNode();
            Term arg1 = terms[0];

            root.setRule(parseTheRule(arg1.arg(2).toString()));
            child.setName(parseTheName(parseTheTerm(arg1.arg(1))));

            // Recursively process the child node if it's not an atom
            Term arg2 = terms[1];
            if (!arg2.isAtom()) {
                mapToTreeNode(child, arg2);
            }

            root.addChild(child);
        }
        // If x has four arguments
        else if (terms.length == 4) {
            TreeNode leftChild = new TreeNode();
            TreeNode rightChild = new TreeNode();

            Term arg1 = terms[0];
            Term arg3 = terms[2];

            root.setRule(parseTheRule(arg1.arg(2).toString()));
            leftChild.setName(parseTheName(parseTheTerm(arg1.arg(1))));
            rightChild.setName(parseTheName(parseTheTerm(arg3.arg(1))));

            // Recursively process the left child node if it's not an atom
            Term arg2 = terms[1];
            if (!arg2.isAtom()) {
                mapToTreeNode(leftChild, arg2);
            }

            // Recursively process the right child node if it's not an atom
            Term arg4 = terms[3];
            if (!arg4.isAtom()) {
                mapToTreeNode(rightChild, arg4);
            }

            root.addChild(leftChild);
            root.addChild(rightChild);
        }
        return root;
    }

    private String parseTheRule(String rule) {
        return rules.get(rule);
    }

    private String parseTheTerm(Term argument) {
        if (argument.arity() == 0) {
            return argument.name();
        }

        StringBuilder leftString = new StringBuilder();
        if (argument.arg(1).isList()) {
            Term[] leftTerms = argument.arg(1).listToTermArray();
            for (Term arg : leftTerms) {
                leftString.append(", ").append(parseTheTerm(arg));
            }
            leftString = leftString.delete(0,2);
        } else if (argument.arg(1).arity() == 2) {
            leftString.append(parseTheTerm(argument.arg(2)));
        }  else {
            leftString.append(argument.arg(1));
        }

        StringBuilder rightString = new StringBuilder();
        if (argument.arity() == 2) {
            if (argument.arg(2).isList()) {
                Term[] rightTerms = argument.arg(2).listToTermArray();
                for (Term arg : rightTerms) {
                    rightString.append(", ").append(parseTheTerm(arg));
                }
                rightString = rightString.delete(0,2);
            } else if (argument.arg(2).arity() == 2) {
                rightString.append(parseTheTerm(argument.arg(2)));
            } else {
                rightString.append(argument.arg(2));
            }
        }

        // Construct the final string
        String finalString;
        if (argument.arity() == 2) {
            if (argument.name().equals("=>")) {
                finalString =  "(" + leftString + ") " + argument.name() + "(" + rightString + ")";
            } else {
                finalString = leftString + " " + argument.name() + " " + rightString;
            }
        } else {
            finalString = argument.name() + " " + leftString;
        }

        // If the argument was a list, wrap it in parentheses
        if (!argument.name().equals("=>")) {
            finalString = "(" + finalString + ")";
        }

        return finalString;
    }

    private String parseTheName(String name) {
        for (Map.Entry<String, String> entry : operations.entrySet()) {
            name = name.replaceAll(entry.getKey(), entry.getValue());
        }
        return name;
    }
}
