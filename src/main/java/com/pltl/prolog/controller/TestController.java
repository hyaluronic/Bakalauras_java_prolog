package com.pltl.prolog.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestController {

    @RequestMapping(value = "/")
    public String showRootPage(ModelMap model) {
        model.addAttribute("something", "OPAAAAA");
        return "test"; // view resolver
    }
}
