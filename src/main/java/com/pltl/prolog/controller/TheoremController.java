package com.pltl.prolog.controller;

import com.pltl.prolog.model.TreeNode;
import com.pltl.prolog.service.PrologQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/theorem")
public class TheoremController {

    @Autowired
    private PrologQuery prologQuery;
    @GetMapping(value = "/")
    public String defaultTheorem(Model model) {
        return "index";
    }
    @PostMapping
    public TreeNode validateTheorem(@RequestBody String theorem) {
        //TODO: parser to acceptable query?
//        theorem = "[c, g, neg p, a, p, d] => [s]";
//        theorem = "[c and g, neg s, a and b,  p, d] => [b and p and a, b, a]";
//        theorem = "[a, b] => [a and b,c,d,e,r]";
//        theorem = "[a or b] => [a,b,c,d,e,r]";
//        theorem = "[c or (a or b)] => [a,b,c]";
//        theorem = "[(c or b) or (a or b)] => [a,b,c]";
        return prologQuery.queryProve(theorem);
    }
}