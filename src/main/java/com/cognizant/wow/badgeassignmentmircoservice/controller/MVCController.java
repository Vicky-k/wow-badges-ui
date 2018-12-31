package com.cognizant.wow.badgeassignmentmircoservice.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;


@Controller
@RequestMapping("/")
final class MVCController {


    RestTemplate restTemplate = new RestTemplate();


    @GetMapping
    String getListOfAllBadgesMVC(HttpServletRequest request) {
        ResponseEntity<List> badges = restTemplate.getForEntity("http://localhost:8082/", List.class);
        request.setAttribute("badges",badges.getBody());
        request.setAttribute("mode", "MODE_HOME");
        return "index";

    }

    @GetMapping("/search-page")
    String getSearchPage(HttpServletRequest request){
        request.setAttribute("mode", "MODE_SEARCH_PAGE");
        return "index";
    }

    @GetMapping("/unreturned-search")
    String getUnreturnedBadgesPage(HttpServletRequest request)  {
        ResponseEntity<List> visitorBadgeMapping = restTemplate.getForEntity("http://localhost:8082/unreturned", List.class);
        request.setAttribute("visitorBadgeMapping",visitorBadgeMapping.getBody());
        request.setAttribute("mode", "MODE_UNRETURNED");
        return "index";
    }

    @PostMapping
    String getReservedBadge(HttpServletRequest request){
        //Long badgeNumber  = Long.parseLong(badgeId);
        String inputBadgeId = request.getParameter("badgeId");
        try {
            if(!inputBadgeId.trim().equals("")){
                Long badgeNumber  = Long.parseLong(request.getParameter("badgeId"));

                ResponseEntity<List> responseEntityBadge = restTemplate.getForEntity("http://localhost:8082/reserved/"+inputBadgeId.trim(), List.class);
                List badges = responseEntityBadge.getBody();
                Object map;
                if(badges.size() == 0)   {
                    request.setAttribute("reserved", "N");
                }   else    {
                    request.setAttribute("reserved", "Y");
                    ResponseEntity<Object> responseEntityBadgeVisitorMap = restTemplate.getForEntity("http://localhost:8082/"+inputBadgeId.trim(), Object.class);
                    map = responseEntityBadgeVisitorMap.getBody();
                    request.setAttribute("badgeVisitorMap",map);
                }


                request.setAttribute("badgeId","nonempty");
            } else {
                request.setAttribute("badgeId","empty");
            }
        }   catch(NumberFormatException ex) {
            request.setAttribute("badgeId", "invalid");
        }




        request.setAttribute("mode", "MODE_SEARCH");
        return "index";
    }


    @PostMapping("/issue")
    String markBadgeAsIssued(HttpServletRequest request){
        String inputBadgeId = request.getParameter("badgeIdIssue");

        try{
            restTemplate.put("http://localhost:8082/"+inputBadgeId,String.class);
            request.setAttribute("issue","success");
        }
        catch (Exception ex){
            request.setAttribute("issue","failure");
        }
        request.setAttribute("mode", "MODE_SEARCH");
        return "index";
    }

    @GetMapping("/return-search-page")
    String getSearchPageForReturn(HttpServletRequest request){
        request.setAttribute("mode", "MODE_RETURN_SEARCH_PAGE");
        return "index";
    }
    @GetMapping("/unreturned")
    String getUnReturnBadgeSearchResult(HttpServletRequest request){
        try{

            String inputBadgeId = request.getParameter("badgeReturnId");
            Long inputBadgeNumber = Long.parseLong(inputBadgeId);
            ResponseEntity<Object> returnBadge = restTemplate.getForEntity("http://localhost:8082/unreturned/"+inputBadgeId,Object.class);
            request.setAttribute("getReturnBadgeDetails","success");
            request.setAttribute("badgeVisitorMap", returnBadge.getBody());

        }catch(HttpStatusCodeException ex)  {
            request.setAttribute("getReturnBadgeDetails","failure");
            if(ex.getStatusCode() == HttpStatus.BAD_REQUEST)    {
                request.setAttribute("errorMessage","Badge Not issued");
            }
            if(ex.getStatusCode() == HttpStatus.NOT_FOUND )   {
                request.setAttribute("errorMessage","Technical error. Try after sometime");
            }
            request.setAttribute("mode", "MODE_RETURN_SEARCH_PAGE");

        }   catch(NumberFormatException ex) {
            request.setAttribute("getReturnBadgeDetails","failure");
            request.setAttribute("errorMessage","Badge Id is not valid.");
            request.setAttribute("mode", "MODE_RETURN_SEARCH_PAGE");
        }

        request.setAttribute("mode", "MODE_RETURN_SEARCH_PAGE");
        return "index";
    }

    @PostMapping("/return")
    String markBadgeAsReturned(HttpServletRequest request){
        String inputBadgeId = request.getParameter("badgeIdReturn");

        try{
            restTemplate.put("http://localhost:8082/return/"+inputBadgeId,String.class);
            request.setAttribute("returnResult","success");
        }
        catch (Exception ex){
            request.setAttribute("returnResult","failure");
        }
        request.setAttribute("mode", "MODE_RETURN_SEARCH_PAGE");
        return "index";
    }

}
