package controllers;

import java.util.ArrayList;
import java.util.List;

import org.codehaus.jackson.node.ObjectNode;
import play.libs.Json;

import play.*;
import play.mvc.*;

import views.html.*;

public class Application extends Controller {
  
    public static Result index() {
        return ok(index.render("Your new application is ready."));
    }
    
    public static Result helloWeb() {
        ObjectNode result = Json.newObject();

        result.put("content", "Hello Web");

        return ok(result);
    }
    
    public static Result curiosmoves() {
        ObjectNode result = Json.newObject();
		
		List<ObjectNode> results = new ArrayList<ObjectNode>();
		
		ObjectNode date1 = Json.newObject();
        date1.put("date", "2012/08/22 22:19:46.831 (TDB)");
        date1.put("x", "-0.0037951595");
        date1.put("y", "-0.0047179352");
        date1.put("z", "0.0000351320");
		results.add(date1);
		
		ObjectNode date2 = Json.newObject();
        date2.put("date", "2012/08/22 23:19:46.831 (TDB)");
        date2.put("x", "-0.0035951595");
        date2.put("y", "-0.0045179352");
        date2.put("z", "0.0000351320");
		results.add(date2);
		
		result.put("positions", Json.toJson(results));
		
        return ok(result);
    }
  
}
