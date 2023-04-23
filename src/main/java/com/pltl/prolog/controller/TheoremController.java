package com.pltl.prolog.controller;

import com.pltl.prolog.model.Theorem;
import com.pltl.prolog.service.PrologQuery;
import org.jpl7.Term;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
public class TheoremController {

    @Autowired
    private PrologQuery prologQuery;

    @RequestMapping(value = "/")
    public String defaultTheorem(Model model) {
        String theorem = "[c, g, neg p, a, p, d] => [s]";
        Map<String, Term> result = prologQuery.queryProve(theorem);
        model.addAttribute("theorem", new Theorem());
        model.addAttribute("result", result);
        return "test"; // view resolver
    }

    @PostMapping(value = "/")
    public String proveTheorem(@ModelAttribute Theorem theorem, Model model) {
        Map<String, Term> result = prologQuery.queryProve(theorem.getValue());
        model.addAttribute("result", result);
        return "test";
    }
}
