package com.pltl.prolog.controller;

import com.pltl.prolog.model.TreeNode;
import com.pltl.prolog.service.PrologService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/theorem")
public class TheoremController {

    private static final Logger logger = LoggerFactory.getLogger(TheoremController.class);

    @Autowired
    private PrologService prologService;
    @GetMapping(value = "/")
    public String defaultTheorem(Model model) {
        return "index";
    }

    @PostMapping
    public TreeNode validateTheorem(@RequestBody String theorem) {
        long startTime = System.currentTimeMillis();
//        theorem = "[c, g, neg p, a, p, d] => [s]";
//        theorem = "[c and g, neg s, a and b,  p, d] => [b and p and a, b, a]";
//        theorem = "[a, b] => [a and b,c,d,e,r]";
//        theorem = "[a or b] => [a,b,c,d,e,r]";
//        theorem = "[c or (a or b)] => [a,b,c]";
//        theorem = "[(c or b) or (a or b)] => [a,b,c]";
//        theorem = "[((c or a) or (a or b)) or (a or b)] => [a,b,c]";
        TreeNode result = prologService.queryProve(theorem);

        logger.info("QUERY TOOK: {} ms.", System.currentTimeMillis() - startTime);

        return result;
    }
}