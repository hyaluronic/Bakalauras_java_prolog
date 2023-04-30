package com.pltl.prolog.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pltl.prolog.model.Theorem;
import com.pltl.prolog.model.TreeNode;
import com.pltl.prolog.service.PrologQuery;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@Controller
public class TestController {

    @Autowired
    private PrologQuery prologQuery;

    @SneakyThrows
    @GetMapping(value = "/")
    public String defaultTheorem(Model model) {
        ObjectMapper objectMapper = new ObjectMapper();
        String theorem = "[c, g, neg p, a, p, d] => [s]";
        TreeNode result = prologQuery.queryProve(theorem);
        String jsonAnswer = objectMapper.writeValueAsString(result);
        model.addAttribute("theorem", new Theorem());
        model.addAttribute("result", jsonAnswer);
        return "index"; // view resolver
    }

    @SneakyThrows
    @PostMapping(value = "/")
    public String proveTheorem(@ModelAttribute Theorem theorem, Model model) {
        ObjectMapper objectMapper = new ObjectMapper();
        TreeNode result = prologQuery.queryProve(theorem.getValue());
        String jsonAnswer = objectMapper.writeValueAsString(result);
        model.addAttribute("result", jsonAnswer);
        return "test";
    }
}
