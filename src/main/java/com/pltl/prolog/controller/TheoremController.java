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
    public String indexPage(Model model) {
        return "index";
    }

    @PostMapping
    public TreeNode validateTheorem(@RequestBody String theorem) {
        long startTime = System.currentTimeMillis();
        TreeNode result = prologService.queryProve(theorem);
        logger.info("QUERY TOOK: {} ms.", System.currentTimeMillis() - startTime);

        return result;
    }
}