package com.pltl.prolog.service;

import org.jpl7.Atom;
import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class PrologQuery {

    public Map<String, Term> queryProve(String theorem) {
        JPL.init();
        Term consult_arg[] = {
                new Atom( "C:/Users/user/Desktop/UNI/8 semestras/Bakalauras/Programa/bakalauras.pl")
        };
        Query consult_query = new Query("consult", consult_arg);
        consult_query.allSolutions();

        return Query.oneSolution(String.format("prove(%s, X)", theorem));
    }
}
