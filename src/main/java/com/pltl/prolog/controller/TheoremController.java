package com.pltl.prolog.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pltl.prolog.model.TreeNode;
import com.pltl.prolog.service.PrologQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;

@RestController
public class TheoremController {

    @Autowired
    private PrologQuery prologQuery;

//    @RequestMapping(value = "/")
//    public String defaultTheorem(Model model) {
//        String theorem = "[c, g, neg p, a, p, d] => [s]";
//        Map<String, Term> result = prologQuery.queryProve(theorem);
//        model.addAttribute("theorem", new Theorem());
//        model.addAttribute("result", result);
//        return "test"; // view resolver
//    }
//
//    @PostMapping(value = "/")
//    public String proveTheorem(@ModelAttribute Theorem theorem, Model model) {
//        Map<String, Term> result = prologQuery.queryProve(theorem.getValue());
//        model.addAttribute("result", result);
//        return "test";
//    }

    @GetMapping(value = "/theorem")
    public ResponseEntity<String> getSequentCalculusAnswer() throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();

//        String theorem = "[c, g, neg p, a, p, d] => [s]";
//        String theorem = "[c and g, neg s, a and b,  p, d] => [b and p and a, b, a]";
        String theorem = "[a, b] => [a and b,c,d,e,r]";
        TreeNode result = prologQuery.queryProve(theorem);

        TreeNode treeNode1 = new TreeNode();
        treeNode1.setValue("first");

        TreeNode treeNode2 = new TreeNode();
        treeNode2.setValue("second left");

        TreeNode treeNode3 = new TreeNode();
        treeNode3.setValue("second right");

        TreeNode treeNode4 = new TreeNode();
        treeNode4.setValue("third right center");

        ArrayList<TreeNode> a = new ArrayList<>();
        a.add(treeNode2);
        a.add(treeNode3);
        treeNode1.setChildren(a);

        ArrayList<TreeNode>  b = new ArrayList<>();
        b.add(treeNode4);
        treeNode3.setChildren(b);

        String jsonAnswer = objectMapper.writeValueAsString(treeNode1);
        return ResponseEntity.ok(jsonAnswer);
    }
}
