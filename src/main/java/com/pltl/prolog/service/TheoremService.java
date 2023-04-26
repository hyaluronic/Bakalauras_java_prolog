package com.pltl.prolog.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.pltl.prolog.model.TreeNode;
import org.springframework.web.client.RestTemplate;

public class TheoremService {

    public TreeNode getSequentCalculusAnswer() throws JsonProcessingException {
        RestTemplate restTemplate = new RestTemplate();
        String jsonAnswer = restTemplate.getForObject("http://localhost:8080/theorem", String.class);
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(jsonAnswer, TreeNode.class);
    }
}
